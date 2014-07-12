//
//  GameActionScene.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameActionScene.h"

@interface GameActionScene ()
@property BOOL contentCreated;
@end

@implementation GameActionScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    
    SKSpriteNode *hero = [self createHeroSprite];
    hero.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self addChild:hero];
    self.backgroundColor = [UIColor colorWithRed:81/255.0f green:228/255.0f blue:255/255.0f alpha:1.0f];
    self.scaleMode = SKSceneScaleModeAspectFit;
}

-(SKSpriteNode *)createHeroSprite
{
    SKSpriteNode *hero = [SKSpriteNode spriteNodeWithImageNamed:@"running_placeholder_one_scaled.png"];
    return hero;
}

@end
