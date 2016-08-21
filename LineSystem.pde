class LineSystem {
  ArrayList<Line> lines;
  float size;
  int w, h;
  GridEntry[][] pointGrid;
  public LineSystem(int width, int height, float gridSize) {
    w = int(width/gridSize) + 1;
    h = int(height/gridSize) + 1;
    size = gridSize;
    lines = new ArrayList<Line>();
    pointGrid = new GridEntry[w][h];
    for (int i=0; i<w; i++) {
      for (int j=0; j<h; j++) {
        pointGrid[i][j] = new GridEntry();
      }
    }
  }
  public void addLine(Point start) {
    Line newLine = new Line();
    lines.add(newLine);
    addPoint(newLine, start);
  }
  public void updateLine(Line l, float range, float fov) {
    Point last = l.lastPoint();
    Point closest = closestPoint(last, fov);
    if (closest != null) {
      // GOAL: Adjust velocity to be pointing perpendicular to closest's velocity
      PVector t1 = new PVector(-closest.dy(), closest.dx());
      PVector t2 = new PVector(-t1.x, -t1.y);
      PVector newV;
      if (PVector.angleBetween(t1, last.vel()) < PVector.angleBetween(t2, last.vel())) {
        newV = angleLerp(last.vel(), t1, .1);
      }
      else {
        newV = angleLerp(last.vel(), t2, .1);
      }
      Point newPoint = new Point(PVector.add(last.pos(), last.vel()), newV, last.c()*.97 + random(-range, range));
      float d = newPoint.pos().dist(closest.pos());
      if (d <= 7) {
        newPoint.visible = false;
      }
      addPoint(l, newPoint);
    }
    else {
      //addPoint(l, l.lastPoint().update(random(-.003, .003)));
      addPoint(l, l.lastPoint().update(random(-range, range)));
    }
    l.lastPoint().pos().set((l.lastPoint().x() + width) % width, (l.lastPoint().y() + height) % height);
  }
  public void addPoint(Line l, Point p) {
    l.addPoint(p);
    GridEntry e = getGridEntry(p.x(), p.y());
    e.addPoint(p);
  }
  public void update(int n, float range, float fov) {
    for (int i=0; i<n; i++) {
      update(range, fov);
    }
  }
  public void update(float range, float fov) {
    for (Line l : lines) {
      updateLine(l, range, fov);
    }
  }
  public ArrayList<Point> getPointsNear(float x, float y) {
    int nX = round(x/size);
    int nY = round(y/size);
    ArrayList<Point> result = new ArrayList<Point>();
    for (int i = nX-1; i<= nX+1; i++) {
      for (int j = nY-1; j<=nY+1; j++) {
        if (i < w && i >= 0 && j < h && j >= 0) {
          if (i == nX && j == nY) {
            for (Point p : pointGrid[i][j].points) {
              if (p.x() != x && p.y() != y) {
                result.add(p);
              }
            }
          }
          else {
            result.addAll(pointGrid[i][j].points);
          }
        }
      }
    }
    return result;
  }
  
  public Point closestPoint(Point p, float fov) {
    Point result = null;
    float bestD = MAX_FLOAT;
    ArrayList<Point> candidates = getPointsNear(p.x(), p.y());
    for (Point q : candidates) {
      if (PVector.angleBetween(PVector.sub(q.pos(), p.pos()), p.vel()) < fov/2) {
        float d = PVector.dist(p.pos(), q.pos());
        if (d < bestD) {
          d = bestD;
          result = q;
        }
      }
    }
    return result;
  }
  
  public GridEntry getGridEntry(float x, float y) {
    int nX = round(x/size);
    int nY = round(y/size);
    if (nX < w && nX >= 0 && nY < h && nY >= 0) {
      return pointGrid[nX][nY];
    }
    else {
      return new GridEntry();
    }
  }
  
  public void shade(float r) {
    for (Line l : lines) {
      l.shade(r);
    }
  }
}

class GridEntry {
  ArrayList<Point> points;
  public GridEntry() {
    points = new ArrayList<Point>();
  }
  public void addPoint(Point p) {
    points.add(p);
  }
}