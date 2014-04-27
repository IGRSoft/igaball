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
        
        [self addChild:node];
		
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_texture.size];
		physicsBody.dynamic = NO;
		physicsBody.categoryBitMask = pillowCategory;
		physicsBody.contactTestBitMask = ballCategory;
		physicsBody.collisionBitMask = 0;
		physicsBody.usesPreciseCollisionDetection = YES;
		
		node.physicsBody = physicsBody;
	}
	
	return self;
}

- (CGSize)size
{
	return _texture.size;
}

@end
