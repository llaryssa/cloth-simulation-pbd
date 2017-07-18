PBD system;

void setup() {
  size(640, 480);
  float cloth_width = 600;
  float cloth_height = 400;
  float cloth_rows = 3;
  float cloth_cols = 4;
  system = new PBD(cloth_width, cloth_height, cloth_rows, cloth_cols); 
}

void draw() {
  background(0);

  // Calculate a "wind" force based on mouse horizontal position
  //float dx = map(mouseX, 0, width, -0.2, 0.2);
  //PVector wind = new PVector(dx, 0);
  //ps.applyForce(wind);
  
  system.run();
}

// Renders a vetor object 'v' as an arrow and a position 'loc'
void drawVector(PVector v, PVector loc, float scayl) {
  pushMatrix();
  float arrowsize = 4;
  // Translate to position to render vector
  translate(loc.x, loc.y);
  stroke(255);
  // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
  rotate(v.heading());
  // Calculate length of vector & scale it to be bigger or smaller if necessary
  float len = v.mag()*scayl;
  // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
  line(0, 0, len, 0);
  line(len, 0, len-arrowsize, +arrowsize/2);
  line(len, 0, len-arrowsize, -arrowsize/2);
  popMatrix();
}