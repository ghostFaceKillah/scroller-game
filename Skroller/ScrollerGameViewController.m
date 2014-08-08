//
//  ScrollerGameViewController.m
//  Skroller
//
//  Created by Michał Garmulewicz on 12.07.2014.
//  Copyright (c) 2014 com.mike-dev. All rights reserved.
//

#import "ScrollerGameViewController.h"
#import "GameActionScene.h"
#import "Hero.h"

@interface ScrollerGameViewController ()

@end

@implementation ScrollerGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
//    GameActionScene* hello = [[GameActionScene alloc] initWithSize:CGSizeMake(2000,1666)];
     GameActionScene* hello = [[GameActionScene alloc] initWithSize:CGSizeMake(300,200)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: hello];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    [image_signature setImage:[self resizeImage:image_signature.image]];
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
//    [image_signature setImage:[self resizeImage:image_signature.image]];
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
