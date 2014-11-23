//
//  GameActionScene.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "GameActionScene.h"
#import "GarbageCollctor.h"
#import "Constants.h"
#import "SpriteFactory.h"
#import "Monster.h"
#import "Platform.h"
#import "Hero.h"
#import "GameData.h"
#import "Goblin.h"

@interface GameActionScene ()
// factory of sprites for our game
@property SpriteFactory *factory;

// just state variables
@property BOOL contentCreated;
@property BOOL heroIsDashing;
@property BOOL shouldSpawnMonsters;
@property NSString *mode;

// heroines are using sword or bow?
@property BOOL swordActive;

// structs for holding all the sprites
@property NSMutableArray *arrowsToBeGarbaged;

// for accounting if game is in dashing state and for monster spawnining
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceLastDash;

// for platforming and background accounting
@property (nonatomic) NSTimeInterval lastPlatformSpawnInterval;
@property (nonatomic) NSTimeInterval lastBackgroundSpawnInterval;

// speedup due to dashing etc.
@property CGFloat worldSpeedup;

// soundtrack
// @property SKAction *soundtrack;
@property AVAudioPlayer *player;


@end


@implementation GameActionScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
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
    self.lastPlatformSpawnInterval += timeSinceLast;
    self.lastBackgroundSpawnInterval += timeSinceLast;
    
    if (((int)(60*self.lastSpawnTimeInterval) % 10 == 0))
    {
        if ([self spawnTest:self.lastSpawnTimeInterval])
        {
            self.lastSpawnTimeInterval = 0;
            if (_shouldSpawnMonsters)
            {
                dispatch_sync(_queue, ^{
                    [_factory addGoblin];
                });
            }
            if ([Constants randomFloat] > 0.5)
            {
                dispatch_sync(_queue, ^{
                    [_factory addCloud];
                });
            }
        }
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    
    // Handle time delta.
    // If we drop below 60fps, we would still like things to happen
    // at approximately the same rate
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    _timeSinceLastDash += timeSinceLast;
    
    //progress tracker update
    static NSTimeInterval _lastCurrentTime = 0;
    if ((currentTime-_lastCurrentTime>1) && ([_mode isEqualToString:@"gameplay"])) {
        [GameData sharedGameData].distance++;
        [GameData sharedGameData].totalDistance++;
        _distance.text = [NSString stringWithFormat:@"Time survived: %i seconds", [GameData sharedGameData].distance];
        _lastCurrentTime = currentTime;
    }
    
    if (timeSinceLast > 1) {
        // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    if (![_mode isEqualToString:@"gameOver"])
        [self resolveHeroMovement];
    if (![_mode isEqualToString:@"gameOver"])
        [self updateDashingState];
    [self updateMonstersState];
    [self handleWorldSpeedup];
    [self handlePlatforming];
    [self garbageCollectArrows];
}


- (void)createSceneContents
{
    
    self.queue = dispatch_queue_create("garbage_collecting", NULL);
    
    // General scene setup
    self.physicsWorld.gravity = CGVectorMake(0, -12);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [UIColor colorWithRed:193/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f];
    self.scaleMode = SKSceneScaleModeAspectFit;
     _worldSpeedup = 0;
    _heroIsDashing = FALSE;
    _mode = @"startMenu";
    _factory = [SpriteFactory createSpriteFactory:self];
    _swordActive = TRUE;
    
        // create soundtrack
    NSError *error;
    NSString *pathForFile = [[NSBundle mainBundle] pathForResource:@"sound_placeholder" ofType:@"wav"];
    NSURL *soundFile = [[NSURL alloc] initFileURLWithPath:pathForFile];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    [_player prepareToPlay];
    
    // create strcutures to hold monster data
    _monsters = [NSMutableArray arrayWithCapacity:10];
    _lastPlatformSpawnInterval = 0;

    //create structures to hold landscape data
    _platforms = [NSMutableArray arrayWithCapacity:10];
    _arrows = [NSMutableArray array];
    _arrowsToBeGarbaged = [NSMutableArray array];

    [_factory addSky];
    [_factory initStaticFloor];
    [_factory addCloud];
    [_factory addHero];
    [_factory initStartMenu];
    [_factory initGameOverMenu];
    [_factory initSwordSwitch];
    [Goblin preloadTextures];
}

-(void) runCountdown {
    SKSpriteNode *three = [SKSpriteNode spriteNodeWithImageNamed:@"countdown_3.png"];
    three.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    SKSpriteNode *two = [SKSpriteNode spriteNodeWithImageNamed:@"countdown_2.png"];
    two.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    SKSpriteNode *one = [SKSpriteNode spriteNodeWithImageNamed:@"countdown_1.png"];
    one.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:three];
    [self addChild:two];
    [self addChild:one];
    SKAction *hide = [SKAction hide];
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *unhide = [SKAction unhide];
    SKAction *sequence = [SKAction sequence:@[hide, wait, unhide, wait, hide]];
    SKAction *sequence2 = [SKAction sequence:@[hide, wait, wait, unhide, wait, hide]];
    SKAction *sequence3 = [SKAction sequence:@[hide, wait, wait, wait, unhide, wait, hide]];
    [three runAction:sequence];
    [two runAction:sequence2];
    [one runAction:sequence3];
}

