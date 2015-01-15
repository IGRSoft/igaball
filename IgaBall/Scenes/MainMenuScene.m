//
//  MainMenuScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "MainMenuScene.h"
#import "Constants.h"
#import "SDiPhoneVersion.h"

@interface MainMenuScene ()

@end

@implementation MainMenuScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
	DBNSLog(@"%s", __func__);
	
	if (self = [super initWithSize:aSize gameController:gGameController])
	{
		/* Setup your scene here */
		BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        
        SKSpriteNode *bgSprite = [self landscapeSpriteForSize:aSize];
        [self addChild:bgSprite];
		
		NSString *imgName = [NSString stringWithFormat:@"GameName"];
		SKTexture *nameTexture = [SKTexture textureWithImageNamed:imgName];
		
		SKSpriteNode *nameImage = [SKSpriteNode spriteNodeWithTexture:nameTexture size:nameTexture.size];
		
		nameImage.position = CGPointMake(CGRectGetMidX(self.frame),
										 CGRectGetMidY(self.frame) + (isIPhone ? 100 : 190));
		
		[self addChild:nameImage];
	}
	
	return self;
}

-(void)update:(CFTimeInterval)currentTime
{
	/* Called before each frame is rendered */
}

@end
