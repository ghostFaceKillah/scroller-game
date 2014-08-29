//
//  Hero.m
//  Skroller
//
//  Created by MacbookPro on 15.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Hero.h"
#import "Constants.h"
#import "GameActionScene.h"

@interface Hero()
@property NSMutableArray* jumpTextures;
@property NSMutableArray* walkTextures;
@property int timesJumped;
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
    hero.sprite.physicsBody.dynamic = TRUE;
    hero.sprite.physicsBody.mass = 1;
    hero.sprite.physicsBody.restitution = 0;
    hero.sprite.physicsBody.friction = 0;
    hero.sprite.physicsBody.allowsRotation = FALSE;
    hero.sprite.physicsBody.categoryBitMask = heroCategory;
    hero.sprite.physicsBody.contactTestBitMask = monsterCategory | floorCategory;
    hero.sprite.physicsBody.collisionBitMask = monsterCategory | floorCategory;
    hero.sprite.physicsBody.usesPreciseCollisionDetection = YES;
    
    return hero;
}


-(void)heroJump: (SKSpriteNode *)heroSprite
{
    if (self.timesJumped <2)
    {
        self.timesJumped += 1;
        SKAction *sequenceOfTextures = [SKAction animateWithTextures:_jumpTextures timePerFrame: 0.15];
        [heroSprite runAction:sequenceOfTextures];
        heroSprite.physicsBody.velocity = CGVectorMake(0, 530);
    }
}


-(void)heroDash: (SKSpriteNode *) heroSprite
{
    [heroSprite.physicsBody applyImpulse: CGVectorMake(500, 0)];
}


-(void) resolveGroundTouch
{
    self.timesJumped = 0;
}



-(void) shootBow: (SKSpriteNode *) heroSprite :(CGPoint) targetLocation :(GameActionScene *) caller
{
    SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:arrow.size];
    arrow.physicsBody.dynamic = TRUE;
    arrow.physicsBody.mass = 0.1;
    arrow.physicsBody.restitution = 0;
    arrow.physicsBody.friction = 0;
    arrow.physicsBody.allowsRotation = TRUE;
    arrow.physicsBody.categoryBitMask = arrowCategory;
    arrow.physicsBody.contactTestBitMask = monsterCategory | floorCategory;
    arrow.physicsBody.collisionBitMask = monsterCategory | floorCategory;
    arrow.physicsBody.usesPreciseCollisionDetection = YES;
    [caller addChild:arrow];
    [caller.arrows addObject:arrow];
    arrow.position = heroSprite.position;
    
    CGFloat x = targetLocation.x - heroSprite.position.x;
    CGFloat y = targetLocation.y - heroSprite.position.y;
    arrow.zRotation = atan(y/x);
    CGFloat norm = sqrt(x*x + y*y);
    CGFloat scale = 150;
    [arrow.physicsBody applyImpulse:CGVectorMake(scale*x/norm, scale*y/norm)];
}


@end
