//
//  SecondViewController.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView* _imageView;
}

//@property (nonatomic, retain) IBOutlet UIView *canvas;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end
