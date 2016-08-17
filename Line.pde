import java.util.Arrays;

class Line {
  private ArrayList<Point> path;
  int sideMult;
  public Line(ArrayList<Point> points) {
    path = points;
    sideMult = 1;
  }
  public Line() {
    path = new ArrayList<Point>();
    sideMult = 1;
  }
  public void addPoint(Point point) {
    path.add(point);
  }
  public void addPoint(float x, float y, float dx, float dy) {
    addPoint(new Point(new PVector(x, y), new PVector(dx, dy)));
  }
  public void addPoint(PVector pos, PVector vel) {
    addPoint(pos.x, pos.y, vel.x, vel.y);
  }
  public Point getPoint(int index) {
    return path.get(index);
  }
  public ArrayList<Point> points() {
    return path;
  }
  public int numPoints() {
    return path.size();
  }
  public Point lastPoint() {
    return getPoint(numPoints()-1);
  }
  public void draw() {
    beginShape();
    for (Point p : path) {
      vertex(p.x(), p.y());
    }
    endShape();
  }
  public void drawStrip(float thickness) {
    beginShape();
    for (int i=0; i<numPoints(); i++) {
      Point p = getPoint(i);
      PVector t = new PVector(-p.dy(), p.dx());
      //float radius = min(numPoints()/100, 1);
      float radius = thickness/2;
      radius *= easeCoef(0, numPoints(), 300, i);
      t.mult(radius);
      vertex(p.x() + t.x, p.y() + t.y);
    }
    for (int i=numPoints()-1; i>=0; i--) {
      Point p = getPoint(i);
      PVector t = new PVector(-p.dy(), p.dx());
      //float radius = min(numPoints()/100, 10);
      float radius = .5;
      radius *= easeCoef(0, numPoints(), 300, i);
      t.mult(radius);
      vertex(p.x() - t.x, p.y() - t.y);
    }
    endShape();
  }
  public PVector getTangent(int i) {
    Point p = getPoint(i);
    return p.v.copy();
  }
}