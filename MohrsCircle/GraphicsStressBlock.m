//
//  GraphicsStressBlock.m
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/21/13.
//
//

#import "GraphicsStressBlock.h"

@implementation GraphicsStressBlock

- (id)initWithViewAndSize:(UIView*)view size:(CGFloat)size viewRect:(CGRect)viewRect{
    
    self = [super init];
    if(self) {
        blockSize = size;
        frameSize = view.frame.size;
        viewingRect = viewRect;
        //make labels
        sigmaxLabel = [self MakeLabel:0 y:0 width:10 height:10 view:view];
        sigmayLabel = [self MakeLabel:0 y:0 width:10 height:10 view:view];
        tauxyLabel = [self MakeLabel:0 y:0 width:10 height:10 view:view];
        thetaLabel = [self MakeLabel:0 y:0 width:10 height:10 view:view];
    }
    return self;
}

- (void)drawStressBlock:(CGPoint)center
                  theta:(CGFloat)theta
                 sigmax:(CGFloat)sigmax
                 sigmay:(CGFloat)sigmay
                  tauxy:(CGFloat)tauxy
              principal:(Boolean)principal {
    
    CGFloat size = blockSize;
    
    CGFloat headSize = 1;
    
    //CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5);
    
    CGPoint p1 = CGPointMake(-size, -size);
    
    CGPoint p2 = CGPointMake(size, -size);
    
    CGPoint p3 = CGPointMake(size, size);
    
    CGPoint p4 = CGPointMake(-size, size);
    
    p1 = [self rotatePoint:p1 theta:theta];
    p2 = [self rotatePoint:p2 theta:theta];
    p3 = [self rotatePoint:p3 theta:theta];
    p4 = [self rotatePoint:p4 theta:theta];
    
    p1 = [self translatePoint:p1 p2:center];
    p2 = [self translatePoint:p2 p2:center];
    p3 = [self translatePoint:p3 p2:center];
    p4 = [self translatePoint:p4 p2:center];
    
    //draw the square
    CGContextMoveToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextAddLineToPoint(context, p3.x, p3.y);
    CGContextAddLineToPoint(context, p4.x, p4.y);
    CGContextClosePath(context);
    
    CGPathDrawingMode mode = kCGPathStroke;// kCGPathFillStroke;
    CGContextDrawPath( context, mode );
    
    CGFloat arrowLength = size*1.25;
    CGFloat shearStressOffset = size*1.4;
    CGFloat normalStressOffset = arrowLength*2+size*0.4;
    if( principal ){
        normalStressOffset = arrowLength*2;
    }
    //shear stress arrows
    if( !principal ){
        p1 = CGPointMake(arrowLength*0.5, shearStressOffset);
        p1 = [self rotatePoint:p1 theta:theta];
        p1 = [self translatePoint:p1 p2:center];
        [self drawArrow:p1 theta:theta length:arrowLength headSize:headSize];
        
        CGPoint ps1 = [self WorldToWindow:p1];
        
        [tauxyLabel setFrame:CGRectMake(ps1.x, ps1.y-10, 60, 20)];
        
        [tauxyLabel loadHTMLString:@"<div style='font-size: 10px;'>1000.00</div>" baseURL:nil];
        
        p1 = CGPointMake(-arrowLength*0.5, -shearStressOffset);
        p1 = [self rotatePoint:p1 theta:theta];
        p1 = [self translatePoint:p1 p2:center];
        [self drawArrow:p1 theta:theta-M_PI length:arrowLength headSize:headSize];
        
        p1 = CGPointMake(shearStressOffset, arrowLength*0.5);
        p1 = [self rotatePoint:p1 theta:theta];
        p1 = [self translatePoint:p1 p2:center];
        [self drawArrow:p1 theta:theta+M_PI_2 length:arrowLength headSize:headSize];
        
        p1 = CGPointMake(-shearStressOffset, -arrowLength*0.5);
        p1 = [self rotatePoint:p1 theta:theta];
        p1 = [self translatePoint:p1 p2:center];
        [self drawArrow:p1 theta:theta-M_PI_2 length:arrowLength headSize:headSize];
    }
    
    //normal stress arrows
    p1 = CGPointMake(normalStressOffset, 0);
    p1 = [self rotatePoint:p1 theta:theta];
    p1 = [self translatePoint:p1 p2:center];
    [self drawArrow:p1 theta:theta length:arrowLength headSize:headSize];
    
    CGPoint ps1 = [self WorldToWindow:p1];
    
    [sigmaxLabel setFrame:CGRectMake(ps1.x, ps1.y-10, 60, 20)];
    
    [sigmaxLabel loadHTMLString:@"<div style='font-size: 10px;'>1000.00</div>" baseURL:nil];
    
    
    p1 = CGPointMake(-normalStressOffset, 0);
    p1 = [self rotatePoint:p1 theta:theta];
    p1 = [self translatePoint:p1 p2:center];
    [self drawArrow:p1 theta:theta-M_PI length:arrowLength headSize:headSize];
    
    p1 = CGPointMake(0, normalStressOffset);
    p1 = [self rotatePoint:p1 theta:theta];
    p1 = [self translatePoint:p1 p2:center];
    [self drawArrow:p1 theta:theta+M_PI_2 length:arrowLength headSize:headSize];
    
    ps1 = [self WorldToWindow:p1];
    
    [sigmayLabel setFrame:CGRectMake(ps1.x, ps1.y-10, 60, 20)];
    
    [sigmayLabel loadHTMLString:@"<div style='font-size: 10px;'>1000.00</div>" baseURL:nil];
    
    p1 = CGPointMake(0, -normalStressOffset);
    p1 = [self rotatePoint:p1 theta:theta];
    p1 = [self translatePoint:p1 p2:center];
    [self drawArrow:p1 theta:theta-M_PI_2 length:arrowLength headSize:headSize];
    
    if( theta > 0.0001 || theta < -0.0001 ) {
        //draw the normal stress axis
        CGFloat normalStressAxisLength = arrowLength*1.5;
        p1 = CGPointMake(normalStressOffset*1.2, 0);
        p2 = CGPointMake(p1.x+normalStressAxisLength, p1.y);
        p1 = [self rotatePoint:p1 theta:theta];
        p1 = [self translatePoint:p1 p2:center];
        p2 = [self rotatePoint:p2 theta:theta];
        p2 = [self translatePoint:p2 p2:center];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.25);
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        CGPathDrawingMode mode = kCGPathStroke;// kCGPathFillStroke;
        CGContextDrawPath( context, mode );
        
    }
    //draw axes
    /*p1 = center;
     p2 = CGPointMake(stress_block_size*1.75, 0);
     p2 = [self rotatePoint:p2 theta:theta];
     p2 = [self translatePoint:p2 p2:center];
     CGContextMoveToPoint(context, p1.x, p1.y);
     CGContextAddLineToPoint(context, p2.x, p2.y);
     mode = kCGPathStroke;// kCGPathFillStroke;
     CGContextDrawPath( context, mode );
     */
    
    //draw the center
    //[self drawDot:center];
    
    //draw the arrows
    
    //draw the labels
    
}

