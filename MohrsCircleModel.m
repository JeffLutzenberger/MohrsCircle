//
//  MohrsCircleModel.m
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MohrsCircleModel.h"


@implementation MohrsCircleModel

- (id)init
{
    self = [super init];
    
    _sigmax = 200;
    _sigmay = 50;
    _tauxy = 100;
    _theta = 20*M_PI/180;
    
    [self CalculatePrinciplaAndRotatedStress];
    
    return self;
    
}

- (CGFloat)Radius
{
    return abs((_sigma1 - _sigma2)*0.5);
}

- (CGFloat)SigmaAvg
{
    return (_sigma1 + _sigma2)*0.5;
}


- (void)CalculatePrinciplaAndRotatedStress{
    //given sigmax, sigmay, tauxy and theta calculate the principal stresses and
    //the rotated stress state for theta
    CGFloat sigmaAvg = (_sigmax + _sigmay)*0.5;
    CGFloat radius = sqrtf( powf((_sigmax-sigmaAvg),2) + powf(_tauxy,2) );
    
    _theta_p = atan2f( _tauxy, _sigmax - sigmaAvg ) * 0.5;
    _sigma2 = sigmaAvg - radius;
    _sigma1 = sigmaAvg + radius;
    
    _sigmax_theta = sigmaAvg + (_sigmax - _sigmay)*0.5*cos(2*_theta)+_tauxy*sin(2*_theta);
    _sigmay_theta = sigmaAvg - (_sigmax - _sigmay)*0.5*cos(2*_theta)-_tauxy*sin(2*_theta);
    _tauxy_theta = -(_sigmax-_sigmay)*0.5*sin(2*_theta)+_tauxy*cos(2*_theta);
}

- (void)CalculateRotatedStressFromPrincipalStressAndThetaP{
    //given sigma1, sigma2, theta_p and theta calculate the original stresses and
    //the rotated stress state for theta
    CGFloat sigmaAvg = (_sigma1 + _sigma2)*0.5;
    CGFloat radius = (_sigma1 - _sigma2)*0.5;
    
    _sigmax = sigmaAvg + radius*cos(2*_theta_p);
    _sigmay = sigmaAvg - radius*cos(2*_theta_p);
    _tauxy = radius*sin(2*_theta_p);
    
    _sigmax_theta = sigmaAvg + (_sigmax - _sigmay)*0.5*cos(2*_theta)+_tauxy*sin(2*_theta);
    _sigmay_theta = sigmaAvg - (_sigmax - _sigmay)*0.5*cos(2*_theta)-_tauxy*sin(2*_theta);
    _tauxy_theta = -(_sigmax-_sigmay)*0.5*sin(2*_theta)+_tauxy*cos(2*_theta);
    
    [self CalculatePrinciplaAndRotatedStress];
}

@end
