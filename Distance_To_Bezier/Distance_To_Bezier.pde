Point[] P; 
Point M;
float deltaX, deltaY;
BezierDistanceFinder bdf;
ArrayList<Double> closest;

void setup() {
  size(500, 500);
  
  P = new Point[4];
  P[0] = new Point(100, 400, color(200, 200, 10), 10);
  P[1] = new Point(100, 200, color(200, 200, 10), 10);
  P[2] = new Point(400, 200, color(200, 200, 10), 10);
  P[3] = new Point(400, 400, color(200, 200, 10), 10);
  M = new Point(370, 270, color(255, 20, 20), 10);
  
  bdf = new BezierDistanceFinder(P[0].pos(), P[1].pos(), P[2].pos(), P[3].pos());
  closest = bdf.getTClosestTo(M.pos());
}


void draw() {
  background(20);

  // Draw the control lines
  stroke(50);
  strokeWeight(2);
  line(P[0].pos().x, P[0].pos().y, P[1].pos().x, P[1].pos().y);
  line(P[2].pos().x, P[2].pos().y, P[3].pos().x, P[3].pos().y);

  // Draw the bezier curves
  noFill();
  stroke(200);
  strokeWeight(2);
  bezier(P[0].pos().x, P[0].pos().y, P[1].pos().x, P[1].pos().y, P[2].pos().x, P[2].pos().y, P[3].pos().x, P[3].pos().y);


  // Draw the points of interest
  for (int i = 0; i < 4; i++) {
    P[i].show();
  }
  M.show();
  
  if (closest.size() == 0) {
    return;
  }
  for (int i = 0; i < closest.size(); i++) {
    fill(120, 170, 250);
    noStroke();
    double t = closest.get(i);
    
    ellipse(bezierPoint(P[0].pos().x, P[1].pos().x, P[2].pos().x, P[3].pos().x, (float)t), bezierPoint(P[0].pos().y, P[1].pos().y, P[2].pos().y, P[3].pos().y, (float)t), 10, 10);
  }
}


void mousePressed() {
  // Check if mouse is over a point
  for (int i = 0; i < 4; i++) {
    if (P[i].isHit(mouseX, mouseY)) {
      P[i].lock();
      deltaX = mouseX - P[i].pos().x;
      deltaY = mouseY - P[i].pos().y;
      return;
    }
  }

  if (M.isHit(mouseX, mouseY)) {
    M.lock();
    deltaX = mouseX - M.pos().x;
    deltaY = mouseY - M.pos().y;
  }
}


void mouseReleased() {
  for (int i = 0; i < 4; i++) {
    P[i].unlock();
  }
  M.unlock();
}


void mouseDragged() {
  for (int i = 0; i < 4; i++) {
    if (P[i].isLocked()) {
      P[i].move(mouseX - deltaX, mouseY - deltaY);
    }
  }
  
  if (M.isLocked()) {
    M.move(mouseX - deltaX, mouseY - deltaY);
  }
  
  bdf.changeParameters(P[0].pos(), P[1].pos(), P[2].pos(), P[3].pos());
  closest = bdf.getTClosestTo(M.pos());
}
