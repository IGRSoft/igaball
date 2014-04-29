//
//  BallObject.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/29/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "BallObject.h"
#import "Constants.h"

@interface BallObject () <SKPhysicsContactDelegate>

@property (nonatomic) SKTexture *texture;

@end

@implementation BallObject

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		NSUInteger ballId = arc4random() % ballsCount;
		NSString *ballName = [NSString stringWithFormat:@"Ball%@", @(ballId)];
		
		_texture = [SKTexture textureWithImageNamed:ballName];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:_texture size:_texture.size];
		
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_texture.size.width/5];
		physicsBody.dynamic = YES;
		physicsBody.categoryBitMask = ballCategory;
		physicsBody.contactTestBitMask = pillowCategory;
		physicsBody.collisionBitMask = 0;
		physicsBody.usesPreciseCollisionDetection = YES;
		
		self.physicsBody = physicsBody;
		
		[self addChild:node];
	}
	
	return self;
}

- (CGSize)size
{
	return _texture.size;
}

@end
