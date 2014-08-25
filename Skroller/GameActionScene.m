//
//  GameActionScene.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameActionScene.h"
#import "Goblin.h"
#import "Hero.h"
#import "Constants.h"
#import "SpriteFactory.h"
#import "Birdie.h"
#import "Hightower.h"
#import "Bomb.h"
#import "TowerLowerPart.h"
#import "TowerUpperPart.h"
#import "Baloon.h"

@interface GameActionScene ()

// just state variables
@property BOOL contentCreated;
@property BOOL heroIsDashing;
@property BOOL shouldSpawnMonsters;
@property NSString *mode;

// structs for holding all the sprites
@property Hero* hero;
@property SKSpriteNode *floor;
@property NSMutableDictionary *monsters;
@property NSMutableSet *clouds;
@property NSMutableArray *monstersToBeGarbaged;
@property SKSpriteNode *menu;
@property SKSpriteNode *menuHolder;
@property SKSpriteNode *gameOverMenuHolder;

// for accounting if game is in dashing state and for monster spawnining
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceLastDash;

// speedup due to dashing etc.
@property CGFloat worldSpeedup;

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


-(BOOL) spawnTest:(CFTimeInterval) timeElapsed
{
    // check if we should spawn a monster
    // probability of spawning a monster instantly rises linearly
    double valueToCross = (1 - 0.65 * timeElapsed);
    double randomResult = [Constants randomFloat];
    return (randomResult >= valueToCross);
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    // check once in a while if we would like to spawn a monster
    self.lastSpawnTimeInterval += timeSinceLast;
    if (((int)(60*self.lastSpawnTimeInterval) % 10 == 0))
    {
        if ([self spawnTest:self.lastSpawnTimeInterval])
        {
            self.lastSpawnTimeInterval = 0;
            if (_shouldSpawnMonsters)
            {
//                CGFloat temp = [Constants randomFloat];
//                
//                if (temp < 0.4)
//                {
//                    [self addGoblin];
//                } else if (temp < 0.5)
//                {
//                    [self addBirdie];
//                } else if (temp < 0.6)
//                {
//                    [self addHightower];
//                } else if (temp <0.7)
//                {
//                    [self addBomb];
//                } else if (temp < 0.8)
//                {
//                    [self addTwoPartTower];
//                } else if (temp < 0.9)
//                {
//                    [self addBaloon];
//                }
            }
            SKSpriteNode *cloudey = [SpriteFactory createCloud];
            cloudey.position = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)-50);
            if ([Constants randomFloat] > 0.5)
            {
                [self addChild:cloudey];
            }
        }
    }
}

-(void) addBaloon
{
    Baloon *monster = [Baloon spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMaxY(self.frame)-20);
    monster.sprite.name = [GameActionScene generateRandomString:10];
    
    // and add it to the data structures
    [self addChild:monster.sprite];
    [_monsters setObject:monster forKey:monster.sprite.name];
}

-(void) addTwoPartTower
{
    TowerLowerPart *monster = [TowerLowerPart spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+50);
    monster.sprite.name = [GameActionScene generateRandomString:10];
    
    TowerUpperPart *attacker = [TowerUpperPart spawn];
    attacker.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame) + 90);
    attacker.sprite.name = [GameActionScene generateRandomString:10];
    
    // and add it to the data structures
    [self addChild:monster.sprite];
    [self addChild:attacker.sprite];
    [_monsters setObject:monster forKey:monster.sprite.name];
    [_monsters setObject:attacker forKey:attacker.sprite.name];
}

-(void) addBomb
{
    Bomb *monster = [Bomb spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+50);
    monster.sprite.name = [GameActionScene generateRandomString:10];
    
    // and add it to the data structures
    [self addChild:monster.sprite];
    [_monsters setObject:monster forKey:monster.sprite.name];
}

-(void) addHightower
{
    Hightower *monster = [Hightower spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+50);
    monster.sprite.name = [GameActionScene generateRandomString:10];
    
    // and add it to the data structures
    [self addChild:monster.sprite];
    [_monsters setObject:monster forKey:monster.sprite.name];
}

