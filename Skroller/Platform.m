//
//  Platform.m
//  Skroller
//
//  Created by Michał Garmulewicz on 26.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Platform.h"
#import "Constants.h"
#import "GarbageCollctor.h"

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

+(SKNode *) spawn
{
    SKNode *platform = [[SKNode alloc] init];
    // draw what type of tile it is
    CGFloat temp = [Constants randomFloat];
    CGFloat tiles_no = 3;
    platform.name = @"platform";
    NSString *tile_type;
    if (temp < 1/tiles_no) {
        tile_type = @"honey_tile.png";
    } else if (temp < 2/tiles_no) {
        tile_type = @"pink_disco_tile.png";
    } else {
        tile_type = @"violet_heart_tile.png";
    }
    CGFloat gaplen = ([Constants randomFloat]*2 + 0.5) * GAP_SCALE;
    CGFloat heightAboveAbyss = 0;
    int length = arc4random_uniform(10) + 5;
    SKSpriteNode *current = [Platform getCrazyTile: tile_type];
    SKAction *move = [SKAction moveByX:(-length*current.size.width - 1000) y:0
                              duration:((length*current.size.width + 1000)/(300))];
    SKAction *kill = [SKAction runBlock: ^{
        [GarbageCollctor cleanObject:platform];
    }];
    SKAction *moveLeft = [SKAction sequence:@[move, kill]];
    for (int i = 0; i < length; i++) {
        current = [Platform getCrazyTile: tile_type];
        [platform addChild:current];
    }
    platform.userData = [NSMutableDictionary
            dictionaryWithDictionary:@{
                    @"moveLeft" : moveLeft,
                    @"gapToNextTile" : [NSNumber numberWithFloat:gaplen],
                    @"heightAboveAbyss" : [NSNumber numberWithFloat:heightAboveAbyss],
                    @"length" : [NSNumber numberWithInt:length]
            }];
    return platform;
}


@end
