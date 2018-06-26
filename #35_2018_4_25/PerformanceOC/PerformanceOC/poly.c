//
//  poly.c
//  PerformanceOC
//
//  Created by Phink on 4/25/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

#include "poly.h"
#import <Accelerate/Accelerate.h>

static const int PolynomialDegree = 15;
static double coefficients[PolynomialDegree + 1] = {
    -1.4026e-21,
    -1.3584e-21,
    8.6894e-18,
    1.5176e-17,
    -2.1842e-14,
    -5.7466e-14,
    2.8588e-11,
    1.0192e-10,
    -2.0757e-08,
    -9.0261e-08,
    8.1542e-06,
    3.2105e-05,
    -0.0014384,
    0.025922,
    0.36992,
    14.271
};

double PolyLazy (double x)
{
    int p = PolynomialDegree;
    double y = coefficients[p];
    while (p--) {
        y += coefficients[p] * pow (x, (PolynomialDegree - p));
    }
    return y;
}





double PolyNoPow (double x)
{
    int p = PolynomialDegree;
    double xp = 1;
    double y = coefficients[p];
    
    while (p--) {
        xp *= x;
        y += coefficients[p] * xp;
    }
    return y;
}








double PolyAccelerate (double x)
{
    if (x == 0) {
        return coefficients[PolynomialDegree];
    }
    double y = 0;
    vDSP_vpolyD (coefficients, 1, &x, 1, &y, 1, 1, PolynomialDegree);
    return y;
}

