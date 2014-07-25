//
//  GameOverScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/29/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameOverScene.h"
#import "Constants.h"
#import "ShadowLabelNode.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
    DBNSLog(@"%s", __func__);
    
    if (self = [super initWithSize:aSize gameController:gGameController])
	{
        // 1
        self.backgroundColor = DEFAULT_BG_COLOR;
		
        // 2
        NSString * message = [NSString stringWithFormat:@"Your Score: %@", @(gGameController.score)];
		
        // 3
        BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        CGFloat titleFontSize = isIPhone ? 30.f : 50.f;
        
        SKLabelNode *label = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
        label.text = message;
        label.fontSize = titleFontSize;
        
        CGFloat yOffset = 200.f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            yOffset = 100.f;
        }
        
        label.position = CGPointMake(self.size.width/2, self.size.height/2 + yOffset);
        [self addChild:label];
    }
    
    return self;
}

@end
