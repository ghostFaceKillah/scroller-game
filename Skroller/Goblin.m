//
//  Goblin.m
//  Skroller
//
//  Created by Michał Garmulewicz on 21.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Goblin.h"
#import "Constants.h"
#import "SpriteFactory.h"

@interface Goblin()
@property BOOL isAttacking;
@property NSMutableArray *moveTextures;
@property NSMutableArray *deathTextures;
@property NSMutableArray *spawnTextures;
@end

@implementation Goblin
static NSMutableArray *st = nil;
static NSMutableArray *vt = nil;

+(NSMutableArray *) getSpawnTextures {
    
    if(st==nil)
        st = [NSMutableArray arrayWithCapacity:1];
    
    return st;
}

+(NSMutableArray *) getMoveTextures {
    if (vt==nil)
        vt = [NSMutableArray arrayWithCapacity:1];

    return vt;
}

+(void) preloadTextures
{
    // spawn Textures
    SKTextureAtlas *goblinSpawnAtlas = [SKTextureAtlas atlasNamed:@"goblinRespawn"];
    NSInteger amount = goblinSpawnAtlas.textureNames.count -1;
    for (NSInteger i=0; i <= amount; i++) {
        NSString *textureName = [NSString stringWithFormat:@"spawn%ld", (long)i];
        SKTexture *temp = [goblinSpawnAtlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [[Goblin getSpawnTextures] addObject:temp];
    }
    
    SKTextureAtlas *goblinMoveAtlas = [SKTextureAtlas atlasNamed:@"goblinMove"];
    NSInteger amount2 = goblinMoveAtlas.textureNames.count;
    for (NSInteger i=1; i <= amount2; i+=2) {
        NSString *textureName = [NSString stringWithFormat:@"%ld", (long)i];
        SKTexture *temp = [goblinMoveAtlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [[Goblin getMoveTextures] addObject:temp];
    }
}


+(Goblin *) spawn
{
    // alloc and init monster goblin
    Goblin *monster = [[Goblin alloc] init];
    monster.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"1.png"];
    monster.sprite.texture.filteringMode = SKTextureFilteringNearest;

    //animate spawn
    SKAction *spawnAnimation = [SKAction animateWithTextures:[Goblin getSpawnTextures] timePerFrame:0.01];
    SKAction *moveDown = [SKAction moveByX:0 y:0 duration:(250/(500))];
    SKAction *combo = [SKAction group:@[spawnAnimation,moveDown]];
    
    //animate move
    
    SKAction *animation = [SKAction animateWithTextures:[Goblin getMoveTextures] timePerFrame:0.09];
    SKAction *animate = [SKAction repeatActionForever:animation];
    
    SKAction *moveLeft = [SKAction moveByX:(-400) y:0
                                  duration:(1000/(500))];
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *combo2 = [SKAction group:@[wait,animate,moveLeft]];
    
    SKAction *finalAnim = [SKAction sequence:@[combo,combo2]];
    
    [monster.sprite runAction:finalAnim];
    
    
    // setup gobbo's physics
    monster.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.sprite.size];
    monster.sprite.physicsBody.dynamic = YES;
    monster.sprite.physicsBody.mass = 1;
    monster.sprite.physicsBody.restitution = 0.3;
    monster.sprite.physicsBody.categoryBitMask = monsterCategory;
    monster.sprite.physicsBody.contactTestBitMask = heroCategory | floorCategory;
    monster.sprite.physicsBody.collisionBitMask = heroCategory| floorCategory;
    
    monster.isAttacking = TRUE;
    
    monster.sprite.userData = [NSMutableDictionary dictionaryWithCapacity:1];
    [monster.sprite.userData setObject:monster forKey:@"parent"];
    
    return monster;
}


-(void) resolveMovement: (CGFloat) worldVelocity
{
    if (self.isAttacking)
    {
        // if monster is still fresh and has not been killed, make it move forward
        // towards our hero
        CGFloat current_y_speed = self.sprite.physicsBody.velocity.dy;
        self.sprite.physicsBody.velocity = CGVectorMake(MIN(-300, 0.5*worldVelocity), current_y_speed);
        
        
    }
}

-(void) resolveHit
{
    self.isAttacking = FALSE;
    self.sprite.physicsBody.angularVelocity = 50*([Constants randomFloat] - 0.5);
    self.sprite.physicsBody.categoryBitMask = menuCategory;
    self.sprite.physicsBody.contactTestBitMask = 0;
    self.sprite.physicsBody.collisionBitMask = 0;
    [self.sprite removeAllActions];

    //load death textures
    
/*  NSMutableArray monster.deathTextures = [NSMutableArray arrayWithCapacity:1];
    SKTextureAtlas *goblinDeathAtlas = [SKTextureAtlas atlasNamed:@"goblinDeath"];
    
    NSInteger amount3 = goblinDeathAtlas.textureNames.count;
    for (NSInteger i=0; i <= amount3; i+=3) {
        NSString *textureName = [NSString stringWithFormat:@"death%ld", (long)i];
        SKTexture *temp = [goblinDeathAtlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [monster.deathTextures addObject:temp];
    }

    SKAction *deathAnimation = [SKAction animateWithTextures:monster.deathTextures timePerFrame:0.01];
*/
//    [self.sprite runAction: deathAnimation];

    
}

-(BOOL) isNoLongerNeeded {
    // calculate if sprite is off-screen (it may be a redundant method now, as we
    // are reimplementing possibly existing method (isVisible etc.)
    // but we will probably need this later when we would like to handle custom vanishing behaviour
    return (self.sprite.position.x < 0) || (self.sprite.position.y < 0);
}

@end
//