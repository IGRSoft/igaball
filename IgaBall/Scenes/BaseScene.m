//
//  BaseScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 7/7/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "BaseScene.h"
#import "Constants.h"

@interface BaseScene (Protected)

@property (nonatomic, weak, readwrite) GameController *gameController;

@end

@implementation BaseScene

- (instancetype)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
	if (self = [super initWithSize:aSize])
	{
		self.gameController = gGameController;
		
		self.name = NSStringFromClass([self class]);
		
		self.backgroundColor = DEFAULT_BG_COLOR;
	}
	
	return self;
}

- (SKSpriteNode*)landscapeSpriteForSize:(CGSize)aSize
{
    NSString *imgName = @"bg_main";
    
    UIImage *bgImage = [UIImage imageNamed:imgName];
    SKTexture *texture = [SKTexture textureWithImage:bgImage];
    SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithTexture:texture size:aSize];
    
    bgSprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
    
    return bgSprite;
}

@end
