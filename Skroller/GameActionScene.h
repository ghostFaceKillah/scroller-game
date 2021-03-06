//
//  GameActionScene.h
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVAudioPlayer.h>


@class Hero;

@interface GameActionScene : SKScene <SKPhysicsContactDelegate>
@property NSMutableArray *monsters;
@property SKSpriteNode *gameOverMenu;
@property NSMutableArray *platforms;
@property SKSpriteNode *startMenu;
@property SKSpriteNode *floor;
@property NSMutableArray *arrows;
@property (nonatomic) NSInteger dist;
@property Hero* hero;
@property dispatch_queue_t queue;
-(CGFloat) getLastTileFloorHeight;
@end
