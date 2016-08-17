class Point {
  private PVector p, v;
  private float c;
  private boolean visible;
  public Point(float x, float y, float dx, float dy, float c) {
    this(new PVector(x, y), new PVector(dx, dy), c);
  }
  public Point(PVector position, PVector velocity, float curvature) {
    p = position.copy();
    v = velocity.copy();
    c = curvature;
    visible = true;
  }
  public Point(PVector position, PVector velocity) {
    this(position, velocity, 0);
  }
  public Point(Point pt) {
    this(pt.p, pt.v, pt.c);
  }
  public float x() {
    return p.x;
  }
  public float y() {
    return p.y;
  }
  public float dx() {
    return v.x;
  }
  public float dy() {
    return v.y;
  }
  public float c() {
    return c;
  }
  public PVector pos() {
    return p;
  }
  public PVector vel() {
    return v;
  }
  public void addC(float amount) {
    c += amount;
  }
  public boolean visible() {
    return visible;
  }
  public void setVisible(boolean v) {
    visible = v;
  }
  public Point update(float amount) {
    Point r = new Point(this);
    r.p.add(r.v);
    r.v.rotate(c);
    r.addC(amount);
    return r;
  }
  public void shade(int side, float r) {
    PVector t = vel().copy();
    for (int j=0; j<random(50, 100); j++) {
        strokeWeight(1);
        float d = random(r) * side;
        d *= d;
        //stroke(d/r*255, (1-d/r)*15);
        stroke(0, (1-d/r)*10);
        //stroke(255);
        PVector midPoint = new PVector(x() - dy() * d, y() + dx() * d);
        t.rotate(random(-.1, .1));
        PVector startPoint = PVector.add(midPoint, PVector.mult(t, random(5)));
        PVector endPoint = PVector.add(midPoint, PVector.mult(t, -random(5)));
        line(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
      }
  }
}