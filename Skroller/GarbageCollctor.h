//
//  GarbageCollctor.h
//  Skroller
//
//  Created by Michał Garmulewicz on 01.11.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GarbageCollctor : NSObject
+(void) cleanObject: (SKNode *) objectToClean;
+(void) cleanGarbage;
@end
