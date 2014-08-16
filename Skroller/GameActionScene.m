//
//  GameActionScene.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameActionScene.h"
#import "Monster.h"
#import "Hero.h"


@interface GameActionScene ()
@property BOOL contentCreated;
@property Hero* hero;
@property SKSpriteNode *floor;
@property CGFloat worldSpeedup;
@property NSMutableDictionary *monsters;
@property NSMutableSet *clouds;
@property NSMutableArray *monstersToBeGarbaged;
@property BOOL heroIsDashing;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceLastDash;
@end

@implementation GameActionScene

// to do

// clean code
// cut duration of dash when player hits a monster
// implement menu



static const uint32_t heroCategory     =  0x1 << 0;
static const uint32_t monsterCategory  =  0x1 << 1;
static const uint32_t floorCategory    =  0x1 << 2;

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}


- (float)randomFloat
{
    // draw a random float from [0,1]
    float val = ((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX);
    return val;
}


-(BOOL) spawnTest:(CFTimeInterval) timeElapsed
// we could try to move this code to Monster class
{
    double lambda = 1;
    double valueToCross = lambda * (1 - 0.55*timeElapsed);
    double randomResult = [self randomFloat];
    return (randomResult >= valueToCross);
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
// we could try to move this code to Monster class
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (((int)(60*self.lastSpawnTimeInterval) % 10 == 0))
    {
        if ([self spawnTest:self.lastSpawnTimeInterval])
        {
            self.lastSpawnTimeInterval = 0;
            [self addMonster];
            SKSpriteNode *cloudey = [self createCloud];
            [self addChild:cloudey];
        }
    }
}


- (void)update:(NSTimeInterval)currentTime
{
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    _timeSinceLastDash += timeSinceLast;
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
     _worldSpeedup = 0;
    _heroIsDashing = FALSE;
    
    // create strcutures to hold monster data
    _monsters = [NSMutableDictionary dictionaryWithCapacity:10];
    _monstersToBeGarbaged = [NSMutableArray arrayWithCapacity:10];
    
    // create floor node
    _floor = [self createFloorSprite];
    _floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+10);
    [self addChild: _floor];
    
    // create landscape
    SKSpriteNode *mountains = [self createMountains];
    mountains.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+20);
//    mountains.texture.filteringMode = SKTextureFilteringNearest;
    [self addChild:mountains];
    
    // create smiling cloud
    SKSpriteNode *cloud = [self createCloud];
    [self addChild:cloud];
    
    // create and setup hero node
    _hero = [Hero createHero];
    _hero.sprite.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMinY(self.frame)+135);
    [self addChild:_hero.sprite];
}


+(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}


-(void) addMonster
{
    // create monster node
    Monster *monster = [Monster createGoblin];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+50);
    monster.sprite.name = [GameActionScene generateRandomString:10];
    
    // and add it to data structures
    [self addChild:monster.sprite];
    [_monsters setObject:monster forKey:monster.sprite.name];
}


-(SKSpriteNode *)createMountains
{
    SKSpriteNode *fuji = [SKSpriteNode spriteNodeWithImageNamed:@"mountains_prototype.png"];
    
    
    NSMutableArray *mountainTextures = [NSMutableArray arrayWithCapacity:64];
    
    NSString *filename;
    for (int i = 0; i < 64; ++i)
    {
        if (i <9)
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"mount_move_0", i+1, @".png"];
        } else
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"mount_move_", i+1, @".png"];
        }
        SKTexture *f = [SKTexture textureWithImageNamed:filename];
        f.filteringMode = SKTextureFilteringNearest;
        [mountainTextures addObject:f];
    }
    
    fuji.zPosition = -10;
    
    // mountain animation
    SKAction *animation = [SKAction animateWithTextures:mountainTextures timePerFrame: 0.1];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [fuji runAction:animate];
    
    return fuji;
    
    
}


-(SKSpriteNode *)createCloud
{
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud_prototype.png"];
    cloud.zPosition = -10;
    cloud.name = @"cloud";
    cloud.position = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)-50);
    SKAction *move = [SKAction moveToX:-cloud.size.width duration:2+4*[self randomFloat]];
    SKAction *die = [SKAction removeFromParent];
    [cloud runAction:[SKAction sequence:@[move, die]]];
    return cloud;
}


