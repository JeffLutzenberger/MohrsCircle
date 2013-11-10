//
//  MohrsCircleTests.m
//  MohrsCircleTests
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MohrsCircleTests.h"
#import "MohrsCircleModel.h"

@implementation MohrsCircleTests

- (void)setUp{
    
    [super setUp];
    
    // Set-up code here.
    circleModel  = [[MohrsCircleModel alloc] init];
    
}

- (void)tearDown{
    
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testCircleCalcInvariance{
    
    //STFail(@"Unit tests are not implemented yet in MohrsCircleTests");
    
    CGFloat sigmax = circleModel.sigmax;
    CGFloat sigmay = circleModel.sigmay;
    CGFloat tauxy = circleModel.tauxy;
    CGFloat theta = circleModel.theta;
    
    [circleModel CalculatePrincipalAndRotatedStress];
    
    STAssertEqualsWithAccuracy(sigmax, circleModel.sigmax, 0.01, @"sigmax check");
    STAssertEqualsWithAccuracy(sigmay, circleModel.sigmay, 0.01, @"sigmay check");
    STAssertEqualsWithAccuracy(tauxy, circleModel.tauxy, 0.01, @"tauxy check");
    STAssertEqualsWithAccuracy(theta, circleModel.theta, 0.01, @"theta check");
    
    [circleModel CalculateRotatedStressFromPrincipalStressAndThetaP];

    CGFloat theta_p = circleModel.theta_p;
    
    STAssertEqualsWithAccuracy(sigmax, circleModel.sigmax, 0.01, @"sigmax check");
    STAssertEqualsWithAccuracy(sigmay, circleModel.sigmay, 0.01, @"sigmay check");
    STAssertEqualsWithAccuracy(tauxy, circleModel.tauxy, 0.01, @"tauxy check");
    STAssertEqualsWithAccuracy(theta, circleModel.theta, 0.01, @"theta check");
    STAssertEqualsWithAccuracy(theta_p, circleModel.theta_p, 0.01, @"theta_p check");
}

- (void)testTimoEx1Chapter6_4 {
    
    circleModel.sigmax = 15000;
    circleModel.sigmay = 5000;
    circleModel.tauxy = 4000;
    circleModel.theta = 40*M_PI/180;
    
    [circleModel CalculatePrincipalAndRotatedStress];
    
    CGFloat sigmaAvg = [circleModel SigmaAvg];
    
    STAssertEqualsWithAccuracy(sigmaAvg, 10000.0f, 0.01, @"Sigma Avg check");
    
    CGFloat radius = [circleModel Radius];
    
    STAssertEqualsWithAccuracy(radius, 6403.0f, 0.01, @"R check");
    STAssertEqualsWithAccuracy(circleModel.theta_p*180/M_PI, 19.33, 0.01, @"theta_p check");
    STAssertEqualsWithAccuracy(circleModel.sigmax_theta, 14807.47f, 0.01, @"sigmax_theta check");
    STAssertEqualsWithAccuracy(circleModel.sigmay_theta, 5192.53f, 0.01, @"sigmay_theta check");
    STAssertEqualsWithAccuracy(circleModel.tauxy_theta, -4229.45f, 0.01, @"tauxy_theta check");
    STAssertEqualsWithAccuracy(circleModel.sigma1, 16403.13f, 0.01, @"sigma1 check");
    STAssertEqualsWithAccuracy(circleModel.sigma2, 3596.88f, 0.01, @"sigma2 check");
    STAssertEqualsWithAccuracy(circleModel.tau_max, 6403.12f, 0.01, @"tau_max check");
    STAssertEqualsWithAccuracy(circleModel.theta_tau_max*180/M_PI, -25.67, 0.01, @"tau_max check");
}

- (void)testTimoEx2Chapter6_4 {
    
    circleModel.sigmax = -50;
    circleModel.sigmay = 10;
    circleModel.tauxy = -40;
    circleModel.theta = 45*M_PI/180;
    
    [circleModel CalculatePrincipalAndRotatedStress];
    
    CGFloat sigmaAvg = [circleModel SigmaAvg];
    
    STAssertEqualsWithAccuracy(sigmaAvg, -20.0f, 0.01, @"Sigma Avg check");
    
    CGFloat radius = [circleModel Radius];
    
    STAssertEqualsWithAccuracy(radius, 50.0f, 0.01, @"R check");
    STAssertEqualsWithAccuracy(circleModel.theta_p*180/M_PI, -63.43, 0.01, @"theta_p check");
    STAssertEqualsWithAccuracy(circleModel.sigmax_theta, -60.00f, 0.01, @"sigmax_theta check");
    STAssertEqualsWithAccuracy(circleModel.sigmay_theta, 20.00f, 0.01, @"sigmay_theta check");
    STAssertEqualsWithAccuracy(circleModel.tauxy_theta, 30.00f, 0.01, @"tauxy_theta check");
    STAssertEqualsWithAccuracy(circleModel.sigma1, 30.00f, 0.01, @"sigma1 check");
    STAssertEqualsWithAccuracy(circleModel.sigma2, -70.00f, 0.01, @"sigma2 check");
    STAssertEqualsWithAccuracy(circleModel.tau_max, 50.00f, 0.01, @"tau_max check");
    STAssertEqualsWithAccuracy(circleModel.theta_tau_max*180/M_PI, -108.43, 0.01, @"tau_max check");
}

@end
