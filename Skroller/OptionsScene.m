//
//  optionsScene.m
//  Skroller
//
//  Created by MacbookPro on 21.11.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "optionsScene.h"

@implementation OptionsScene


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        // Setting up the menu scene
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"NeverGrowUp.png"];
        logo.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+100);
        
        [self addChild:logo];

    }
        return self;
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    SKNode *node = [self nodeAtPoint:location];

    


@end

