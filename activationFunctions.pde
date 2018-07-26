//activationFunctions & derivatives

String[] activations = {"sigmoid", "relu", "softmax", "tanh", "none"};
float infinity = 0.1/0.0;

// SIGMOID FUNCTIONS
public float sigmoid(float x) {
  return 1 / (1 + exp(-x));
}

public float dsigmoid(float x) {
  return x * (1. - x);
}

// ReLU FUNCTIONS

public float ReLU(float x) {
  return max(x, 0);
}

public float dReLU(float x) {
  if(x > 0) {
    return 1;
  } else {
    return 0;
  }
}

public float tanh(float x) {
 return (float) Math.tanh(x);
}

public float dtanh(float x) {
 return 1. - x * x;
}

//SOFTMAX FUNCTION

float[] softmax(float[] outputs) {
  float total = 0;

  for(int i = 0; i < outputs.length; outputs[i] = exp(outputs[i]), total += outputs[i++]);

  for(int i = 0; i < outputs.length; i++) {
    outputs[i] /= total;
  }

  return outputs;
}

boolean correctActivationFunction(String ac) {
  for(int i = 0; i < activations.length; i++) {
    if(activations[i].equals(ac)) {
      return true;
    }
  }
  return false;
}
