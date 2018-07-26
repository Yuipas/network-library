class Nexo {

  int inputShape;
  int outputShape;
  int links;

  tensor1d inputs;
  tensor1d outputs;

  tensor1d bias;
  tensor2d weights;

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
      weights.randomize();
    }

    if(bias != null) {
      bias.randomize();
    }
  }

  tensor1d predict(tensor1d inputs) {
    setInputs(inputs);
    applyBias();
    applyActivation();
    applyWeights();

    return outputs;
  }

  void setInputs(tensor1d in) {
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


  void applyBiasDeltas(tensor1d deltas) {
    if(deltas.containsNaN()) {
      println("infinity error");
    }
    bias.add(deltas);
  }

  void applyWeightsDeltas(tensor2d deltas) {
    if(deltas.containsNaN()) {
      println("infinity error");
    }
    weights.add(deltas);
  }

}
