//
//  BaseScene.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 7/7/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameController.h"
@import SpriteKit;

@interface BaseScene : SKScene

- (instancetype)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController;

@property (nonatomic, weak, readwrite) GameController *gameController;

@end
