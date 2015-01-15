//
//  TrampolineObject.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/27/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "TrampolineObject.h"
#import "Constants.h"

@interface TrampolineObject ()

@property (nonatomic) SKTexture *texture;
@property (nonatomic, assign) CGFloat activationDuration;
@property (nonatomic) SKEmitterNode *particleNode;
@property (nonatomic) SKSpriteNode *trampolineNode;
@property (nonatomic) SKPhysicsBody *physicsBodyTemplate;

@end

@implementation TrampolineObject

- (id)initWithDirection:(TrampolineDirection)aDirection
{
	self = [super init];
	if (self != nil)
	{
		NSString *imgName = @"Trampoline";
		
		_texture = [SKTexture textureWithImageNamed:imgName];
		NSAssert(_texture, @"Can't create texture for Trampoline: %@", imgName);
		if (!_texture)
		{
			return nil;
		}
		
		_trampolineNode = [SKSpriteNode spriteNodeWithTexture:_texture size:_texture.size];
		_trampolineNode.name = NSStringFromClass([TrampolineObject class]);
		
		_trampolineNode.alpha = 0.f;
		
        switch (aDirection)
        {
            case TrampolineDirection_Right:
            {
                _trampolineNode.xScale = -1.0;
            }
                break;
            case TrampolineDirection_Left:
            default:
                break;
        }
        
		self.activationDuration = defaultDuration / 3.f;
		
		[self addChild:self.trampolineNode];
		
		NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"PillowParticle" ofType:@"sks"];
		
		_particleNode = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
		_particleNode.position = CGPointZero;
		_particleNode.name = NSStringFromClass([TrampolineObject class]);
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		{
			[_particleNode setScale:0.6];
		}
		
		[self addChild:self.particleNode];
		
		self.physicsBodyTemplate = [SKPhysicsBody bodyWithRectangleOfSize:_texture.size];
		self.physicsBodyTemplate.dynamic = NO;
		self.physicsBodyTemplate.categoryBitMask = trampolineCategory;
		self.physicsBodyTemplate.contactTestBitMask = ballCategory;
		self.physicsBodyTemplate.collisionBitMask = 0;
	}
	
	return self;
}

- (CGSize)size
{
	return _texture.size;
}

-(void)dealloc
{
	DBNSLog(@"DEALOC - TrampolineObject");
	
	self.physicsBodyTemplate = nil;
	[self.trampolineNode removeFromParent];
	[self.particleNode removeFromParent];
}

- (void)activateObjectWitDuration:(BOOL)withDuration
{
	if (self.physicsBody)
	{
		return;
	}
	
	_trampolineNode.alpha = 1.f;
	_particleNode.alpha = 0.f;
	
	self.physicsBody = [self.physicsBodyTemplate copy];
	
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
		_activationDuration -= 0.1;
		
		SKAction *blinkAction1 = [SKAction fadeAlphaTo:0.5f duration:0.20];
		SKAction *blinkAction2 = [SKAction fadeAlphaTo:1.f duration:0.20];
		SKAction *blinkAction3 = [SKAction fadeAlphaTo:0.3f duration:0.10];
		SKAction *blinkAction4 = [SKAction fadeAlphaTo:1.f duration:0.10];
		
		__weak TrampolineObject *weakSelf = self;
		[self runAction: [SKAction sequence:@[
											  [SKAction waitForDuration:_activationDuration],
											  blinkAction1, blinkAction2,
											  blinkAction3, blinkAction4, blinkAction3, blinkAction4,
											  [SKAction runBlock:^{
			
			// there are no colision
			if (weakSelf.physicsBody)
			{
				if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(wasFallStart)])
				{
					[weakSelf.delegate wasFallStart];
				}
			}
			
			weakSelf.physicsBody = nil;
			weakSelf.trampolineNode.alpha = 0.f;
			weakSelf.particleNode.alpha = 1.f;
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
	
	_trampolineNode.alpha = 0.f;
	_particleNode.alpha = 1.f;
}

@end