-(void) addBirdie
{
    // wrapper for adding a monster birdie to the scene
    
    Birdie *birdie = [Birdie spawn: _hero];
    birdie.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMaxY(self.frame)-10);
    birdie.sprite.name = [GameActionScene generateRandomString:10];
    
    [self addChild:birdie.sprite];
    [_monsters setObject:birdie forKey:birdie.sprite.name];
}

-(void) addGoblin
{
    // a wrapper for handling all the monster data structures
    // create monster node
    Goblin *monster = [Goblin spawn];
    monster.sprite.position = CGPointMake(CGRectGetMaxX(self.frame)-20, CGRectGetMinY(self.frame)+50);
    monster.sprite.name = [GameActionScene generateRandomString:10];
    
    // and add it to the data structures
    [self addChild:monster.sprite];
    [_monsters setObject:monster forKey:monster.sprite.name];
}

- (void)update:(NSTimeInterval)currentTime
{
    // Handle time delta.
    // If we drop below 60fps, we would still like things to happen
    // at approximately the same rate
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    _timeSinceLastDash += timeSinceLast;
    if (timeSinceLast > 1)
    {
        // more than a second since last update
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
    _mode = @"startMenu";
    
    // create strcutures to hold monster data
    _monsters = [NSMutableDictionary dictionaryWithCapacity:10];
    _monstersToBeGarbaged = [NSMutableArray arrayWithCapacity:10];
    
    [self initLandscape];
    [self initFloor];
    [self makeCloud];
    [self makeHero];
    [self initStartMenu];
    [self initGameOverMenu];
}

-(void) initFloor
{
    _floor = [SpriteFactory createFloorSprite];
    _floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+10);
    [self addChild:_floor];
}


-(void) initLandscape
{
    SKSpriteNode *mountains = [SpriteFactory createMountains];
    mountains.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+20);
    [self addChild:mountains];
}


-(void) makeCloud
{
    SKSpriteNode *cloud = [SpriteFactory createCloud];
    [self addChild:cloud];
    cloud.position = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)-50);
}


-(void) makeHero
{
    _hero = [Hero createHero];
    _hero.sprite.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMinY(self.frame)+135);
    [self addChild:_hero.sprite];
}


-(void) initStartMenu
{
    SKSpriteNode *menuHolder = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(200, 10)];
    menuHolder.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    menuHolder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:menuHolder.size];
    menuHolder.physicsBody.dynamic = FALSE;
    [self addChild:menuHolder];
    SKSpriteNode *menu = [SpriteFactory createStartMenu];
    menu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:menu];
    [menu.physicsBody applyImpulse:CGVectorMake(2, 0)];
    _menuHolder = menuHolder;
    SKPhysicsJointLimit *menuLink = [SKPhysicsJointLimit jointWithBodyA:menuHolder.physicsBody bodyB:menu.physicsBody anchorA:menuHolder.position anchorB:menu.position];
    [self.physicsWorld addJoint:menuLink];
}


-(void) initGameOverMenu
{
    _gameOverMenuHolder = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(200, 10)];
    _gameOverMenuHolder.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    _gameOverMenuHolder.physicsBody =
    _gameOverMenuHolder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gameOverMenuHolder.size];
    _gameOverMenuHolder.physicsBody.dynamic = FALSE;
    [self addChild:_gameOverMenuHolder];
    SKSpriteNode *gameOverMenu = [SpriteFactory createGameOverMenu];
    gameOverMenu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:gameOverMenu];
    SKPhysicsJointLimit *gameOverMenuLink = [SKPhysicsJointLimit jointWithBodyA:_gameOverMenuHolder.physicsBody bodyB:gameOverMenu.physicsBody anchorA:_gameOverMenuHolder.position anchorB:gameOverMenu.position];
    [self.physicsWorld addJoint:gameOverMenuLink];
    _gameOverMenuHolder.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)+200);
}


