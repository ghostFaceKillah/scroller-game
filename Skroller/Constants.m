//
//  Constants.m
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (float)randomFloat
{
    // get a random float from unit interval
    float val = ((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX);
    return val;
}

@end
