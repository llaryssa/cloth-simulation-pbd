class Particle {
  PVector pos;
  PVector cons_pos;
  PVector vel;
  float invmass = 0.1;
  
  PVector forces;
  
  boolean fixed;
  PImage img;
  
  Particle(PVector p) {
    vel = new PVector(0,0);
    forces = new PVector(0,0);
    pos = p.copy();
    fixed = false;
  }
  
  Particle(PVector p, boolean fix) {
    vel = new PVector(0,0);
    forces = new PVector(0,0);
    pos = p.copy();
    fixed = fix;
  }

  void run() {
    update();
    render();
  }

  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void applyForce(PVector f) {
    forces.add(f);
  }

  // Method to update position
  void update() {
    //vel.add(acc);
    //pos.add(vel);
    //acc.mult(0); // clear Acceleration
  }

  // Method to display
  void render() {
    //imageMode(CENTER);
    //tint(255, lifespan);
    //image(img, loc.x, loc.y);
    
    // Drawing a circle instead
     if (fixed) {
       fill(80);
     } else {
       fill(255);
     }
     noStroke();
     ellipse(pos.x,pos.y,5,5);
  }
}