// ALL CREDIT TO MARIUS WATZ

float radianAbs(float a) {
  while (a<0) {
    a+=TWO_PI;
  }
  while(a>TWO_PI) {
    a-=TWO_PI;
  }
 
  return a;
}
 
float radianLerp(float a, float b, float t) {
  float D=radianShortest(a, b);
  return a+D*t;//a+D*t;
}

public PVector angleLerp(PVector a, PVector b, float t) {
  float angleA = atan2(a.y, a.x);
  float angleB = atan2(b.y, b.x);
  float dA = radianShortest(angleA, angleB);
  return a.copy().rotate(dA*t);
}
 
float radianShortest(float a, float b) {
  float D, D2;
 
  D=radianAbs(b-a);
  D2=-radianAbs((a-b));
 
  if (abs(D)>abs(D2)) D=D2;
  return D;
}