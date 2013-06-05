//
//  ResultCell.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 5/28/13.
//
//

#import <UIKit/UIKit.h>
#import "ResultsDrawingView.h"

@interface ResultCell : UITableViewCell

@property (nonatomic, retain) IBOutlet ResultsDrawingView *resultDrawing;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UILabel *title;

@end
