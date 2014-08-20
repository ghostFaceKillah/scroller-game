//
//  SpriteFactory.h
//  Skroller
//
//  Created by Michał Garmulewicz on 19.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SpriteFactory : NSObject
+(SKSpriteNode *)createMountains;
+(SKSpriteNode *)createStartMenu;
+(SKSpriteNode *) createGameOverMenu;
+(SKSpriteNode *)createCloud;
+(SKSpriteNode *)createFloorSprite;
@end
