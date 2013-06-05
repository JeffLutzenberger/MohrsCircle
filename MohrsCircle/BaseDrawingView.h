//
//  BaseDrawingView.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/16/13.
//
//

#import <UIKit/UIKit.h>

@interface BaseDrawingView : UIScrollView {
    
    CGRect viewingRect;
    
}

- (UIWebView*)MakeLabel:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

- (CGPoint)translatePoint:(CGPoint)p1 p2:(CGPoint)p2;

- (CGPoint)rotatePoint:(CGPoint)p theta:(CGFloat)theta;

- (void)drawDot:(CGPoint)p;

- (void)drawArrowHead:(CGPoint)p theta:(CGFloat)theta size:(CGFloat)size;

- (void)drawArrow:(CGPoint)tip theta:(CGFloat)theta length:(CGFloat)length  headSize:(CGFloat)headSize;

- (CGPoint)WindowToWorld: (CGPoint)windowPt;

- (CGPoint)WorldToWindow: (CGPoint)worldPt;

@end