-(void) startInitializedGame
{
//    [self runCountdown];
    _mode = @"gameplay";
    // move menu up
    SKAction *moveUp = [SKAction moveToY:CGRectGetMaxY(self.frame)+_startMenu.size.width/2 duration:1];
    [_startMenu runAction:moveUp];
    // setup HUD
    [self setupHUD];
    // start spawning monsters
    _shouldSpawnMonsters = TRUE;
    // start platforming move
    _highScore.text = [NSString stringWithFormat:@"Highscore: %li pt", (long)[GameData sharedGameData].highScore];
    //_score.text = @"0 pt";
    _distance.text = @"";
    SKNode *platform = [_platforms lastObject];
    SKAction *moveLeft = [platform.userData objectForKey:@"moveLeft"];
    for (SKNode *p in _platforms) {
        for (SKSpriteNode *current in p.children) {
            [current runAction:moveLeft];
        }
    }
    // [_player play];
}

-(void) restartGameAfterGameover
{
    dispatch_sync(_queue, ^{
        // clean up old assets
        for (Monster *m in _monsters) {
            [GarbageCollctor cleanObject: m.sprite];
        }
        [_monsters removeAllObjects];
        for (SKNode *p in _platforms) {
            [GarbageCollctor cleanObject: p];
        }
        for (SKNode *platform in _platforms) {
            [GarbageCollctor cleanObject:platform];
        }
        [_platforms removeAllObjects];
 
        // remake assets
        [_factory initStaticFloor];
        [_factory addHero];
        // restart game
        _mode = @"gameplay";
        SKAction *moveUp = [SKAction moveToY:CGRectGetMaxY(self.frame)+_gameOverMenu.size.height/2 duration:0.5];
        [_gameOverMenu runAction:moveUp];
        //reset progress tracker
        [GameData sharedGameData].highScore = MAX([GameData sharedGameData].distance, [GameData sharedGameData].highScore);
        [[GameData sharedGameData] reset];
        // start spawning monsters
        _shouldSpawnMonsters = TRUE;
        SKNode *platform = [_platforms lastObject];
        SKAction *moveLeft = [platform.userData objectForKey:@"moveLeft"];
        for (SKNode *p in _platforms) {
            for (SKSpriteNode *current in p.children) {
                [current runAction:moveLeft];
            }
        }
    });
        

}

-(void) endGame
{
    // game over code
    _mode = @"gameOver";
    dispatch_sync(_queue, ^{
        [GarbageCollctor cleanObject: _hero.sprite];
    });
    SKAction *moveDown = [SKAction moveToY:CGRectGetMidY(self.frame) duration:0.25];
    [_gameOverMenu runAction:moveDown];
    SKLabelNode *score = (SKLabelNode*)[_gameOverMenu childNodeWithName:@"score"];
    NSString *distance = [NSString stringWithFormat:@"You've been running for %li seconds", (long)[GameData sharedGameData].distance];
    score.text = distance;
    _shouldSpawnMonsters = FALSE;
    _worldSpeedup = (CGFloat) 500;
//    [_player stop];
//    _player.currentTime = 0;
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
                [self startInitializedGame];
            }
        }
    } else if ([_mode isEqualToString:@"gameplay"])
    {
        BOOL switchTouched = FALSE;
        for (UITouch *touch in touches)
        {
            SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
            if ([n.name isEqual:@"swordSwitch"])
            {
                // start game
                _swordActive = !_swordActive;
                switchTouched = TRUE;
            }
        }
        // if left half is touched ->  jump
        // if right half is touched -> dash
        if (!switchTouched)
        {
            UITouch * touch = [touches anyObject];
            CGPoint location = [touch locationInNode:self];
            if (location.x >= CGRectGetMinX(self.frame) + 0.35 * (CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)))
            {
                if (_swordActive)
                {
                    [_hero heroDash:_hero.sprite];
                    _timeSinceLastDash = 0;
                } else
                {
                    //shoot freaking bow
                    [_hero shootBow:_hero.sprite :location :self];
                }
            } else
            {
              [_hero heroJump];
            }
        }
    } else if ([_mode isEqualToString:@"gameOver"])
    {
        for (UITouch *touch in touches)
        {
            SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
            if ([n.name isEqual:@"tryAgain"])
            {
                [self restartGameAfterGameover];
            }
        }
    }
}


