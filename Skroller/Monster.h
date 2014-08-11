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
+(Monster *)createGoblin;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement;
-(void) resolveHit;
@end
