//
//  MohrsCircleAppDelegate.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MohrsCircleModel.h"

@interface MohrsCircleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) MohrsCircleModel* circleModel;

@end