-(void)resolveHeroMovement
{
    if (_hero.sprite.position.y < -100)
    {
        [self endGame];
    } else if (_hero.sprite.physicsBody.velocity.dx >= 0)
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
                _hero.sprite.physicsBody.velocity = CGVectorMake(old_v.dx-[Constants signum: delta]*k*delta*delta, MAX(0, old_v.dy) );
            } else
            {
                _hero.sprite.physicsBody.velocity = CGVectorMake(old_v.dx-[Constants signum: delta]*k*delta*delta, old_v.dy);
            }
        }
    } else
    {
        // if hero is not dashing return to place linearly speeding up world
        if (_hero.sprite.position.x != CGRectGetMinX(self.frame)+20) {
            CGFloat delta = _hero.sprite.position.x - CGRectGetMinX(self.frame)-20;
            CGVector old_v = _hero.sprite.physicsBody.velocity;
            CGFloat speedupCoeff = 5;
            _worldSpeedup = -[Constants signum: delta]*speedupCoeff*MIN(100,abs(delta));
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
                -((speedCoeff / (dashTime - dashDecayTime)) * _timeSinceLastDash + (speedCoeff / (dashDecayTime - dashTime)) * dashDecayTime);
        _heroIsDashing = TRUE;
    } else
    {
        _worldSpeedup = 0;
        _heroIsDashing = FALSE;
    }
}


-(void) updateMonstersState
{
    dispatch_sync(_queue, ^{
    NSMutableArray *dumps = [NSMutableArray array];
    for (Monster *m in _monsters)
    {
        // garbage collect uneeded monsters
        if ([m isNoLongerNeeded])
        {
            [GarbageCollctor cleanObject: m.sprite];
            [dumps addObject:m];
        } else
        {
            m.sprite.speed = 1 - 0.001666*_worldSpeedup;
        }
    }
    [_monsters removeObjectsInArray:dumps];
    });
}


-(void) handleWorldSpeedup
{
    //    NSLog(@"%f", _floor.speed);
    for (SKSpriteNode *sprite in self.children)
    {
        if ([sprite.name isEqualToString:@"cloud"] && ![sprite.name isEqualToString:@"gameOverMenu"])
        {
            sprite.speed = 1 - 0.001666*_worldSpeedup;
        }
    }
    for (SKNode *p in _platforms)
    {
        p.speed = 1 - 0.001666*_worldSpeedup;
    }
}



- (void)handlePlatforming {
    
    if (![_mode  isEqual: @"gameOver"]) {
        // see if we have to spawn a new platform, cause end of this one approaches
        SKNode *lastPlatform = [self.platforms lastObject];
        SKSpriteNode *lastTile = [lastPlatform.children lastObject];
        NSNumber *temp = [lastPlatform.userData objectForKey:@"gapToNextTile"];
        CGFloat gap = [temp floatValue];
        if (lastTile.position.x + lastTile.size.width / 2 + gap <= self.frame.size.width) {
            [_factory initPlatform];
        }
    }
}

-(void) garbageCollectArrows
{
    dispatch_sync(_queue, ^{
    for (SKSpriteNode *arrow in _arrows)
    {
        if ((arrow.position.x < 0) || (arrow.position.y < 0) || arrow.position.x > self.frame.size.width + 10)
        {
            [_arrowsToBeGarbaged addObject:arrow];
            [GarbageCollctor cleanObject:arrow];
        }
    }
    [_arrows removeObjectsInArray:_arrowsToBeGarbaged];
    [_arrowsToBeGarbaged removeAllObjects];
    });
}

- (void)didSimulatePhysics {}

-(CGFloat) getLastTileFloorHeight
{
    SKNode *lastPlatform = [self.platforms lastObject];
    SKSpriteNode *lastTile = [lastPlatform.children lastObject];
    return (lastTile.position.y + lastTile.size.height/2);
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
            Monster *m = (secondBody.node.userData)[@"parent"];
            [m resolveHit];
            _timeSinceLastDash += 10;
        } else
        {
            [self endGame];
        }
    }
    if ((firstBody.categoryBitMask & heroCategory) != 0 &&
        (secondBody.categoryBitMask & floorCategory) != 0)
    {
        [_hero resolveGroundTouch];
    }
    
    if ((firstBody.categoryBitMask & monsterCategory) != 0 &&
        (secondBody.categoryBitMask & arrowCategory) != 0)
    {
        Monster *m = (firstBody.node.userData)[@"parent"];
        [m resolveHit];
        secondBody.categoryBitMask = 0;
    }
}

SKLabelNode* _score;
SKLabelNode* _highScore;
SKLabelNode* _distance;

-(void)setupHUD
{
//    _score = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
//    _score.fontSize = 12.0;
//    _score.position = CGPointMake(50, 7);
//    _score.fontColor = [SKColor greenColor];
//    [self addChild:_score];
    
    _distance = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _distance.fontSize = 12.0;
    _distance.position = CGPointMake(115, 257);
    _distance.fontColor = [SKColor greenColor];
    _distance.zPosition = 1000;
    [self addChild:_distance];
    
    _highScore = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _highScore.fontSize = 12.0;
    _highScore.position = CGPointMake(215, 257);
    _highScore.fontColor = [SKColor redColor];
    _highScore.zPosition = 1000;
    [self addChild:_highScore];
}


@end
