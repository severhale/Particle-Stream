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

class Point {
  PVector p, v;
  public Point(PVector position, PVector velocity) {
    p = position.copy();
    v = velocity.copy();
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
}

class LineSystem {
  ArrayList<Line> lines;
  float size;
  int w, h;
  public LineSystem(int width, int height, float gridSize) {
    w = width;
    h = height;
    size = gridSize;
    lines = new ArrayList<Line>();
  }
  
}

public float closestPointDistance(Line l, int x, int y) {
  return new PVector(x, y).dist(l.getPoint(closestPointIndex(l, x, y)).p);
}

public int closestPointIndex(Line l, int x, int y) {
  float result = MAX_FLOAT;
  int ind = 0;
  PVector orig = new PVector(x, y);
  for (int i=0; i<l.numPoints(); i++) {
    PVector p = l.getPoint(i).p;
    //PVector p1, p2;
    //if (i==0) {
    //  p2 = l.getPoint(i+1);
    //  p1 = p;
    //}
    //else if (i==l.numPoints()-1) {
    //  p2 = p;
    //  p1 = l.getPoint(i-1);
    //}
    //else {
    //  p2 = l.getPoint(i+1);
    //  p1 = l.getPoint(i-1);
    //}
    //if (l.sideMult * ((x-p1.x)*(p2.y-p1.y)-(y-p1.y)*(p2.x-p1.x)) < 0) {
      float d = orig.dist(p);
      if (d < result) {
        result = d;
        ind = i;
      }
    //}
  }
  return ind;
}

//public float closestPointDistance(Line l, int x, int y, float r) {
//  ArrayList<Integer> points = closePoints(l, x, y, r);
//  float result = MAX_FLOAT;
//  PVector orig = new PVector(x, y);
//  for (int i : points) {
//    PVector p = l.getPoint(i);
//    PVector p1, p2;
//    if (i==0) {
//      p2 = l.getPoint(i+1);
//      p1 = p;
//    }
//    else if (i==l.numPoints()-1) {
//      p2 = p;
//      p1 = l.getPoint(i-1);
//    }
//    else {
//      p2 = l.getPoint(i+1);
//      p1 = l.getPoint(i-1);
//    }
//    //PVector toOrig = PVector.sub(orig, p);
//    //if (l.sideMult * (atan2(toOrig.y, toOrig.x) - atan2(tangent.y, tangent.x)) < 0) {
//      //(x−x1)(y2−y1)−(y−y1)(x2−x1)
//    if (l.sideMult * ((x-p1.x)*(p2.y-p1.y)-(y-p1.y)*(p2.x-p1.x)) < 0) {
//      result = min(result, orig.dist(p));
//    }
//    //else {
//    //  result = MAX_FLOAT;
//    //  break;
//    //}
//  }
//  return result;
//}

//public ArrayList<Integer> closePoints(Line l, int x, int y, float r) {
//  ArrayList<Integer> results = new ArrayList<Integer>();
//  PVector orig = new PVector(x, y);
//  for (int i=0; i<l.numPoints(); i++) {
//    PVector p = l.getPoint(i);
//    if (orig.dist(p) <= r) {
//      results.add(i);
//    }
//  }
//  return results;
//}

public float easeCoef(float a, float b, float threshold, float t) {
  float dist = min(t-a, b-t);
  float result = 1;
  if (dist <= threshold) {
    result = sin(PI/2*dist/threshold);
    //result = dist/threshold;
    //result = result*result*result/2+1;
  }
  return result;
}

public float[][] shade(Line l, int w, int h, float r) {
  float[][] values = new float[w][h];
  for (int i=0; i<w; i++) {
    for (int j=0; j<h; j++) {
      float d = closestPointDistance(l, i, j);
      if (d <= r) {
        values[i][j] = 1-d/r;
      }
    }
  }
  return values;
}

public float[][] shade(ArrayList<Line> lines, int w, int h, float r) {
  float[][] values = new float[w][h];
  //float sqrtR = sqrt(r);
  for (int i=0; i<w; i++) {
    for (int j=0; j<h; j++) {
      for (Line l : lines) {
        int k = closestPointIndex(l, i, j);
        float d = new PVector(i, j).dist(l.getPoint(k).p);
        if (d < r) {
          //values[i][j] += easeCoef(0, l.numPoints(), 300, k)*(1-d/r);
          values[i][j] += 1-d/r;
        }
      }
    }
  }
  return values;
}

public void shade(ArrayList<Line> lines, float r) {
  for (Line l : lines) {
    for (int i=0; i<l.numPoints(); i++) {
      Point point = l.getPoint(i);
      PVector tangent = point.v.copy().normalize();
      for (int j=0; j<random(40, 80); j++) {
        strokeWeight(1);
        float d = random(1);
        float easeCoef = easeCoef(0, l.numPoints(), 300, i);
        d = d*d*r*easeCoef;
        stroke(0, (1-d/r)*5);
        PVector midPoint = new PVector(point.x() - tangent.y * d, point.y() + tangent.x * d);
        PVector startPoint = PVector.add(midPoint, PVector.mult(tangent, random(3)));
        PVector endPoint = PVector.add(midPoint, PVector.mult(tangent, -random(3)));
        line(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
      }
    }
  }
}

public Line curveWalk(int steps) {
  Line l = new Line();
  l.addPoint(random(width), 3*height/4, 0, -1);
  float c = 0;
  for (int i=0; i<steps; i++) {
    Point pt = l.lastPoint();
    l.addPoint(PVector.add(pt.p, pt.v), pt.v.copy().rotate(c));
    c += random(-.003, .003);
  }
  return l;
}

void setup() {
  size(900, 900);
  background(0);
  ArrayList<Line> lines = new ArrayList<Line>();
  for (int j=0; j<100; j++) {
    Line l = curveWalk(1000);
    l.sideMult = random(1)<.5?1:-1;
    lines.add(l);
  }
  
  //float[][] finalShading = shade(lines, width, height, 20);
  //for (int i=0; i<width; i++) {
  //  for (int j=0; j<height; j++) {
  //    if (finalShading[i][j] > 0) {
  //      stroke(255, finalShading[i][j]*50);
  //      point(i, j);
  //    }
  //  }
  //}
  
  noStroke();
  fill(255);
  for (Line l : lines) {
    l.drawStrip(5);
  }
  save("test.png");
}

void draw() {}

void keyPressed() {
  Line l = curveWalk(1000);
  l.sideMult = random(1)<.5?1:-1;
  l.drawStrip(3);
}