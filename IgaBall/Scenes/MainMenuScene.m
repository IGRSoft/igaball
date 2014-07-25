//
//  MainMenuScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "MainMenuScene.h"
#import "Constants.h"

@interface MainMenuScene ()

@end

@implementation MainMenuScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
    DBNSLog(@"%s", __func__);
    
    if (self = [super initWithSize:aSize gameController:gGameController])
	{
        /* Setup your scene here */
		
        BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        
		self.name = NSStringFromClass([self class]);
		
		SKTexture *texture = nil;
		if (isIPhone)
		{
            BOOL isIPhone5 = (([[UIScreen mainScreen] bounds].size.height - 568.f)? NO : YES);
            NSString *imgName = [NSString stringWithFormat:@"bg_main%@", isIPhone5 ? @"-568h" : @""];
			texture = [SKTexture textureWithImageNamed:imgName];
		}
		else
		{
			texture = [SKTexture textureWithImageNamed:@"bg_main"];
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
        
		self.name = NSStringFromClass([self class]);
		
		self.backgroundColor = DEFAULT_BG_COLOR;
		
		NSString *imgName = [NSString stringWithFormat:@"GameName"];
        SKTexture *nameTexture = [SKTexture textureWithImageNamed:imgName];
		
        SKSpriteNode *nameImage = [SKSpriteNode spriteNodeWithTexture:nameTexture size:nameTexture.size];
		
        nameImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) + (isIPhone ? 60 : 200));
        
        [self addChild:nameImage];
    }
	
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
