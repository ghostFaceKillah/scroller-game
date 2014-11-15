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
-(void) addGoblin;
-(void) initGameOverMenu;
-(void) initStaticFloor;
-(void)addCloud;
-(void) addHero;
-(void) initStartMenu;
-(void) initPlatform;
-(void) initSwordSwitch;
-(void)addSky;
@end
