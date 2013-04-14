//
//  Camera.h
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Camera : NSObject {
    CGRect viewport;
    
}

- (id)initWithRect:(CGRect)rect;

@end
