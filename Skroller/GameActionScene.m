//
//  GameActionScene.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameActionScene.h"
#import "Hero.h"

@interface GameActionScene ()
@property BOOL contentCreated;
@property SKSpriteNode* hero;
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
    
    _hero = [Hero createHeroSprite];
    SKSpriteNode *floor = [self createFloorSprite];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+20);
    _hero.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMinY(self.frame)+35);
    [self addChild: floor];
    [self addChild:_hero];
    self.backgroundColor = [UIColor colorWithRed:81/255.0f green:228/255.0f blue:255/255.0f alpha:1.0f];
    self.scaleMode = SKSceneScaleModeAspectFit;
}

-(SKSpriteNode *)createFloorSprite
{
    NSMutableArray *floorTextures = [NSMutableArray arrayWithCapacity:2];
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor.png"];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"floor.png"];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"floor_two.png"];
    [floorTextures addObject:f1];
    [floorTextures addObject:f2];
    [Hero animateSprite: floor : floorTextures : 0.2];
    
    return floor;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Hero heroJump:_hero];
}

@end
