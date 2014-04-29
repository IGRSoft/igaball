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
	self.alpha = 1.f;
	
	SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_texture.size];
	physicsBody.dynamic = NO;
	physicsBody.categoryBitMask = pillowCategory;
	physicsBody.contactTestBitMask = ballCategory;
	physicsBody.collisionBitMask = 0;
	
	self.physicsBody = physicsBody;
	
	// deactivate Object after 0.5s
	[self runAction:
	 [SKAction sequence:@[
						  [SKAction waitForDuration:0.5],
						  [SKAction runBlock:^{
		 
		 self.physicsBody = nil;
		 self.alpha = 0.5f;
	 }]
						  ]]
	 ];
}

@end
