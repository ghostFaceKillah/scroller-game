//
//  GameActionScene.h
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@class Hero;

@interface GameActionScene : SKScene <SKPhysicsContactDelegate>
@property NSMutableDictionary *monsters;
@property SKSpriteNode *gameOverMenu;
@property NSMutableArray *platforms;
@property SKSpriteNode *startMenu;
@property SKSpriteNode *floor;
@property NSMutableArray *arrows;
@property Hero* hero;
-(CGFloat) getLastTileFloorHeight;
@end
