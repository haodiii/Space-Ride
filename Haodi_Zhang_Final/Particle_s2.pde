class ParticleSystem2{
  ArrayList<Particle2> particles;

  PShape particleShape;

  ParticleSystem2(int n) {
    particles = new ArrayList<Particle2>();
    particleShape = createShape(PShape.GROUP);

    for (int i = 0; i < n; i++) {
      Particle2 p = new Particle2();
      particles.add(p);
      particleShape.addChild(p.getShape());
    }
  }

  void update() {
    for (Particle2 p : particles) {
      p.update();
    }
  }

  void setEmitter(float x, float y) {
    for (Particle2 p : particles) {
      if (p.isDead()) {
        p.rebirth(x, y);
      }
    }
  }

  void display() {

    shape(particleShape);
  }
}
