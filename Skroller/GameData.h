//
//  GameData.h
//  Skroller
//
//  Created by MacbookPro on 31.10.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

@property (assign, nonatomic) long score;
@property (assign, nonatomic) int distance;

@property (assign, nonatomic) long highScore;
@property (assign, nonatomic) long totalDistance;

+(instancetype)sharedGameData;
-(void)reset;

@end