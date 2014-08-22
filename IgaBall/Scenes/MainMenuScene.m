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
		
        BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        
		SKTexture *texture = nil;
		if (isIPhone)
		{
            CGFloat height = MAX(CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]));
            BOOL isIPhone5 = (height - 568.f == 0) ? YES : NO;
            NSString *imgName = [NSString stringWithFormat:@"LaunchImage-700%@", isIPhone5 ? @"-568h" : @""];
			texture = [SKTexture textureWithImageNamed:imgName];
		}
		else
		{
			texture = [SKTexture textureWithImageNamed:@"LaunchImage-700-Landscape"];
		}
        
        CGSize newSize = aSize;
        if (isIPhone)
        {
            newSize = CGSizeMake(aSize.height, aSize.width);
        }
        
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:newSize];
        
        if (isIPhone)
        {
            bgImage.zRotation = M_PI / 2;
        }
        
        bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:bgImage];
        
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
