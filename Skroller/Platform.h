//
//  Platform.h
//  Skroller
//
//  Created by Michał Garmulewicz on 26.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Platform : NSObject
@property SKSpriteNode *sprite;
@property CGFloat gapToNextTile;
@property CGFloat heightAboveAbyss;
+(Platform *) spawn;
-(BOOL) isNoLongerNeeded;
-(void) resolveMovement: (CGFloat) worldVelocity;
@end
