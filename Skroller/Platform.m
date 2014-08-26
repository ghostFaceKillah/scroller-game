//
//  Platform.m
//  Skroller
//
//  Created by Michał Garmulewicz on 26.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Platform.h"
#import "Constants.h"

@implementation Platform

const CGFloat GAP_SCALE = 100;

+(Platform *) spawn
{
    // alloc and init monster goblin
    Platform *platform = [[Platform alloc] init];
    platform.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"floor_move_01.png"];
    platform.sprite.texture.filteringMode = SKTextureFilteringNearest;
    
    // setup platform's physics
    platform.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.sprite.size];
    platform.sprite.physicsBody.dynamic = NO;
    platform.sprite.physicsBody.categoryBitMask = floorCategory;
    platform.sprite.physicsBody.contactTestBitMask = heroCategory | monsterCategory;
    platform.sprite.physicsBody.collisionBitMask = heroCategory | monsterCategory;
    
    platform.gapToNextTile = ([Constants randomFloat]*2 + 0.5) * GAP_SCALE;
    platform.heightAboveAbyss = 0;
    
    return platform;
}


-(void) resolveMovement: (CGFloat) worldVelocity
{
   // if monster is still fresh and has not been killed, make it move forward
   // towards our hero
   // CGFloat current_y_speed = self.sprite.physicsBody.velocity.dy;
   // self.sprite.physicsBody.velocity = CGVectorMake(MIN(-200, 0.5*worldVelocity), current_y_speed);
}


-(BOOL) isNoLongerNeeded {
    // calculate if sprite is off-screen (it maybe a redundant method now, as we
    // are reimplementing possibly existing method (isVisible etc.)
    // but we will probably need this later when we would like to handle custom vanishing behaviour
    return (self.sprite.position.x < 0) || (self.sprite.position.y < 0);
}


@end
