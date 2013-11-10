//
//  CircleDrawingView.m
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CircleDrawingView.h"
#import "MohrsCircleAppDelegate.h"
#import "RegexKitLite.h"

#import <QuartzCore/QuartzCore.h>

@implementation CircleDrawingView

typedef enum Quadrant : NSInteger Quadrant;
enum Quadrant : NSInteger {
    UPPER_RIGHT,
    UPPER_LEFT,
    LOWER_LEFT,
    LOWER_RIGHT
};

@synthesize circleModel = _circleModel;

double label_offset_x = 24;
double label_offset_y = 16;
double model_width_factor = 4.5;

- (id)init {
    
    self = [super init];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        //self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        planeStress = YES;
        
        MohrsCircleAppDelegate* app = (MohrsCircleAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.circleModel = app.circleModel;
        
        CGFloat modelWidth = [self.circleModel Radius]*model_width_factor;
        CGFloat modelCenter = [self.circleModel SigmaAvg];
        CGFloat modelHeight = self.frame.size.height/self.frame.size.width*modelWidth;
        CGPoint origin = CGPointMake(modelCenter-modelWidth/2, -modelHeight/2);
        viewingRect = CGRectMake(origin.x, origin.y, modelWidth, modelHeight);
        
        //labels...
        sigma1Label = [self MakeLabel:0 y:0 width:10 height:10];
        sigma2Label = [self MakeLabel:0 y:0 width:10 height:10];
        twoThetaPLabel = [self MakeLabel:0 y:0 width:10 height:10];
        twoThetaLabel = [self MakeLabel:0 y:0 width:10 height:10];
        tauLabel = [self MakeLabel:0 y:0 width:10 height:10];
        sigmaxLabel = [self MakeLabel:0 y:0 width:10 height:10];
        sigmayLabel = [self MakeLabel:0 y:0 width:10 height:10];
        sigmaxPLabel = [self MakeLabel:0 y:0 width:10 height:10];
        sigmayPLabel = [self MakeLabel:0 y:0 width:10 height:10];
        
        //colliding label list
        collisionCheckLabels = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)awakeFromNib {

}

// This method will get called for each attribute you define.
-(void) setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"stressType"]) {
        
        planeStress = [value isEqualToString:@"plane stress"];
    }
}

- (UIWebView*)MakeLabel:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    
    //TODO: should not leak memory...profile
    UIWebView* myView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [myView setOpaque:NO];
    [myView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:myView];
    return myView;
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self zoomToExtents];
    return YES;
}
*/
- (void)zoomToExtents {
    
    //update the viewingRectangle and redraw
    CGFloat modelWidth = [self.circleModel Radius]*model_width_factor;
    CGFloat modelCenter = [self.circleModel SigmaAvg];
    CGFloat modelHeight = self.frame.size.height/self.frame.size.width*modelWidth;
    CGPoint origin = CGPointMake(modelCenter-modelWidth/2, -modelHeight/2);
    viewingRect = CGRectMake(origin.x, origin.y, modelWidth, modelHeight);
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //new
    // Drawing code
    //flip our view so that the origin is Lower Left
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //now set our scale (window height/model height)
    CGFloat tempScale = self.frame.size.width/viewingRect.size.width;
    
    //and translate to the center of our view
    CGContextScaleCTM(context, tempScale, tempScale);
    CGContextTranslateCTM(context, 
                          -viewingRect.origin.x, 
                          viewingRect.origin.y + viewingRect.size.height);
    
    [collisionCheckLabels removeAllObjects];
    
    [[UIColor darkGrayColor] set];
    
    [self drawAxes];
    
    [self drawCircle];
    
    //if( !planeStress ) {
    //    [self drawTauAxis];
    //}
    
    [self drawStressAxis];
    
    [self drawRotatedStressAxis];
    
    if( !planeStress ) {
        [self drawThetaPrincipalArc];
    }
    
    [self drawThetaArc];
    
    
}

