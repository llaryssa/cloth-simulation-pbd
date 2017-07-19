class Particle {
  PVector pos;
  PVector cons_pos;
  PVector vel;
  float invmass = 0.1;
  
  PVector forces;
  
  boolean fixed;
  PImage img;
  
  Particle(PVector p) {
    vel = new PVector(0,0,0);
    forces = new PVector(0,0,0);
    pos = p.copy();
    cons_pos = p.copy();
    fixed = false;
  }
  
  Particle(PVector p, boolean fix) {
    vel = new PVector(0,0,0);
    forces = new PVector(0,0,0);
    pos = p.copy();
    cons_pos = p.copy();
    fixed = fix;
  }

  void run() {
    render();
  }

  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void applyForce(PVector f) {
    forces.add(f);
  }

  // Method to display
  void render() {
     int color_value;
     if (fixed) {
       color_value = 100;
     } else {
       color_value = 255;
     }
     
     pushMatrix();
     translate(pos.x, pos.y, pos.z);
     lights();
          
     noStroke();
     fill(color_value);
     
     sphere(4);
     popMatrix();
     
     
  }
}