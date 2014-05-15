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

@property () SKTexture *texture;
@property (assign) CGFloat activationDuration;
@property () SKEmitterNode *particleNode;
@property () SKSpriteNode *pillowNode;

@end

@implementation PillowObject

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_texture = [SKTexture textureWithImageNamed:@"Pillow"];
        _pillowNode = [SKSpriteNode spriteNodeWithTexture:_texture size:_texture.size];
		_pillowNode.name = NSStringFromClass([PillowObject class]);
		
		_pillowNode.alpha = 0.f;
		
		self.activationDuration = defaultDuration / 3.f;
		
		[self addChild:self.pillowNode];
        
        NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"PillowParticle" ofType:@"sks"];
        
        _particleNode = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
        _particleNode.position = CGPointZero;
        _particleNode.name = NSStringFromClass([PillowObject class]);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [_particleNode setScale:0.6];
        }
        
        [self addChild:self.particleNode];
	}
	
	return self;
}

- (CGSize)size
{
	return _texture.size;
}

- (void)activateObjectWitDuration:(BOOL)withDuration
{
	if (self.physicsBody)
	{
		return;
	}
	
	_pillowNode.alpha = 1.f;
	_particleNode.alpha = 0.f;
    
    CGSize size = CGSizeMake(_texture.size.width * 2.f, _texture.size.height);
	SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
	physicsBody.dynamic = NO;
	physicsBody.categoryBitMask = pillowCategory;
	physicsBody.contactTestBitMask = ballCategory;
	physicsBody.collisionBitMask = 0;
	
	self.physicsBody = physicsBody;
	
	// deactivate Object after 1.5s or less
	
    if (withDuration)
    {
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
             _pillowNode.alpha = 0.f;
             _particleNode.alpha = 1.f;
             
         }]
                              ]]
         ];
    }
}

- (void)deactivateObject
{
	if ([self hasActions])
	{
		[self removeAllActions];
	}
	
	self.physicsBody = nil;
	
    _pillowNode.alpha = 0.f;
    _particleNode.alpha = 1.f;
}

@end
