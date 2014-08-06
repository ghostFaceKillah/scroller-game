//
//  GameActionScene.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameActionScene.h"
#import "Hero.h"

@interface GameActionScene ()
@property BOOL contentCreated;
@property Hero* hero;
@property SKSpriteNode* monster;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end

@implementation GameActionScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addMonster];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

- (void)createSceneContents
{
    // General scene setup
    self.physicsWorld.gravity = CGVectorMake(0, -7);
    self.backgroundColor = [UIColor colorWithRed:81/255.0f green:228/255.0f blue:255/255.0f alpha:1.0f];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // create floor node
    SKSpriteNode *floor = [self createFloorSprite];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+30);
    [self addChild: floor];
    
    // create and setup hero node
    _hero = [Hero createHero];
    _hero.sprite.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMinY(self.frame)+135);
    [self addChild:_hero.sprite];
}

-(void) addMonster
{
    // create monster node
    _monster = [SKSpriteNode spriteNodeWithImageNamed:@"monster.png"];
    _monster.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+50);
    _monster.texture.filteringMode = SKTextureFilteringNearest;
    _monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monster.size];
    _monster.physicsBody.dynamic = NO;
    _monster.physicsBody.mass = 1;
    _monster.physicsBody.restitution = 0;
    [self addChild:_monster];
    
    // move monster node
    SKAction * actionMove = [SKAction moveTo:CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+50) duration:2];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [_monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

-(SKSpriteNode *)createFloorSprite
{
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor.png"];

    // manage floor textures
    NSMutableArray *floorTextures = [NSMutableArray arrayWithCapacity:2];
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"floor.png"];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"floor_two.png"];
    [floorTextures addObject:f1];
    [floorTextures addObject:f2];
    
    // floor physics
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = false;
    
    // floor animation
    SKAction *animation = [SKAction animateWithTextures:floorTextures timePerFrame: 0.2];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [floor runAction:animate];
    
    return floor;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_hero heroJump:_hero.sprite];
}

@end
