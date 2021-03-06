PBD system;

PVector rotation;
PVector translation;

void setup() {
  size(640, 480, P3D);
  float cloth_width = 300;
  float cloth_height = 250;
  float cloth_rows = 20;
  float cloth_cols = 27;
  //float cloth_width = 400;
  //float cloth_height = 300;
  //float cloth_rows = 150;
  //float cloth_cols = 150;
  system = new PBD(cloth_width, cloth_height, cloth_rows, cloth_cols);

  rotation = new PVector(0,0,0);
  translation = new PVector(0,0,0);
}

void draw() {
  background(0);
  
  ortho(-width/2, width/2, -height/2, height/2);
  rotateX(rotation.x);
  rotateY(rotation.y);
  rotateZ(rotation.z);
  translate(translation.x, translation.y, translation.z);
  
  // Calculate a "wind" force based on mouse horizontal position
  if (mousePressed) {
    float dx = map(mouseX, 0, width, -10, 10);
    float dy = map(mouseY, 0, height, -10, 10);
    PVector wind = new PVector(dx, dy, 0);
    drawVector(wind, new PVector(width/2, height/2, 0), 10); 
    system.applyForce(wind);
  }
  
  system.run(); 
  saveFrame();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      system.force.add(new PVector(0,0,0.5));
    } else if (keyCode == DOWN) {
      system.force.sub(new PVector(0,0,0.5));
    }
  } else {
    switch (key) {
      case '0':
        rotation = new PVector(0,0,0);
        translation = new PVector(0,0,0);
        break;    
      case '1':
        rotation = new PVector(PI/6, PI/6 + float(height) * PI, 0);
        translation = new PVector(width/10,-height/6,0);
        break;
      case '2':
        rotation = new PVector(-PI/6, 0, PI/3);
        translation = new PVector(width/4,-height/4,0);
        break;
      case '3':
        rotation = new PVector(-PI/6, PI/6, 0);
        translation = new PVector(width/10,height/4,0);
        break;
      case '4':
        rotation = new PVector(0, PI/3, 0);
        translation = new PVector(2*width, 0,0);
        break;
      case 'z':
        system.force.mult(0);
        break;
    }
  }
}

// Renders a vetor object 'v' as an arrow and a position 'loc'
void drawVector(PVector v, PVector loc, float scayl) {
  pushMatrix();
  float arrowsize = 4;
  // Translate to position to render vector
  translate(loc.x, loc.y, loc.z);
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