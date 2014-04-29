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
#import "BallObject.h"
#import "Constants.h"
#import "GameOverScene.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, weak) GameController *viewController;
@property (nonatomic, strong) SKLabelNode  *scoreLabel;

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
		
		self.physicsWorld.gravity = CGVectorMake(0,0);
		self.physicsWorld.contactDelegate = self;
		
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
		
		self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.scoreLabel.text = @"0";
        self.scoreLabel.fontSize = 20;
        self.scoreLabel.fontColor = [SKColor blackColor];
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
											   self.frame.size.height - 50.f);
        [self addChild:self.scoreLabel];
    }
	
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
	
    if ([node.name isEqualToString:NSStringFromClass([PillowObject class])])
	{
        NSLog(@"Pillow was touched!");
        PillowObject *pillow = (PillowObject *)node.parent;
		[pillow activateObject];
    }
}

- (void)addPillowToFrame:(CGRect)rect rotate:(BOOL)rotate
{
	for (NSUInteger i = 0 ; i < PILLOWCOUNT ; ++i)
	{
		PillowObject *pillow = [[PillowObject alloc] init];
		pillow.position = CGPointMake(CGRectGetMidX(rect) + (rotate ? 15 : -15),
									  MAGICNUMBER * i + pillow.size.height * (i + 1));
		
		[self addChild:pillow];
		
		if (rotate)
		{
			pillow.zRotation = M_PI;
			[self addBallToPoint:pillow.position];
		}
	}
}

- (void)addBallToPoint:(CGPoint)point
{
	BallObject *ball = [[BallObject alloc] init];
	
	CGFloat screeCentre = CGRectGetMidX(self.frame);
	CGFloat minPos = screeCentre - 100;
	CGFloat offset = arc4random() % 200;
	ball.position = CGPointMake(minPos + offset,
								point.y);
	
	[self addChild:ball];
	
	BallDiraction ballDiraction = arc4random() % 2;
	
	CGPoint realDest = CGPointMake(ball.position.x + (ballDiraction == BallDiractionLeft ? -screeCentre : screeCentre), ball.position.y);
	
	float realMoveDuration = 2.f;
    SKAction *actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
	SKAction *actionGameOver = [self actionGameOver];
	
    [ball runAction:[SKAction sequence:@[actionMove, actionGameOver]]];
}

- (SKAction *) actionGameOver
{
	return [SKAction runBlock:^{
		// 5
		SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
		GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size controller:self.viewController score:[self.scoreLabel.text integerValue]];
		[self.view presentScene:gameOverScene transition: reveal];
	}];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
	
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
	
    // 2
    if ((firstBody.categoryBitMask & ballCategory) != 0 &&
        (secondBody.categoryBitMask & pillowCategory) != 0)
    {
        [self ball:(BallObject *)firstBody.node didCollideWithPillow:(PillowObject *)secondBody.node];
    }
}

- (void)ball:(BallObject *)ball didCollideWithPillow:(PillowObject *)pillow
{
	DBNSLog(@"%s", __func__);
	
	@synchronized(self.scoreLabel)
	{
		NSUInteger integerValue = [self.scoreLabel.text integerValue];
		++integerValue;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			self.scoreLabel.text = [NSString stringWithFormat:@"%@", @(integerValue)];
		});
	}
	
	CGFloat screeCentre = CGRectGetMidX(self.frame);
	BallDiraction ballDiraction = ball.position.x > screeCentre ? BallDiractionLeft : BallDiractionRight;
	
	CGPoint realDest = CGPointMake(ball.position.x + (ballDiraction == BallDiractionLeft ? -(self.frame.size.width) : (self.frame.size.width)), ball.position.y);
	
	float realMoveDuration = 2.f;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction *actionGameOver = [self actionGameOver];
	
    [ball runAction:[SKAction sequence:@[actionMove, actionGameOver]]];
}

@end