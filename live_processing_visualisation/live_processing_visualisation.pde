import oscP5.*;
import netP5.*;

OscP5 oscP5;

float rmsVal = 0;
float centroidVal = 0;
float onsetVal = 0;

void setup() {
  size(600, 600);
  oscP5 = new OscP5(this, 9000);
  noStroke();
}

void draw() {
  background(20);
  
  // Map RMS (roughly -0.7 to -0.1 range based on your data) to size
  float size = map(rmsVal, -0.7, -0.1, 80, 300);
  
  // Map centroid (roughly -20000 to 20000 range) to hue
  float hueVal = map(centroidVal, -20000, 20000, 140, 40); // blue/cool to orange/warm
  
  // Map onset to wobble amount
  float wobble = map(abs(onsetVal), 0, 5, 0, 30);
  
  colorMode(HSB, 360, 100, 100);
  fill(hueVal, 70, 90);
  
  translate(width/2, height/2);
  
  beginShape();
  int points = 24;
  for (int i = 0; i < points; i++) {
    float angle = map(i, 0, points, 0, TWO_PI);
    float r = size + random(-wobble, wobble);
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    curveVertex(x, y);
  }
  endShape(CLOSE);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/rms")) {
    rmsVal = msg.get(0).floatValue();
  } else if (msg.checkAddrPattern("/centroid")) {
    centroidVal = msg.get(0).floatValue();
  } else if (msg.checkAddrPattern("/onset")) {
    onsetVal = msg.get(0).floatValue();
  }
}
