//
//  GameScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameScene.h"
#import "TrampolineObject.h"
#import "BallObject.h"
#import "Constants.h"
#import "ShadowLabelNode.h"
#import "SoundMaster.h"

@interface GameScene () <SKPhysicsContactDelegate, TrampolineObjectDelegate>

@property (nonatomic) ShadowLabelNode  *scoreLabel;
@property (nonatomic) SKShapeNode  *scoreBorder;
@property (nonatomic) SKShapeNode  *scoreBorderShadow;
@property (nonatomic) SKSpriteNode *bgImage;

@property (nonatomic) SKSpriteNode *offScreenNodeLeft;
@property (nonatomic) SKSpriteNode *offScreenNodeRight;

@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) CGFloat borderOffset;

@property (nonatomic, assign) BOOL useSound;

@property (nonatomic) SKAction *collisionSound;

@property (nonatomic) NSMutableArray *balls;
@property (nonatomic) NSMutableArray *trampolines;

@end

#define TRAMPOLINECOUNT 3
#define OFFSET_Y		20.0

@implementation GameScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
	DBNSLog(@"%s", __func__);
	
	if (self = [super initWithSize:aSize gameController:gGameController])
	{
		BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
		
        // Background
		SKTexture *texture = [SKTexture textureWithImageNamed:@"bg_game"];
		
		_bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:aSize];
		_bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
										CGRectGetMidY(self.frame));
		_bgImage.zPosition = kPositionZBGImage;
		[self addChild:_bgImage];
		
		// Game Score
		self.isGameOver = NO;
		self.score = -1;
		
		CGFloat titleFontSize = isIPhone ? 30.0 : 50.0;
		
		self.scoreLabel = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
		self.scoreLabel.fontSize = titleFontSize;
		self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
											   self.frame.size.height - (isIPhone ? 40.0 : 100.0));
		self.scoreLabel.zPosition = kPositionZLabels;
		[self addChild:self.scoreLabel];
		
		self.scoreBorder = [SKShapeNode node];
		self.scoreBorder.lineWidth = isIPhone ? 3.0 : 5.0;
		self.scoreBorder.strokeColor = [UIColor whiteColor];
		self.scoreBorder.zPosition = kPositionZLabels;
		
		self.scoreBorderShadow = [self.scoreBorder copy];
		self.scoreBorderShadow.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
		self.scoreBorderShadow.glowWidth = 3.0;
		self.scoreBorderShadow.position = CGPointMake(1.0, -1.0);
		self.scoreBorderShadow.zPosition = kPositionZLabels - 1;
		
		[self.scoreLabel addChild:self.scoreBorder];
		[self.scoreLabel addChild:self.scoreBorderShadow];
		
        // Sound
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		self.useSound = [ud boolForKey:kUseSound];
		
        self.collisionSound = [SKAction runBlock:^{
            
            [[SoundMaster sharedMaster] playEffect:@"pop.m4a"];
        }];
        
        // Setup Game Objects
		self.balls = [NSMutableArray array];
        self.trampolines = [NSMutableArray array];
        
		_offScreenNodeRight = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor]
                                                           size:self.frame.size];
		_offScreenNodeRight.position = CGPointMake(self.frame.origin.x + self.frame.size.width + CGRectGetMidX(self.frame),
												   CGRectGetMidY(self.frame));
        _offScreenNodeRight.zPosition = kPositionZBall;
        
        _offScreenNodeLeft = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor]
                                                          size:self.frame.size];
        _offScreenNodeLeft.position = CGPointMake(self.frame.origin.x - CGRectGetMidX(self.frame),
                                                  CGRectGetMidY(self.frame));
        _offScreenNodeLeft.zPosition = kPositionZBall;
        
        self.borderOffset = 50.0;
        CGPoint borderPoint = CGPointMake(self.frame.size.width - self.borderOffset,
                                          CGRectGetMidY(self.frame));
        CGRect borderRect = CGRectMake(borderPoint.x, borderPoint.y, self.borderOffset * 0.5, aSize.height);
		[self addTrampolineToFrame:borderRect rotate:YES];
		
		borderPoint = CGPointMake(self.borderOffset * 0.5,
								  CGRectGetMidY(self.frame));
		borderRect = CGRectMake(borderPoint.x, borderPoint.y, self.borderOffset * 0.5, aSize.height);
		
		[self addTrampolineToFrame:borderRect rotate:NO];
		
        // Game Scene Phisics
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
		//Add offscreen Collision
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
		physicsBody.dynamic = NO;
		physicsBody.categoryBitMask = offScreenCategory;
		physicsBody.contactTestBitMask = ballCategory;
		physicsBody.collisionBitMask = 0;
		
		_offScreenNodeRight.physicsBody = [physicsBody copy];
		[self addChild:_offScreenNodeRight];
		
		_offScreenNodeLeft.physicsBody = [physicsBody copy];
		[self addChild:_offScreenNodeLeft];
		
		self.score = 0;
	}
	
	return self;
}

