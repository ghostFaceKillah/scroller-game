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

-(void)animateSprite :(SKSpriteNode *)sprite :(NSArray *)arrayOfTextures :(NSTimeInterval )time
{
    for (SKTexture *t in arrayOfTextures) {t.filteringMode = SKTextureFilteringNearest;}
    
    SKAction *animation = [SKAction animateWithTextures:arrayOfTextures timePerFrame: time];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [sprite runAction:animate];
}

-(SKSpriteNode *)createFloorSprite
{
    NSMutableArray *floorTextures = [NSMutableArray arrayWithCapacity:2];
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor.png"];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"floor.png"];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"floor_two.png"];
    [floorTextures addObject:f1];
    [floorTextures addObject:f2];
    [self animateSprite: floor : floorTextures : 0.2];
    
    return floor;
}

-(SKSpriteNode *)createHeroSprite
{
    
    NSMutableArray *heroWalkWithTextures = [NSMutableArray arrayWithCapacity:2];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"running_placeholder_one.png"];
    [heroWalkWithTextures addObject:f1];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"running_placeholder_two.png"];
    [heroWalkWithTextures addObject:f2];
    SKSpriteNode *hero = [SKSpriteNode spriteNodeWithImageNamed:@"running_placeholder_one.png"];
    [self animateSprite : hero : heroWalkWithTextures : 0.2];


    return hero;
}

@end
