class Grapher {

  PGraphics pg;
  int step;
  int lasty = height/2;
  float strokeWeight = 1.5;
  int strokeColor = color(0, 0, 0);
  int backgroundColor = color(255);

  int pixeloff = 1;

  int jsonmemory = 200;

  JSONArray log;

  Grapher() {
    log = new JSONArray();

    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(backgroundColor);
    pg.endDraw();
  }

  void show() {
    image(pg, 0, 0, width, height);
  }

  void update() {
    show();

    if(mousePressed) {
      line(mouseX, 0, mouseX, height);
      int index = step-(width-mouseX)/pixeloff;
      if(index >= 0 && index < log.size()) {
        println(index + ": " + map(log.getJSONObject(index).getInt("y"), 0, width, 1, 0));
      }
    }
  }

  void saveAll() {
    saveJSONArray(log, hour()+"-"+minute()+"-"+second()+".log");
    pg.save("data/imgs/graph.png");
  }

  void fromJSON(JSONArray json) {
    for(int i = 0; i < json.size(); i++) {
      JSONObject jobj = json.getJSONObject(i);
      int y = jobj.getInt("y");
      add(y);
    }
  }

  void add(int y) {
    if(step == 0) lasty = y;

    pg = pushPG(pg, pixeloff, backgroundColor, strokeWeight);
    pg.beginDraw();
    pg.stroke(strokeColor);
    pg.line(width, y, width-pixeloff, lasty);
    pg.endDraw();
    lasty = y;

    JSONObject it = new JSONObject();
    it.setInt("x", step);
    it.setInt("y", y);
    log.setJSONObject(step, it);

    if(log.size() >= jsonmemory) {
      log.remove(0);
    }

    step++;
  }

  void add(float normalized) {
    int y = floor(map(normalized, 0, 1, height, 0));
    add(y);
  }

}

PGraphics pushPG(PGraphics pg, int c, int backgroundColor, float strokeWeight) {

  PGraphics newpg = createGraphics(pg.width, pg.height);

  newpg.beginDraw();
  newpg.background(backgroundColor);
  newpg.strokeWeight(strokeWeight);

  for (int x = 0; x < pg.width; x++) {

    for (int y = 0; y < pg.height; y++) {

      int nx = x-c;

      if (nx >= 0 && nx < pg.width) {
        int col = pg.get(x, y);
        newpg.set(nx, y, col);
        //if(col != -1) println(col != backgroundColor, indexNEW >= 0, indexNEW < pg.width);
      }
    }
  }
  newpg.endDraw();
  return newpg;
}
