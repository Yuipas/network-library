final String networksPath = "data/networks/";
final int packageSize = 400;
final int packageCount = 25;

final int resolution = 28;
final int INPUTS = resolution*resolution;
final int OUTPUTS = 10;
int logFrecuency = 10000;


final float MINWEIGHT = -1;
final float MAXWEIGHT = +1;
final float MINBIAS = -1;
final float MAXBIAS = +1;

color getColor(float val)
{
  color col = color(255);
  if (val < 0) {
    // rgb(250, 128, 114)
    val = abs(val);
    float r = constrain(250 * val, 0, 250);
    float g = constrain(128 * val, 0, 128);
    float b = constrain(114 * val, 0, 114);
    col = color(r, g, b);
  } else if (val > 0) {
    // rgb(70, 130, 180)
    // rgb(50, 205, 50)
    float r = constrain(70 * val, 0, 70);
    float g = constrain(130 * val, 0, 130);
    float b = constrain(180 * val, 0, 180);
    // float r = constrain(50 * val, 0, 50);
    // float g = constrain(205 * val, 0, 205);
    // float b = constrain(50 * val, 0, 50);
    col = color(r, g, b);
  }

  return col;
}

int indexof(float[] arr, float search) {
  if (arr == null)   return -1;

  for (int i = 0; i != arr.length; i++)
    if (search == (arr[i]))  return i;

  return -1;
}

int sum(int[] arr) {
  float[] temp = float(arr);
  return int(sum(temp));
}

float sum(float[] arr) {
  float total = 0;
  for(float a : arr) total += a;
  return total;
}
