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

  if(frameCount % 6 == 0) {
    test();
  }
  
  gp.add(nn.cost / (1.0 * nn.layers[nn.layers.length-1]));
  gp.update();
}

void train() {
  training = true;

  for(int i = 0; i < 100; i++) {
    float xs[];
    float ys[];

    int rand = int(random(4));

    if(rand == 3) {
      float xs2[] = {0, 0};
      float ys2[] = {1, 0, 0};

      xs = xs2;
      ys = ys2;
    } else if(rand == 2) {
      float xs2[] = {1, 0};
      float ys2[] = {0, 1, 0};

      xs = xs2;
      ys = ys2;
    } else if(rand == 1) {
      float xs2[] = {0, 1};
      float ys2[] = {1, 1, 0};

      xs = xs2;
      ys = ys2;
    } else {
      float xs2[] = {1, 1};
      float ys2[] = {0, 0, 1};

      xs = xs2;
      ys = ys2;
    }

    nn.fit(xs, ys);
  }

  training = false;
}

void test() {
  float xs[];
  float ys[];

  int rand = int(random(4));

  if(rand == 3) {
    float xs2[] = {0, 0};
    float ys2[] = {1, 0, 0};

    xs = xs2;
    ys = ys2;
  } else if(rand == 2) {
    float xs2[] = {1, 0};
    float ys2[] = {0, 1, 0};

    xs = xs2;
    ys = ys2;
  } else if(rand == 1) {
    float xs2[] = {0, 1};
    float ys2[] = {1, 1, 0};

    xs = xs2;
    ys = ys2;
  } else {
    float xs2[] = {1, 1};
    float ys2[] = {0, 0, 1};

    xs = xs2;
    ys = ys2;
  }

  println("inputs: ");
  println(xs);
  println("outputs: ");
  println(nn.predict(xs));
  println("targets: ");
  println(ys);
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
