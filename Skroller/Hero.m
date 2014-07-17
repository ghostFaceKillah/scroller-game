//
//  Hero.m
//  Skroller
//
//  Created by MacbookPro on 15.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Hero.h"

@implementation Hero

+(void)animateSprite :(SKSpriteNode *)sprite :(NSArray *)arrayOfTextures :(NSTimeInterval )time
{
    for (SKTexture *t in arrayOfTextures) {t.filteringMode = SKTextureFilteringNearest;}
    
    SKAction *animation = [SKAction animateWithTextures:arrayOfTextures timePerFrame: time];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [sprite runAction:animate];
}

+(SKSpriteNode *)createHeroSprite
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

+(void)heroJump: (SKSpriteNode *)hero
{
    NSMutableArray *jumpTextures = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *moves = [NSMutableArray arrayWithCapacity:3];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"hero_jump_1.png"];
    [jumpTextures addObject:f1];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"hero_jump_2.png"];
    [jumpTextures addObject:f2];
    SKTexture *f3 = [SKTexture textureWithImageNamed:@"hero_jump_3.png"];
    [jumpTextures addObject:f3];
    SKAction *moveUp = [SKAction moveByX:0 y:50 duration:0.40];
    [moves addObject:moveUp];
    SKAction *wait = [SKAction waitForDuration:0.1];
    [moves addObject:wait];
    SKAction *moveDown = [SKAction moveByX:0 y:-50 duration:0.40];
    [moves addObject:moveDown];
    
    for (SKTexture *t in jumpTextures) {t.filteringMode = SKTextureFilteringNearest;}
    
    SKAction *sequenceOfTextures = [SKAction animateWithTextures:jumpTextures timePerFrame: 0.25];
    SKAction *sequenceOfMoves = [SKAction sequence:moves];
    
    SKAction *group = [SKAction group:@[sequenceOfMoves, sequenceOfTextures]];
    
    [hero runAction:group];
}



@end
