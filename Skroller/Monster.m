//
//  Monster.m
//  Skroller
//
//  Created by Michał Garmulewicz on 10.08.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "Monster.h"
#import "Constants.h"
@interface Monster()
@end

@implementation Monster

// ideas for monsters
// * just goblin - he has two modes - going forward defenceless and second attacking whatever is in front of him
// * spike - you have to dodge him - no method for killing this guy
// * rocket - this guy first runs onto screen and floats around, and later it attacks you directly, but is slow
// to change direction so you can dodge him and he hits floor/etc and kills himself
// * archer - pretty much self-explainatory
// * tower - an untouchable guy at the bottom and another guy to be hit at the bottom

// need to implement probabilistic spawning of monsters



+(Monster *) spawn
{
    NSLog(@"bad method spawn called, nothing to do in Monster abstract class");
    return nil;
}



-(BOOL) isNoLongerNeeded {
    NSLog(@"bad method isNoLongerNeeded called, nothing to do in Monster abstract class");
    return 0;
}

-(void) resolveHit
{
    NSLog(@"bad method resolveHit called, nothing to do in Monster abstract class");
}


-(void) resolveMovement:(CGFloat)worldVelocity
{
    NSLog(@"bad method resolveMovement called, nothing to do in Monster abstract class");
}

@end
