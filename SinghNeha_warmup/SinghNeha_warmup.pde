
void setup() {
  size(500,500);
  
}

void draw() {
  background(100,100,100);
  ellipse(250, 250, 500, 500);
  
  fill(0,0,0);
  float bigRadius = 250.0;
  float centerX = 250.0;
  float centerY = 250.0;
  
  float littleRadius = 0.7/(bigRadius*2.0) * (500.0-mouseY) * bigRadius;
  fill(255,255,255);
  stroke(0,0,0);
  
  //recurse to draw circles
  circleMaker(bigRadius, littleRadius, centerX, centerY, 1);
}

//recursion happens here, drawing many happy circles
void circleMaker(float bigRadius, float littleRadius, float centerX, float centerY, int baseCounter) {
  
  //base case: more than 6 iteratoins
  if (baseCounter > 6) {
    return;
  }
  
  //gets new value of littleRadius
  //littleRadius = 0.7/(bigRadius*2.0) * (500.0-mouseY) * bigRadius;
  
  float theta;
  float cx = 0.0;
  float cy = 0.0;
  
  for (int i = 0; i < 3; i++) {
    
     //pi added at the end so the lil circles start at the top
     theta = float(mouseX) * 2.0*PI / 500.0 + (2.0 * PI * i / 3.0) + PI;
     
     //i struggle with basic trigonometry but it works?? i guess??
     cx = centerX + (bigRadius-littleRadius) * sin(theta);
     cy = centerY + (bigRadius-littleRadius) * cos(theta);
     
     //no clue what these colors are doing but they map to 360 nicely so let's go i guess
     colorMode(HSB, 360, 100, 100);
     fill(theta * 180.0/PI, 16.6*baseCounter, 100.0);
     
     //draw 3 circles
     ellipse(cx, cy, 2.0*littleRadius, 2.0*littleRadius);
     
     //recurse once for each circle, with new input values
     circleMaker(littleRadius, 0.7/500.0 * (500.0-mouseY) * littleRadius, cx, cy, baseCounter + 1);
  }
}