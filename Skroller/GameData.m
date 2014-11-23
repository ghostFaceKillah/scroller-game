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
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

-(void)reset
{
    self.score = 0;
    self.distance = 0;
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[GameData filePath] atomically:YES];
}

static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataTotalDistanceKey = @"totalDistance";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey: SSGameDataHighScoreKey];
    [encoder encodeDouble:self.totalDistance forKey: SSGameDataTotalDistanceKey];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeDoubleForKey: SSGameDataHighScoreKey];
        _totalDistance = [decoder decodeDoubleForKey: SSGameDataTotalDistanceKey];
    }
    return self;
}

+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [GameData filePath]];
    if (decodedData) {
        GameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[GameData alloc] init];
}
@end
