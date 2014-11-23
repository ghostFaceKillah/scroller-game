//
//  MenuScene.m
//  Skroller
//
//  Created by MacbookPro on 27.10.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "MenuScene.h"
#import "GameActionScene.h"
#import "OptionsScene.h"

@implementation MenuScene


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        // Setting up the menu scene
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"NeverGrowUp.png"];
        logo.texture.filteringMode = SKTextureFilteringNearest;
        logo.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+100);
        SKAction *moveUp = [SKAction moveByX:0 y:8 duration:1];
        SKAction *moveDown = [SKAction moveByX:0 y:-8 duration:1];
        SKAction *sequence = [SKAction sequence:@[moveDown,moveUp]];
        SKAction *loopinho = [SKAction repeatActionForever:sequence];
        
        [logo runAction:loopinho];
        
        SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton.png"];
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        playButton.name = @"startButton";
        
        SKSpriteNode *optionsButton = [SKSpriteNode spriteNodeWithImageNamed:@"optionsButton.png"];
        optionsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-70);
        optionsButton.name = @"optionsButton";
        
        [self addChild:playButton];
        [self addChild:logo];
        [self addChild:optionsButton];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if play button is touched, start transition to gameActionScene
    if ([node.name isEqualToString:@"startButton"]) {
        SKScene *gameActionScene = [[GameActionScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition fadeWithDuration:3];
        [self.view presentScene:gameActionScene transition:transition];
    }
    
    // if options button is touched, start transition to OptionsScene
    if ([node.name isEqualToString:@"optionsButton"]) {
        SKScene *optionScene = [[OptionsScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition fadeWithDuration:3];
        [self.view presentScene:optionScene transition:transition];
    }
}
@end
