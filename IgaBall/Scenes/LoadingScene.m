//
//  LoadingScene.m
//  IgaBall
//
//  Created by Korich on 4/24/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "LoadingScene.h"
#import "SoundMaster.h"
#import "SDiPhoneVersion.h"

@interface LoadingScene ()

@end

@implementation LoadingScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
	DBNSLog(@"%s", __func__);
	
    SKSpriteNode *logoImage = nil;
    CGFloat changeSceneDelay = 0.0;
    
	if (self = [super initWithSize:aSize gameController:gGameController])
	{
        changeSceneDelay = 1.0;
        
		/* Setup your scene here */
		[[SoundMaster sharedMaster] preloadMusic:@"game.m4a"];
		[[SoundMaster sharedMaster] preloadMusic:@"gameover.m4a"];
		[[SoundMaster sharedMaster] preloadEffect:@"main.m4a"];
		[[SoundMaster sharedMaster] preloadEffect:@"pop.m4a"];
		
        SKSpriteNode *bgSprite = [self landscapeSpriteForSize:aSize];
        [self addChild:bgSprite];
        
		SKTexture *logoTexture = [SKTexture textureWithImageNamed:@"IGRSoft"];
		
		logoImage = [SKSpriteNode spriteNodeWithTexture:logoTexture];
		
        BOOL isIOS7 = iOSVersionLessThanOrEqualTo(@"7.1.2");
		if (isIOS7)
		{
			logoImage.position = CGPointMake(CGRectGetMidY(self.frame),
											 CGRectGetMidX(self.frame));
		}
		else
		{
			logoImage.position = CGPointMake(CGRectGetMidX(self.frame),
											 CGRectGetMidY(self.frame));
		}
		
		[self addChild:logoImage];
	}
	
	__weak LoadingScene *weakSelf = self;
	[self runAction:
	 [SKAction sequence:@[
						  [SKAction waitForDuration:changeSceneDelay],
						  [SKAction runBlock:^{
         
         [logoImage setHidden:YES];
         
		 [weakSelf.gameController setupMainMenu];
	 }]
						  ]]
	 ];
	
	return self;
}

-(void)update:(CFTimeInterval)currentTime
{
	/* Called before each frame is rendered */
}

@end
