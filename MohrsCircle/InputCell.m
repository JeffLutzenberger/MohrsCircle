//
//  InputCell.m
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 4/6/13.
//
//

#import "InputCell.h"

@implementation InputCell

@synthesize inputTextField = _inputTextField;
@synthesize webView = _webView;
@synthesize label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.label = @"";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	//[self setNeedsDisplay];
    //[self.view setNeedsDisplay];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginEditingInput" object:self];
    _textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndEditingInput" object:self];
    _textFieldBeingEdited = nil;
}

@end
