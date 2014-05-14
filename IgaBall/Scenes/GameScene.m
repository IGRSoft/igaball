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

@interface GameScene () <SKPhysicsContactDelegate, PillowObjectDelegate>

@property (weak) GameController *viewController;
@property (strong) SKLabelNode  *scoreLabel;
@property (assign) BOOL isGameOver;
@property (nonatomic, assign) NSInteger score;
@property (assign) CGFloat borderOffset;
@property (strong) NSMutableArray *bals;

@end

#define PILLOWCOUNT 3
#define OFFSET_Y	40

@implementation GameScene

- (id)initWithSize:(CGSize)size controller:(GameController *)controller
{
	DBNSLog(@"%s", __func__);
	
    if (self = [super initWithSize:size])
	{
        /* Setup your scene here */
		
		self.physicsWorld.gravity = CGVectorMake(0,0);
		self.physicsWorld.contactDelegate = self;
		
		self.isGameOver = NO;
		self.score = -1;
		self.bals = [NSMutableArray array];
        
		self.viewController = controller;
		self.name = NSStringFromClass([self class]);
		
		self.backgroundColor = [SKColor colorWithRed:120.f/255.f green:190.f/255.f blue:225.f/255.f alpha:1.000];
		
		SKTexture *texture = [SKTexture textureWithImageNamed:@"Grass"];
		self.borderOffset = texture.size.width * 2;
		
        SKSpriteNode *grassRight = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];
		
        grassRight.position = CGPointMake(self.frame.size.width - texture.size.width * 0.5f,
                                       CGRectGetMidY(self.frame));
	
        [self addChild:grassRight];
		
		[self addPillowToFrame:grassRight.frame rotate:YES];
		
		SKSpriteNode *grassLeft = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];
		grassLeft.zRotation = M_PI;
        grassLeft.position = CGPointMake(texture.size.width * 0.5f,
										  CGRectGetMidY(self.frame));
        
        [self addChild:grassLeft];
		
		[self addPillowToFrame:grassLeft.frame rotate:NO];
		
		
		//Add offscreen Collision
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:texture.size];
		physicsBody.dynamic = NO;
		physicsBody.categoryBitMask = offScreenCategory;
		physicsBody.contactTestBitMask = ballCategory;
		physicsBody.collisionBitMask = 0;
		
		SKSpriteNode *offScreenNodeRight = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:texture.size];
		offScreenNodeRight.position = CGPointMake(grassRight.position.x + grassRight.size.width,
												  grassRight.position.y);
		
		SKSpriteNode *offScreenNodeLeft = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:texture.size];
		offScreenNodeLeft.position = CGPointMake(grassLeft.position.x - grassLeft.size.width,
												 grassLeft.position.y);
		
		offScreenNodeRight.physicsBody = [physicsBody copy];
		[self addChild:offScreenNodeRight];
		
		offScreenNodeLeft.physicsBody = [physicsBody copy];
		[self addChild:offScreenNodeLeft];
		
		// Add Score
		self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.scoreLabel.text = @"0";
        self.scoreLabel.fontSize = 20;
        self.scoreLabel.fontColor = [SKColor blackColor];
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
											   self.frame.size.height - 50.f);
        [self addChild:self.scoreLabel];
        
        self.score = 0;
    }
	
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.isGameOver)
	{
		return;
	}
	
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
	
    if ([node.name isEqualToString:NSStringFromClass([PillowObject class])])
	{
        NSLog(@"Pillow was touched!");
        PillowObject *pillow = (PillowObject *)node.parent;
		[pillow activateObjectWitDuration:YES];
    }
}

- (void)addPillowToFrame:(CGRect)rect rotate:(BOOL)rotate
{
	CGFloat iPhoneScale = 1.f;
    CGFloat yOffset = 90.f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        iPhoneScale = 0.5f;
        yOffset = 0.f;
    }
    
	for (NSUInteger i = 0 ; i < PILLOWCOUNT ; ++i)
	{
		PillowObject *pillow = [[PillowObject alloc] init];
		pillow.position = CGPointMake(CGRectGetMidX(rect) + (rotate ? -(15*iPhoneScale) : (15*iPhoneScale)),
									  yOffset + OFFSET_Y*iPhoneScale * i + pillow.size.height * (i + 1));
		
		pillow.delegate = self;
		
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
	
    NSInteger screeWidth = self.frame.size.width - self.borderOffset * 2;
	CGFloat minPos = self.borderOffset;
	CGFloat offset = arc4random() % screeWidth;
	ball.position = CGPointMake(minPos + offset,
								point.y);
    
	[self addChild:ball];
	
    [self.bals addObject:ball];
}

- (void)startMoveBall:(BallObject *)ball
{
    CGFloat screeCentre = CGRectGetMidX(self.frame);
    
    BallDiraction ballDiraction = ball.position.x > screeCentre ? BallDiractionLeft : BallDiractionRight;
	
	CGPoint realDest = CGPointMake(ball.position.x + (ballDiraction == BallDiractionLeft ? -(screeCentre * 2.f) : (screeCentre * 2.f)), ball.position.y);
	
	SKAction *actionMove = [self actionBall:ball destination:realDest];
    [ball runAction:[SKAction sequence:@[actionMove]]];
}

- (SKAction *)actionGameOver
{
	return [SKAction runBlock:^{
		
        self.viewController.score = self.score;
        [self.viewController setupGameOver];
	}];
}

- (SKAction *)actionBall:(BallObject *)ball destination:(CGPoint)destination
{
	CGFloat realMoveDuration = [ball moveDuration];
	
	CGFloat pi = (arc4random() % 2 == 0) ? -M_PI : M_PI;
	NSUInteger rotationCount = arc4random() % 5;
	
	SKAction *oneRevolution = [SKAction repeatAction:[SKAction rotateByAngle:pi*2 duration:rotationCount] count:5];
    SKAction *actionMove = [SKAction moveTo:destination duration:realMoveDuration];
	
	return [SKAction group:@[oneRevolution, actionMove]];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
	if (self.isGameOver)
	{
		return;
	}
	
    // 1
    SKPhysicsBody *firstBody, *secondBody;
	
	if (contact.bodyA.categoryBitMask == offScreenCategory || contact.bodyB.categoryBitMask == offScreenCategory)
	{
		[self runAction:[self actionGameOver]];
		
		self.isGameOver = YES;
		
		return;
	}
	
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
	
	++self.score;
    
	[ball removeAllActions];
	
	CGFloat screeCentre = CGRectGetMidX(self.frame);
	BallDiraction ballDiraction = ball.position.x > screeCentre ? BallDiractionLeft : BallDiractionRight;
	
	CGPoint realDest = CGPointMake(ball.position.x + (ballDiraction == BallDiractionLeft ? -(self.frame.size.width) : (self.frame.size.width)), ball.position.y);
	
	SKAction *actionMove = [self actionBall:ball destination:realDest];
    [ball runAction:[SKAction sequence:@[actionMove]]];
	
	[pillow deactivateObject];
    
    [self runAction:[SKAction playSoundFileNamed:@"pop.m4a" waitForCompletion:NO]];
}

- (void)wasFallStart
{
	--self.score;
}

- (void)setScore:(NSInteger)score
{
    if (score < self.bals.count && _score < score)
    {
        BallObject *newBall = self.bals[score];
        
        if (!newBall.hasActions)
        {
            [self startMoveBall:newBall];
        }
    }
    
    _score = score;
    
    dispatch_async(dispatch_get_main_queue(), ^{
		
		self.scoreLabel.text = [NSString stringWithFormat:@"%@", @(_score)];
	});
}

@end