//
//  FirstViewController.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MohrsCircleModel.h"
#import "CircleDrawingView.h"

@interface FirstViewController : UIViewController {
    UITextField *_textFieldBeingEdited;
}

- (void)updateAfterEditNotification:(NSNotification *)notification;

@property (nonatomic, retain) IBOutlet CircleDrawingView* circleDrawing;

@property (nonatomic, retain) IBOutlet UITableView* inputTableView;

@property (nonatomic, assign) MohrsCircleModel* circleModel;

@end
