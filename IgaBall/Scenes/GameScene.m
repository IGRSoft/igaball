//
//  GameScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameScene.h"
#import "GameController.h"
#import "PillowObject.h"

@interface GameScene ()

@property (nonatomic, weak) GameController *viewController;

@end

#define PILLOWCOUNT 4
#define MAGICNUMBER 40

@implementation GameScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller
{
	DBNSLog(@"%s", __func__);
	
    if (self = [super initWithSize:size])
	{
        /* Setup your scene here */
		self.viewController = controller;
		self.name = NSStringFromClass([self class]);
		
		self.backgroundColor = [UIColor colorWithRed:210.f/255.f green:170.f/255.f blue:220.f/255.f alpha:1.f];
		
		SKTexture *texture = texture = [SKTexture textureWithImageNamed:@"Grass"];
        SKSpriteNode *grassRight = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];
		
        grassRight.position = CGPointMake(self.frame.size.width - texture.size.width * 0.5f,
                                       CGRectGetMidY(self.frame));
        
        [self addChild:grassRight];
		
		[self addPillowToFrame:grassRight.frame rotate:NO];
		
		SKSpriteNode *grassLeft = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];
		grassLeft.zRotation = M_PI;
        grassLeft.position = CGPointMake(texture.size.width * 0.5f,
										  CGRectGetMidY(self.frame));
        
        [self addChild:grassLeft];
		
		[self addPillowToFrame:grassLeft.frame rotate:YES];
    }
	
    return self;
}

- (void)addPillowToFrame:(CGRect)rect rotate:(BOOL)rotate
{
	for (NSUInteger i = 0 ; i < PILLOWCOUNT ; ++i)
	{
		PillowObject *pillow = [[PillowObject alloc] init];
		pillow.position = CGPointMake(CGRectGetMidX(rect) + (rotate ? 15 : -15),
									  MAGICNUMBER * i + pillow.size.height * (i + 1));
		
		if (rotate)
		{
			pillow.zRotation = M_PI;
		}
		
		[self addChild:pillow];
	}
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end