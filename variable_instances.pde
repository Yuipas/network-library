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
  if (val < 0)
  {
    float r = constrain(-val * 255, 0, 255);
    float gb = constrain(val * 255 * -sigmoid(val), 10, 100);
    col = color(r, gb, gb);
  }
  if (val > 0)
  {
    float g = constrain(val * 255, 0, 255);
    float rb = constrain(val * 255 * -sigmoid(val), 10, 100);
    col = color(rb, g, rb);
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
