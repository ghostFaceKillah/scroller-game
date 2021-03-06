//
//  Hero.h
//  Skroller
//
//  Created by MacbookPro on 15.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameActionScene.h"

@interface Hero : NSObject
@property SKSpriteNode * sprite;
+(Hero *)createHero;
-(void) heroJump;
-(void) heroDash: (SKSpriteNode *) heroSprite;
-(void) resolveGroundTouch;
-(void) shootBow: (SKSpriteNode *) heroSprite :(CGPoint) targetLocation : (GameActionScene *) caller;
@end
