//
//  InfoScene.m
//  IgaBall
//
//  Created by Korich on 5/14/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "InfoScene.h"
#import "Constants.h"

@interface InfoScene ()

@end

@implementation InfoScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
    DBNSLog(@"%s", __func__);
    
    if (self = [super initWithSize:aSize gameController:gGameController])
    {
        // 1
        self.backgroundColor = DEFAULT_BG_COLOR;
		
        // 2
        BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        CGFloat titleFontSize = isIPhone ? 20.f : 30.f;
        CGFloat textFontSize = isIPhone ? 15.f : 25.f;
        CGFloat yOffset = isIPhone ? 10.f : 30.f;
        
        SKLabelNode *labelBack = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelBack.text = @"Touch anywhere to go back";
        labelBack.fontSize = textFontSize;
        labelBack.fontColor = [SKColor whiteColor];
        
        SKAction *pulseText = [SKAction sequence:@[
                                                   [SKAction fadeAlphaTo:0.5 duration:0.7],
                                                   [SKAction fadeAlphaTo:1 duration:0.7],
                                                   ]];
        
        [labelBack runAction:[SKAction repeatActionForever:pulseText]];
        
        labelBack.position = CGPointMake(self.size.width/2, yOffset * 2);
        [self addChild:labelBack];
        
        // 3
        SKLabelNode *labelCopyrights = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelCopyrights.text = @"IGR Software © 2014";
        labelCopyrights.fontSize = titleFontSize;
        labelCopyrights.fontColor = [SKColor whiteColor];
        
        labelCopyrights.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - labelCopyrights.frame.size.height - yOffset * 2);
        [self addChild:labelCopyrights];
        
        // 4
        SKLabelNode *labelDeveloperTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDeveloperTitle.text = @"Develop:";
        labelDeveloperTitle.fontSize = titleFontSize;
        labelDeveloperTitle.fontColor = [SKColor whiteColor];
        
        labelDeveloperTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelCopyrights.position.y - labelCopyrights.frame.size.height - yOffset * 3);
        [self addChild:labelDeveloperTitle];
        
        SKLabelNode *labelDeveloper = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDeveloper.text = @"Vitalii Parovishnyk (Korich)";
        labelDeveloper.fontSize = textFontSize;
        labelDeveloper.fontColor = [SKColor whiteColor];
        
        labelDeveloper.position = CGPointMake(CGRectGetMidX(self.frame), labelDeveloperTitle.position.y - labelDeveloperTitle.frame.size.height);
        [self addChild:labelDeveloper];
        
        // 5
        SKLabelNode *labelDesignerTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDesignerTitle.text = @"Design:";
        labelDesignerTitle.fontSize = titleFontSize;
        labelDesignerTitle.fontColor = [SKColor whiteColor];
        
        labelDesignerTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelDeveloper.position.y - labelDeveloper.frame.size.height - yOffset);
        [self addChild:labelDesignerTitle];
        
        SKLabelNode *labelDesigner = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDesigner.text = @"Oksana Ralko";
        labelDesigner.fontSize = textFontSize;
        labelDesigner.fontColor = [SKColor whiteColor];
        
        labelDesigner.position = CGPointMake(CGRectGetMidX(self.frame), labelDesignerTitle.position.y - labelDesignerTitle.frame.size.height);
        [self addChild:labelDesigner];
        
        // 6
        SKLabelNode *labelSoundTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelSoundTitle.text = @"Sound:";
        labelSoundTitle.fontSize = titleFontSize;
        labelSoundTitle.fontColor = [SKColor whiteColor];
        
        labelSoundTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelDesigner.position.y - labelDesigner.frame.size.height - yOffset);
        [self addChild:labelSoundTitle];
        
        SKLabelNode *labelSound1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelSound1.text = @"Lucky Lion Studios";
        labelSound1.fontSize = textFontSize;
        labelSound1.fontColor = [SKColor whiteColor];
        
        labelSound1.position = CGPointMake(CGRectGetMidX(self.frame), labelSoundTitle.position.y - labelSoundTitle.frame.size.height);
        [self addChild:labelSound1];
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^
         {
             labelBack.alpha = 0.5f;
         }
                         completion:^(BOOL finished)
         {
             
         }];
    }
    
    return self;
}

//handle touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.gameController setupMainMenu];
}

@end
