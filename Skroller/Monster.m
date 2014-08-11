//
//  Monster.m
//  Skroller
//
//  Created by Michał Garmulewicz on 10.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Monster.h"
@interface Monster()
@property BOOL isAttacking;
@end

@implementation Monster

static const uint32_t heroCategory     =  0x1 << 0;
static const uint32_t monsterCategory  =  0x1 << 1;
static const uint32_t floorCategory    =  0x1 << 2;

+(Monster *)createGoblin
{
    // alloc and init monster
    Monster *monster = [[Monster alloc] init];
    monster.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"monster.png"];
    monster.sprite.texture.filteringMode = SKTextureFilteringNearest;
    monster.isAttacking = TRUE;
    
    // setup gobbo's physics
    monster.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.sprite.size];
    monster.sprite.physicsBody.dynamic = YES;
    monster.sprite.physicsBody.mass = 1;
    monster.sprite.physicsBody.restitution = 0;
    monster.sprite.physicsBody.categoryBitMask = monsterCategory;
    monster.sprite.physicsBody.contactTestBitMask = heroCategory | floorCategory;
    monster.sprite.physicsBody.collisionBitMask = heroCategory| floorCategory;
    
    return monster;
}

-(BOOL) didPassHero {
    return (self.sprite.position.x < 0);
}

-(void) resolveMovement
{
    if (self.isAttacking)
    {
        CGFloat current_y_speed = self.sprite.physicsBody.velocity.dy;
        self.sprite.physicsBody.velocity = CGVectorMake(-100, current_y_speed);
    }
}

-(void) resolveHit
{
    self.isAttacking = FALSE;
}

@end
