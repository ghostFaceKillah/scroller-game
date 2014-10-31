//
//  Goblin.h
//  Skroller
//
//  Created by Michał Garmulewicz on 21.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Monster.h"

@interface Goblin : Monster
@property SKSpriteNode *sprite;
@property NSString *monsterName;
+(Goblin *) spawn;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement: (CGFloat) worldVelocity;
-(void) resolveHit;
+(void) preloadTextures;
+(NSMutableArray *) getSpawnTextures;
+(NSMutableArray *) getMoveTextures;
@end
