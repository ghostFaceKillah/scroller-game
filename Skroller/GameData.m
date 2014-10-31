//
//  GameData.m
//  Skroller
//
//  Created by MacbookPro on 31.10.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameData.h"

@implementation GameData

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)reset
{
    self.score = 0;
    self.distance = 0;
}

@end