+(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++)
    {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // handle menu mode and game mode touch events
    if ([_mode isEqualToString:@"startMenu"])
    {
        for (UITouch *touch in touches)
        {
            SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
            if ([n.name isEqual:@"start"])
            {
                // start game
                NSLog(@"%@", @"start touched");
                _mode = @"gameplay";
                // move menu up
                SKAction *moveUp = [SKAction moveToY:500 duration:0.5];
                [_menuHolder runAction:moveUp];
                // start spawning monsters
                _shouldSpawnMonsters = TRUE;
            }
        }
    } else if ([_mode isEqualToString:@"gameplay"])
    {
        // if left half is touched ->  jump
        // if right half is touched -> dash
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        if (location.x >= CGRectGetMidX(self.frame))
        {
        [_hero heroDash:_hero.sprite];
            _timeSinceLastDash = 0;
        } else
        {
          [_hero heroJump:_hero.sprite];
        }
    } else if ([_mode isEqualToString:@"gameOver"])
    {
        for (UITouch *touch in touches)
        {
            SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
            if ([n.name isEqual:@"tryAgain"])
            {
                // restart game
                _mode = @"gameplay";
                // recreate hero
                _hero = [Hero createHero];
                _hero.sprite.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMinY(self.frame)+135);
                [self addChild:_hero.sprite];
                // move menu up
                SKAction *moveUp = [SKAction moveToY:500 duration:0.5];
                [_gameOverMenuHolder runAction:moveUp];
                // start spawning monsters
                _shouldSpawnMonsters = TRUE;
            }
        }
    }

}


int signum(int n)
{
    return (n < 0) ? -1 : (n > 0) ? +1 : 0;
}

-(void)resolveHeroMovement
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
            if (_heroIsDashing)
            {
                _hero.sprite.physicsBody.velocity = CGVectorMake(old_v.dx-signum(delta)*k*delta*delta, MAX(0, old_v.dy) );
            } else
            {
                _hero.sprite.physicsBody.velocity = CGVectorMake(old_v.dx-signum(delta)*k*delta*delta, old_v.dy);
            }
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
}

-(void)updateDashingState
{
    CGFloat dashTime = 0.3;
    CGFloat dashDecayTime = 0.4;
    CGFloat speedCoeff = 750;
    
    if (_timeSinceLastDash <= dashTime)
    {
        _worldSpeedup = -speedCoeff;
        _heroIsDashing = TRUE;
    } else if (_timeSinceLastDash <= dashDecayTime)
    {
        // decay linearly from speed coeff to zero in time from t_0 = dashTime to t_1 = dashDecayTime
        _worldSpeedup =
            -( (speedCoeff/(dashTime-dashDecayTime ))*_timeSinceLastDash + (speedCoeff/(dashDecayTime-dashTime))*dashDecayTime);
        _heroIsDashing = TRUE;
    } else
    {
        _worldSpeedup = 0;
        _heroIsDashing = FALSE;
    }
}


-(void) updateMonstersState
{
    Monster *m;
    for (id key in _monsters)
    {
        m = _monsters[key];
        // garbage collect uneeded monsters
        if ([m isNoLongerNeeded])
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
}


-(void) handleWorldSpeedup
{
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


- (void)didSimulatePhysics
{
    [self resolveHeroMovement];
    [self updateDashingState];
    [self updateMonstersState];
    [self handleWorldSpeedup];
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // just some sample code for resolving collisions, will probably be changed later
    SKPhysicsBody *firstBody, *secondBody;
    // not very nice way to ensure the first guy in collision is hero and the second is monster
    // copied from SKit docs
    // LOL look at this ugly code and it was actually Apple guys who wrote it
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
            // game over code
            [_hero.sprite removeFromParent];
            SKAction *moveDown = [SKAction moveToY:CGRectGetMaxY(self.frame) duration:0.5];
            [_gameOverMenuHolder runAction:moveDown];
            _shouldSpawnMonsters = FALSE;
            _mode = @"gameOver";
            
            Monster *m;
            for (id key in _monsters)
            {
                m = _monsters[key];
                [m.sprite removeFromParent];
            }
            [_monsters removeAllObjects];
        }
    }
    if ((firstBody.categoryBitMask & heroCategory) != 0 &&
        (secondBody.categoryBitMask & floorCategory) != 0)
    {
        [_hero resolveGroundTouch];
    }
    
}


@end
