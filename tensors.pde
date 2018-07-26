PApplet sketch;

class Tensor1d {

  private float data[];

  Tensor1d() {
    this.data = new float[0];
  }

  Tensor1d(int l) {
    this.data = new float[l];
  }

  Tensor1d(float[] dat) {
    this.data = new float[dat.length];
    arrayCopy(dat, this.data);
  }

  Tensor1d(JSONArray JTensor1d) {
    this.data = JTensor1d.getFloatArray();
  }

  /*INITIALIZATION && CONVERTION FUNCTIONS*/

  JSONArray toJSON() {
    JSONArray JData = new JSONArray();

    for(int i = 0; i < size(); i++) {
      JData.setFloat(i, data[i]);
    }

    return JData;
  }


  Tensor1d copy() {
    return new Tensor1d(data);
  }

  Tensor2d toTensor2d() {
    Tensor2d Tensor = new Tensor2d(size(), 0);

    Tensor.pushCol(this.copy());
    return Tensor;
  }

  Tensor2d toTensor2d(int cols) {
    Tensor2d Tensor = createTensor(ceil(float(size())/float(cols)), cols);
    int rows = Tensor.rows();
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        Tensor.data[i][j] = get(i*rows+j);
      }
    }
    return Tensor;
  }

  void resize(int l) {
    Tensor1d newTensor = new Tensor1d(l);
    int maxle = l;//sketch.max(size(), l);

    for(int i = 0; i < maxle; i++) {
      float newval = 0;

      if(i < size()) {
        newval = get(i);
      }
      newTensor.set(i, newval);
    }
    this.data = newTensor.data;
  }

  float[] toArray() {
    float[] newarray = new float[size()];
    arrayCopy(data, newarray);
    return newarray;
  }

  void push(float f) {
    data = (float[]) append(data, f);
  }

  void push(int pos, float f) {
    data = (float[]) splice(data, f, pos);
  }

  void push(float[] f) {
    data = (float[]) concat(data, f);
  }

  void push(Tensor1d f) {
    data = (float[]) concat(data, f.toArray());
  }

  /*INFO FUNCTIONS*/

  boolean containsNaN() {
    float infinity = 0.1/0.0;
    for(int i = 0; i < size(); i++) {
      float v = get(i);
      if(Float.isNaN(v) || v == infinity || v == -infinity) {
        return true;
      }
    }
    return false;
  }

  float sum() {
    float sum = 0;

    for(float f : data) {
      sum += f;
    }

    return sum;
  }

  int size() {
    return data.length;
  }

  float get(int i) {
    return data[i];
  }

  void set(int i, float newval) {
    data[i] = newval;
  }

  void print() {
    println(data);
    println();
  }

  int indexof(float search) {
    if (size() == 0) return -1;
    for (int i = 0; i < data.length; i++) {
      if (search == (data[i])) {
        return i;
      }
    }
    return -1;
  }

  int argMax() {
    return indexof(max());
  }

  float max() {
    return sketch.max(data);
  }

  /*ACTION FUNCTIONS*/

  void abs() {
    for(int i = 0; i < size(); i++) {
      set(i, sketch.abs(get(i)));
    }
  }

  void setAll(float val) {
    for(int i = 0; i < size(); i++) {
      data[i] = val;
    }
  }

  void randomize() {
    for (int i = 0; i < size(); i++) {
      this.data[i] = random(1);
    }
  }

  void randomize(int n) {
    for (int i = 0; i < size(); i++) {
      this.data[i] = int(random(n));
    }
  }

  void randomize(float n) {
    n *= 100;
    for (int i = 0; i < size(); i++) {
      this.data[i] = int(random(n));
      this.data[i] /= 100;
    }
  }

  void randomize(float min, float max) {
    for (int i = 0; i < size(); i++) {
      this.data[i] = int(random(min, max)*100);
      this.data[i] /= 100.0;
    }
  }

  void add(float scalar) {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] += scalar;
    }
  }

  void add(Tensor1d Tensor) {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] += Tensor.data[i];
    }
  }

  void sub(float scalar) {
    this.add(-scalar);
  }

  void sub(Tensor1d Tensor) {
    Tensor1d temp = Tensor.copy();
    temp.mult(-1);
    this.add(temp);
  }

  void mult(float Tensor) {
    //SCALAR PRODUCT
    for (int i = 0; i < this.size(); i++) {
      this.data[i] *= Tensor;
    }
  }

  void mult(Tensor1d Tensor) {
    //hadamard PRODUCT
    for (int i = 0; i < this.size(); i++) {
      this.data[i] *= Tensor.data[i];
    }
  }

  void div(float scalar) {
    this.mult(1.0 / scalar);
  }

  void div(Tensor1d Tensor) {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] /= Tensor.data[i];
    }
  }

  void pow(float scalar) {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] = sketch.pow(this.data[i], scalar);
    }
  }

  void pow(Tensor1d Tensor) {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] = sketch.pow(this.data[i], Tensor.data[i]);
    }
  }

  void applySigmoid() {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] = sigmoid(this.data[i]);
    }
  }

  void applyDSigmoid() {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] = dsigmoid(this.data[i]);
    }
  }

  void applyReLU() {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] = ReLU(this.data[i]);
    }
  }

  void applyDReLU() {
    for (int i = 0; i < this.size(); i++) {
      this.data[i] = dReLU(this.data[i]);
    }
  }
  void applyTanh() {
    for (int i = 0; i < this.size(); i++) {
      float val = tanh(get(i));
      this.set(i, val);
    }
  }

  void applyDTanh() {
    for (int i = 0; i < this.size(); i++) {
      float val = dtanh(get(i));
      this.set(i, val);
    }
  }

  void map(String func) {
    switch (func) {
      case "sigmoid":
        applySigmoid();
        break;
      case "dsigmoid":
        applyDSigmoid();
        break;
      case "relu":
        applyReLU();
        break;
      case "drelu":
        applyDReLU();
        break;
      case "tanh":
        applyTanh();
        break;
      case "dtanh":
        applyDTanh();
        break;

      default:
        sketch.println("no func applyed");
    }
  }

}

