//
//  MenuScene.m
//  Skroller
//
//  Created by MacbookPro on 27.10.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "MenuScene.h"
#import "GameActionScene.h"

@implementation MenuScene


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        // Setting up the menu scene
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"NeverGrowUp.png"];
        logo.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+100);
        SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton.png"];
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        playButton.name = @"startButton";
        [self addChild:playButton];
        [self addChild:logo];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if next button is touched, start transition to gameActionScene
    if ([node.name isEqualToString:@"startButton"]) {
        SKScene *gameActionScene = [[GameActionScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition fadeWithDuration:3];
        [self.view presentScene:gameActionScene transition:transition];
    }
}
@end
