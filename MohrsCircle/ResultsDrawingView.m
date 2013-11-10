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

double stress_block_size = 6;

double model_width = 80;
double model_margin = 0;

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
        
        //self.layer.cornerRadius = 10;
        //self.layer.masksToBounds = YES;
        
        MohrsCircleAppDelegate* app = (MohrsCircleAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.circleModel = app.circleModel;
        
        CGFloat modelWidth = model_width;
        CGFloat modelCenter = modelWidth/2;//[self.circleModel SigmaAvg];
        CGFloat modelHeight = self.frame.size.height/self.frame.size.width*modelWidth;
        CGPoint origin = CGPointMake(modelCenter-modelWidth/2, -modelHeight/2);
        viewingRect = CGRectMake(origin.x, origin.y, modelWidth, modelHeight);
        
        _stressBlockType = InitialStress;
        
        stressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
        //principalStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
        //rotatedStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
        //maxShearStressBlock = [[GraphicsStressBlock alloc] initWithViewAndSize:self size:stress_block_size viewRect:viewingRect];
    
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
    

    //CGFloat x = stress_block_size+model_margin;
    //CGFloat y = viewingRect.origin.y+viewingRect.size.height-model_margin;
    
    CGFloat x = viewingRect.origin.x + viewingRect.size.width*0.5;
    CGFloat y = viewingRect.origin.y + viewingRect.size.height*0.5;
    
    
    CGPoint center = CGPointMake(x, y);
    
    CGFloat theta = 0;
    CGFloat sigmax = 0;
    CGFloat sigmay = 0;
    CGFloat tauxy = 0;
    if(_stressBlockType == InitialStress) {
        theta = 0;
        sigmax = self.circleModel.sigmax;
        sigmay = self.circleModel.sigmay;
        tauxy = self.circleModel.tauxy;
    }
    else if(_stressBlockType == PrincipalStress) {
        theta = self.circleModel.theta_p*0.5;
        sigmax = self.circleModel.sigma1;
        sigmay = self.circleModel.sigma2;
        tauxy = 0;
    }
    else if(_stressBlockType == RotatedStress) {
        theta = self.circleModel.theta - self.circleModel.theta_p*0.5;
        sigmax = self.circleModel.sigmax_theta;
        sigmay = self.circleModel.sigmay_theta;
        tauxy = self.circleModel.tauxy_theta;
    }
    else if(_stressBlockType == MaxShearStress) {
        theta = self.circleModel.theta_tau_max;
        sigmax = self.circleModel.SigmaAvg;
        sigmay = self.circleModel.SigmaAvg;
        tauxy = self.circleModel.Radius;
    }
    
    [stressBlock drawStressBlock:center
                           theta:theta
                          sigmax:sigmax
                          sigmay:sigmay
                           tauxy:tauxy
                 stressBlockType:_stressBlockType];
    
    //[self drawStressBlock];
    
    //[self drawPrincipalStressBlock];
    
    //[self drawRotatedStressBlock];
    
    //[self drawMaxShearStressBlock];
    
}

- (void)drawInitialStressBlock {
    
    //CGFloat x = stress_block_size+model_margin;
    //CGFloat y = viewingRect.size.height*0.25;
    CGFloat x = stress_block_size+model_margin;
    CGFloat y = viewingRect.origin.y+viewingRect.size.height-model_margin;
    
    CGPoint center = CGPointMake(x, y);
    
    [initialStressBlock drawStressBlock:center
                                  theta:0
                                 sigmax:self.circleModel.sigmax
                                 sigmay:self.circleModel.sigmay
                                  tauxy:self.circleModel.tauxy
                              stressBlockType:InitialStress];
}

- (void)drawPrincipalStressBlock {
    
    //CGFloat x = model_width - stress_block_size - model_margin;
    //CGFloat y = viewingRect.size.height*0.25;
    CGFloat x = stress_block_size+model_margin;
    CGFloat y = viewingRect.origin.y+viewingRect.size.height-model_margin-stress_block_size*7;
    CGPoint center = CGPointMake(x, y);
    CGFloat theta = self.circleModel.theta_p*0.5;

    [principalStressBlock drawStressBlock:center
                                    theta:theta
                                   sigmax:self.circleModel.sigma1
                                   sigmay:self.circleModel.sigma2
                                    tauxy:0
                          stressBlockType:PrincipalStress];
    
    
    [principalStressBlock drawXYAxes:center];
    
    [principalStressBlock drawThetaArc:center theta:theta];

}

- (void)drawRotatedStressBlock {

    //CGFloat x = stress_block_size+model_margin;
    //CGFloat y = -viewingRect.size.height*0.2;
    CGFloat x = stress_block_size+model_margin;
    CGFloat y = viewingRect.origin.y+viewingRect.size.height-model_margin-stress_block_size*14;
    CGPoint center = CGPointMake(x, y);
    CGFloat theta = self.circleModel.theta - self.circleModel.theta_p*0.5;
    
    [rotatedStressBlock drawStressBlock:center
                                    theta:theta
                                   sigmax:self.circleModel.sigmax_theta
                                   sigmay:self.circleModel.sigmay_theta
                                    tauxy:self.circleModel.tauxy_theta
                                stressBlockType:RotatedStress];
    
    
    [rotatedStressBlock drawXYAxes:center];
    
    [rotatedStressBlock drawThetaArc:center theta:theta];
}

- (void)drawMaxShearStressBlock {
    
    CGFloat x = model_width - stress_block_size - model_margin;
    CGFloat y = -viewingRect.size.height*0.2;
    CGPoint center = CGPointMake(x, y);
    CGFloat theta = self.circleModel.theta_tau_max;
    
    [maxShearStressBlock drawStressBlock:center
                                    theta:theta
                                   sigmax:self.circleModel.SigmaAvg
                                   sigmay:self.circleModel.SigmaAvg
                                    tauxy:self.circleModel.Radius
                                stressBlockType:MaxShearStress];
    
    
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