-(SKSpriteNode *)createFloorSprite
{
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor_move_01.png"];

    // manage floor textures
    NSMutableArray *floorTextures = [NSMutableArray arrayWithCapacity:64];
//    SKTexture *f = [SKTexture textureWithImageNamed:@"floor.png"];
//    SKTexture *f2 = [SKTexture textureWithImageNamed:@"floor_two.png"];
//    [floorTextures addObject:f1];
//    [floorTextures addObject:f2];
    
    
    NSString *filename;
    for (int i = 0; i < 64; ++i)
    {
        if (i <9)
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"floor_move_0", i+1, @".png"];
        } else
        {
            filename = [NSString stringWithFormat:@"%@%d%@", @"floor_move_", i+1, @".png"];
        }
        SKTexture *f = [SKTexture textureWithImageNamed:filename];
        f.filteringMode = SKTextureFilteringNearest;
        [floorTextures addObject:f];
    }
    
    // floor physics
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = false;
    floor.physicsBody.categoryBitMask = floorCategory;
    floor.physicsBody.contactTestBitMask = heroCategory;
    floor.physicsBody.collisionBitMask = heroCategory;
//    
//    floor.zPosition = -10;
//    
//    NSLog(@"%f", floor.zPosition);
    
    // floor animation
    SKAction *animation = [SKAction animateWithTextures:floorTextures timePerFrame: 0.0075];
    SKAction *animate = [SKAction repeatActionForever:animation];
    [floor runAction:animate];
    
    return floor;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if left half is touched ->  jump
    // if right half is touched -> dash
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if (location.x >= CGRectGetMidX(self.frame)) {
    [_hero heroDash:_hero.sprite];
        _timeSinceLastDash = 0;
    } else {
      [_hero heroJump:_hero.sprite];
    }

}


int signum(int n)
{
    return (n < 0) ? -1 : (n > 0) ? +1 : 0;
}


- (void)didSimulatePhysics
{
    if (_hero.sprite.physicsBody.velocity.dx >= 0)
    {
        // if hero is dashing use spring equation
        // imagine a spring holding our hero's back
        // the other side is attached to vertical line where hero should belong
        // quick physics refresher: spring equation is F = -(1/2) * x * k
        // where F is spring's elastic force, x is displacement and k is elasticity coefficient
        if (_hero.sprite.position.x != CGRectGetMinX(self.frame)+20) {
            _worldSpeedup = 0;
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
            CGFloat speedupCoeff = 5;
            _worldSpeedup = -signum(delta)*speedupCoeff*MIN(100,abs(delta));
            _hero.sprite.physicsBody.velocity = CGVectorMake(_worldSpeedup, old_v.dy);
        }
    }
    
    CGFloat dashTime = 0.3;
    CGFloat dashDecayTime = 0.4;
    CGFloat speedCoeff = 750;
 
    if (_timeSinceLastDash <= dashTime)
    {
        _worldSpeedup = -speedCoeff;
        _heroIsDashing = TRUE;
    } else if (_timeSinceLastDash <= dashDecayTime)
    {
        _worldSpeedup = -( (speedCoeff/(dashTime-dashDecayTime ))*_timeSinceLastDash + (speedCoeff/(dashDecayTime-dashTime))*dashDecayTime );
        _heroIsDashing = TRUE;
    } else
    {
        _worldSpeedup = 0;
        _heroIsDashing = FALSE;
    }
    
    Monster *m;
    for (id key in _monsters)
    {
        m = _monsters[key];
        if ([m isNoLongerNeeded]) // to be changed to is Visible because sometimes they will just fall off screen when hit etc
        {
            // delete this monster
            [m.sprite removeFromParent];
            [_monstersToBeGarbaged addObject:m.sprite.name];
        } else
        {
            [m resolveMovement: _worldSpeedup];
        }
    }
    [_monsters removeObjectsForKeys:_monstersToBeGarbaged];
    [_monstersToBeGarbaged removeAllObjects];
    
    _floor.speed = 1 - 0.001666*_worldSpeedup;
    //    NSLog(@"%f", _floor.speed);
    
    
    for (SKSpriteNode *sprite in self.children)
    {
        if ([sprite.name isEqualToString:@"cloud"])
        {
            sprite.speed = 1 - 0.001666*_worldSpeedup;
        }
    }
    
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // just some sample code for resolving collisions, will probably be changed later
    SKPhysicsBody *firstBody, *secondBody;
    // not very nice way to ensure the first guy in collision is hero and the second is monster
    // copied from SKit docs <-> LOL look at this ugly code and it was actually Apple guys who wrote it
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
    if ((firstBody.categoryBitMask & heroCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        if (_heroIsDashing)
        {
         //   [secondBody.node removeFromParent];
            Monster *m = _monsters[secondBody.node.name];
            [m resolveHit];
            _timeSinceLastDash += 10;
        } else
        {
            [_hero.sprite removeFromParent];
            // game over code
        }
    }
    if ((firstBody.categoryBitMask & heroCategory) != 0 &&
        (secondBody.categoryBitMask & floorCategory) != 0)
    {
        [_hero resolveGroundTouch];
    }
    
}

@end
