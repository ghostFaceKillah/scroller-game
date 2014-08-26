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
+(SKSpriteNode *) createMountains;
+(SKSpriteNode *) createStartMenu;
+(SKSpriteNode *) createGameOverMenu;
+(SKSpriteNode *) createCloud;
-(void) addBaloon;
-(void) addBomb;
-(void) addBirdie;
-(void) addGoblin;
-(void) addHightower;
-(void) addTwoPartTower;
-(void) initGameOverMenu;
-(void) initLandscape;
-(void) initStaticFloor;
-(void) makeCloud;
-(void) makeHero;
-(void) initStartMenu;
-(void) initPlatform;
@end
