//
//  GameScene.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameController;

@interface GameScene : SKScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller;

@end
