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
		
		self.backgroundColor = DEFAULT_BG_COLOR;
		
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
