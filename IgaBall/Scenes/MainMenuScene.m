//
//  MainMenuScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameController.h"
#import "Constants.h"

@interface MainMenuScene ()

@property (weak) GameController *viewController;

@end

@implementation MainMenuScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller
{
	DBNSLog(@"%s", __func__);
	
    if (self = [super initWithSize:size])
	{
        /* Setup your scene here */
        
        BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        
		self.viewController = controller;
		self.name = NSStringFromClass([self class]);
		
		self.backgroundColor = [SKColor colorWithRed:120.f/255.f green:190.f/255.f blue:225.f/255.f alpha:1.000];
		
		NSString *imgName = [NSString stringWithFormat:@"GameName"];
        SKTexture *texture = [SKTexture textureWithImageNamed:imgName];
		
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];
		
        bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) + (isIPhone ? 60 : 200));
        
        [self addChild:bgImage];
    }
	
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
