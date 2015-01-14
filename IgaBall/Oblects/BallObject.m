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

@property (nonatomic) CGSize objectSize;

@end

@implementation BallObject

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		NSUInteger ballId = arc4random() % ballsCount;
		NSString *ballName = [NSString stringWithFormat:@"Ball%@", @(ballId)];
		
		SKTexture *texture = [SKTexture textureWithImageNamed:ballName];
		NSAssert(texture, @"Can't create texture for Ball: %@", ballName);
		if (!texture)
		{
			return nil;
		}
		
		_objectSize = texture.size;
		SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:texture size:self.objectSize];
		
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.objectSize.width / 5];
		physicsBody.dynamic = YES;
		physicsBody.categoryBitMask = ballCategory;
		physicsBody.contactTestBitMask = trampolineCategory;
		physicsBody.collisionBitMask = 0;
		physicsBody.usesPreciseCollisionDetection = YES;
		
		self.physicsBody = physicsBody;
		
		self.moveDuration = defaultDuration;
		
		[self addChild:node];
	}
	
	return self;
}

-(void)dealloc
{
	DBNSLog(@"DEALOC - BallObject");
	
	self.physicsBody = nil;
	[self removeAllChildren];
}

- (CGSize)size
{
	return _objectSize;
}

- (CGFloat)moveDuration
{
	CGFloat offset = arc4random() % 500 / 10000.f;
	
	_moveDuration -= offset;
	
	if (arc4random() % 5 == 0)
	{
		_moveDuration += 0.2;
	}
	
	if (arc4random() % 3 == 0)
	{
		_moveDuration -= 0.2;
	}
	
	_moveDuration = MAX(_moveDuration, 0.3);
	
	return _moveDuration;
}

@end
