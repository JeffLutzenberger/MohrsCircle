//
//  Canvas.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Camera.h"
#import "MohrsCircleModel.h"

@interface Canvas : UIView {
    
    CGRect viewingRect;
    CGPoint eyePosition;
    
    CGFloat lastMove;
    
    MohrsCircleModel* circleModel;
    
}

//- (IBAction)xDrag: (id)sender withEvent: (UIEvent *) event;

- (void)drawAxes;

- (void)drawCircle;


@end
