//
//  ResultCell.m
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 5/28/13.
//
//

#import "ResultCell.h"

@implementation ResultCell

@synthesize resultDrawing = _resultDrawing;

@synthesize webView = _webView;

@synthesize title = _title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
