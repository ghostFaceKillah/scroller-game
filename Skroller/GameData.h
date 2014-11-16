//
//  GameData.h
//  Skroller
//
//  Created by MacbookPro on 31.10.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject <NSCoding>

@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger distance;

@property (assign, nonatomic) NSInteger highScore;
@property (assign, nonatomic) NSInteger totalDistance;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end