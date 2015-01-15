//
//  BaseScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 7/7/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "BaseScene.h"
#import "Constants.h"
#import "SDiPhoneVersion.h"

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
    NSString *imgName = @"LaunchImage-700";
    
    BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    BOOL isIOS7 = iOSVersionLessThanOrEqualTo(@"7.1.2");
    
    if (isIPhone)
    {
        BOOL isIPhone5_6 = [SDiPhoneVersion deviceSize] > iPhone35inch;
        imgName = [imgName stringByAppendingString:isIPhone5_6 ? @"-568h" : @""];
    }
    else
    {
        imgName = [imgName stringByAppendingString:@"-Landscape"];
    }
    
    UIImage *bgImage = [UIImage imageNamed:imgName];
    SKTexture *texture = [SKTexture textureWithImage:bgImage];
    
    CGSize newSize = aSize;
    if (isIPhone && !isIOS7)
    {
        newSize = CGSizeMake(aSize.height, aSize.width);
    }
    
    SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithTexture:texture size:newSize];
    
    if (isIPhone)
    {
        bgSprite.zRotation = (M_PI / 2);
    }
    
    if (isIOS7)
    {
        bgSprite.position = CGPointMake(CGRectGetMidY(self.frame),
                                        CGRectGetMidX(self.frame));
    }
    else
    {
        bgSprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
    }
    
    return bgSprite;
}

@end
