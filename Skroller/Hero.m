//
//  Hero.m
//  Skroller
//
//  Created by MacbookPro on 15.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Hero.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>

@interface Hero()
@property NSMutableArray* jumpTextures;
@property NSMutableArray* walkTextures;
@property NSMutableArray* attack1Textures;
@property int timesJumped;
@end

@implementation Hero

+(Hero *)createHero
{
    Hero *hero = [[Hero alloc] init];
    hero.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"girl0.png"];
    hero.sprite.name = @"hero";
//    hero.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"killer.png"];
  
    // load textures
    hero.walkTextures = [NSMutableArray arrayWithCapacity:1];
    SKTextureAtlas *blondieMoveAtlas = [SKTextureAtlas atlasNamed:@"blondeHeroineMove"];
    
    NSInteger amount = blondieMoveAtlas.textureNames.count -1;
    for (NSInteger i = 0; i <= amount; i++) {
        NSString *textureName = [NSString stringWithFormat:@"girl%ld", (long)i];
        SKTexture *temp = [blondieMoveAtlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [hero.walkTextures addObject:temp];
    }
    
    hero.jumpTextures = [NSMutableArray arrayWithCapacity:1];
    SKTextureAtlas *blondieJumpAtlas = [SKTextureAtlas atlasNamed:@"blondeHeroineJump"];
    
    NSInteger amount2 = blondieJumpAtlas.textureNames.count;
    for (NSInteger i = 1; i <= amount2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"jump_0%ld", (long)i];
        SKTexture *temp = [blondieJumpAtlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [hero.jumpTextures addObject:temp];
    }

    hero.attack1Textures = [NSMutableArray arrayWithCapacity:1];
    SKTextureAtlas *blondieAttack1Atlas = [SKTextureAtlas atlasNamed:@"blondeHeroineAttack1"];
    
    NSInteger amount3 = blondieAttack1Atlas.textureNames.count;
    for (NSInteger i = 1; i <= amount3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"attack%ld", (long)i];
        SKTexture *temp = [blondieAttack1Atlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [hero.attack1Textures addObject:temp];
    }
    
    // create hero node
    SKAction *walk = [SKAction animateWithTextures:hero.walkTextures timePerFrame: 0.08 resize:YES restore:NO];
    SKAction *loop = [SKAction repeatActionForever:walk];
    [hero.sprite runAction:loop];
    
    // setup physics
    hero.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(26, 42)];
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
        SKAction *sequenceOfTextures = [SKAction animateWithTextures:_jumpTextures timePerFrame: 0.1 resize:YES restore:NO];
        [self.sprite runAction:sequenceOfTextures];
        self.sprite.physicsBody.velocity = CGVectorMake(0, 700);
    }
}

-(void)heroDash: (SKSpriteNode *) heroSprite
{
    SKAction *walk = [SKAction animateWithTextures:_walkTextures timePerFrame: 0.08 resize:YES restore:NO];
    SKAction *loop = [SKAction repeatActionForever:walk];
    SKAction *dash_animation = [SKAction animateWithTextures:_attack1Textures timePerFrame: 0.15 resize:YES restore:NO];
    SKAction *sequence = [SKAction sequence:@[dash_animation, loop]];
    [self.sprite runAction:sequence];
    static int k = 0;
    k = (k+1) % 3;
    NSString *name;
    if (k==0) {
        name = @"attack_placeholder_1.wav";
    } else if (k==1) {
        name = @"attack_placeholder_2.wav";
    } else {
        name = @"attack_placeholder_3.wav";
    }
    [self.sprite runAction:[SKAction playSoundFileNamed:name waitForCompletion:NO]];
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
