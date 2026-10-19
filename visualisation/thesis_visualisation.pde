import oscP5.*;
import netP5.*;

OscP5 oscP5;

float rmsVal = 0;
float centroidVal = 0;
float onsetVal = 0;
float phraseVal = 0;

float offsetX = 0, offsetY = 0;
float targetX = 0, targetY = 0;
float phraseThreshold = 0.10; //this went through so many changes 

void setup() {
  size(600, 600);
  oscP5 = new OscP5(this, 9000);
  noStroke();
}

void draw() {
  background(20);
  
  float shapeSize = map(rmsVal, 0.01, 0.35, 60, 220);
  float hueVal = map(centroidVal, 13500, 23000, 200, 20);
  float wobble = map(onsetVal, 0, 15, 0, 45);
  
  if (phraseVal >= phraseThreshold && random(1) < 0.10) {
    targetX = random(-80, 80);
    targetY = random(-50, 50);
  }
  if (phraseVal < phraseThreshold) {
    targetX *= 0.9;
    targetY *= 0.9;
  }
  offsetX += (targetX - offsetX) * 0.3;
  offsetY += (targetY - offsetY) * 0.3;
  
  colorMode(HSB, 360, 100, 100);
  fill(hueVal, 70, 90);
  
  translate(width/2 + offsetX, height/2 + offsetY);
  
  beginShape();
  int points = 16;
  for (int i = 0; i < points; i++) {
    float angle = map(i, 0, points, 0, TWO_PI);
    float r = shapeSize + random(-wobble, wobble);
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    curveVertex(x, y);
  }
  endShape(CLOSE);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/centroid")) {
    centroidVal = msg.get(0).floatValue();
    println("centroid:", centroidVal);
  } else if (msg.checkAddrPattern("/onset")) {
    onsetVal = msg.get(0).floatValue();
    println("onset:", onsetVal);
  } else if (msg.checkAddrPattern("/phrase")) {
    phraseVal = msg.get(0).floatValue();
    println("phrase:", phraseVal);
  } else if (msg.checkAddrPattern("/rms_raw")) {
    rmsVal = msg.get(0).floatValue();
    println("rms_raw:", rmsVal);
  } else if (msg.checkAddrPattern("/centroid_raw")) {
    println("centroid_raw:", msg.get(0).floatValue());
}
  }
