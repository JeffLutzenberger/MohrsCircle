//
//  CircleDrawingView.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseDrawingView.h"
#import "MohrsCircleModel.h"

@interface CircleDrawingView : BaseDrawingView {
    
    UIWebView* sigmaMinusTauWebView;
    UIWebView* sigma1Label;
    UIWebView* sigma2Label;
    UIWebView* twoThetaPLabel;
    UIWebView* twoThetaLabel;
    UIWebView* tauLabel;
    
    UIWebView* sigmaxLabel;
    UIWebView* sigmayLabel;
    UIWebView* sigmaxPLabel;
    UIWebView* sigmayPLabel;
    
    NSMutableArray* collisionCheckLabels;
    
    Boolean planeStress;
    
}

@property (nonatomic, assign) MohrsCircleModel* circleModel;

- (void)drawThetaArc;
- (void)drawThetaPrincipalArc;
- (void)drawCircle;
- (void)drawAxes;
- (void)drawTauAxis;
- (void)drawStressAxis;
- (void)drawRotatedStressAxis;
- (void)zoomToExtents;

@end
