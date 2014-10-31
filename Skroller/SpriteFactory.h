//
//  SpriteFactory.h
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GameActionScene.h"

@interface SpriteFactory : NSObject
+(SpriteFactory *) createSpriteFactory: (GameActionScene *) receiver;
+(void) animateSprite :(SKSpriteNode *)sprite :(NSMutableArray *)arrayOfTextures :(NSTimeInterval )time;
+(SKSpriteNode *) createCloud;
-(void) addGoblin;-(void) initGameOverMenu;
-(void) createLandscape : (int) shift;
-(void) initStaticFloor;
-(void) makeCloud;
-(void) makeHero;
-(void) initStartMenu;
-(void) initPlatform;
-(void) initSwordSwitch;
-(void) initSky;
@end
