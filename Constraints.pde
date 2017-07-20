class Constraint {
  Particle p1;
  Particle p2;
  Particle p3;
  float stiffness;
  int cardinality;
  boolean equality;
  
  Constraint(Particle p, Particle q, Particle r, float stiff, int card, boolean eq) {
    p1 = p;
    p2 = q;
    p3 = r;
    stiffness = stiff;
    cardinality = card;
    equality = eq;
  }
  
  void run() {}
  void update() {}
  
  void prettyPrint() {
    println("p1: (" + p1.pos.x + "," + p1.pos.y + ")");
    println("p2: (" + p2.pos.x + "," + p2.pos.y + ")");
  }
}

////////////////////////////////////////////////////////////////////////////////

class DistanceConstraint extends Constraint {
  float rest_distance;
  
  DistanceConstraint(Particle p, Particle q, float stiff, float d) {
    super(p,q,null,stiff,2,true);
    rest_distance = d;
  }
  
  void update() {
    PVector n = p1.cons_pos.copy().sub(p2.cons_pos);
    float dist = n.mag();
    n.normalize();
    float invmass_sum = p1.invmass + p2.invmass;
    
    PVector diff = n.mult(stiffness * (dist - rest_distance) / invmass_sum);
    //PVector diff = n.mult((dist - rest_distance) / invmass_sum);
    
    if (!p1.fixed) {
      p1.cons_pos.sub(diff.copy().mult(p1.invmass));
    }
    
    //if (!p2.fixed) {
    //  p2.cons_pos.add(diff.copy().mult(p2.invmass));
    //}
    
    if (diff.mag() == 0) {
      p1.cons_pos = p1.pos.copy();
      p2.cons_pos = p2.pos.copy();
    }    
  }
  
  void run() {
    render();
  }
  
  void render() {
    line(p1.cons_pos.x, p1.cons_pos.y, p1.cons_pos.z, p2.cons_pos.x, p2.cons_pos.y, p2.cons_pos.z);
    stroke(50);
  }
}

////////////////////////////////////////////////////////////////////////////////

class BendingConstraint extends Constraint {
  float rest_length;
  float gen_invmass;
  float bending;
  PVector centroid;
  
  BendingConstraint(Particle p, Particle q, Particle r, float stiff, float bend) {
    super(p,q,r,stiff,3,false);
    bending = bend;
    gen_invmass = p.invmass + q.invmass + 2*r.invmass;
    centroid = p.pos.copy().add(q.pos).add(r.pos).mult(1.0/3.0);
    rest_length = p3.pos.copy().sub(centroid).mag();
  }
  
  void update() {
    centroid = p1.cons_pos.copy().add(p2.cons_pos).add(p3.cons_pos).mult(1.0/3.0);
    PVector n = p3.pos.copy().sub(centroid);
    float l = n.mag();
    PVector diff = n.copy().mult(1 - rest_length/l);
    
    if (!p1.fixed) {
      p1.cons_pos.add(diff.copy().mult(stiffness).mult(2*p1.invmass/gen_invmass));
    }
    if (!p2.fixed) {
      p2.cons_pos.add(diff.copy().mult(stiffness).mult(2*p2.invmass/gen_invmass));
    }
    if (!p3.fixed) {
      p3.cons_pos.add(diff.copy().mult(stiffness).mult(-4*p3.invmass/gen_invmass));
    }
  }
  
  void run() {
    render();
  }
  
  void render() {
    beginShape();
    vertex(p1.cons_pos.x, p1.cons_pos.y, p1.cons_pos.z);
    vertex(p2.cons_pos.x, p2.cons_pos.y, p2.cons_pos.z);
    vertex(p3.cons_pos.x, p3.cons_pos.y, p3.cons_pos.z);
    endShape();
    //line(p1.cons_pos.x, p1.cons_pos.y, p1.cons_pos.z, p2.cons_pos.x, p2.cons_pos.y, p2.cons_pos.z);
    stroke(90);
  }
}