//
//  GarbageCollctor.m
//  Skroller
//
//  Created by Michał Garmulewicz on 01.11.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GarbageCollctor.h"

@implementation GarbageCollctor

+(void) addObjectToGarbage: (SKNode *) objectToDump
{
    
};

+(void) cleanGarbage
{
    
};

+(void) cleanObject: (SKNode *) objectToClean
{
    for (SKNode *child in objectToClean.children) {
        [GarbageCollctor cleanObject: child];
    }
                    [objectToClean removeAllChildren];
                    [objectToClean removeAllActions];
                    [objectToClean removeFromParent];
};


@end


