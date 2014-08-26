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


+(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++)
    {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

+(int) signum:(int) n
{
    return (n < 0) ? -1 : (n > 0) ? +1 : 0;
}


@end