- (void)drawThetaArc:(CGPoint)center theta:(CGFloat)theta {
    
    CGFloat radius = blockSize*4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    Boolean clockwise = (theta < 0);
    CGContextAddArc(context,
                    center.x,
                    center.y,
                    radius,
                    0,
                    theta,
                    clockwise ? 1 : 0);
    CGContextStrokePath(context);
    
    //now add our arrow head at the end of the arc...
    /*CGPoint tip = CGPointMake(center.x+radius*cos(theta), radius*sin(theta));
     
     CGFloat arrowHeadTheta = theta;
     if(theta < 0){
     arrowHeadTheta += M_PI;
     }
     
     [self drawArrowHead:tip theta:arrowHeadTheta size:1];
     */
    
    
    /*CGPoint ps1 = [self WorldToWindow:end];
     
     [twoThetaLabel setFrame:CGRectMake(ps1.x-30, ps1.y, 30, 20)];
     
     [twoThetaLabel loadHTMLString:@"<div style='margin-top: -8px;font-size: 14px;'>2&theta;\'</div>" baseURL:nil];
     */
}


- (void)drawXYAxes:(CGPoint)center {
    
    CGFloat size = blockSize*4.5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.25);
    CGPoint p1 = CGPointMake(size, 0);
    CGPoint p2 = center;
    CGPoint p3 = CGPointMake(0, size);
    p1 = [self translatePoint:p1 p2:center];
    p3 = [self translatePoint:p3 p2:center];
    CGContextMoveToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    //CGContextAddLineToPoint(context, p3.x, p3.y);
    CGPathDrawingMode mode = kCGPathStroke;// kCGPathFillStroke;
    CGContextDrawPath( context, mode );
}



@end
