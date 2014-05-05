//
//  PillowObject.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/27/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "PillowObject.h"
#import "Constants.h"

@interface PillowObject ()

@property (nonatomic) SKTexture *texture;
@property (nonatomic, assign) CGFloat activationDuration;

@end

@implementation PillowObject

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_texture = [SKTexture textureWithImageNamed:@"Pillow"];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:_texture size:_texture.size];
		node.name = NSStringFromClass([PillowObject class]);
		
		self.alpha = 0.5f;
		
		self.activationDuration = defaultDuration / 2.f;
		
		[self addChild:node];
	}
	
	return self;
}

- (CGSize)size
{
	return _texture.size;
}

- (void)activateObject
{
	if (self.physicsBody)
	{
		return;
	}
	
	self.alpha = 1.f;
	
	SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_texture.size];
	physicsBody.dynamic = NO;
	physicsBody.categoryBitMask = pillowCategory;
	physicsBody.contactTestBitMask = ballCategory;
	physicsBody.collisionBitMask = 0;
	
	self.physicsBody = physicsBody;
	
	// deactivate Object after 1.5s or less
	
	CGFloat offset = arc4random() % 100 / 10000.f;
	_activationDuration -= offset;
	
	if (arc4random() % 5 == 0)
	{
		_activationDuration += 0.2;
	}
	
	_activationDuration = MAX(_activationDuration, 0.3);
	
	[self runAction:
	 [SKAction sequence:@[
						  [SKAction waitForDuration:_activationDuration],
						  [SKAction runBlock:^{
		 
		 // there are no colision
		 if (self.physicsBody)
		 {
			 if (self.delegate && [self.delegate respondsToSelector:@selector(wasFallStart)])
			 {
				 [self.delegate wasFallStart];
			 }
		 }
		 
		 self.physicsBody = nil;
		 self.alpha = 0.5f;
		 
	 }]
						  ]]
	 ];
}

- (void)deactivateObject
{
	if ([self hasActions])
	{
		[self removeAllActions];
	}
	
	self.physicsBody = nil;
	self.alpha = 0.5f;
}

@end
