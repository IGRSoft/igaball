//
//  LoadingScene.m
//  IgaBall
//
//  Created by Korich on 4/24/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "LoadingScene.h"
#import "SoundMaster.h"

@interface LoadingScene ()

@end

@implementation LoadingScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
    DBNSLog(@"%s", __func__);
    
    if (self = [super initWithSize:aSize gameController:gGameController])
	{
        /* Setup your scene here */
		[[SoundMaster sharedMaster] preloadMusic:@"game.m4a"];
        [[SoundMaster sharedMaster] preloadMusic:@"gameover.m4a"];
        [[SoundMaster sharedMaster] preloadEffect:@"main.m4a"];
        [[SoundMaster sharedMaster] preloadEffect:@"pop.m4a"];
        
        BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        		
		SKTexture *texture = nil;
		if (isIPhone)
		{
            BOOL isIPhone5 = (([[UIScreen mainScreen] bounds].size.height - 568.f)? NO : YES);
            NSString *imgName = [NSString stringWithFormat:@"LaunchImage-700%@", isIPhone5 ? @"-568h" : @""];
			texture = [SKTexture textureWithImageNamed:imgName];
		}
		else
		{
			texture = [SKTexture textureWithImageNamed:@"LaunchImage-700-Landscape"];
		}

        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:aSize];

        if (isIPhone)
        {
            bgImage.zRotation = M_PI / 2;
            
            bgImage.position = CGPointMake(CGRectGetMidY(self.frame),
                                           CGRectGetMidX(self.frame));
        }
        else
        {
            bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
        }
        
        [self addChild:bgImage];
    }
	
    __weak LoadingScene *weakSelf = self;
	[self runAction:
	 [SKAction sequence:@[
						  [SKAction waitForDuration:1.0],
						  [SKAction runBlock:^{
		 
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
