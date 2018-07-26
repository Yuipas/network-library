int green = color(21, 255, 21);
int red = color(255, 21, 21);

Network nn;
int scalar = 200;

boolean drawing = true;
boolean training = false;


Grapher gp;

void setup() {

  size(600, 600);
  background(255);
  noSmooth();

  nn = new Network();
  {
    Nexo inputs = new Nexo(2);
    Nexo hidden1 = new Nexo(16);
    Nexo hidden2 = new Nexo(16);
    Nexo outputs = new Nexo(3);

    nn.join(inputs);
    nn.join(hidden1);
    nn.join(hidden2);
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
    nn.setupScheme(op);
  }

  gp.add(nn.cost / (1.0 * nn.layers[nn.layers.length-1]));

  if(drawing) {
    background(255);
    image(nn.scheme, 0, 0);
  } else {
    gp.update(width, height);
  }
}

void keyPressed() {
  if(key == ' ') {
    if(drawing) {
      drawing = false;
    } else {
      drawing = true;
    }
    println("drawing: " + drawing);

    background(255);
  }

  if(key == 's') {
    saveNetwork(nn, "temp.nn");
  }

}
