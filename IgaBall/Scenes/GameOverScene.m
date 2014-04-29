//
//  GameOverScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/29/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller score:(NSUInteger)score
{
    if (self = [super initWithSize:size]) {
		
        // 1
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		
        // 2
        NSString * message = [NSString stringWithFormat:@"%@", @(score)];
		
        // 3
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
		
        // 4
        [self runAction:
		 [SKAction sequence:@[
							  [SKAction waitForDuration:3.0],
							  [SKAction runBlock:^{
			 // 5
			 SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
			 GameScene *gameScene = [[GameScene alloc] initWithSize:self.size controller:controller];
			 [self.view presentScene:gameScene transition: reveal];
		 }]
							  ]]
		 ];
		
    }
    return self;
}

@end