- (void)drawAxes {
    
    [[UIColor darkGrayColor] set];
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    CGFloat axisMargin = 30/pixelScale;
    
    CGFloat x1 = viewingRect.origin.x+axisMargin;
    CGFloat x2 = viewingRect.origin.x+viewingRect.size.width-axisMargin;
    CGFloat y1 = viewingRect.origin.y+axisMargin;
    CGFloat y2 = viewingRect.origin.y+viewingRect.size.height-axisMargin;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, x1, 0);
    CGContextAddLineToPoint(context, x2, 0);
    CGContextMoveToPoint(context, 0, y1);
    CGContextAddLineToPoint(context, 0, y2);
    CGContextStrokePath(context);
    
    [self drawArrowHead:CGPointMake(x2, 0) theta:-M_PI_2 size:6/pixelScale];
    [self drawArrowHead:CGPointMake(0, y2) theta:0 size:6/pixelScale];
}


- (void)drawCircle {
    
    [[UIColor darkGrayColor] set];
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    CGFloat radius = [self.circleModel Radius];
    CGFloat sigma2 = [self.circleModel sigma2];
    CGRect circle = CGRectMake(sigma2, -radius, radius*2, radius*2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddEllipseInRect(context, circle);
    CGContextStrokePath(context);
    
    [self drawDot:CGPointMake(sigma2, 0)];
    [self drawDot:CGPointMake(sigma2+2*radius, 0)];
    
    if( !planeStress) {
        
        CGPoint ps1 = [self WorldToWindow:CGPointMake(sigma2+2*radius, 0)];
        [sigma1Label setFrame:CGRectMake(ps1.x, ps1.y, 30, 20)];
        [sigma1Label loadHTMLString:
         @"<div style='margin-top: -8px;font-size: 16px;font-family: Helvetica, Arial, sans-serif;'>&sigma;<sub>1</sub></div>" baseURL:nil];
        //[self StartCheckLabelForCollisionAndAdjust:sigma1Label];
        CGPoint ps2 = [self WorldToWindow:CGPointMake(sigma2, 0)];
        [sigma2Label setFrame:CGRectMake(ps2.x-30, ps2.y, 30, 20)];
        [sigma2Label loadHTMLString:
         @"<div style='margin-top: -8px;font-size: 16px;font-family: Helvetica, Arial, sans-serif;'>&sigma;<sub>2</sub></div>" baseURL:nil];
    }
}



- (void)drawThetaPrincipalArc {
    
    [[UIColor darkGrayColor] set];
    //arc should go from plane stress line to tau = 0 (CCW)
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineDash(context, 0, NULL, 0);
    
    CGFloat radius = [self.circleModel Radius]*0.5;
    CGFloat sigmaAvg = [self.circleModel SigmaAvg];
    
    CGFloat theta = -2*[self.circleModel theta_p];
    
    Boolean clockwise = (theta > 0);
    
    //Boolean clockwise = NO;
    CGContextAddArc(context,
                    sigmaAvg,
                    0,
                    radius,
                    theta,
                    0,
                    clockwise ? 1 : 0);
    CGContextStrokePath(context);
    
    CGPoint tip = CGPointMake(sigmaAvg+radius*cos(0), radius*sin(0));
    CGPoint end = CGPointMake(sigmaAvg+radius*cos(-2*[self.circleModel theta_p]), radius*sin(-2*[self.circleModel theta_p]));
    
    [self drawArrowHead:tip theta:clockwise ? M_PI : 0 size:6/pixelScale];
    
    CGPoint ps1 = [self WorldToWindow:end];
    
    [twoThetaPLabel setFrame:CGRectMake(ps1.x-30, ps1.y-10, 40, 20)];
    [twoThetaPLabel loadHTMLString:@"<div style='margin-top: -8px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>2&theta;<sub>p</sub></div>" baseURL:nil];
    
}

- (void)drawThetaArc {
    
    [[UIColor darkGrayColor] set];
    //arc should go from plane stress line to tau = 0 (CCW)
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineDash(context, 0, NULL, 0);
    
    CGFloat radius = [self.circleModel Radius]*0.75;
    CGFloat sigmaAvg = [self.circleModel SigmaAvg];
    CGFloat theta_1 = -2*[self.circleModel theta_p];
    CGFloat theta_2 = -2*[self.circleModel theta_p]+2*[self.circleModel theta];
    
    Boolean clockwise = NO;
    CGContextAddArc(context,
                    sigmaAvg,
                    0,
                    radius,
                    theta_1,
                    theta_2,
                    clockwise ? 1 : 0);
    CGContextStrokePath(context);
    
    //now add our arrow head at the end of the arc...
    CGPoint tip = CGPointMake(sigmaAvg+radius*cos(theta_2), radius*sin(theta_2));
    CGPoint end = CGPointMake(sigmaAvg+radius*cos(theta_1), radius*sin(theta_1));
    
    [self drawArrowHead:tip theta:theta_2 size:6/pixelScale];
    
    CGPoint ps1 = [self WorldToWindow:end];
    
    [twoThetaLabel setFrame:CGRectMake(ps1.x-20, ps1.y, 30, 20)];
    [twoThetaLabel loadHTMLString:@"<div style='margin-top: -8px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>2&theta;\'</div>" baseURL:nil];
    
}

- (void)drawTauAxis {
    
    [[UIColor darkGrayColor] set];
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    CGFloat radius = [self.circleModel Radius];
    CGFloat sigmaAvg = [self.circleModel SigmaAvg];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, sigmaAvg, radius);
    CGContextAddLineToPoint(context, sigmaAvg, -radius);
    CGContextStrokePath(context);
    
    [self drawDot:CGPointMake(sigmaAvg,radius)];

    [self drawDot:CGPointMake(sigmaAvg,-radius)];
    
    CGPoint ps1 = [self WorldToWindow:CGPointMake(sigmaAvg, radius)];
    
    [tauLabel setFrame:CGRectMake(ps1.x-20, ps1.y-30, 40, 20)];
    [tauLabel loadHTMLString:@"<div style='margin-top: -8px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>&tau;<sub>max</sub></div>" baseURL:nil];
    
    [self StartCheckLabelForCollisionAndAdjust:tauLabel];
    

}

