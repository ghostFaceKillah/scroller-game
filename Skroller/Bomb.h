//
//  Bomb.h
//  Skroller
//
//  Created by Michał Garmulewicz on 23.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Monster.h"

@interface Bomb : Monster
@property SKSpriteNode *sprite;
@property NSString *monsterName;
+(Bomb *) spawn;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement: (CGFloat) worldVelocity;
-(void) resolveHit;
@end