Tensor1d oneHot(int index, int depth) {
  Tensor1d Tensor = createTensor(depth);
  Tensor.set(index, 1);
  return Tensor;
}

Tensor1d reverse(Tensor1d Tensor) {
  return new Tensor1d(sketch.reverse(Tensor.data));
}

Tensor1d mult(Tensor1d a, Tensor1d b) {
  if (a.size() != b.size()) {
    println("error: mult " + a +", "+ b);
    return null;
  }

  Tensor1d Tensor = new Tensor1d(a.size());

  for (int i = 0; i < Tensor.size(); i++) {
    Tensor.data[i] = a.data[i] * b.data[i];
  }

  return Tensor;
}

Tensor1d add(Tensor1d a, Tensor1d b) {
  if (a.size() != b.size()) {
    println("error: add " + a + ", " + b);
    return null;
  }

  Tensor1d Tensor = new Tensor1d(a.size());

  for (int i = 0; i < b.size(); i++) {
    Tensor.data[i] = a.data[i] + b.data[i];
  }
  return Tensor;
}

Tensor1d sub(Tensor1d a, Tensor1d b) {
  if (a.size() != b.size()) {
    println("error: sub " + a + ", " + b);
    return null;
  }

  Tensor1d Tensor = new Tensor1d(a.size());

  for (int i = 0; i < b.size(); i++) {
    Tensor.data[i] = a.data[i] - b.data[i];
  }
  return Tensor;
}

Tensor1d mult(Tensor2d a, Tensor1d b) {
  if (a.cols() != b.size()) {
    println("error: " + a.cols() +", "+ b.size());
    a.print();
    b.print();
    return null;
  }

  Tensor1d Tensor = createTensor(a.rows());

  for(int i = 0; i < Tensor.size(); i++) {
    float sum = 0;
    for(int j = 0; j < a.cols(); j++) {
      float val = b.data[j] * a.get(i, j);
      sum += val;
    }
    Tensor.data[i] = sum;// b.data[i % b.size()]*a.getFloat(i);
  }

  return Tensor;
}


