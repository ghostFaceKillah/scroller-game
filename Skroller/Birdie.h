//
//  Birdie.h
//  Skroller
//
//  Created by Michał Garmulewicz on 21.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Monster.h"
#import "Hero.h"

@interface Birdie : Monster
@property SKSpriteNode *sprite;
@property NSString *monsterName;
+(Birdie *) spawn: (Hero*) hero;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement: (CGFloat) worldVelocity;
-(void) resolveHit;
@end
