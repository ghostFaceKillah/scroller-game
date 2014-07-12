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
    SKSpriteNode *floor = [self createFloorSprite];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+20);
    hero.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMinY(self.frame)+35);
    [self addChild: floor];
    [self addChild:hero];
    self.backgroundColor = [UIColor colorWithRed:81/255.0f green:228/255.0f blue:255/255.0f alpha:1.0f];
    self.scaleMode = SKSceneScaleModeAspectFit;
}

-(SKSpriteNode *)createFloorSprite
{
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor_two.png"];
    floor.texture.filteringMode = SKTextureFilteringNearest;
    return floor;
}

-(SKSpriteNode *)createHeroSprite
{
    
    NSMutableArray *heroWalkWithTextures = [NSMutableArray arrayWithCapacity:2];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"running_placeholder_one.png"];
    f1.filteringMode = SKTextureFilteringNearest;
    [heroWalkWithTextures addObject:f1];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"running_placeholder_two.png"];
    f2.filteringMode = SKTextureFilteringNearest;
    [heroWalkWithTextures addObject:f2];
    
    SKAction *walkAnimation = [SKAction animateWithTextures:heroWalkWithTextures timePerFrame:0.2];
    
    SKSpriteNode *hero = [SKSpriteNode spriteNodeWithImageNamed:@"running_placeholder_one.png"];
    SKAction *animate = [SKAction repeatActionForever:walkAnimation];
    [hero runAction:animate];

    return hero;
}

@end