//-------------------------------------------------------------



class Tensor2d {

  private float data[][];

  Tensor2d() {
    this.data = new float[0][0];
  }

  Tensor2d(int rows, int cols) {
    this.data = new float[rows][cols];
  }

  Tensor2d(float[][] data) {
    if(data.length != 0) {
      this.data = new float[data.length][data[0].length];

      for(int i = 0; i < data.length; i++) {
        arrayCopy(data[i], this.data[i]);
      }
    }
  }

  Tensor2d(JSONObject JTensor2d) {
    JSONArray JData = JTensor2d.getJSONArray("data");

    this.data = new float[JTensor2d.getInt("rows")][JTensor2d.getInt("cols")];

    for(int i = 0; i < rows(); i++) {

      JSONArray JCol = JData.getJSONArray(i);

      for(int j = 0; j < cols(); j++) {
        this.data[i][j] = JCol.getFloat(j);
      }
    }

  }

  /*INITIALIZATION && CONVERTION FUNCTIONS*/

  Tensor2d copy() {
    return createTensor(data);
  }

  JSONObject toJSON() {
    JSONObject JTensor2d = new JSONObject();


    JSONArray JData = new JSONArray();

    for(int i = 0; i < rows(); i++) {

      JSONArray JCol = new JSONArray();

      for(int j = 0; j < cols(); j++) {
        JCol.setFloat(j, data[i][j]);
      }
      JData.setJSONArray(i, JCol);
    }
    JTensor2d.setJSONArray("data", JData);

    JTensor2d.setInt("rows", rows());
    JTensor2d.setInt("cols", cols());

    return JTensor2d;
  }

  Tensor1d toTensor1d() {
    Tensor1d Tensor = new Tensor1d();
    for(int i = 0; i < size(); i++) {
      Tensor.push(getFloat(i));
    }
    return Tensor;
  }

  float[][] toArray() {
    float[][] newarray = new float[rows()][cols()];
    // arrayCopy(data, newarray);
    for(int i = 0; i < data.length; i++) {
      arrayCopy(this.data[i], data[i]);
    }
    return newarray;
  }

  void resize(int rows, int cols) {
    Tensor2d newTensor = new Tensor2d(rows, cols);
    rows = max(this.rows(), rows);
    cols = max(this.cols(), cols);
    int totalsize = size();

    for(int i = 0; i < cols*rows; i++) {
      float newval = 0;

      if(i < totalsize) {
        newval = getFloat(i);
      }
      newTensor.set(i, newval);
    }

    data = newTensor.data;
  }

  void push(float[] temp) {
    data = (float[][]) append(data, temp);
  }

  void push(Tensor1d temp) {
    push(temp.toArray());
  }

  void pushRow(float[] f) {

    float[][] newdata = new float[rows()+1][max(cols(), f.length)];

    for(int i = 0; i < newdata.length; i++) {

      for(int j = 0; j < newdata[i].length; j++) {
        float val = 0;
        if(i < rows() && j < cols()) {
          val = data[i][j];
        }
        else if(j < f.length) {
          val = f[j];
        }
        newdata[i][j] = val;
      }

    }
    data = newdata;
  }

  void pushRow(Tensor1d f) {
    pushRow(f.toArray());
  }

  void pushCol(float[] f) {

    float[][] newdata = new float[max(rows(), f.length)][cols()+1];

    for(int i = 0; i < newdata.length; i++) {

      for(int j = 0; j < newdata[i].length; j++) {
        float val = 0;
        if(i < rows() && j < cols()) {
          val = data[i][j];
        }
        else if(i < f.length) {
          val = f[i];
        }
        newdata[i][j] = val;
      }

    }
    data = newdata;
  }

  void pushCol(Tensor1d f) {
    pushCol(f.toArray());
  }


  void push(float[][] f) {
    data = (float[][]) concat(data, f);
  }

  void push(Tensor2d f) {
    push(f.toArray());
  }

  /*INFO FUNCTIONS*/

