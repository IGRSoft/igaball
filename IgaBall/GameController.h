//
//  ViewController.h
//  IgaBall
//

//  Copyright (c) 2014 IGR Software. All rights reserved.
//

@import UIKit;

@interface GameController : UIViewController

- (void)setupMainMenu;
- (void)setupGameOverWithScore:(NSInteger)aScore;

@property (nonatomic, assign, readonly) NSInteger score;

@end
