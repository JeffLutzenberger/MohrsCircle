//
//  ResultsDrawingView.m
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/16/13.
//
//

#import "ResultsDrawingView.h"
#import "MohrsCircleAppDelegate.h"
#import "RegexKitLite.h"

#import <QuartzCore/QuartzCore.h>

@implementation ResultsDrawingView

@synthesize circleModel = _circleModel;

double stress_block_size = 4;

double model_width = 100;
double model_margin = 25;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        MohrsCircleAppDelegate* app = (MohrsCircleAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.circleModel = app.circleModel;
        
        CGFloat modelWidth = model_width;
        CGFloat modelCenter = modelWidth/2;//[self.circleModel SigmaAvg];
        CGFloat modelHeight = self.frame.size.height/self.frame.size.width*modelWidth;
        CGPoint origin = CGPointMake(modelCenter-modelWidth/2, -modelHeight/2);
        viewingRect = CGRectMake(origin.x, origin.y, modelWidth, modelHeight);
        
        initialStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
        principalStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
        rotatedStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
        maxShearStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
    
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
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
    

    [self drawInitialStressBlock];
    
    [self drawPrincipalStressBlock];
    
    [self drawRotatedStressBlock];
    
    [self drawMaxShearStressBlock];
    
}

- (void)drawInitialStressBlock {
    
    CGFloat x = stress_block_size+model_margin;
    CGFloat y = viewingRect.size.height*0.25;
    CGPoint center = CGPointMake(x, y);
    
    [initialStressBlock drawStressBlock:center
                                  theta:0
                                 sigmax:self.circleModel.sigmax
                                 sigmay:self.circleModel.sigmay
                                  tauxy:self.circleModel.tauxy
                              principal:NO];
}

- (void)drawPrincipalStressBlock {
    
    CGFloat x = model_width - stress_block_size - model_margin;
    CGFloat y = viewingRect.size.height*0.25;
    CGPoint center = CGPointMake(x, y);
    CGFloat theta = self.circleModel.theta_p*0.5;

    [principalStressBlock drawStressBlock:center
                                    theta:theta
                                   sigmax:self.circleModel.sigma1
                                   sigmay:self.circleModel.sigma2
                                    tauxy:0
                                principal:YES];
    
    
    [principalStressBlock drawXYAxes:center];
    
    [principalStressBlock drawThetaArc:center theta:theta];

}

- (void)drawRotatedStressBlock {

    CGFloat x = stress_block_size+model_margin;
    CGFloat y = -viewingRect.size.height*0.2;
    CGPoint center = CGPointMake(x, y);
    CGFloat theta = self.circleModel.theta - self.circleModel.theta_p*0.5;
    
    [rotatedStressBlock drawStressBlock:center
                                    theta:theta
                                   sigmax:self.circleModel.sigmax_theta
                                   sigmay:self.circleModel.sigmay_theta
                                    tauxy:self.circleModel.tauxy_theta
                                principal:NO];
    
    
    [rotatedStressBlock drawXYAxes:center];
    
    [rotatedStressBlock drawThetaArc:center theta:theta];
}

- (void)drawMaxShearStressBlock {
    
    CGFloat x = model_width - stress_block_size - model_margin;
    CGFloat y = -viewingRect.size.height*0.2;
    CGPoint center = CGPointMake(x, y);
    CGFloat theta = self.circleModel.theta_max_tauxy;
    
    [maxShearStressBlock drawStressBlock:center
                                    theta:theta
                                   sigmax:self.circleModel.SigmaAvg
                                   sigmay:self.circleModel.SigmaAvg
                                    tauxy:self.circleModel.Radius
                                principal:NO];
    
    
    [maxShearStressBlock drawXYAxes:center];
    
    [maxShearStressBlock drawThetaArc:center theta:theta];
}

- (void)zoomToExtents{
    
    //update the viewingRectangle and redraw
    /*CGFloat modelWidth = [self.circleModel Radius]*model_width_factor;
    CGFloat modelCenter = [self.circleModel SigmaAvg];
    CGFloat modelHeight = self.frame.size.height/self.frame.size.width*modelWidth;
    CGPoint origin = CGPointMake(modelCenter-modelWidth/2, -modelHeight/2);
    viewingRect = CGRectMake(origin.x, origin.y, modelWidth, modelHeight);
    
    [self setNeedsDisplay];
    */
}

@end
