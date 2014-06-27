//
//  GameOverScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/29/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameOverScene.h"
#import "GameController.h"
#import "Constants.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller score:(NSInteger)score
{
    if (self = [super initWithSize:size]) {
		
        controller.score = score;
        
        // 1
        self.backgroundColor = DEFAULT_BG_COLOR;
		
        // 2
        NSString * message = [NSString stringWithFormat:@"Your Score: %@", @(score)];
		
        // 3
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        
        CGFloat yOffset = 100.f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            yOffset = 50.f;
        }
        
        label.position = CGPointMake(self.size.width/2, self.size.height/2 + yOffset);
        [self addChild:label];
    }
    
    return self;
}

@end
