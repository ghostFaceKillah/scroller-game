//
//  Monster.h
//  Skroller
//
//  Created by Michał Garmulewicz on 10.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Monster : NSObject
@property SKSpriteNode *sprite;
@property NSString *monsterName;
+(Monster *) spawn;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement: (CGFloat) worldVelocity;
-(void) resolveHit;
@end