//
//  TowerLowerPart.m
//  Skroller
//
//  Created by Michał Garmulewicz on 24.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "TowerLowerPart.h"
#import "Constants.h"

@interface TowerLowerPart()
@property BOOL isAttacking;
@end

@implementation TowerLowerPart

+(TowerLowerPart *) spawn
{
    // alloc and init monster goblin
    TowerLowerPart *monster = [[TowerLowerPart alloc] init];
    monster.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"tower_down_placeholder.png"];
    monster.sprite.texture.filteringMode = SKTextureFilteringNearest;
    monster.isAttacking = TRUE;
    
    // setup gobbo's physics
    monster.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.sprite.size];
    monster.sprite.physicsBody.dynamic = YES;
    monster.sprite.physicsBody.mass = 1;
    monster.sprite.physicsBody.restitution = 0.3;
    monster.sprite.physicsBody.categoryBitMask = monsterCategory;
    monster.sprite.physicsBody.contactTestBitMask = heroCategory | floorCategory | monsterCategory;
    monster.sprite.physicsBody.collisionBitMask = heroCategory| floorCategory | monsterCategory;
    
    return monster;
}


-(void) resolveMovement: (CGFloat) worldVelocity
{
    if (self.isAttacking)
    {
        // if monster is still fresh and has not been killed, make it move forward
        // towards our hero
        CGFloat current_y_speed = self.sprite.physicsBody.velocity.dy;
        self.sprite.physicsBody.velocity = CGVectorMake(MIN(-200, 0.5*worldVelocity), current_y_speed);
    }
}

-(void) resolveHit
{
    self.isAttacking = FALSE;
    self.sprite.physicsBody.angularVelocity = 50*([Constants randomFloat] - 0.5);
    self.sprite.physicsBody.categoryBitMask = menuCategory;
    self.sprite.physicsBody.contactTestBitMask = 0;
    self.sprite.physicsBody.collisionBitMask = 0;
}

-(BOOL) isNoLongerNeeded {
    // calculate if sprite is off-screen (it maybe a redundant method now, as we
    // are reimplementing possibly existing method (isVisible etc.)
    // but we will probably need this later when we would like to handle custom vanishing behaviour
    return (self.sprite.position.x < 0) || (self.sprite.position.y < 0);
}
@end