//
//  Constants.h
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

+ (float)randomFloat;
+(NSString*)generateRandomString:(int)num;
+(int) signum:(int) n;

@end

static const uint32_t heroCategory     =  0x1 << 0;
static const uint32_t monsterCategory  =  0x1 << 1;
static const uint32_t floorCategory    =  0x1 << 2;
static const uint32_t menuCategory     =  0x1 << 3;
static const uint32_t arrowCategory  =  0x1 << 4;