  boolean equals(Tensor2d a) {

    if(rows() != a.rows() || cols() != a.cols()) {
      return false;
    }

    int rows = a.rows();
    int cols = a.cols();

    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        if(a.get(i, j) != get(i, j)) {
          return false;
        }
      }
    }

    return true;
  }

  boolean containsNaN() {
    float infinity = 0.1/0.0;
    for(int i = 0; i < size(); i++) {
      if(Float.isNaN(getFloat(i)) || getFloat(i) == infinity || getFloat(i) == -infinity) {
        return true;
      }
    }
    return false;
  }


  float sumAll() {
    float sum = 0;

    for(int i = 0; i < size(); i++) {
      sum += getFloat(i);
    }

    return sum;
  }

  int rows() {
    return data.length;
  }

  int cols() {
    if(rows() == 0) return 0;
    return data[0].length;
  }

  int size() {
    return cols()*rows();
  }

  void set(int i, float f) {
    int col = i % cols();
    int row = i/cols() % rows();
    data[row][col] = f;
  }

  void set(int row, int col, float f) {
    data[row][col] = f;
  }

  float get(int i, int j) {
    return data[i][j];
  }


  Tensor1d get(int i) {
    return new Tensor1d(data[i]);
  }

  float getFloat(int i) {
    int col = i % cols();
    int row = i/cols() % rows();

    return data[row][col];
  }

  void print() {
    for (int i = 0; i < this.rows(); i++) {

      for (int j = 0; j < this.cols(); j++) {
        System.out.print("[" + i + "][" + j + "] " + this.data[i][j] + "  ");
      }

      System.out.println();
    }
    System.out.println();
  }

  void println() {
    for (int i = 0; i < this.rows(); i++) {

      for (int j = 0; j < this.cols(); j++) {
        System.out.println("[" + i + "][" + j + "] " + this.data[i][j] + "  ");
      }
    }
    System.out.println();
  }

  /*ACTION FUNCTIONS*/

  void setAll(float val) {
    for(int i = 0; i < size(); i++) {
      set(i, val);
    }
  }

  void randomize() {
    for (int i = 0; i < rows(); i++) {
      for (int j = 0; j < cols(); j++) {
        this.data[i][j] = random(1);
      }
    }
  }

  void randomize(int n) {
    for (int i = 0; i < rows(); i++) {
      for (int j = 0; j < cols(); j++) {
        this.data[i][j] = int(random(n));
      }
    }
  }

  void randomize(float min, float max) {
    for (int i = 0; i < rows(); i++) {
      for (int j = 0; j < cols(); j++) {
        float val = int(random(min, max)*100);
        this.data[i][j] = val / 100.0;
      }
    }
  }


  void add(float n) {
    for (int i = 0; i < this.rows(); i++) {
      for (int j = 0; j < this.cols(); j++) {
        this.data[i][j] += n;
      }
    }
  }

  void add(Tensor2d Tensor) {
    if (Tensor.rows() != this.rows() || Tensor.cols() != this.cols()) {
      throw new ArithmeticException("add error: 53");
    }

    for (int i = 0; i < this.rows(); i++) {
      for (int j = 0; j < this.cols(); j++) {
        this.data[i][j] += Tensor.data[i][j];
      }
    }
  }

  void sub(float scalar) {
    this.add(-scalar);
  }

  void sub(Tensor2d Tensor) {
    for (int i = 0; i < Tensor.rows(); i++) {
      for (int j = 0; j < Tensor.cols(); j++) {
        this.data[i][j] = this.data[i][j] - Tensor.data[i][j];
      }
    }
  }

  void mult(float n) {
    //SCALAR PRODUCT
    for (int i = 0; i < this.rows(); i++) {
      for (int j = 0; j < this.cols(); j++) {
        this.data[i][j] *= n;
      }
    }
  }

  void mult(Tensor2d Tensor) {
    //hadamard PRODUCT
    for (int i = 0; i < this.rows(); i++) {
      for (int j = 0; j < this.cols(); j++) {
        this.data[i][j] *= Tensor.data[i][j];
      }
    }
  }

  void div(float scalar) {
    scalar = 1.0 / scalar;
    this.mult(scalar);
  }

  void div(Tensor2d Tensor) {
    for (int i = 0; i < this.size(); i++) {
      float val = getFloat(i) / Tensor.getFloat(i);
      this.set(i, val);
    }
  }

  void pow(float scalar) {
    for (int i = 0; i < this.size(); i++) {
      float val = sketch.pow(getFloat(i), scalar);
      this.set(i, val);
    }
  }

  void pow(Tensor2d Tensor) {
    for (int i = 0; i < this.size(); i++) {
      float val = sketch.pow(getFloat(i), Tensor.getFloat(i));
      this.set(i, val);
    }
  }

  void applySigmoid() {
    for (int i = 0; i < this.size(); i++) {
      float val = sigmoid(getFloat(i));
      this.set(i, val);
    }
  }

  void applyDSigmoid() {
    for (int i = 0; i < this.size(); i++) {
      float val = dsigmoid(getFloat(i));

      this.set(i, val);
    }
  }

  void applyReLU() {
    for (int i = 0; i < this.size(); i++) {
      float val = ReLU(getFloat(i));
      this.set(i, val);
    }
  }

  void applyDReLU() {
    for (int i = 0; i < this.size(); i++) {
      float val = dReLU(getFloat(i));
      this.set(i, val);
    }
  }

  void applyTanh() {
    for (int i = 0; i < this.size(); i++) {
      float val = tanh(getFloat(i));
      this.set(i, val);
    }
  }

  void applyDTanh() {
    for (int i = 0; i < this.size(); i++) {
      float val = tanh(getFloat(i));
      this.set(i, val);
    }
  }

  void map(String func) {
    switch (func) {
      case "sigmoid":
        applySigmoid();
        break;
      case "dsigmoid":
        applyDSigmoid();
        break;
      case "relu":
        applyReLU();
        break;
      case "drelu":
        applyDReLU();
        break;
      case "tanh":
        applyTanh();
        break;
      case "dtanh":
        applyDTanh();
        break;

      default:
        sketch.println("no func applyed");
    }
  }

}

