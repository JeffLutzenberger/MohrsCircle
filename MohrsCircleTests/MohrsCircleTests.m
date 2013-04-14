//
//  MohrsCircleTests.m
//  MohrsCircleTests
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MohrsCircleTests.h"

@implementation MohrsCircleTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    circleModel  = [[MohrsCircleModel alloc] init];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in MohrsCircleTests");
}

- (void)testCircleCalcInvariance
{
    //STFail(@"Unit tests are not implemented yet in MohrsCircleTests");
    
    CGFloat sigmax = circleModel.sigmax;
    CGFloat sigmay = circleModel.sigmay;
    CGFloat tauxy = circleModel.tauxy;
    CGFloat theta = circleModel.theta;
    
    [circleModel CalculatePrinciplaAndRotatedStress];
    
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

@end
