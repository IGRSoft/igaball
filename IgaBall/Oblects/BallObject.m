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

@property () SKTexture *texture;

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
	return _texture.size;
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
