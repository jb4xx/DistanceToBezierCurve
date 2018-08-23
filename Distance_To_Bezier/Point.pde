class Point {
  
  private PVector pos;
  private color col;
  private int size;
  private boolean locked;
 
  Point(float x, float y, color p_col, int p_size) {
    pos = new PVector(x, y);
    col = p_col;
    size = p_size;
    locked = false;
  }
  
  void move(float x, float y) {
   pos.x = x;
   pos.y = y;
  }
  
  void show() {
    fill(col);
    noStroke();
    ellipse(pos.x, pos.y, size, size);
  }
  
  PVector pos() {
    return pos;
  }
  
  void lock() {
    locked = true;
  }
  
  void unlock() {
    locked = false;
  }
  
  boolean isLocked() {
    return locked;
  }
  
  boolean isHit(float x, float y) {
    return (pos.x - x) * (pos.x - x) + (pos.y - y) * (pos.y - y) < (size * size) / 4.0;
  }
}
