//
//  CircleDrawingView.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MohrsCircleModel.h"

@interface CircleDrawingView : UIView {
    
    CGRect viewingRect;
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
    
}

@property (nonatomic, assign) MohrsCircleModel* circleModel;

- (CGPoint)translatePoint:(CGPoint)p1 p2:(CGPoint)p2;
- (CGPoint)rotatePoint:(CGPoint)p theta:(CGFloat)theta;
- (void)drawDot:(CGPoint)p;
- (void)drawArrowHead:(CGPoint)p theta:(CGFloat)theta;
    
- (void)drawThetaArc;
- (void)drawThetaPrincipalArc;
- (void)drawCircle;
- (void)drawAxes;
- (void)drawTauAxis;
- (void)drawStressAxis;
- (void)drawRotatedStressAxis;
- (void)drawLabels;

- (void)zoomToExtents;

- (void)updateLabels;

- (CGPoint)WindowToWorld: (CGPoint)windowPt;
- (CGPoint)WorldToWindow: (CGPoint)worldPt;

@end
