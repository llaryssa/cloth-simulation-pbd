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
    if (!p2.fixed) {
      p2.cons_pos.add(diff.copy().mult(p2.invmass));
    }
  }
  
  void run() {
    render();
  }
  
  void render() {
    line(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
    //line(p1.cons_pos.x, p1.cons_pos.y, p2.cons_pos.x, p2.cons_pos.y);
    stroke(50);
  }
}