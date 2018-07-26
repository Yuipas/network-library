final String datPath = "data/HWD/";

final String pathbase = "data#";
final String dataFormat = ".dat";

class data {

  float[] xs;
  float[] ys;

  int recognized = 0;

  data() {

  }

  data(float[] xs, float[] ys) {
    this.xs = xs;
    this.ys = ys;
  }

  data(JSONObject jdata) {

    JSONArray jxs = jdata.getJSONArray("xs");
    JSONArray jys = jdata.getJSONArray("ys");

    xs = new float[jxs.size()];
    ys = new float[jys.size()];

    for(int i = 0; i < jxs.size() || i < jys.size(); i++) {
      if(i < jxs.size()) xs[i] = jxs.getFloat(i);
      if(i < jys.size()) ys[i] = jys.getFloat(i);
    }

  }

  /*
  28^2 inputs
  10 outputs
  */

  JSONObject toJSON() {

    JSONObject jdata = new JSONObject();
    JSONArray jxs = new JSONArray();
    JSONArray jys = new JSONArray();

    for(int i = 0; i < xs.length || i < ys.length; i++) {
      if(i < xs.length) jxs.setFloat(i, xs[i]);
      if(i < ys.length) jys.setFloat(i, ys[i]);
    }

    jdata.setJSONArray("xs", jxs);
    jdata.setJSONArray("ys", jys);

    return jdata;
  }


}

String getPath(int id) {
  int pack = id / packageSize;
  pack *= packageSize;
  return datPath + pack + "-" + (pack+399) + "/" + pathbase + id + dataFormat;
}

data loadDataFile(int id) {

  String path = getPath(id);
  // println(path);
  try {
    JSONObject JData = loadJSONObject(path);

    data dat = new data();

    JSONArray JPixels = JData.getJSONArray("pixels");
    int label = JData.getInt("label");

    float[] ys = new float[10];
    ys[label] = 1;

    dat.xs = new float[JPixels.size()];
    dat.ys = ys;

    for(int i = 0; i < JPixels.size(); i++) {
      dat.xs[i] = JPixels.getFloat(i);
    }

    return dat;

  } catch(NullPointerException e) {
    println("data not found at: " + path);
    // println(e);

    return null;
  }

}

data[] loadData(int number) {
  data[] allData = {};

  for(int i = 0; i < number; i++) {
    data dat = loadDataFile(i);
    allData = (data[]) append(allData, dat);
  }

  return allData;
}

data[] loadPackage(int packId) {
  packId = constrain(packId, 0, packageCount-1);

  data[] packageData = {};

  for(int i = packId*packageSize; i < (packId+1)*packageSize; i++) {
    data dat = loadDataFile(i);
    packageData = (data[]) append(packageData, dat);
  }

  return packageData;
}


PImage toImage(data d) {
  PImage img = createImage(resolution, resolution, ALPHA);

  img.loadPixels();

  for(int i = 0; i < img.pixels.length; i++) {
    int col = int(d.xs[i]);

    col = abs(1-col);
    col *= 255;
    col = color(col);

    img.pixels[i] = col;
  }

  img.updatePixels();

  return img;
}
