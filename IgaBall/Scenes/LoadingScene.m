//
//  LoadingScene.m
//  IgaBall
//
//  Created by Korich on 4/24/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "LoadingScene.h"
#import "GameController.h"

@interface LoadingScene ()

@property (weak) GameController *viewController;

@end

@implementation LoadingScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller
{
	DBNSLog(@"%s", __func__);
	
    if (self = [super initWithSize:size])
	{
        /* Setup your scene here */
		
        BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        
		self.viewController = controller;
		self.name = NSStringFromClass([self class]);
		
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

        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:size];

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
	
	[self runAction:
	 [SKAction sequence:@[
						  [SKAction waitForDuration:1.0],
						  [SKAction runBlock:^{
		 
         [self.viewController setupMainMenu];
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
