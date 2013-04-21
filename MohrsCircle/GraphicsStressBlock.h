//
//  GraphicsStressBlock.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/21/13.
//
//

#import <UIKit/UIKit.h>
#import "GraphicsObject.h"

@interface GraphicsStressBlock : GraphicsObject {
    
    CGFloat blockSize;
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
              principal:(Boolean)principal;

- (void)drawThetaArc:(CGPoint)center theta:(CGFloat)theta;

- (void)drawXYAxes:(CGPoint)center;

@end
