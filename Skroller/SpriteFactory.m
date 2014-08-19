//
//  SpriteFactory.m
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "SpriteFactory.h"
#import "Constants.h"

@implementation SpriteFactory

+(SKSpriteNode *)createMountains
{
    SKSpriteNode *fuji = [SKSpriteNode spriteNodeWithImageNamed:@"mountains_prototype.png"];
    
    
    NSMutableArray *mountainTextures = [NSMutableArray arrayWithCapacity:64];
    
    NSString *filename;
    for (int i = 0; i < 64; ++i)
    {
        if (i <9)
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"mount_move_0", i+1, @".png"];
        } else
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"mount_move_", i+1, @".png"];
        }
        SKTexture *f = [SKTexture textureWithImageNamed:filename];
        f.filteringMode = SKTextureFilteringNearest;
        [mountainTextures addObject:f];
    }
    
    fuji.zPosition = -10;
    
    // mountain animation
    SKAction *animation = [SKAction animateWithTextures:mountainTextures timePerFrame: 0.1];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [fuji runAction:animate];
    
    return fuji;
}


+(SKSpriteNode *) createStartMenu
{
    SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:@"menu_placeholder.png"];
    menu.zPosition = 100;
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start_button_placeholder.png"];
    [menu addChild:startButton];
    startButton.position = CGPointMake(4, 40);
    startButton.name = @"start";
    startButton.zPosition = 110;
    
    return menu;
}


+(SKSpriteNode *)createCloud
{
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud_prototype.png"];
    cloud.zPosition = -10;
    cloud.name = @"cloud";
    SKAction *move = [SKAction moveToX:-cloud.size.width duration:2+4*[Constants randomFloat]];
    SKAction *die = [SKAction removeFromParent];
    [cloud runAction:[SKAction sequence:@[move, die]]];
    return cloud;
}


+(SKSpriteNode *)createFloorSprite
{
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor_move_01.png"];
    
    // manage floor textures
    NSMutableArray *floorTextures = [NSMutableArray arrayWithCapacity:64];
    //    SKTexture *f = [SKTexture textureWithImageNamed:@"floor.png"];
    //    SKTexture *f2 = [SKTexture textureWithImageNamed:@"floor_two.png"];
    //    [floorTextures addObject:f1];
    //    [floorTextures addObject:f2];
    
    
    NSString *filename;
    for (int i = 0; i < 64; ++i)
    {
        if (i <9)
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"floor_move_0", i+1, @".png"];
        } else
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"floor_move_", i+1, @".png"];
        }
        SKTexture *f = [SKTexture textureWithImageNamed:filename];
        f.filteringMode = SKTextureFilteringNearest;
        [floorTextures addObject:f];
    }
    
    // floor physics
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = false;
    floor.physicsBody.categoryBitMask = floorCategory;
    floor.physicsBody.contactTestBitMask = heroCategory;
    floor.physicsBody.collisionBitMask = heroCategory;
    //
    //    floor.zPosition = -10;
    //
    //    NSLog(@"%f", floor.zPosition);
    
    // floor animation
    SKAction *animation = [SKAction animateWithTextures:floorTextures timePerFrame: 0.0075];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [floor runAction:animate];
    
    return floor;
}

@end
