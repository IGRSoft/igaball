//
//  GameOverScene.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/29/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameController;

@interface GameOverScene : SKScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller score:(NSInteger)score;

@end
