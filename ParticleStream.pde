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
      for (int j=0; j<random(30, 50); j++) {
        strokeWeight(1);
        float easeCoef = easeCoef(0, l.numPoints(), 300, i);
        float d = random(r);
        d *= d;
        //stroke(d/r*255, (1-d/r)*15);
        stroke(0, (1-d/r)*easeCoef*15);
        //stroke(255);
        PVector midPoint = new PVector(point.x() - tangent.y * d*easeCoef, point.y() + tangent.x * d*easeCoef);
        PVector startPoint = PVector.add(midPoint, PVector.mult(tangent, random(5)));
        PVector endPoint = PVector.add(midPoint, PVector.mult(tangent, -random(5)));
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

public void save() {
  String folder = month() + "-" + day() + "-" + year();
  String fName = hour() + ";" + minute() + "," + second();
  String ext = ".png";
  save(folder + "/" + fName + ext);
}

LineSystem lines;
int animTime = 5000;
void setup() {
  size(900, 900);
  background(255);
  //ArrayList<Line> lines = new ArrayList<Line>();
  //for (int j=0; j<10; j++) {
  //  Line l = curveWalk(1000);
  //  l.sideMult = random(1)<.5?1:-1;
  //  lines.add(l);
  //}
  
  //float[][] finalShading = shade(lines, width, height, 20);
  //for (int i=0; i<width; i++) {
  //  for (int j=0; j<height; j++) {
  //    if (finalShading[i][j] > 0) {
  //      stroke(255, finalShading[i][j]*50);
  //      point(i, j);
  //    }
  //  }
  //}
  
  lines = new LineSystem(width, height, 25);
  for (int i=0; i<2; i++) {
    float x = random(width);
    float y = random(height);
    float a = atan2(height/2-y, width/2-x);
    //float a = random(PI, PI + .1);
    lines.addLine(new Point(x, y, cos(a), sin(a), 0));
  }
  //lines.update(1);
  
  //noStroke();
  //fill(0, 150);
  //for (Line l : lines.lines) {
  //  fill(0);
  //  l.drawStrip(1);
  //  //float weight = random(10);
  //  //fill(weight/10*50, 150 - weight/10*100);
  //  //l.drawStrip(weight);
  //}
  //shade(lines.lines, 15);
  //save("test.png");
}

void draw() {
  //float size = easeCoef(0, animTime, 300, frameCount % animTime) * 5;
  stroke(0, 5);
  lines.update(.001, PI-.01);
  for (Line l : lines.lines) {
    float size = abs(l.lastPoint().c())*1000;
    pushMatrix();
    translate(l.lastPoint().x(), l.lastPoint().y());
    rotate(atan2(l.lastPoint().dy(), l.lastPoint().dx()));
    
    // overlapping ellipse code
    //fill(255);
    //noStroke();
    //ellipse(0, 0, l.lastPoint().vel().mag()*2, size + 10);
    
    //if (l.lastPoint().visible()) {
      fill(0);
      noStroke();
      ellipse(0, 0, size*2, size);
    //}
    popMatrix();
    //stroke(color(255, 0, 0));
    //l.lastPoint().shade(1, 25);
  }
  if (frameCount % animTime == 0) {
    save();
    setup();
  }
}