- (void)dealloc
{
	[self removeAllChildren];
}

- (void)clean
{
	[self.scoreBorder removeFromParent];
	self.scoreBorder = nil;
	[self.scoreBorderShadow removeFromParent];
	self.scoreBorderShadow = nil;
	[self.scoreLabel removeFromParent];
	self.scoreLabel = nil;
	
    [self.balls makeObjectsPerformSelector:@selector(removeAllActions)];
    [self.balls makeObjectsPerformSelector:@selector(removeFromParent)];
	[self.balls removeAllObjects];
	
    [self.trampolines makeObjectsPerformSelector:@selector(removeAllActions)];
    [self.trampolines makeObjectsPerformSelector:@selector(removeFromParent)];
	[self.trampolines removeAllObjects];
	
    // need release memory (iPhone issue)
	[self.bgImage removeFromParent];
	self.bgImage = nil;
	
	[self.offScreenNodeRight removeAllActions];
	[self.offScreenNodeRight removeFromParent];
	[self.offScreenNodeLeft removeAllActions];
	[self.offScreenNodeLeft removeFromParent];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

#pragma mark - Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.isGameOver)
	{
		return;
	}
	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInNode:self];
	SKNode *node = [self nodeAtPoint:location];
	
	if ([node.name isEqualToString:NSStringFromClass([TrampolineObject class])])
	{
		DBNSLog(@"Trampoline was touched!");
		TrampolineObject *trampoline = (TrampolineObject *)node.parent;
		[trampoline activateObjectWitDuration:YES];
	}
}

#pragma mark - Add Game objects to scene

- (void)addTrampolineToFrame:(CGRect)rect rotate:(BOOL)rotate
{
	BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
	CGFloat x = CGRectGetMidX(rect) + (rotate ? -15 : 15);
	CGFloat y = OFFSET_Y;
	
	if (isIPhone)
	{
		x = CGRectGetMidX(rect) + (rotate ? 15 : -15);
		y *= 0.5;
	}

	rect.origin.y = y;
	rect.size.height = self.scoreLabel.position.y - rect.origin.y;
	
	CGFloat frameHeight = rect.size.height / TRAMPOLINECOUNT;
	
	for (NSUInteger i = 0 ; i < TRAMPOLINECOUNT ; ++i)
	{
		TrampolineObject *trampoline = [[TrampolineObject alloc] initWithDirection:(rotate ? TrampolineDirection_Right : TrampolineDirection_Left)];
		trampoline.position = CGPointMake(x,
										  rect.origin.y + frameHeight * i + frameHeight * 0.5);
		
		trampoline.delegate = self;
		trampoline.zPosition = kPositionZTrampoline;
		[self addChild:trampoline];
		
		if (rotate)
		{
			[self addBallToPoint:trampoline.position];
		}
		
		[self.trampolines addObject:trampoline];
	}
}

- (void)addBallToPoint:(CGPoint)point
{
	BallObject *ball = [[BallObject alloc] init];
	
	NSInteger screeWidth = self.frame.size.width - self.borderOffset * 4;
	CGFloat minPos = self.borderOffset * 2;
	CGFloat offset = arc4random() % screeWidth;
	ball.position = CGPointMake(minPos + offset,
								point.y);
	ball.zPosition = kPositionZBall;
	[self addChild:ball];
	
	[self.balls addObject:ball];
}

#pragma mark - Game objects Actions

