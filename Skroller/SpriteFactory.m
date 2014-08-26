//
//  SpriteFactory.m
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "SpriteFactory.h"
#import "Constants.h"
#import "GameActionScene.h"
#import "Baloon.h"
#import "TowerLowerPart.h"
#import "TowerUpperPart.h"
#import "Goblin.h"
#import "Hero.h"
#import "Birdie.h"
#import "Hightower.h"
#import "Bomb.h"
#import "Platform.h"

@interface SpriteFactory()
@property GameActionScene *receiver;
@end

@implementation SpriteFactory

const CGFloat HEIGHT_VARIABILITY = 100;

+(SpriteFactory *) createSpriteFactory: (GameActionScene *) receiver;
{
    SpriteFactory *factory = [[SpriteFactory alloc] init];
    factory.receiver = receiver;
    return factory;
}


-(void) addBomb
{
    Bomb *monster = [Bomb spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMinY(_receiver.frame)+50);
    monster.sprite.name = [Constants generateRandomString:10];
    
    // and add it to the data structures
    [_receiver addChild:monster.sprite];
    [_receiver.monsters setObject:monster forKey:monster.sprite.name];
}

-(void) addHightower
{
    Hightower *monster = [Hightower spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMinY(_receiver.frame)+50);
    monster.sprite.name = [Constants generateRandomString:10];
    
    // and add it to the data structures
    [_receiver addChild:monster.sprite];
    [_receiver.monsters setObject:monster forKey:monster.sprite.name];
}

-(void) addBirdie
{
    // wrapper for adding a monster birdie to the scene
    
    Birdie *birdie = [Birdie spawn: _receiver.hero];
    birdie.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMaxY(_receiver.frame)-10);
    birdie.sprite.name = [Constants generateRandomString:10];
    
    [_receiver addChild:birdie.sprite];
    [_receiver.monsters setObject:birdie forKey:birdie.sprite.name];
}

-(void) addGoblin
{
    // a wrapper for handling all the monster data structures
    // create monster node
    Goblin *monster = [Goblin spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMinY(_receiver.frame)+50);
    monster.sprite.name = [Constants generateRandomString:10];
    
    // and add it to the data structures
    [_receiver addChild:monster.sprite];
    [_receiver.monsters setObject:monster forKey:monster.sprite.name];
}

-(void) addTwoPartTower
{
    TowerLowerPart *monster = [TowerLowerPart spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMinY(_receiver.frame)+50);
    monster.sprite.name = [Constants generateRandomString:10];
    
    TowerUpperPart *attacker = [TowerUpperPart spawn];
    attacker.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMinY(_receiver.frame) + 90);
    attacker.sprite.name = [Constants generateRandomString:10];
    
    // and add it to the data structures
    [_receiver addChild:monster.sprite];
    [_receiver addChild:attacker.sprite];
    [_receiver.monsters setObject:monster forKey:monster.sprite.name];
    [_receiver.monsters setObject:attacker forKey:attacker.sprite.name];
}


-(void) addBaloon
{
    Baloon *monster = [Baloon spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, CGRectGetMaxY(_receiver.frame)-20);
    monster.sprite.name = [Constants generateRandomString:10];
    
    // and add it to the data structures
    [_receiver addChild:monster.sprite];
    [_receiver.monsters setObject:monster forKey:monster.sprite.name];
}

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
    menu.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:menu.size];
    menu.physicsBody.dynamic = TRUE;
    menu.physicsBody.mass = 1;
    menu.physicsBody.categoryBitMask = menuCategory;
    menu.physicsBody.contactTestBitMask = 0;
    menu.physicsBody.collisionBitMask = 0;
    return menu;
}

+(SKSpriteNode *) createGameOverMenu
{
    SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:@"game_over_menu_placeholder.png"];
    menu.zPosition = 1100;
    SKSpriteNode *tryAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"try_again_button_placeholder.png"];
    [menu addChild:tryAgainButton];
    tryAgainButton.position = CGPointMake(4, 40);
    tryAgainButton.name = @"tryAgain";
    tryAgainButton.zPosition = 1110;
    menu.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:menu.size];
    menu.physicsBody.dynamic = TRUE;
    menu.physicsBody.mass = 1;
    menu.physicsBody.categoryBitMask = menuCategory;
    menu.physicsBody.contactTestBitMask = 0;
    menu.physicsBody.collisionBitMask = 0;
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


