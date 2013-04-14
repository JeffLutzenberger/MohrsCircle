//
//  PrinciplaStressController.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/8/13.
//
//

#import <UIKit/UIKit.h>

#import "MohrsCircleModel.h"
#import "CircleDrawingView.h"

@interface PrinciplaStressController : UIViewController {
    UITextField *_textFieldBeingEdited;
}

- (void)updateAfterEditNotification:(NSNotification *)notification;

@property (nonatomic, retain) IBOutlet CircleDrawingView* circleDrawing;

@property (nonatomic, retain) IBOutlet UITableView* inputTableView;

@property (nonatomic, assign) MohrsCircleModel* circleModel;

@end
