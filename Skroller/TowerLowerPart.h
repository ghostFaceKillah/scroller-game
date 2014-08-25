//
//  TowerLowerPart.h
//  Skroller
//
//  Created by Michał Garmulewicz on 24.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Monster.h"
#import "Hero.h"

@interface TowerLowerPart : Monster
@property SKSpriteNode *sprite;
@property NSString *monsterName;
+(TowerLowerPart *) spawn;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement: (CGFloat) worldVelocity;
-(void) resolveHit;
@end


