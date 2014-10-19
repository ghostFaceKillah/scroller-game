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
@property NSMutableArray *deathTextures;
@end

@implementation Goblin

+(Goblin *) spawn
{
    // alloc and init monster goblin
    Goblin *monster = [[Goblin alloc] init];
    monster.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"1.png"];
    monster.sprite.texture.filteringMode = SKTextureFilteringNearest;
    
    //load spawn textures
    
    NSMutableArray *spawnTextures = [NSMutableArray arrayWithCapacity:1];
    SKTextureAtlas *goblinSpawnAtlas = [SKTextureAtlas atlasNamed:@"respawn"];
    
    int amount = goblinSpawnAtlas.textureNames.count -1;
    for (int i=0; i <= amount; i++) {
    NSString *textureName = [NSString stringWithFormat:@"spawn%d", i];
    SKTexture *temp = [goblinSpawnAtlas textureNamed:textureName];
    temp.filteringMode = SKTextureFilteringNearest;
    [spawnTextures addObject:temp];
    }
    
    //animate spawn
    
    SKAction *spawnAnimation = [SKAction animateWithTextures:spawnTextures timePerFrame:0.01];
    
    SKAction *moveDown = [SKAction moveByX:0 y:0
                                  duration:(250/(500))];
    SKAction *combo = [SKAction group:@[spawnAnimation,moveDown]];
    
//    [monster.sprite runAction:combo];
    
    //load move textures
    
    NSMutableArray *moveTextures = [NSMutableArray arrayWithCapacity:1];
    SKTextureAtlas *goblinMoveAtlas = [SKTextureAtlas atlasNamed:@"move"];
    
    int amount2 = goblinMoveAtlas.textureNames.count;
    for (int i=1; i <= amount2; i+=2) {
        NSString *textureName = [NSString stringWithFormat:@"%d", i];
        SKTexture *temp = [goblinMoveAtlas textureNamed:textureName];
        temp.filteringMode = SKTextureFilteringNearest;
        [moveTextures addObject:temp];
    }
    
    
    SKAction *animation = [SKAction animateWithTextures:moveTextures timePerFrame:0.09];
    SKAction *animate = [SKAction repeatActionForever:animation];
    
    SKAction *moveLeft = [SKAction moveByX:(-400) y:0
                                  duration:(1000/(500))];
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *combo2 = [SKAction group:@[wait,animate,moveLeft]];
    
//    [monster.sprite runAction:combo2];
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
}

-(BOOL) isNoLongerNeeded {
    // calculate if sprite is off-screen (it may be a redundant method now, as we
    // are reimplementing possibly existing method (isVisible etc.)
    // but we will probably need this later when we would like to handle custom vanishing behaviour
    return (self.sprite.position.x < 0) || (self.sprite.position.y < 0);
}

@end
//