Tensor2d transpose(Tensor2d Tensor) {
  Tensor2d tor = new Tensor2d(Tensor.cols(), Tensor.rows());

  for (int i = 0; i < Tensor.rows(); i++) {
    for (int j = 0; j < Tensor.cols(); j++) {
      tor.data[j][i] = Tensor.data[i][j];
    }
  }
  return tor;
}

Tensor2d mult(Tensor2d a, Tensor2d b) {
  if (a.cols() != b.rows()) {
    println("error: mult " + a +", "+ b);
    return null;
  }

  Tensor2d Tensor = new Tensor2d(a.rows(), b.cols());
  for (int i = 0; i < Tensor.rows(); i++) {

    for (int j = 0; j < Tensor.cols(); j++) {

      float sum = 0;
      for (int k = 0; k < a.cols(); k++) {
        sum += a.data[i][k] * b.data[k][j];
      }

      Tensor.data[i][j] = sum;
    }
  }
  return Tensor;
}

Tensor2d sub(Tensor2d a, Tensor2d b) {
  if (a.cols() != b.cols() || a.rows() != b.rows()) {
    println("error: sub " + a + ", " + b);
    return null;
  }

  Tensor2d Tensor = new Tensor2d(a.rows(), a.cols());
  for (int i = 0; i < b.rows(); i++) {
    for (int j = 0; j < b.cols(); j++) {
      Tensor.data[i][j] = a.data[i][j] - b.data[i][j];
    }
  }
  return Tensor;
}





Tensor1d createTensor(int length) {
  return new Tensor1d(length);
}

Tensor1d createTensor(float[] dat) {
  return new Tensor1d(dat);
}

Tensor2d createTensor(int rows, int cols) {
  return new Tensor2d(rows, cols);
}

Tensor2d createTensor(float[][] dat) {
  return new Tensor2d(dat);
}

Tensor1d createTensor(JSONArray Tensor1) {
  return new Tensor1d(Tensor1);
}

Tensor2d createTensor(JSONObject Tensor2) {
  return new Tensor2d(Tensor2);
}
