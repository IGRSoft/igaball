//
//  LoadingScene.m
//  IgaBall
//
//  Created by Korich on 4/24/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "LoadingScene.h"
#import "MainMenuScene.h"
#import "GameController.h"

@interface LoadingScene ()

	@property (nonatomic, weak) GameController *viewController;

@end

@implementation LoadingScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller
{
	DBNSLog(@"%s", __func__);
	
    if (self = [super initWithSize:size])
	{
        /* Setup your scene here */
		
		self.viewController = controller;
		self.name = NSStringFromClass([self class]);
		
		SKTexture *texture = nil;
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		{
			texture = [SKTexture textureWithImageNamed:@"LaunchImage-700"];
		}
		else
		{
			texture = [SKTexture textureWithImageNamed:@"LaunchImage-700-Landscape"];
		}

        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];

        bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:bgImage];
    }
	
	[self runAction:
	 [SKAction sequence:@[
						  [SKAction waitForDuration:1.0],
						  [SKAction runBlock:^{
		 
		 SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
		 SKScene * myScene = [[MainMenuScene alloc] initWithSize:self.size controller:self.viewController];
		 [self.view presentScene:myScene transition: reveal];
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