- (void)startMoveBall:(BallObject *)ball
{
	CGFloat screeCentre = CGRectGetMidX(self.frame);
	
	BallDiraction ballDiraction = ball.position.x > screeCentre ? BallDiractionLeft : BallDiractionRight;
	
	CGPoint realDest = CGPointMake(ball.position.x + (ballDiraction == BallDiractionLeft ? -(screeCentre * 2.0) : (screeCentre * 2.0)),
                                   ball.position.y);
	
	SKAction *actionMove = [self actionBall:ball destination:realDest];
	[ball runAction:[SKAction sequence:@[actionMove]]];
}

- (SKAction *)actionGameOver
{
	__weak GameScene *weakSelf = self;
	return [SKAction runBlock:^{
		
		[weakSelf.gameController setupGameOverWithScore:_score];
	}];
}

- (SKAction *)actionBall:(BallObject *)ball destination:(CGPoint)destination
{
	CGFloat realMoveDuration = [ball moveDuration];
	
	CGFloat pi = (arc4random() % 2 == 0) ? -M_PI : M_PI;
	NSUInteger rotationCount = arc4random() % 5;
	
	SKAction *oneRevolution = [SKAction repeatAction:[SKAction rotateByAngle:pi*2 duration:rotationCount] count:99];
	SKAction *actionMove = [SKAction moveTo:destination duration:realMoveDuration];
	
	return [SKAction group:@[oneRevolution, actionMove]];
}

- (void)wasFallStart
{
    --self.score;
}

#pragma mark - Game Over

- (void)setScore:(NSInteger)score
{
    if (score < self.balls.count && _score < score)
    {
        BallObject *newBall = self.balls[score];
        
        if (!newBall.hasActions)
        {
            [self startMoveBall:newBall];
        }
    }
    
    _score = score;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.scoreLabel.text = [NSString stringWithFormat:@"%@", @(_score)];
        
        BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        
        CGFloat height = isIPhone ? 40.0 : 70.0;
        CGFloat width = isIPhone ? 40.0 : 70.0;
        
        if (score >= 1000)
        {
            width = isIPhone ? 100.0 :130.0;
        }
        else if (score >= 100)
        {
            width = isIPhone ? 80.0 :110.0;
        }
        else if (score >= 10)
        {
            width = isIPhone ? 60.0 : 90.0;
        }
        
        CGRect borderRect = CGRectMake(-(width*0.5), -(height*0.25) + self.scoreBorder.lineWidth * 0.5,
                                       width, height);
        
        CGPathRef path = CGPathCreateWithRoundedRect(borderRect, (height*0.5), (height*0.5), nil);
        [self.scoreBorder setPath:path];
        [self.scoreBorderShadow setPath:path];
        CGPathRelease(path);
    });
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
	if (self.isGameOver)
	{
		return;
	}
	
	// check ball on scene
	SKPhysicsBody *firstBody, *secondBody;
	
	if (contact.bodyA.categoryBitMask == offScreenCategory || contact.bodyB.categoryBitMask == offScreenCategory)
	{
		[self runAction:[self actionGameOver]];
		
		[self clean];
		
		self.isGameOver = YES;
		
		return;
	}
	
    // check collision
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
	
	if ((firstBody.categoryBitMask & ballCategory) != 0 &&
		(secondBody.categoryBitMask & trampolineCategory) != 0)
	{
		[self ball:(BallObject *)firstBody.node didCollideWithTrampoline:(TrampolineObject *)secondBody.node];
	}
}

- (void)ball:(BallObject *)ball didCollideWithTrampoline:(TrampolineObject *)trampoline
{
	DBNSLog(@"%s", __func__);
	
	++self.score;
	
	[ball removeAllActions];
	
	CGFloat screeCentre = CGRectGetMidX(self.frame);
	BallDiraction ballDiraction = ball.position.x > screeCentre ? BallDiractionLeft : BallDiractionRight;
	
	CGPoint realDest = CGPointMake(ball.position.x + (ballDiraction == BallDiractionLeft ? -(self.frame.size.width) : (self.frame.size.width)), ball.position.y);
	
	SKAction *actionMove = [self actionBall:ball destination:realDest];
	[ball runAction:[SKAction sequence:@[actionMove]]];
	
	[trampoline deactivateObject];
	
	if (self.useSound)
	{
		[trampoline runAction:self.collisionSound];
	}
}

@end
