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
#import "SpriteFactory.h"

@interface Hero()
@property NSMutableArray* jumpTextures;
@property NSMutableArray* walkTextures;
@property int timesJumped;
@end

@implementation Hero

+(Hero *)createHero
{
    Hero *hero = [[Hero alloc] init];
    hero.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"girl_one_run_frame1.png"];
//    hero.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"killer.png"];
  
    // load textures
    SKTexture *running_1 = [SKTexture textureWithImageNamed:@"girl_one_run_frame1.png"];
    SKTexture *running_2 = [SKTexture textureWithImageNamed:@"girl_one_run_frame2.png"];
    SKTexture *running_3 = [SKTexture textureWithImageNamed:@"girl_one_run_frame3.png"];
    SKTexture *running_4 = [SKTexture textureWithImageNamed:@"girl_one_run_frame4.png"];
    SKTexture *f3 = [SKTexture textureWithImageNamed:@"hero_jump_1.png"];
    SKTexture *f4 = [SKTexture textureWithImageNamed:@"hero_jump_2.png"];
    SKTexture *f5 = [SKTexture textureWithImageNamed:@"hero_jump_3.png"];

//    SKTexture *f1 = [SKTexture textureWithImageNamed:@"killer.png"];
//    SKTexture *f2 = [SKTexture textureWithImageNamed:@"killer.png"];
//    SKTexture *f3 = [SKTexture textureWithImageNamed:@"killer.png"];
//    SKTexture *f4 = [SKTexture textureWithImageNamed:@"killer.png"];
//    SKTexture *f5 = [SKTexture textureWithImageNamed:@"killer.png"];

    hero.walkTextures = [NSMutableArray arrayWithCapacity:4];
    hero.jumpTextures = [NSMutableArray arrayWithCapacity:3];
    
    [hero.walkTextures addObject:running_1];
    [hero.walkTextures addObject:running_2];
    [hero.walkTextures addObject:running_3];
    [hero.walkTextures addObject:running_4];
    [hero.jumpTextures addObject:f3];
    [hero.jumpTextures addObject:f4];
    [hero.jumpTextures addObject:f5];

    for (SKTexture *t in hero.walkTextures) {t.filteringMode = SKTextureFilteringNearest;}
    for (SKTexture *t in hero.jumpTextures) {t.filteringMode = SKTextureFilteringNearest;}
    
    // create hero node
    [SpriteFactory animateSprite: hero.sprite : hero.walkTextures : 0.2];
    
    // setup physics
    hero.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.sprite.size];
    hero.sprite.physicsBody.dynamic = TRUE;
    hero.sprite.physicsBody.mass = 1;
    hero.sprite.physicsBody.restitution = -10;
    hero.sprite.physicsBody.friction = 0;
    hero.sprite.physicsBody.allowsRotation = FALSE;
    hero.sprite.physicsBody.categoryBitMask = heroCategory;
    hero.sprite.physicsBody.contactTestBitMask = monsterCategory | floorCategory;
    hero.sprite.physicsBody.collisionBitMask = monsterCategory | floorCategory;
    hero.sprite.physicsBody.usesPreciseCollisionDetection = YES;
    
    return hero;
}


-(void)heroJump
{
    if (abs(self.sprite.physicsBody.velocity.dy) < 20 && self.timesJumped <1)
    {
        self.timesJumped += 1;
        SKAction *sequenceOfTextures = [SKAction animateWithTextures:_jumpTextures timePerFrame: 0.15];
        [self.sprite runAction:sequenceOfTextures];
        self.sprite.physicsBody.velocity = CGVectorMake(0, 700);
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
    arrow.physicsBody.restitution = 0.6;
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
