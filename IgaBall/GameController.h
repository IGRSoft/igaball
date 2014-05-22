//
//  ViewController.h
//  IgaBall
//

//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameController : UIViewController

- (void)playMusic:(NSString *)name;

- (void)setupMainMenu;
- (void)setupGameOverWithScore:(NSInteger)score;

@property (assign) NSInteger score;

@end
