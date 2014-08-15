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
static const uint32_t deadCategory     =  0x1 << 3;

// ideas for monsters
// * just goblin - he has two modes - going forward defenceless and second attacking whatever is in front of him
// * spike - you have to dodge him - no method for killing this guy
// * rocket - this guy first runs onto screen and floats around, and later it attacks you directly, but is slow
// to change direction so you can dodge him and he hits floor/etc and kills himself
// * archer - pretty much self-explainatory

// need to implement probabilistic spawning of monsters

+(Monster *)createGoblin
{
    // alloc and init monster goblin
    Monster *monster = [[Monster alloc] init];
    monster.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"monster.png"];
    monster.sprite.texture.filteringMode = SKTextureFilteringNearest;
    monster.isAttacking = TRUE;
    
    // setup gobbo's physics
    monster.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.sprite.size];
    monster.sprite.physicsBody.dynamic = YES;
    monster.sprite.physicsBody.mass = 1;
    monster.sprite.physicsBody.restitution = 0.3;
    monster.sprite.physicsBody.categoryBitMask = monsterCategory;
    monster.sprite.physicsBody.contactTestBitMask = heroCategory | floorCategory;
    monster.sprite.physicsBody.collisionBitMask = heroCategory| floorCategory;
    
    return monster;
}

-(BOOL) isNoLongerNeeded {
    // calculate if sprite is off-screen (it maybe a redundant method now, as we
    // are reimplementing possibly existing method (isVisible etc.)
    // but we will probably need this later when we would like to handle custom vanishing behaviour
    return (self.sprite.position.x < 0) || (self.sprite.position.y < 0);
}

-(void) resolveMovement: (CGFloat) worldVelocity
{
    if (self.isAttacking)
    {
        // if monster is still fresh and has not been killed, make it move forward
        // towards our hero
        CGFloat current_y_speed = self.sprite.physicsBody.velocity.dy;
        self.sprite.physicsBody.velocity = CGVectorMake(MIN(-200, worldVelocity), current_y_speed);
    }
}

- (float)randomFloat {
    float val = ((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX);
    return val;
}

-(void) resolveHit
{
    self.isAttacking = FALSE;
    self.sprite.physicsBody.angularVelocity = 50*([self randomFloat] - 0.5);
    self.sprite.physicsBody.categoryBitMask = deadCategory;
    self.sprite.physicsBody.contactTestBitMask = 0;
    self.sprite.physicsBody.collisionBitMask = 0;
}

@end
