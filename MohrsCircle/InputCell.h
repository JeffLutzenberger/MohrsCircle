//
//  InputCell.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 4/6/13.
//
//

#import <UIKit/UIKit.h>

@interface InputCell : UITableViewCell{
    UITextField *_textFieldBeingEdited;
    //NSString *label;
}

@property (nonatomic, retain) IBOutlet UITextField *inputTextField;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) NSString *label;

@end
