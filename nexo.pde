class Nexo {

  int inputShape;
  int outputShape;
  int links;

  Tensor1d inputs;
  Tensor1d outputs;

  Tensor1d bias;
  Tensor2d weights;

  String activation = "sigmoid";

  Nexo() {

  }

  Nexo(int inputShape) {
    this.inputShape = inputShape;
  }

  Nexo(int inputShape, int outputShape) {
    this.inputShape = inputShape;
    this.outputShape = outputShape;

    links = inputShape * outputShape;

    init();
  }

  Nexo(JSONObject JNexo) {
    setActivationFunction(JNexo.getString("activation"));
    this.inputShape = JNexo.getInt("inputShape");
    this.outputShape = JNexo.getInt("outputShape");

    if(!JNexo.isNull("bias")) {
      bias = createTensor(JNexo.getJSONArray("bias"));
    }
    if(!JNexo.isNull("weights")) {
      bias = createTensor(JNexo.getJSONArray("weights"));
    }

  }

  JSONObject toJSON() {
    JSONObject JNexo = new JSONObject();

    JNexo.setString("activation", activation);
    JNexo.setInt("inputShape", inputShape);
    JNexo.setInt("outputShape", outputShape);

    if(bias != null) {
      JNexo.setJSONArray("bias", bias.toJSON());
    }
    if(weights != null) {
      JNexo.setJSONObject("weights", weights.toJSON());
    }

    return JNexo;
  }

  void linkNexo(Nexo n) {
    this.outputShape = n.inputShape;
    this.links = inputShape * outputShape;

    init();
  }

  void setActivationFunction(String activation) {
    if(correctActivationFunction(activation)) {
      this.activation = activation;
    } else {
      println("activation not defined. " + activation);
    }
  }

  void init() {
    inputs = createTensor(inputShape);
    bias = createTensor(inputShape);

    if(outputShape != 0) {
      outputs = createTensor(outputShape);
      weights = createTensor(outputShape, inputShape);
    } else {
      outputs = createTensor(inputShape);
    }
  }

  void randomize() {
    if(weights != null) {
      weights.randomize(MINWEIGHT, MAXWEIGHT);
    }

    if(bias != null) {
      bias.randomize(MINBIAS, MAXBIAS);
    }
  }

  Tensor1d predict(Tensor1d inputs) {
    setInputs(inputs);
    applyBias();
    applyActivation();
    applyWeights();

    return outputs;
  }

  void setInputs(Tensor1d in) {
    inputs = in.copy();
  }

  void applyWeights() {
    if(weights == null == false) {
      outputs = mult(weights, inputs);
    }
  }

  void applyBias() {
    if(bias != null) {
      inputs.add(bias.copy());
    }
  }

  void applyActivation() {
    if(activation == null == false) {
      inputs.map(activation);
    }
  }


  void applyBiasDeltas(Tensor1d deltas) {
    if(deltas.containsNaN()) {
      deltas.print();
      throw new IllegalArgumentException("infinity error");
    }
    bias.add(deltas);
  }

  void applyWeightsDeltas(Tensor2d deltas) {
    if(deltas.containsNaN()) {
      deltas.print();
      throw new IllegalArgumentException("infinity error");
    }
    weights.add(deltas);
  }

}
