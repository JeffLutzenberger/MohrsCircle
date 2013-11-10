//
//  MohrsCircleModel.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MohrsCircleModel : NSObject {
    
}

- (id)init;

- (CGFloat)Radius;

- (CGFloat)SigmaAvg;

- (void)CalculatePrincipalAndRotatedStress;

- (void)CalculateRotatedStressFromPrincipalStressAndThetaP;

@property (assign, nonatomic) CGFloat sigmax;

@property (assign, nonatomic) CGFloat sigmay;

@property (assign, nonatomic) CGFloat tauxy;

@property (assign, nonatomic) CGFloat theta;

@property (assign, nonatomic) CGFloat theta_p;

@property (assign, nonatomic) CGFloat theta_tau_max;

@property (assign, nonatomic) CGFloat sigma1;

@property (assign, nonatomic) CGFloat sigma2;

@property (assign, nonatomic) CGFloat sigmax_theta;

@property (assign, nonatomic) CGFloat sigmay_theta;

@property (assign, nonatomic) CGFloat tauxy_theta;

@property (assign, nonatomic) CGFloat tau_max;

@end
