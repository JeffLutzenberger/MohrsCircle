//
//  BaseDrawingView.m
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/16/13.
//
//

#import "BaseDrawingView.h"

@implementation BaseDrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIWebView*)MakeLabel:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    //TODO: should not leak memory...profile
    UIWebView* myView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [myView setOpaque:NO];
    [myView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:myView];
    return myView;
}


- (CGPoint)translatePoint:(CGPoint)p1 p2:(CGPoint)p2{
    return CGPointMake(p1.x+p2.x, p1.y+p2.y);
}

- (CGPoint)rotatePoint:(CGPoint)p theta:(CGFloat)theta{
    CGFloat x = p.x;
    CGFloat y = p.y;
    return CGPointMake(x*cos(theta) - y*sin(theta),
                       x*sin(theta) + y*cos(theta));
}

- (void)drawDot:(CGPoint)p{
    
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGFloat radius = 2/pixelScale;
    
    CGRect circle = CGRectMake(p.x-radius, p.y-radius, 2*radius, 2*radius);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, circle);
    
    CGContextStrokePath(context);
}
- (void)drawArrowHead:(CGPoint)p theta:(CGFloat)theta size:(CGFloat)size{
    
    //CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint p1 = CGPointMake(0, 0);
    
    CGPoint p2 = CGPointMake(p1.x-size*0.5, p1.y-size);
    
    CGPoint p3 = CGPointMake(0, p1.y-size*0.6);
    
    CGPoint p4 = CGPointMake(p1.x+size*0.5, p1.y-size);
    
    p1 = [self rotatePoint:p1 theta:theta];
    p2 = [self rotatePoint:p2 theta:theta];
    p3 = [self rotatePoint:p3 theta:theta];
    p4 = [self rotatePoint:p4 theta:theta];
    
    p1 = [self translatePoint:p1 p2:p];
    p2 = [self translatePoint:p2 p2:p];
    p3 = [self translatePoint:p3 p2:p];
    p4 = [self translatePoint:p4 p2:p];
    
    CGContextMoveToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextAddLineToPoint(context, p3.x, p3.y);
    CGContextAddLineToPoint(context, p4.x, p4.y);
    CGContextClosePath(context);
    
    CGPathDrawingMode mode = kCGPathFillStroke;
    CGContextDrawPath( context, mode );
    
}

- (void)drawArrow:(CGPoint)tip theta:(CGFloat)theta length:(CGFloat)length headSize:(CGFloat)headSize{
    
    //CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint p1 = CGPointMake(0, 0);
    CGPoint p2 = CGPointMake(-length, 0);
    
    p2 = [self rotatePoint:p2 theta:theta];
    
    p1 = [self translatePoint:p1 p2:tip];
    p2 = [self translatePoint:p2 p2:tip];
    
    CGContextMoveToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    
    CGPathDrawingMode mode = kCGPathStroke;
    CGContextDrawPath( context, mode );
    
    [self drawArrowHead:tip theta:theta-M_PI_2 size:headSize];
    
}

- (CGPoint)WorldToWindow: (CGPoint)worldPt
{
    //x
    CGFloat x0win = 0;
    CGFloat x2win = self.frame.size.width;
    CGFloat x2world = viewingRect.size.width + viewingRect.origin.x;
    CGFloat x0world = viewingRect.origin.x;
    CGFloat x1win = (worldPt.x-x0world)/(x2world-x0world)*(x2win-x0win);
    
    //y
    CGFloat y0win = 0;
    CGFloat y2win = self.frame.size.height;
    CGFloat y2world = viewingRect.size.height + viewingRect.origin.y;
    CGFloat y0world = viewingRect.origin.y;
    CGFloat y1win = (worldPt.y-y0world)/(y2world-y0world)*(y2win-y0win);
    
    return CGPointMake( x1win, self.frame.size.height - y1win );
}

- (CGPoint)WindowToWorld: (CGPoint)windowPt
{
    //x
    CGFloat x0win = 0;
    CGFloat x2win = self.frame.size.width;
    CGFloat x2world = viewingRect.size.width + viewingRect.origin.x;
    CGFloat x0world = viewingRect.origin.x;
    CGFloat x1world = x0world + (windowPt.x-x0win)/(x2win-x0win)*(x2world-x0world);
    
    //y
    CGFloat y0win = 0;
    CGFloat y2win = self.frame.size.height;
    CGFloat y2world = viewingRect.size.height + viewingRect.origin.y;
    CGFloat y0world = viewingRect.origin.y;
    CGFloat y1world = y0world + (windowPt.y-y0win)/(y2win-y0win)*(y2world-y0world);
    
    return CGPointMake( x1world, y1world );
}


@end
