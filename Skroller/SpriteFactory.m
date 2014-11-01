//
//  SpriteFactory.m
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "SpriteFactory.h"
#import "Constants.h"
#import "Goblin.h"
#import "Hero.h"
#import "Platform.h"
#import "GarbageCollctor.h"

@interface SpriteFactory()
@property GameActionScene *receiver;
@end

@implementation SpriteFactory

const CGFloat HEIGHT_VARIABILITY = 100;

+(SpriteFactory *) createSpriteFactory: (GameActionScene *) receiver;
{
    // running away from standard obj-c constructor
    SpriteFactory *factory = [[SpriteFactory alloc] init];
    factory.receiver = receiver;
    return factory;
}

-(void) addGoblin
{
    // a wrapper for handling all the monster data structures
    // create monster node
    Goblin *monster = [Goblin spawn];
    CGFloat y_position = [_receiver getLastTileFloorHeight] + monster.sprite.size.height/2;
    monster.sprite.position = CGPointMake(CGRectGetMaxX(_receiver.frame)-20, y_position+100);
    
    // and add it to the data structures
    [_receiver addChild:monster.sprite];
    [_receiver.monsters addObject:monster];
}

-(void) addSky
{
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithImageNamed:@"sky.png"];
    sky.zPosition = -100;
    sky.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMidY(_receiver.frame));
    [_receiver addChild:sky];
}

-(void) initGameOverMenu
{
    SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:@"game_over_menu_placeholder.png"];
    menu.name = @"gameOverMenu";
    menu.zPosition = 1100;
    menu.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMaxY(_receiver.frame) + menu.size.height/2);
    SKSpriteNode *tryAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"try_again_button_placeholder.png"];
    [menu addChild:tryAgainButton];
    tryAgainButton.position = CGPointMake(4, 40);
    tryAgainButton.name = @"tryAgain";
    tryAgainButton.zPosition = 1110;
    [_receiver addChild:menu];
    _receiver.gameOverMenu = menu;
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

-(void) addCloud
{
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud_prototype.png"];
    cloud.zPosition = -10;
    cloud.name = @"cloud";
    SKAction *move = [SKAction moveToX:-cloud.size.width duration:2+4*[Constants randomFloat]];
    SKAction *die =  [SKAction runBlock:^{
        [GarbageCollctor cleanObject:cloud];
    }];
    [_receiver addChild:cloud];
    cloud.position = CGPointMake(CGRectGetMaxX(_receiver.frame), CGRectGetMaxY(_receiver.frame)-50);
    [cloud runAction:[SKAction sequence:@[move, die]]];
}


-(void) initStaticFloor
{
    SKNode *floor = [Platform spawn];
    CGFloat heightAboveAbyss = 17;
    int i = 0;
    SKSpriteNode *middle = floor.children[1];
    SKSpriteNode *first = floor.children[0];
    for (SKSpriteNode *current in floor.children)
    {
        current.position = CGPointMake(CGRectGetMinX(_receiver.frame) +
                                       current.size.width/2 +
                                       first.size.width +
                                       (i-1) * middle.size.width,
                                       heightAboveAbyss);
        current.name = @"platform";
        i++;
    }
    [_receiver addChild:floor];
    [_receiver.platforms addObject:floor];
}


-(void) initPlatform
{
    SKNode *floor = [Platform spawn];
    SKNode *lastPlatform = [_receiver.platforms lastObject];
    NSNumber *temp = [lastPlatform.userData objectForKey:@"heightAboveAbyss"];
    CGFloat lp_h = [temp floatValue];
    CGFloat floor_h = lp_h + ([Constants randomFloat] - 0.5) * HEIGHT_VARIABILITY;
    while (floor_h <= CGRectGetMinY(_receiver.frame) ||
           floor_h >= CGRectGetMaxY(_receiver.frame) - 30) {
        floor_h = lp_h + ([Constants randomFloat] - 0.5) * HEIGHT_VARIABILITY;
    }
    [floor.userData setValue:[NSNumber numberWithFloat:floor_h] forKey:@"heightAboveAbyss"];
    SKSpriteNode *middle = floor.children[1];
    SKSpriteNode *first = floor.children[0];
    SKAction *moveLeft = [floor.userData objectForKey:@"moveLeft"];
    int i = 0;
    for (SKSpriteNode *current in floor.children)
    {
        current.position = CGPointMake(CGRectGetMaxX(_receiver.frame) +
                                       current.size.width/2 +
                                       first.size.width +
                                       (i-1) * middle.size.width,
                                       floor_h);
        [current runAction:moveLeft];
        current.name = @"platform";
        i++;
    }
    [_receiver addChild:floor];
    [_receiver.platforms addObject:floor];
}


-(void) addHero
{
    _receiver.hero = [Hero createHero];
    _receiver.hero.sprite.position = CGPointMake(CGRectGetMinX(_receiver.frame)+20, CGRectGetMinY(_receiver.frame)+135);
    [_receiver addChild:_receiver.hero.sprite];
}


-(void) initStartMenu
{
    SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:@"menu_placeholder.png"];
    menu.zPosition = 1100;
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start_button_placeholder.png"];
    [menu addChild:startButton];
    startButton.position = CGPointMake(4, 40);
    startButton.name = @"start";
    startButton.zPosition = 1100;
    [_receiver addChild:menu];
    menu.position = CGPointMake(CGRectGetMidX(_receiver.frame), CGRectGetMidY(_receiver.frame));
    _receiver.startMenu = menu;
}

@end
