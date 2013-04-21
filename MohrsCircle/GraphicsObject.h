//
//  GraphicsObject.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/21/13.
//
//

#import <Foundation/Foundation.h>

@interface GraphicsObject : NSObject {
    
    CGRect viewingRect;
    CGSize frameSize;
    
}

- (CGPoint)translatePoint:(CGPoint)p1 p2:(CGPoint)p2;

- (CGPoint)rotatePoint:(CGPoint)p theta:(CGFloat)theta;

- (UIWebView*)MakeLabel:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height view:(UIView*)view;

- (void)drawArrowHead:(CGPoint)p theta:(CGFloat)theta size:(CGFloat)size;

- (void)drawArrow:(CGPoint)tip theta:(CGFloat)theta length:(CGFloat)length  headSize:(CGFloat)headSize;

- (CGPoint)WindowToWorld: (CGPoint)windowPt;

- (CGPoint)WorldToWindow: (CGPoint)worldPt;


@end
