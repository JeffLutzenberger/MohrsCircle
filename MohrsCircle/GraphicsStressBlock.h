//
//  GraphicsStressBlock.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/21/13.
//
//

#import <UIKit/UIKit.h>
#import "GraphicsObject.h"

enum {
    InitialStress = 1,
    PrincipalStress = 2,
    RotatedStress = 3,
    MaxShearStress = 4
    };
    
typedef NSUInteger StressBlockType;
    
@interface GraphicsStressBlock : GraphicsObject {
    
    CGFloat blockSize;
    UIWebView* titleLabel;
    UIWebView* sigmaxLabel;
    UIWebView* sigmayLabel;
    UIWebView* tauxyLabel;
    UIWebView* thetaLabel;
}

- (id)initWithViewAndSize:(UIView*)view size:(CGFloat)size viewRect:(CGRect)viewRect;

- (void)drawStressBlock:(CGPoint)center
                  theta:(CGFloat)theta
                 sigmax:(CGFloat)sigmax
                 sigmay:(CGFloat)sigmay
                  tauxy:(CGFloat)tauxy
        stressBlockType:(StressBlockType)stressBlockType;

- (void)drawThetaArc:(CGPoint)center theta:(CGFloat)theta;

- (void)drawXYAxes:(CGPoint)center;

@end