- (void)drawStressAxis {
    
    [[UIColor darkGrayColor] set];
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGFloat dashArray[] = {4/pixelScale,4/pixelScale};
    
    CGContextSetLineDash(context, 3, dashArray, 2);
    
    CGFloat sigmax = self.circleModel.sigmax;
    CGFloat sigmay = self.circleModel.sigmay;
    CGFloat tauxy = self.circleModel.tauxy;
    
    CGContextMoveToPoint(context, sigmay, tauxy);
    CGContextAddLineToPoint(context, sigmax, -tauxy);
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0);
    
    [self drawDot:CGPointMake(sigmay, tauxy)];
    
    [self drawDot:CGPointMake(sigmax, -tauxy)];
    
    if( planeStress ) {
        
        CGPoint ps1 = [self PositionLabel:CGPointMake(sigmax, -tauxy) quadrant:LOWER_RIGHT textLength:50 textHeight:14];
    
        [sigmaxLabel setFrame:CGRectMake(ps1.x, ps1.y, 100, 18)];
    
        [sigmaxLabel loadHTMLString:@"<div style='margin-top: -14px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>&sigma;<sub>x</sub>,-&tau;<sub>xy</sub></div>" baseURL:nil];
    
        //[self StartCheckLabelForCollisionAndAdjust:sigmaxLabel];
    
        CGPoint ps2 = [self PositionLabel:CGPointMake(sigmay, tauxy) quadrant:UPPER_LEFT textLength:50 textHeight:14];
    
        [sigmayLabel setFrame:CGRectMake(ps2.x, ps2.y, 100, 18)];
    
        [sigmayLabel loadHTMLString:@"<div style='margin-top: -14px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>&sigma;<sub>y</sub>,&tau;<sub>xy</sub></div>" baseURL:nil];
    
        //[self StartCheckLabelForCollisionAndAdjust:sigmayLabel];
        
    }
    
}

