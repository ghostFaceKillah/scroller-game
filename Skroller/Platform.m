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

+(SKSpriteNode *) getSingleTile : (BOOL) isFirst : (BOOL) isLast
{
    SKSpriteNode *tile;
    SKSpriteNode *background;
    if (isFirst) {
        tile = [SKSpriteNode spriteNodeWithImageNamed:@"school_platform_beg.png"];
        background = [SKSpriteNode spriteNodeWithImageNamed:@"school_platform_beg_back.png"];
    } else if (isLast) {
        tile = [SKSpriteNode spriteNodeWithImageNamed:@"school_platform_end.png"];
        background = [SKSpriteNode spriteNodeWithImageNamed:@"school_platform_end_back.png"];
    } else {
        tile = [SKSpriteNode spriteNodeWithImageNamed:@"school_platform_mid.png"];
        background = [SKSpriteNode spriteNodeWithImageNamed:@"school_platform_mid_back.png"];
    }
    [tile addChild:background];
    background.position = CGPointMake(0, tile.size.height/2 + background.size.height/2);
    tile.texture.filteringMode = SKTextureFilteringNearest;
    background.texture.filteringMode = SKTextureFilteringNearest;

    tile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tile.size];
    tile.physicsBody.dynamic = NO;
    tile.physicsBody.categoryBitMask = floorCategory;
    tile.physicsBody.contactTestBitMask = heroCategory | monsterCategory;
    tile.physicsBody.collisionBitMask = heroCategory | monsterCategory;

    return tile;
}

+(SKSpriteNode *) getCrazyTile: (NSString *) tile_type
{
    SKSpriteNode *tile = [SKSpriteNode spriteNodeWithImageNamed:tile_type];
    tile.texture.filteringMode = SKTextureFilteringNearest;
    tile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tile.size];
    tile.physicsBody.restitution = 0;
    tile.physicsBody.dynamic = NO;
    tile.physicsBody.categoryBitMask = floorCategory;
    tile.physicsBody.contactTestBitMask = heroCategory | monsterCategory;
    tile.physicsBody.collisionBitMask = heroCategory | monsterCategory;
    
    return tile;
}

+(Platform *) spawn
{
    Platform *platform = [[Platform alloc] init];
    
    // draw what type of tile it is
    CGFloat temp = [Constants randomFloat];
    CGFloat tiles_no = 3;
    NSString *tile_type;
    if (temp < 1/tiles_no)
    {
        tile_type = @"honey_tile.png";
    } else if (temp < 2/tiles_no)
    {
        tile_type = @"pink_disco_tile.png";
    } else
    {
        tile_type = @"violet_heart_tile.png";
    }
    
    // setup platform's physics
    
    platform.gapToNextTile = ([Constants randomFloat]*2 + 0.5) * GAP_SCALE;
    platform.heightAboveAbyss = 0;
    platform.length = arc4random_uniform(10) + 5;
    platform.parts = [NSMutableArray array];

    SKSpriteNode *current = [Platform getCrazyTile: tile_type];
    platform.moveLeft = [SKAction moveByX:(-platform.length*current.size.width - 1000) y:0
                                  duration:((platform.length*current.size.width + 1000)/(300))];
    
//    for (int i = 0; i < platform.length; i++)
//    {
//        current = [Platform getSingleTile: (i==0): (i==platform.length - 1)];
//        [platform.parts addObject:current];
//    }
//    
    for (int i = 0; i < platform.length; i++)
    {
        current = [Platform getCrazyTile: tile_type];
        [platform.parts addObject:current];
    }
    
    return platform;
}



+(Platform *) getLongPlatform
{
    Platform *platform = [[Platform alloc] init];
    
    // setup platform's physics
    
    platform.gapToNextTile = ([Constants randomFloat]*2 + 0.5) * GAP_SCALE;
    platform.heightAboveAbyss = 0;
    platform.length = 200;
    platform.parts = [NSMutableArray array];
    
    SKSpriteNode *current = [Platform getSingleTile: FALSE: FALSE];
    platform.moveLeft = [SKAction moveByX:(-platform.length*current.size.width - 1000) y:0
                                 duration:((platform.length*current.size.width + 1000)/(300))];
    
    for (int i = 0; i < platform.length; i++)
    {
//        current = [Platform getSingleTile: (i==0): (i==platform.length - 1)];
        current = [Platform getCrazyTile:@"honey_tile.png"];
        [platform.parts addObject:current];
    }
    
    
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
    SKSpriteNode *lastTile = [self.parts lastObject];
    return (lastTile.position.x + lastTile.size.width/2 < 0) ||
           (lastTile.position.y + lastTile.size.height/2 < 0);
}


@end