-(void) initStaticFloor
{
    Platform *floor = [Platform spawn];
    floor.sprite.position = CGPointMake(CGRectGetMinX(_receiver.frame) + floor.sprite.size.width/2,
                                        CGRectGetMinY(_receiver.frame)+10);
    floor.heightAboveAbyss = CGRectGetMinY(_receiver.frame)+10;

    
    [_receiver.platforms addObject:floor];
    [_receiver addChild:floor.sprite];
    [_receiver.platforms addObject:floor];
}


-(void) initPlatform
{
    Platform *floor = [Platform spawn];
    Platform *lastTile = [_receiver.platforms lastObject];
    floor.heightAboveAbyss = lastTile.heightAboveAbyss + ([Constants randomFloat] - 0.5) * HEIGHT_VARIABILITY;
    while (floor.heightAboveAbyss <= CGRectGetMinY(_receiver.frame) ||
           floor.heightAboveAbyss >= CGRectGetMaxY(_receiver.frame) - 30)
    {
        floor.heightAboveAbyss = lastTile.heightAboveAbyss + ([Constants randomFloat] - 0.5) * HEIGHT_VARIABILITY;
    }
    floor.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame) + floor.sprite.size.width/2,
                                       floor.heightAboveAbyss);
    SKAction *moveLeft = [SKAction moveBy:CGVectorMake(-900, 0) duration:3];
    [floor.sprite runAction:moveLeft];
    
    
    [_receiver.platforms addObject:floor];
    [_receiver addChild:floor.sprite];
    [_receiver.platforms addObject:floor];
    
}


-(void) initLandscape
{
    SKSpriteNode *mountains = [SpriteFactory createMountains];
    mountains.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMinY(_receiver.frame)+20);
    [_receiver addChild:mountains];
}


-(void) makeCloud
{
    SKSpriteNode *cloud = [SpriteFactory createCloud];
    [_receiver addChild:cloud];
    cloud.position = CGPointMake(CGRectGetMaxX(_receiver.frame), CGRectGetMaxY(_receiver.frame)-50);
}


-(void) makeHero
{
    _receiver.hero = [Hero createHero];
    _receiver.hero.sprite.position = CGPointMake(CGRectGetMinX(_receiver.frame)+20, CGRectGetMinY(_receiver.frame)+135);
    [_receiver addChild:_receiver.hero.sprite];
}


-(void) initStartMenu
{
    SKSpriteNode *menuHolder = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(200, 10)];
    menuHolder.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMaxY(_receiver.frame));
    menuHolder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:menuHolder.size];
    menuHolder.physicsBody.dynamic = FALSE;
    [_receiver addChild:menuHolder];
    SKSpriteNode *menu = [SpriteFactory createStartMenu];
    menu.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMidY(_receiver.frame));
    [_receiver addChild:menu];
    [menu.physicsBody applyImpulse:CGVectorMake(2, 0)];
    _receiver.menuHolder = menuHolder;
    SKPhysicsJointLimit *menuLink = [SKPhysicsJointLimit jointWithBodyA:menuHolder.physicsBody bodyB:menu.physicsBody anchorA:menuHolder.position anchorB:menu.position];
    [_receiver.physicsWorld addJoint:menuLink];
}


-(void) initGameOverMenu
{
    _receiver.gameOverMenuHolder = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(200, 10)];
    _receiver.gameOverMenuHolder.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMaxY(_receiver.frame));
    _receiver.gameOverMenuHolder.physicsBody =
    _receiver.gameOverMenuHolder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_receiver.gameOverMenuHolder.size];
    _receiver.gameOverMenuHolder.physicsBody.dynamic = FALSE;
    [_receiver addChild:_receiver.gameOverMenuHolder];
    SKSpriteNode *gameOverMenu = [SpriteFactory createGameOverMenu];
    gameOverMenu.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMidY(_receiver.frame));
    [_receiver addChild:gameOverMenu];
    SKPhysicsJointLimit *gameOverMenuLink = [SKPhysicsJointLimit jointWithBodyA:_receiver.gameOverMenuHolder.physicsBody bodyB:gameOverMenu.physicsBody anchorA:_receiver.gameOverMenuHolder.position anchorB:gameOverMenu.position];
    [_receiver.physicsWorld addJoint:gameOverMenuLink];
    _receiver.gameOverMenuHolder.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMaxY(_receiver.frame)+200);
}

@end
