//
//  Hero.h
//  Skroller
//
//  Created by MacbookPro on 15.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Hero : NSObject
@property SKSpriteNode * sprite;
+(Hero *)createHero;
+(void)animateSprite :(SKSpriteNode *)sprite :(NSArray *)arrayOfTextures :(NSTimeInterval )time;
-(void)heroJump : (SKSpriteNode *)hero;
-(void)heroDash: (SKSpriteNode *) heroSprite;
-(BOOL)isDashing;
-(void)updateDashingState;
@end
