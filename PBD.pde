class PBD {
  ArrayList<Particle> particles;
  ArrayList<Constraint> constraints;
  float cloth_width;
  float cloth_height;
  float rows;
  float cols;
  
  float particle_id;
  
  float cloth_stretch = 0.3;
  float cloth_bending = 0.6;
  PVector force = new PVector(5, 5, 0);
  
  int iterations = 10;
  float time_step = 0.2;
  //PImage img;

  PBD(float wid, float hei, float r, float c) {
    particles = new ArrayList<Particle>();
    constraints = new ArrayList<Constraint>();
    cloth_width = wid;
    cloth_height = hei;
    rows = r;
    cols = c;
    
    particle_id = 0;
    
    createMesh();
  }
  
  void run() {  
    for (int i = constraints.size()-1; i >= 0; i--) {
      Constraint p = constraints.get(i);
      p.run();
    }
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
    }
    
    update();
    //delay(5);
  }
  
  void update() {
    println("force: " + force);
     //<>//
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      if (!p.fixed) {
        p.applyForce(force.copy().mult(p.invmass));
        p.vel.add(p.forces.copy().mult(time_step));
        // damping
        p.vel.mult(0.5);
        p.cons_pos = p.pos.copy().add(p.vel.copy().mult(time_step));
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
    }
  }
  
  void createMesh() {
    float dx = cloth_height / (rows - 1);
    float dy = cloth_width / (cols - 1);
    
    // create particles and init distance constraint
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        float x = dx*i + (height/2) - (cloth_height/2);
        float y = dy*j + (width/2) - (cloth_width/2)*1.3;
        
        boolean fix = false;
        if ((j==0 && i==0) || (j==0 && i==rows-1) || (j==cols-1 && i==0) || (j==cols-1 && i==rows-1)) {
          fix = true;
        }
        
        //Particle p = new Particle(new PVector(y,x,0), fix, particle_id++);
        Particle p = new Particle(new PVector(y,x,0), (j == 0), particle_id++);
        
        if (i > 0) {
          // index of upper particle
          int up = int((i-1)*cols+j);
          Constraint c2 = 
            new DistanceConstraint(p, particles.get(up), cloth_stretch, dx);
          constraints.add(c2);
        }
        
        if (j > 0) {
          // index of previous particle
          int prev = int(i*cols + (j-1));
          Constraint c1 = 
            new DistanceConstraint(p, particles.get(prev), cloth_stretch, dy);
          constraints.add(c1);
        }
        
        particles.add(p);
      }
    }
   
    
    // clear fixed constraints
    for (int i = 0; i < constraints.size(); i++) {
      Constraint c = constraints.get(i);
      if (c.p1.fixed && c.p2.fixed && c.p3==null) {
        constraints.remove(i);
        i--;
      }
    }
 
  }

  void applyForce(PVector dir) {
    //force.add(dir);
    force = dir.copy();
  }
}