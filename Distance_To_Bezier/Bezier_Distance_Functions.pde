class BezierDistanceFinder {

  private PVector P0, P1, P2, P3;


  BezierDistanceFinder(PVector p_P0, PVector p_P1, PVector p_P2, PVector p_P3) {
    P0 = p_P0;
    P1 = p_P1;
    P2 = p_P2;
    P3 = p_P3;
  }


  void changeParameters(PVector p_P0, PVector p_P1, PVector p_P2, PVector p_P3) {
    P0 = p_P0;
    P1 = p_P1;
    P2 = p_P2;
    P3 = p_P3;
  }


  ComplexNumber evaluateDotProduct(PVector M, ComplexNumber t) {
    ComplexNumber result, perX, perY, tanX, tanY;
    double divisor;

    perX = t.pow(3).mult(-P3.x).add(t.mult(-1.0).add(1.0).mult(t.pow(2)).mult(-3*P2.x)).add(t.mult(-1.0).add(1.0).pow(2).mult(t).mult(-3*P1.x)).add(t.mult(-1.0).add(1.0).pow(3).mult(-P0.x)).add(M.x);
    perY = t.pow(3).mult(-P3.y).add(t.mult(-1.0).add(1.0).mult(t.pow(2)).mult(-3*P2.y)).add(t.mult(-1.0).add(1.0).pow(2).mult(t).mult(-3*P1.y)).add(t.mult(-1.0).add(1.0).pow(3).mult(-P0.y)).add(M.y);
    tanX = t.pow(2).mult(3*P3.x).add(t.mult(-1.0).add(1.0).mult(t).mult(6*P2.x)).add(t.pow(2).mult(-3*P2.x)).add(t.mult(-1.0).add(1.0).mult(t).mult(-6*P1.x)).add(t.mult(-1.0).add(1.0).pow(2).mult(3*P1.x)).add(t.mult(-1.0).add(1.0).pow(2).mult(-3*P0.x));
    tanY = t.pow(2).mult(3*P3.y).add(t.mult(-1.0).add(1.0).mult(t).mult(6*P2.y)).add(t.pow(2).mult(-3*P2.y)).add(t.mult(-1.0).add(1.0).mult(t).mult(-6*P1.y)).add(t.mult(-1.0).add(1.0).pow(2).mult(3*P1.y)).add(t.mult(-1.0).add(1.0).pow(2).mult(-3*P0.y));
    divisor = -3*P0.x*P0.x+18*P0.x*P1.x-18*P0.x*P2.x+6*P0.x*P3.x-27*P1.x*P1.x+54*P1.x*P2.x-18*P1.x*P3.x-27*P2.x*P2.x+18*P2.x*P3.x-3*P3.x*P3.x-3*P0.y*P0.y+18*P0.y*P1.y-18*P0.y*P2.y+6*P0.y*P3.y-27*P1.y*P1.y+54*P1.y*P2.y-18*P1.y*P3.y-27*P2.y*P2.y+18*P2.y*P3.y-3*P3.y*P3.y;
    //divisor = 1;

    result = perX.mult(tanX).add(perY.mult(tanY)).divide(divisor);

    return result;
  }

  private ComplexNumber[] getNextGeneration(ComplexNumber[] old, PVector M) {
    ComplexNumber[] result = new ComplexNumber[5];

    result[0] = evaluateDotProduct(M, old[0]).divide(old[0].add(old[1].mult(-1)).mult(old[0].add(old[2].mult(-1))).mult(old[0].add(old[3].mult(-1))).mult(old[0].add(old[4].mult(-1)))).mult(-1).add(old[0]);
    result[1] = evaluateDotProduct(M, old[1]).divide(old[1].add(result[0].mult(-1)).mult(old[1].add(old[2].mult(-1))).mult(old[1].add(old[3].mult(-1))).mult(old[1].add(old[4].mult(-1)))).mult(-1).add(old[1]);
    result[2] = evaluateDotProduct(M, old[2]).divide(old[2].add(result[1].mult(-1)).mult(old[2].add(result[0].mult(-1))).mult(old[2].add(old[3].mult(-1))).mult(old[2].add(old[4].mult(-1)))).mult(-1).add(old[2]);
    result[3] = evaluateDotProduct(M, old[3]).divide(old[3].add(result[1].mult(-1)).mult(old[3].add(result[2].mult(-1))).mult(old[3].add(result[0].mult(-1))).mult(old[3].add(old[4].mult(-1)))).mult(-1).add(old[3]);
    result[4] = evaluateDotProduct(M, old[4]).divide(old[4].add(result[1].mult(-1)).mult(old[4].add(result[2].mult(-1))).mult(old[4].add(result[3].mult(-1))).mult(old[4].add(result[0].mult(-1)))).mult(-1).add(old[4]);

    return result;
  }


  private ComplexNumber[] getRootsOfDotProduct(PVector M) {
    ComplexNumber[] result = new ComplexNumber[5];

    result[0] = new ComplexNumber(1, 0);
    result[1] = new ComplexNumber(0.4, 0.9);
    result[2] = result[1].pow(2);
    result[3] = result[1].pow(3);
    result[4] = result[1].pow(4);

    for (int i = 0; i < 15; i++) {
      result = getNextGeneration(result, M);
    }

    return result;
  }


  ArrayList<Double> getTClosestTo(PVector M) {
    ComplexNumber[] roots = getRootsOfDotProduct(M);
    ArrayList<Double> tempResult = new ArrayList<Double>();
    ArrayList<Double> result = new ArrayList<Double>();
    double minDist = Double.POSITIVE_INFINITY;
    float threshold = 0.00001;

    for (int i = 0; i < 5; i++) {
      if (roots[i].Re() > 0 && roots[i].Re() < 1) {  
        tempResult.add(roots[i].Re());
      }
    }
    tempResult.add((double)0);
    tempResult.add((double)1);
    
    for (int i = 0; i < tempResult.size(); i++) {
      double t = tempResult.get(i);
      double dist = dist(M.x, M.y, bezierPoint(P[0].pos().x, P[1].pos().x, P[2].pos().x, P[3].pos().x, (float)t), bezierPoint(P[0].pos().y, P[1].pos().y, P[2].pos().y, P[3].pos().y, (float)t));
      if(dist < minDist) {
        minDist = dist;
      }
    }
    
    for (int i = 0; i < tempResult.size(); i++) {
      double t = tempResult.get(i);
      double dist = dist(M.x, M.y, bezierPoint(P[0].pos().x, P[1].pos().x, P[2].pos().x, P[3].pos().x, (float)t), bezierPoint(P[0].pos().y, P[1].pos().y, P[2].pos().y, P[3].pos().y, (float)t)) - minDist;
      if(abs((float)dist) < threshold) {
        result.add(t);
      }
    }
    
    return result;
  }
}
