//
//  ResultsViewController.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/15/13.
//
//

#import <UIKit/UIKit.h>

#import "MohrsCircleModel.h"
#import "ResultsDrawingView.h"

@interface ResultsViewController : UIViewController

@property (nonatomic, retain) IBOutlet ResultsDrawingView* resultsDrawing;

@property (nonatomic, retain) IBOutlet UITableView* resultTableView;

@property (nonatomic, assign) MohrsCircleModel* circleModel;

@end
