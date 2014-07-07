//
//  ViewController.h
//  IgaBall
//

//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameController : UIViewController

- (void)setupMainMenu;
- (void)setupGameOverWithScore:(NSInteger)aScore;

@property (assign, readonly) NSInteger score;

@end
