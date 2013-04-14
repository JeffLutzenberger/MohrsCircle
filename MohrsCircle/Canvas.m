//
//  Canvas.m
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Canvas.h"


@implementation Canvas

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    circleModel = [[MohrsCircleModel alloc] init];
    
    CGFloat modelWidth = 500;
    CGFloat modelHeight = self.frame.size.height/self.frame.size.width*modelWidth;
    viewingRect = CGRectMake(-modelWidth/2, -modelHeight/2, modelWidth, modelHeight);
    eyePosition = CGPointMake( 0, 0 );
    
    //lastMove = 0;
    
    //UIPanGestureRecognizer *panGesture = 
    //  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    //[self addGestureRecognizer:panGesture];
    
    //[panGesture release];
    
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //flip our view so that the origin is Lower Left
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //now set our scale (window height/model height)
    CGFloat tempScale = self.frame.size.width/viewingRect.size.width;
    
    //and translate so that the origin is in the center of our view
    CGContextScaleCTM(context, tempScale, tempScale);
    CGContextTranslateCTM(context, viewingRect.size.width/2, viewingRect.size.height/2);
    //start by drawing our axes
    
    //now translate to our center point
    CGContextTranslateCTM(context, eyePosition.x, eyePosition.y);
    
    
    
    [self drawCircle];
    
    [self drawAxes];
    
    
    
    
    
}

- (void)drawAxes
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextMoveToPoint(context, -1000, 0);
    
    CGContextAddLineToPoint(context, 1000, 0);
    
    //CGContextMoveToPoint(context, 0, -1000);
    
    //CGContextAddLineToPoint(context, 0, 1000);
    
    CGContextStrokePath(context);
}

- (void)drawCircle
{
    CGFloat radius = [circleModel Radius];
    
    CGFloat sigma2 = circleModel.sigma2;
    
    CGRect circle = CGRectMake(sigma2, -radius, radius*2, radius*2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextAddEllipseInRect(context, circle);
    
    CGContextStrokePath(context);
}


- (void)dealloc
{
    [super dealloc];
    
}

/*
- (IBAction)xDrag: (id)sender withEvent: (UIEvent *) event {
    UIButton *selected = (UIButton *)sender;
    CGPoint touchPoint = [[[event allTouches] anyObject] locationInView:self];
    touchPoint.y = xAxisLocation;
    if( touchPoint.x > sigmaAvgButton.center.x-30 ) touchPoint.x = sigmaAvgButton.center.x-30;
    
    selected.center = touchPoint;
    radius = sigmaAvgButton.center.x - touchPoint.x;
    
    [sigma1Button setCenter:CGPointMake(sigmaAvgButton.center.x + radius, xAxisLocation)];
    
    //CGFloat windowToWorld = [self GetScale];
    
    
    
    [self setNeedsDisplay];
    
} 
*/

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translate = [sender translationInView:self.superview];
    //CGPoint velocity = [sender velocityInView:self];
    
    //convert pixel translate amount to view rect amount
    CGFloat delta = translate.x;
    lastMove = delta;
    
    CGFloat scale = viewingRect.size.width/self.frame.size.width;
    
    eyePosition.x = scale*delta;
    
    //NSLog([NSString stringWithFormat:@"translating %f", translate.x]);
    //NSLog([NSString stringWithFormat:@"velocity %f", velocity.x]);
    
    [self setNeedsDisplay];
    
    /* implement momentum...
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
		CGFloat finalX = eyePosition.x + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self].x);
		
                    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        //eyePosition.x = finalX;
        //[self setNeedsDisplay];
        //[[sender view] setCenter:CGPointMake(finalX, eyePosition.y)];
        [UIView commitAnimations];
	}
     */
    
}

@end
