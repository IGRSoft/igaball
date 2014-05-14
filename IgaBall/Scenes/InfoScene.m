//
//  InfoScene.m
//  IgaBall
//
//  Created by Korich on 5/14/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "InfoScene.h"
#import "GameController.h"

@interface InfoScene ()

@property (weak) GameController *viewController;

@end

@implementation InfoScene


- (id)initWithSize:(CGSize)size controller:(GameController *)controller
{
    if (self = [super initWithSize:size])
    {
        self.viewController = controller;
        // 1
        self.backgroundColor = [SKColor colorWithRed:120.f/255.f green:190.f/255.f blue:225.f/255.f alpha:1.000];
		
        // 2
        SKLabelNode *labelBack = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelBack.text = @"Touch anywhere to go back";
        labelBack.fontSize = 20;
        labelBack.fontColor = [SKColor whiteColor];
        
        SKAction *pulseText = [SKAction sequence:@[
                                                   [SKAction fadeAlphaTo:0.5 duration:1],
                                                   [SKAction fadeAlphaTo:1 duration:1],
                                                   ]];
        
        [labelBack runAction:[SKAction repeatActionForever:pulseText]];
        
        labelBack.position = CGPointMake(self.size.width/2, 40);
        [self addChild:labelBack];
        
        SKLabelNode *labelCopyrights = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelCopyrights.text = @"IGR Software © 2014";
        labelCopyrights.fontSize = 20;
        labelCopyrights.fontColor = [SKColor whiteColor];
        
        labelCopyrights.position = CGPointMake(self.size.width/2, 120);
        [self addChild:labelCopyrights];
        
        // 3
        NSString *imgName = [NSString stringWithFormat:@"GameName"];
        SKTexture *texture = [SKTexture textureWithImageNamed:imgName];
		
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];
		
        bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                       self.frame.size.height - texture.size.height * 0.5 - 20);
        [self addChild:bgImage];
        
        // 4
        SKLabelNode *labelDeveloperTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDeveloperTitle.text = @"Developer:";
        labelDeveloperTitle.fontSize = 25;
        labelDeveloperTitle.fontColor = [SKColor whiteColor];
        
        labelDeveloperTitle.position = CGPointMake(CGRectGetMidX(self.frame), bgImage.position.y - bgImage.size.height);
        [self addChild:labelDeveloperTitle];
        
        SKLabelNode *labelDeveloper = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDeveloper.text = @"Vitalii Parovishnyk (Korich)";
        labelDeveloper.fontSize = 25;
        labelDeveloper.fontColor = [SKColor whiteColor];
        
        labelDeveloper.position = CGPointMake(CGRectGetMidX(self.frame), labelDeveloperTitle.position.y - labelDeveloperTitle.frame.size.height);
        [self addChild:labelDeveloper];
        
        // 5
        SKLabelNode *labelDesignerTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDesignerTitle.text = @"Designer:";
        labelDesignerTitle.fontSize = 25;
        labelDesignerTitle.fontColor = [SKColor whiteColor];
        
        labelDesignerTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelDeveloper.position.y - labelDeveloper.frame.size.height - 20.f);
        [self addChild:labelDesignerTitle];
        
        SKLabelNode *labelDesigner = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelDesigner.text = @"Andrey Chaika";
        labelDesigner.fontSize = 25;
        labelDesigner.fontColor = [SKColor whiteColor];
        
        labelDesigner.position = CGPointMake(CGRectGetMidX(self.frame), labelDesignerTitle.position.y - labelDesignerTitle.frame.size.height);
        [self addChild:labelDesigner];
        
        // 6
        SKLabelNode *labelSoundTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelSoundTitle.text = @"Sound:";
        labelSoundTitle.fontSize = 25;
        labelSoundTitle.fontColor = [SKColor whiteColor];
        
        labelSoundTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelDesigner.position.y - labelDesigner.frame.size.height - 20.f);
        [self addChild:labelSoundTitle];
        
        SKLabelNode *labelSound1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelSound1.text = @"yd";
        labelSound1.fontSize = 25;
        labelSound1.fontColor = [SKColor whiteColor];
        
        labelSound1.position = CGPointMake(CGRectGetMidX(self.frame), labelSoundTitle.position.y - labelSoundTitle.frame.size.height);
        [self addChild:labelSound1];
        
        SKLabelNode *labelSound2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelSound2.text = @"Independent.nu";
        labelSound2.fontSize = 25;
        labelSound2.fontColor = [SKColor whiteColor];
        
        labelSound2.position = CGPointMake(CGRectGetMidX(self.frame), labelSound1.position.y - labelSound1.frame.size.height);
        [self addChild:labelSound2];
        
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
    [self.viewController setupMainMenu];
}

@end
