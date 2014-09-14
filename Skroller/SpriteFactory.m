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

+(SKSpriteNode *)createFarBackground
{
    SKSpriteNode *buildings = [SKSpriteNode spriteNodeWithImageNamed:@"background_placeholder.png"];
    buildings.name = @"buildings";
    buildings.zPosition = -100;
    SKAction* moveLeft = [SKAction moveByX:(-10) y:0
                                 duration:(0.1)];
    SKAction* move = [SKAction repeatActionForever:moveLeft];
    [buildings runAction:move];

    
    return buildings;
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

-(void) initSwordSwitch
{
    SKSpriteNode *swordSwitch = [SKSpriteNode spriteNodeWithImageNamed:@"sword_switch.png"];
    swordSwitch.texture.filteringMode = SKTextureFilteringLinear;
    swordSwitch.zPosition = 1100;
    swordSwitch.name = @"swordSwitch";
    swordSwitch.position = CGPointMake(CGRectGetMinX(_receiver.frame) + swordSwitch.size.width/2 + 5,
                                       CGRectGetMaxY(_receiver.frame) - swordSwitch.size.height/2 - 5);
    [_receiver addChild:swordSwitch];
}

+(SKSpriteNode *) createCloud
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
//    Platform *floor = [Platform getLongPlatform];
    
    Platform *floor = [Platform spawn];
    floor.heightAboveAbyss = 17;
    
    int i = 0;
    
    SKSpriteNode *last = floor.parts[0];
    for (SKSpriteNode *current in floor.parts)
    {
        
        current.position = CGPointMake(CGRectGetMinX(_receiver.frame) +
                                       current.size.width/2 +
                                       last.size.width +
                                       (i-1) * current.size.width, floor.heightAboveAbyss);
        [_receiver addChild:current];
        i++;
    }
    [_receiver.platforms addObject:floor];
}


-(void) initPlatform
{
    Platform *floor = [Platform spawn];
    Platform *lastPlatform = [_receiver.platforms lastObject];
    floor.heightAboveAbyss = lastPlatform.heightAboveAbyss + ([Constants randomFloat] - 0.5) * HEIGHT_VARIABILITY;
    
    while (floor.heightAboveAbyss <= CGRectGetMinY(_receiver.frame) ||
           floor.heightAboveAbyss >= CGRectGetMaxY(_receiver.frame) - 30)
    {
        floor.heightAboveAbyss = lastPlatform.heightAboveAbyss + ([Constants randomFloat] - 0.5) * HEIGHT_VARIABILITY;
    }
    
    SKSpriteNode *current;
    SKSpriteNode *last = floor.parts[0];
    for (int i = 0; i < floor.length; i++)
    {
        current = floor.parts[i];
        current.position = CGPointMake(CGRectGetMaxX(_receiver.frame) +
                                       current.size.width/2 +
                                       last.size.width +
                                       (i-1) * current.size.width,
                                       floor.heightAboveAbyss);
        [current runAction:floor.moveLeft];
        [_receiver addChild:current];
    }
    [_receiver.platforms addObject:floor];
}


-(void) createLandscape : (int) shift
{
    SKSpriteNode *buildings = [SpriteFactory createFarBackground];
    buildings.position = CGPointMake(CGRectGetMidX(_receiver.frame)+shift, CGRectGetMinY(_receiver.frame)+50);
    [_receiver addChild:buildings];
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
