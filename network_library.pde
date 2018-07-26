int green = color(21, 255, 21);
int red = color(255, 21, 21);

Network nn;
int scalar = 200;

boolean drawing = true;
boolean training = false;


Grapher gp;

void setup() {

  size(500, 500);
  background(255);
  noSmooth();

  nn = new Network();
  {
    Nexo inputs = new Nexo(100);
    Nexo hidden1 = new Nexo(100);
    Nexo hidden2 = new Nexo(100);
    Nexo outputs = new Nexo(100);

    nn.join(inputs);
    nn.join(hidden1);
    nn.join(hidden2);
    nn.join(outputs);

    nn.flush();
  }

  nn.randomize();

  // nn.setupScheme();
  // image(nn.scheme, 0, 0);

  nn.lrAuto = true;

  textAlign(CENTER, CENTER);
  textSize(20);

  // frameRate(6);
  strokeWeight(4);

  gp = new Grapher();
}

void draw() {
  if(!training) {
    thread("train");
  }
  gp.update();
}

void train() {
  training = true;
  // trainXOR(nn);
  trainCODER(nn);
  gp.add(nn.cost / 100.0);
  training = false;
}

void keyPressed() {
  if(key == ' ') {
    if(drawing) {
      drawing = false;
      frameRate(3);
    } else {
      drawing = true;
      frameRate(1);
    }
    println("drawing: " + drawing);

    background(255);
  }

  if(key == 's') {
    saveNetwork(nn, "temp.nn");
  }

}

void trainCODER(Network network) {
  tensor1d xs = createTensor(100);
  // xs.randomize();

  network.fit(xs, xs);
}
