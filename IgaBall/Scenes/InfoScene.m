//
//  InfoScene.m
//  IgaBall
//
//  Created by Korich on 5/14/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "InfoScene.h"
#import "Constants.h"
#import "ShadowLabelNode.h"
#import "SDiPhoneVersion.h"

@interface InfoScene ()

@end

@implementation InfoScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
	DBNSLog(@"%s", __func__);
	
	if (self = [super initWithSize:aSize gameController:gGameController])
	{
		// 1
        BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        
        SKSpriteNode *bgSprite = [self landscapeSpriteForSize:aSize];
		bgSprite.zPosition = kPositionZBGImage;
		[self addChild:bgSprite];
		
		CGFloat titleFontSize = isIPhone ? 25.f : 50.f;
		CGFloat textFontSize = isIPhone ? 20.f : 35.f;
		CGFloat yOffset = isIPhone ? 10.f : 30.f;
		
		SKLabelNode *labelBack = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelBack.text = @"Touch anywhere to go back";
		labelBack.fontSize = textFontSize;
		
		SKAction *pulseText = [SKAction sequence:@[
												   [SKAction fadeAlphaTo:0.5 duration:0.7],
												   [SKAction fadeAlphaTo:1 duration:0.7],
												   ]];
		
		[labelBack runAction:[SKAction repeatActionForever:pulseText]];
		
		labelBack.position = CGPointMake(self.size.width/2, yOffset * 2);
		
		labelBack.zPosition = kPositionZLabels;
		[self addChild:labelBack];
		
		// 3
		SKLabelNode *labelCopyrights = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelCopyrights.text = @"IGR Software © 2014";
		labelCopyrights.fontSize = titleFontSize;
		
		labelCopyrights.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - labelCopyrights.frame.size.height - yOffset * 2);
		labelCopyrights.zPosition = kPositionZLabels;
		[self addChild:labelCopyrights];
		
		// 4
		SKLabelNode *labelDeveloperTitle = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelDeveloperTitle.text = @"Develop:";
		labelDeveloperTitle.fontSize = titleFontSize;
		
		labelDeveloperTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelCopyrights.position.y - labelCopyrights.frame.size.height - yOffset * 3);
		labelDeveloperTitle.zPosition = kPositionZLabels;
		[self addChild:labelDeveloperTitle];
		
		SKLabelNode *labelDeveloper = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelDeveloper.text = @"Vitalii Parovishnyk (Korich)";
		labelDeveloper.fontSize = textFontSize;
		
		labelDeveloper.position = CGPointMake(CGRectGetMidX(self.frame), labelDeveloperTitle.position.y - labelDeveloperTitle.frame.size.height);
		labelDeveloper.zPosition = kPositionZLabels;
		[self addChild:labelDeveloper];
		
		// 5
		SKLabelNode *labelDesignerTitle = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelDesignerTitle.text = @"Design:";
		labelDesignerTitle.fontSize = titleFontSize;
		
		labelDesignerTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelDeveloper.position.y - labelDeveloper.frame.size.height - yOffset);
		labelDesignerTitle.zPosition = kPositionZLabels;
		[self addChild:labelDesignerTitle];
		
		SKLabelNode *labelDesigner = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelDesigner.text = @"Oksana Ralko";
		labelDesigner.fontSize = textFontSize;
		
		labelDesigner.position = CGPointMake(CGRectGetMidX(self.frame), labelDesignerTitle.position.y - labelDesignerTitle.frame.size.height);
		labelDesigner.zPosition = kPositionZLabels;
		[self addChild:labelDesigner];
		
		// 6
		SKLabelNode *labelSoundTitle = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelSoundTitle.text = @"Sound:";
		labelSoundTitle.fontSize = titleFontSize;
		
		labelSoundTitle.position = CGPointMake(CGRectGetMidX(self.frame), labelDesigner.position.y - labelDesigner.frame.size.height - yOffset);
		labelSoundTitle.zPosition = kPositionZLabels;
		[self addChild:labelSoundTitle];
		
		SKLabelNode *labelSound1 = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		labelSound1.text = @"Lucky Lion Studios";
		labelSound1.fontSize = textFontSize;
		
		labelSound1.position = CGPointMake(CGRectGetMidX(self.frame), labelSoundTitle.position.y - labelSoundTitle.frame.size.height);
		labelSound1.zPosition = kPositionZLabels;
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
