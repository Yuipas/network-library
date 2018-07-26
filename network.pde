class Network {


  // Layer[] network;
  Nexo[] network;
  int[] layers;
  PGraphics scheme;

  float learningRate = 0.2;
  boolean lrAuto = false;

  int steps;

  float cost;
  Tensor1d costHistory;

  int costMemory = 40;

  Network() {
    network = new Nexo[0];

    costHistory = createTensor(0);
  }

  // TODO: json functionality

  /*INITIALIZATION FUNCTIONS*/

  void join(Nexo nex) {

    if(nex.inputShape == 0) {
      println("couldnt add the nexo: " + nex);
      return;
    }

    network = (Nexo[]) append(network, nex);

    if(network.length >= 2) {
      network[network.length-2].linkNexo(network[network.length-1]);
    }
  }

  void flush() {
    layers = getTotalLayers();
    network[network.length-1].linkNexo(new Nexo(0));
    network[0].activation = null;
    network[0].bias = null;

    int w = getWeights();
    int b = getBias();
    println((w + b) + " parameters (" + w + " weights, " + b + " bias).");
  }

  void randomize() {
    for(int i = 0; i < size(); i++) {
      network[i].randomize();
    }
  }

  /*INFO FUNCTIONS*/

  int[] getTotalLayers() {
    int[] layers = new int[network.length];

    for(int i = 0; i < network.length; layers[i] = network[i].inputShape, i++);
    return layers;
  }

  int size() {
    return network.length;
  }

  int getTotalParameters() {
    return getWeights() + getBias();
  }

  int getWeights() {
    int totalweights = 0;


    for(int i = 0; i < layers.length-1; i++) {
      totalweights += layers[i]*layers[i+1];
    }

    return totalweights;
  }

  int getBias() {
    int totalbias = sum(getTotalLayers())-network[0].inputShape;

    return totalbias;
  }

  /*ACTION FUNCTIONS*/

  float[] predict(float[] inputs) {
    return predict(createTensor(inputs)).toArray();
  }

  Tensor1d predict(Tensor1d inputs) {

    for(int i = 0; i < network.length; i++) {
      inputs = network[i].predict(inputs);
    }

    int index = network.length-1; //last nexo of the network.
    return network[index].inputs;
  }



  void fit(float[] inputs, float[] targets) {
    fit(createTensor(inputs), createTensor(targets));
  }

  void fit(Tensor1d inputs, Tensor1d targets) {
    steps++;

    if(lrAuto) {
      learningRate = getLR();
    }

    Tensor1d outputs = predict(inputs);
    Tensor1d out_errors = sub(targets, outputs);


    Tensor2d gradients = outputs.toTensor2d();

    gradients.map("d" + network[network.length-1].activation);
    gradients.mult(out_errors.toTensor2d());
    gradients.mult(learningRate);

    Tensor1d lasterrors = out_errors;

    calculateCost(out_errors.copy());

    for(int layerI = network.length-2; layerI >= 0; layerI--) {

      Nexo nexo = network[layerI];
      Tensor2d hidden = transpose(nexo.inputs.toTensor2d());
      Tensor2d deltas = mult(gradients, hidden);
      Tensor2d who_t = transpose(nexo.weights);

      network[layerI+1].applyBiasDeltas(gradients.toTensor1d());
      network[layerI].applyWeightsDeltas(deltas);

      Tensor2d errors = mult(who_t, lasterrors.toTensor2d());
      lasterrors = errors.toTensor1d();

      gradients = transpose(hidden);
      gradients.map("d" + network[layerI+1].activation);
      gradients.mult(errors);
      gradients.mult(learningRate);
    }
  }

  void calculateCost(Tensor1d errors) {
    errors.pow(2);
    cost = errors.sum();

    costHistory.push(0, cost);

    if(costHistory.size() > costMemory) {
      costHistory.resize(costMemory);
    }
  }

  float getLR() {
    float x = steps / 100.0;
    x = exp(x) / pow(3, x);
    if (x != x || x == infinity || x == -infinity) {
      x = 1E-5;
      lrAuto = false;
      println("error detected. (fixed)");
    }
    return x;
  }


  /*AESTHETIC FUNCTIONS*/

  boolean setupScheme() {
    return setupScheme(null);
  }

  boolean setupScheme(JSONObject options) {

    /* Returns false if the scheme is already done.
    */

    boolean redo = false;
    int w = width;
    int h = height;
    float sqsize = min(w, h) / 20;

    if (options != null) {//loading options from json
      if(!options.isNull("redo")) {
        redo = options.getBoolean("redo");
      }
      if(!options.isNull("sqsize")) {
        sqsize = options.getFloat("sqsize");
      }
      if(!options.isNull("width")) {
        w = options.getInt("width");
      }
      if(!options.isNull("height")) {
        h = options.getInt("height");
      }
    }

    pushStyle();

    if(scheme != null && !redo) {
      return false;
    }

    PGraphics pg = createGraphics(w, h);

    pg.beginDraw();
    pg.rectMode(CORNER);

    for(int actuallayer = 0; actuallayer < layers.length; actuallayer++) {

      Nexo nexo = network[actuallayer];
      int totalneurons = nexo.inputShape;
      int x = (actuallayer+1) * w / (layers.length+1);

      for(int innode = 0; innode < nexo.inputShape; innode++) {

        for(int outnode = 0; outnode < nexo.outputShape && actuallayer < layers.length-1; outnode++) {

          float weight = nexo.weights.get(outnode, innode); // [innode].weights[outnode];

          pg.stroke(getColor(weight));

          int xtemp = w/(layers.length+1);
          int x1 = (actuallayer+1) * xtemp +10;
          int y1 = (innode+1) * h/(nexo.inputShape+1) +10;
          int x2 = (actuallayer+2) * xtemp +10;
          int y2 = (outnode+1) * h/(network[actuallayer].outputShape+1) +10;
          pg.line(x1, y1, x2, y2);
        }

        int y = (innode+1) * h / (totalneurons+1);
        pg.stroke(0);
        pg.rect(x, y, sqsize, sqsize);
      }

    }


    pg.endDraw();

    popStyle();

    scheme = pg;

    return true;
  }

  PImage rawImage() {
    return rawImage(null);
  }


  PImage rawImage(JSONObject options) {

    float res = float(resolution);
    float squareRes = 10;


    // #squares * squarewidth = width
    // squarewidth = width / #squares
    int w = int(resolution*squareRes);
    int h = w;
    boolean stroke = true;

    if(options != null) {
      //loading options from json
      if(!options.isNull("noStroke") && options.getBoolean("noStroke")) {
        stroke = false;
      }
      if(!options.isNull("squareRes")) {
        squareRes = options.getInt("squareRes");
        w = int(resolution*squareRes);
        h = w;
      }
      if(!options.isNull("resolution")) {
        res = options.getInt("resolution");
        w = int(resolution*squareRes);
        h = w;
      }
      if(!options.isNull("width")) {
        w = options.getInt("width");
      }
      if(!options.isNull("height")) {
        h = options.getInt("height");
      }
    }

    PGraphics pg = createGraphics(w, h);

    pg.beginDraw();
    pg.stroke(211);
    if(!stroke) pg.noStroke();
    pg.rectMode(CORNER);

    float scalar = res*squareRes;
    for(float x = 0; x < 1; x += 1/res)
    {

      for(float y = 0; y < 1; y += 1/res)
      {
        float[] inputs = {x, y};
        float[] output = predict(inputs);

        pg.fill(output[0]*255, output[1]*255, output[2]*255);
        pg.rect(x*scalar, y*scalar, squareRes, squareRes);
        // println("["+(x+y)+"] " + output);
      }

    }
    pg.endDraw();

    return pg.get();
  }

}


Network loadNetwork(String filename) {
  String totalPath = networksPath + filename;

  return new Network();//loadJSONObject(totalPath));
}

void saveNetwork(Network nn, String filename) {
  // saveJSONObject(nn.toJSON(), networksPath + filename);
}
