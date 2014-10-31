//
//  Birdie.m
//  Skroller
//
//  Created by Michał Garmulewicz on 21.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Birdie.h"
#import "Constants.h"

@interface Birdie()
@property NSString *state;
@property CGFloat alpha;
@property Hero *hero;
@property CGPoint targetCoordinates;
@property CGFloat timeSinceChargeStart;
@end

@implementation Birdie

+(Birdie *) spawn: (Hero*) hero
{
    Birdie *monster = [[Birdie alloc] init];
    monster.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"birdie_placeholder.png"];
    monster.sprite.texture.filteringMode = SKTextureFilteringNearest;
    
    // setup physics
    monster.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.sprite.size];
    monster.sprite.physicsBody.dynamic = YES;
    monster.sprite.physicsBody.mass = 1;
    monster.sprite.physicsBody.categoryBitMask = monsterCategory;
    monster.sprite.physicsBody.contactTestBitMask = heroCategory | floorCategory;
    monster.sprite.physicsBody.collisionBitMask = heroCategory| floorCategory;
    monster.state = @"going to circle";
    
    monster.hero = hero;
    
    return monster;
}


-(void) resolveMovement: (CGFloat) worldVelocity
{
    if ([self.state isEqualToString:@"going to circle"])
    {
        // if monster is still fresh and has not been killed, make it move forward
        // towards our hero
//        CGFloat current_y_speed = self.sprite.physicsBody.velocity.dy;
        self.sprite.physicsBody.velocity = CGVectorMake((CGFloat) MIN(-200, 0.5*worldVelocity), 30);
        if (self.sprite.position.x <= 200)
        {
            self.state = @"circling";
            self.alpha = 0;
        }
    } else if ([self.state isEqualToString:@"circling"])
    {
        self.alpha += 0.1;
        CGFloat flyingPower = 100;
        CGFloat x_prime = (CGFloat) (flyingPower * sin(self.alpha));
        CGFloat y_prime = (CGFloat) (-flyingPower * cos(self.alpha) + 30);
        self.sprite.physicsBody.velocity = CGVectorMake(x_prime, y_prime);
        if ([Constants randomFloat] < 0.005)
        {
            self.state = @"attack";
            _targetCoordinates = _hero.sprite.position;
            _timeSinceChargeStart = 0;
        }
    } else if ([self.state isEqualToString:@"attack"])
    {
        _timeSinceChargeStart += 1;
        CGFloat attackSpeed = 0.5;
        CGFloat x = _targetCoordinates.x - self.sprite.position.x;
        CGFloat y = _targetCoordinates.y - self.sprite.position.y;
        CGFloat norm = sqrt(x*x + y*y);
        x = _timeSinceChargeStart * _timeSinceChargeStart * attackSpeed * x/norm;
        // correction by +30 is to have it fly
        y = _timeSinceChargeStart * _timeSinceChargeStart * attackSpeed * y/norm + 30;
        self.sprite.physicsBody.velocity = CGVectorMake(x, y);
//        [self.sprite.physicsBody applyImpulse:CGVectorMake(x, y)];
        if (norm < 10)
        {
            self.state = @"after attack";
        }
    }
//    else if ([self.state isEqualToString:@"after attack"])
}

-(void) resolveHit
{
    self.sprite.physicsBody.angularVelocity = 50*([Constants randomFloat] - 0.5);
    self.sprite.physicsBody.categoryBitMask = menuCategory;
    self.sprite.physicsBody.contactTestBitMask = 0;
    self.sprite.physicsBody.collisionBitMask = 0;
}

-(BOOL) isNoLongerNeeded {
    // calculate if sprite is off-screen (it maybe a redundant method now, as we
    // are reimplementing possibly existing method (isVisible etc.)
    // but we will probably need this later when we would like to handle custom vanishing behaviour
    return (self.sprite.position.x < 0) || (self.sprite.position.y < 0);
}



@end
