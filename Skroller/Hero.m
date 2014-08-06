//
//  Hero.m
//  Skroller
//
//  Created by MacbookPro on 15.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Hero.h"
@interface Hero()
@property NSMutableArray* jumpTextures;
@property NSMutableArray* walkTextures;

@end

@implementation Hero

+(void)animateSprite :(SKSpriteNode *)sprite :(NSArray *)arrayOfTextures :(NSTimeInterval )time
{
    SKAction *animation = [SKAction animateWithTextures:arrayOfTextures timePerFrame: time];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [sprite runAction:animate];
}

+(Hero *)createHero
{
    Hero *hero = [[Hero alloc] init];
    hero.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"running_placeholder_one.png"];
  
    // load textures
    hero.walkTextures = [NSMutableArray arrayWithCapacity:2];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"running_placeholder_one.png"];
    [hero.walkTextures addObject:f1];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"running_placeholder_two.png"];
    [hero.walkTextures addObject:f2];
    for (SKTexture *t in hero.walkTextures) {t.filteringMode = SKTextureFilteringNearest;}

    hero.jumpTextures = [NSMutableArray arrayWithCapacity:3];
    SKTexture *f3 = [SKTexture textureWithImageNamed:@"hero_jump_1.png"];
    [hero.jumpTextures addObject:f3];
    SKTexture *f4 = [SKTexture textureWithImageNamed:@"hero_jump_2.png"];
    [hero.jumpTextures addObject:f4];
    SKTexture *f5 = [SKTexture textureWithImageNamed:@"hero_jump_3.png"];
    [hero.jumpTextures addObject:f5];
    for (SKTexture *t in hero.jumpTextures) {t.filteringMode = SKTextureFilteringNearest;}
    
    // create hero node
    [Hero animateSprite: hero.sprite : hero.walkTextures : 0.2];
    
    // setup physics
    hero.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.sprite.size];
    hero.sprite.physicsBody.dynamic = YES;
    hero.sprite.physicsBody.mass = 1;
    hero.sprite.physicsBody.restitution = 0;
    return hero;
}

-(void)heroJump: (SKSpriteNode *)heroSprite
{
    SKAction *sequenceOfTextures = [SKAction animateWithTextures:_jumpTextures timePerFrame: 0.25];
    [heroSprite runAction:sequenceOfTextures];
    heroSprite.physicsBody.velocity = CGVectorMake(0, 360);
}

@end
