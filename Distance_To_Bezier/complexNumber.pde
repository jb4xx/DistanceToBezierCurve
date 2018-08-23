class ComplexNumber {

  private double rPart, iPart;
  
  
  ComplexNumber(double r, double i) {
    rPart = r;
    iPart = i;
  }
  
  
  ComplexNumber(double r) {
    rPart = r;
    iPart = 0;
  }
  
  
  double Re() {
    return rPart;
  }
  
  
  double Im() {
    return iPart;
  }
  
  
  ComplexNumber mult(ComplexNumber nb) {
    return new ComplexNumber(rPart * nb.Re() - iPart * nb.Im(), rPart * nb.Im() + iPart * nb.Re());
  }
  
  
  ComplexNumber mult(double lambda) {
    return new ComplexNumber(lambda * rPart, lambda * iPart);
  }
  
  
  ComplexNumber add(ComplexNumber nb) {
    return new ComplexNumber(rPart + nb.Re(), iPart + nb.Im());
  }
  
  ComplexNumber add(double nb) {
    return new ComplexNumber(rPart + nb, iPart);
  }
  
  
  ComplexNumber divide(ComplexNumber nb) {
    double divisor = nb.Re() * nb.Re() + nb.Im() * nb.Im();
    double dividendRe = rPart * nb.Re() + iPart * nb.Im();
    double dividendIm = iPart * nb.Re() - rPart * nb.Im();

    return new ComplexNumber(dividendRe / divisor, dividendIm / divisor);
  }
  
  
  ComplexNumber divide(double divisor) {
    return new ComplexNumber(rPart / divisor, iPart / divisor);
  }
  
  
  ComplexNumber pow(int n) {
    ComplexNumber result;
    
    if (n == 0) {
      return new ComplexNumber(1, 0);
    }
    
    if (n == 1) {
      return new ComplexNumber(rPart, iPart);
    }
    
    result = new ComplexNumber(rPart, iPart);   
    for (int i = 0; i < n - 1; i++) {
      result = result.mult(this);
    }
    return result;
  }
  
  
  void log() {
    println(rPart + " + " + iPart + "i");
  }
}