- (void)drawRotatedStressAxis {
    
    [[UIColor darkGrayColor] set];
    CGFloat pixelScale = self.frame.size.width/viewingRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0/pixelScale);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGFloat dashArray[] = {4/pixelScale,4/pixelScale};
    
    CGContextSetLineDash(context, 3, dashArray, 2);
    
    CGFloat sigmax = self.circleModel.sigmax_theta;
    CGFloat sigmay = self.circleModel.sigmay_theta;
    CGFloat tauxy = self.circleModel.tauxy_theta;
    
    CGContextMoveToPoint(context, sigmay, tauxy);
    CGContextAddLineToPoint(context, sigmax, -tauxy);
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0);
    
    [self drawDot:CGPointMake(sigmay, tauxy)];
    
    [self drawDot:CGPointMake(sigmax, -tauxy)];
    
    if( planeStress ) {
        
        CGPoint ps1 = [self PositionLabel:CGPointMake(sigmax, -tauxy) quadrant:LOWER_RIGHT textLength:50 textHeight:14];
    
        [sigmaxPLabel setFrame:CGRectMake(ps1.x, ps1.y, 100, 20)];
    
        [sigmaxPLabel loadHTMLString:@"<div style='margin-top: -14px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>&sigma;<sub>x</sub>\',-&tau;\'<sub>xy</sub></div>" baseURL:nil];
    
        //[self StartCheckLabelForCollisionAndAdjust:sigmaxPLabel];
    
        CGPoint ps2 = [self PositionLabel:CGPointMake(sigmay, tauxy) quadrant:UPPER_LEFT textLength:50 textHeight:14];
    
        [sigmayPLabel setFrame:CGRectMake(ps2.x, ps2.y, 100, 20)];
    
        [sigmayPLabel loadHTMLString:@"<div style='margin-top: -14px;font-size: 14px;font-family: Helvetica, Arial, sans-serif;'>&sigma;<sub>y</sub>\',&tau;\'<sub>xy</sub></div>" baseURL:nil];
    
        //[self StartCheckLabelForCollisionAndAdjust:sigmayPLabel];
    }
    
}

- (BOOL)validateTextIsNumber:(NSString*)newText value:(double*)value {
    
	BOOL result = FALSE;
    
	if ( [newText isMatchedByRegex:@"^-{0,1}(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"] ) {
		
        result = TRUE;
		
        *value = [newText doubleValue];
	
    }
	return result;
}

//loop over all labels and adjust this one so that it does not collide with others
- (void)StartCheckLabelForCollisionAndAdjust:(UIWebView*)label {
    
    if( [self CheckLabelForCollisionAndAdjust:label maxRecursion:0] ){
        
        [collisionCheckLabels addObject:label];
    }
}


- (BOOL)CheckLabelForCollisionAndAdjust:(UIWebView*)label maxRecursion:(int)maxRecursion {
    
    maxRecursion += 1;
    
    if(maxRecursion > 20){
        return NO;
    }
    
    CGRect rect1 = label.frame;
    
    for (id object in collisionCheckLabels) {
        
        CGRect rect2 = ((UIWebView*)object).frame;
        
        if( CGRectIntersectsRect(rect1, rect2)){
            
            //reposition rect1 and recheck
            
            [label setFrame:CGRectMake(rect1.origin.x, rect2.origin.y+rect2.size.height+10, rect1.size.width, rect1.size.height)];
            
            [self CheckLabelForCollisionAndAdjust:label maxRecursion:maxRecursion];
        }
    }
    
    return YES;
    
}

- (CGPoint)PositionLabel:(CGPoint)modelPoint quadrant:(Quadrant)quardrant textLength:(CGFloat)textLength textHeight:(CGFloat)textHeight {

    CGPoint pt = [self WorldToWindow:modelPoint];

    switch (quardrant) {

        case UPPER_RIGHT: {
            return CGPointMake(pt.x, pt.y-textHeight);
        }
        
        case UPPER_LEFT: {
            return CGPointMake(pt.x-textLength, pt.y-textHeight);
        }
            
        case LOWER_LEFT: {
            return CGPointMake(pt.x-textLength, pt.y);
        }
            
        case LOWER_RIGHT: {
            return CGPointMake(pt.x, pt.y);
        }
        
        default:
            break;
    }
}


- (void)dealloc
{
    [super dealloc];
    
    [sigma1Label release];
    
    [sigma2Label release];
    
    [twoThetaLabel release];
    
    [twoThetaPLabel release];
    
    [tauLabel release];
}

@end
