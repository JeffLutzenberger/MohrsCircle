//
//  Camera.m
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"


@implementation Camera

- (id)initWithRect:(CGRect)rect
{
    [super init];
    
    viewport = rect;
    
    return self;
}

@end
