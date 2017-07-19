class PBD {
  ArrayList<Particle> particles;
  ArrayList<Constraint> constraints;
  float cloth_width;
  float cloth_height;
  float rows;
  float cols;
  
  float cloth_stiffness = 1;
  
  PVector force = new PVector(5, 5, 0);
  
  int iterations = 10;
  float time_step = 0.01;
  //PImage img;

  PBD(float wid, float hei, float r, float c) {
    particles = new ArrayList<Particle>();
    constraints = new ArrayList<Constraint>();
    cloth_width = wid;
    cloth_height = hei;
    rows = r;
    cols = c;
    
    createMesh();
  }
  
  void run() {  
    //pushMatrix();
    for (int i = constraints.size()-1; i >= 0; i--) {
      Constraint p = constraints.get(i);
      p.run();
    }
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
    }
    //popMatrix();
    
    update();
    delay(50);
  }
  
  void update() {
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      if (!p.fixed) {
        p.applyForce(force.copy().mult(p.invmass));
        p.vel.add(p.forces.copy().mult(time_step));
        // damping
        p.vel.mult(0.98);
        p.cons_pos = p.pos.add(p.vel.copy().mult(time_step));
      } else {
        p.cons_pos = p.pos.copy();
      }
    }
    
    for (int i = 0; i < constraints.size(); i++) {
      constraints.get(i).update();
    }
    
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.vel = p.cons_pos.copy().sub(p.pos).div(time_step);
      p.pos = p.cons_pos.copy();
      p.forces = force.mult(0);
    } 
  }
  
  void createMesh() {
    float dx = cloth_height / (rows - 1);
    float dy = cloth_width / (cols - 1);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        float x = dx*i + (height/2) - (cloth_height/2);
        float y = dy*j + (width/2) - (cloth_width/2);
        
        Particle p = new Particle(new PVector(y,x,0), false);
        //Particle p = new Particle(new PVector(y,x,0), (j == 0));
        
        if (i > 0) {
          // index of upper particle
          int up = int((i-1)*cols+j);
          Constraint c2 = 
            new DistanceConstraint(p, particles.get(up), cloth_stiffness, dy);
          constraints.add(c2);
        }
        
        if (j > 0) {
          // index of previous particle
          int prev = int(i*cols + (j-1));
          Constraint c1 = 
            new DistanceConstraint(p, particles.get(prev), cloth_stiffness, dx);
          constraints.add(c1);
        }
        
        particles.add(p);
      }
    }
 
  }

  // Method to add a force vector to all particles currently in the system
  void applyForce(PVector dir) {
    force = dir.copy();
  }
}