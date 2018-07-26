Network nn;
int scalar = 200;

boolean drawing = true;
boolean training = false;
boolean loop = true;

Grapher gp;

void setup() {

  size(600, 600);
  background(255);
  noSmooth();

  nn = new Network();
  {
    Nexo inputs = new Nexo(100);
    Nexo hidden1 = new Nexo(99);
    Nexo outputs = new Nexo(100);

    nn.join(inputs);
    nn.join(hidden1);
    // nn.join(hidden2);
    nn.join(outputs);

    nn.flush();
  }

  nn.randomize();

  nn.lrAuto = true;

  textAlign(CENTER, CENTER);
  textSize(20);

  frameRate(6);
  strokeWeight(4);

  gp = new Grapher();
}

void draw() {
  if(!training) {
    thread("train");
  }

  if(frameCount % 6 == 1) {
    nn.setupScheme();
  }

  gp.add(nn.cost / (1.0 * nn.layers[nn.layers.length-1]));

  if(drawing) {
    background(255);
    image(nn.scheme, 0, 0);
  } else {
    gp.update(width, height);
  }

  fill(0);
  text(int(frameRate) + " fps", width*0.9, height*0.1);
}

void train() {
  training = true;
  //
  training = false;
}
