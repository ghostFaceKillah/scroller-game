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
    self.physicsWorld.gravity = CGVectorMake(0, -12);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [UIColor colorWithRed:81/255.0f green:228/255.0f blue:255/255.0f alpha:1.0f];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // create floor node
    SKSpriteNode *floor = [self createFloorSprite];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+10);
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
    _monster.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+20);
    _monster.texture.filteringMode = SKTextureFilteringNearest;
    _monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monster.size];
    _monster.physicsBody.dynamic = NO;
    _monster.physicsBody.mass = 1;
    _monster.physicsBody.restitution = 0;
    _monster.physicsBody.categoryBitMask = monsterCategory;
    _monster.physicsBody.contactTestBitMask = heroCategory;
    _monster.physicsBody.collisionBitMask = heroCategory;

    [self addChild:_monster];
    
    // move monster node
    SKAction * actionMove = [SKAction moveTo:CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+20) duration:2];
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
    floor.physicsBody.categoryBitMask = floorCategory;
    floor.physicsBody.contactTestBitMask = heroCategory;
    floor.physicsBody.collisionBitMask = heroCategory;
    
    // floor animation
    SKAction *animation = [SKAction animateWithTextures:floorTextures timePerFrame: 0.2];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [floor runAction:animate];
    
    return floor;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if (location.x >= CGRectGetMidX(self.frame)) {
      [_hero heroDash:_hero.sprite];
    } else {
      [_hero heroJump:_hero.sprite];
    }

}

int signum(int n) { return (n < 0) ? -1 : (n > 0) ? +1 : 0; }

- (void)didSimulatePhysics {
    
    // see if we need to correct hero's x due to collisions or dash
    if (_hero.isDashing)
    {
        // if hero is dashing use spring equation
        // imagine a spring holding our hero's back
        // the other side is attached to vertical line where hero should belong
        // quick physics refresher: spring equation is F = -(1/2) * x * k
        // where F is spring's elastic force, x is displacement and k is elasticity coefficient
        if (_hero.sprite.position.x != CGRectGetMinX(self.frame)+20) {
            CGFloat delta = _hero.sprite.position.x - CGRectGetMinX(self.frame)-20;
            CGFloat k =  0.03;
            CGVector old_v = _hero.sprite.physicsBody.velocity;
            _hero.sprite.physicsBody.velocity = CGVectorMake(old_v.dx-signum(delta)*k*delta*delta, old_v.dy);
        }
        
    } else
    {
        // if hero is not dashing return to place linearly speeding up world
        if (_hero.sprite.position.x != CGRectGetMinX(self.frame)+20) {
            CGFloat delta = _hero.sprite.position.x - CGRectGetMinX(self.frame)-20;
            CGVector old_v = _hero.sprite.physicsBody.velocity;
            CGFloat speedup = 5;
            _hero.sprite.physicsBody.velocity = CGVectorMake(-signum(delta)*speedup*MIN(100,abs(delta)), old_v.dy);
        }
    }
    
    [_hero updateDashingState];
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & heroCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        if ([_hero isDashing])
        {
            [secondBody.node removeFromParent];
        } else
        {
            [_hero.sprite removeFromParent];
        }
    }
}


@end
