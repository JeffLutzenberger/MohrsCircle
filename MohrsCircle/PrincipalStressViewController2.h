//
//  PrincipalStressViewController.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/10/13.
//
//

#import <UIKit/UIKit.h>

#import "MohrsCircleModel.h"
#import "CircleDrawingView.h"

@interface PrincipalStressViewController : UIViewController{
    UITextField *_textFieldBeingEdited;
}

- (BOOL)validateTextIsNumber:(NSString*)newText value:(double*)value;

@property (nonatomic, retain) IBOutlet CircleDrawingView* circleDrawing;

@property (nonatomic, retain) IBOutlet UITableView* inputTableView;

@property (nonatomic, assign) MohrsCircleModel* circleModel;

@end

