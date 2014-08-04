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

@property () ShadowLabelNode  *scoreLabel;
@property () SKShapeNode  *scoreBorder;
@property () SKShapeNode  *scoreBorderShadow;
@property () SKSpriteNode *bgImage;

@property () SKSpriteNode *offScreenNodeLeft;
@property () SKSpriteNode *offScreenNodeRight;

@property (assign) BOOL isGameOver;
@property (nonatomic, assign) NSInteger score;
@property (assign) CGFloat borderOffset;

@property (assign) BOOL useSound;

@property () SKAction *collisionSound;

@property () NSMutableArray *bals;
@property () NSMutableArray *trampolines;

@end

#define TRAMPOLINECOUNT 3
#define OFFSET_Y	20

@implementation GameScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
    DBNSLog(@"%s", __func__);
    
    if (self = [super initWithSize:aSize gameController:gGameController])
	{
        BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        
		SKTexture *texture = [SKTexture textureWithImageNamed:@"bg_game"];
        
        _bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:aSize];
        
        _bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        _bgImage.zPosition = kPositionZBGImage;
        [self addChild:_bgImage];
        
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        self.useSound = [ud boolForKey:kUseSound];
        
		self.physicsWorld.gravity = CGVectorMake(0,0);
		self.physicsWorld.contactDelegate = self;
		
		self.isGameOver = NO;
		self.score = -1;
        
		self.bals = [NSMutableArray array];
        self.trampolines = [NSMutableArray array];
        
		self.backgroundColor = DEFAULT_BG_COLOR;
		
		self.borderOffset = 50.f;
        
        CGPoint borderPoint = CGPointMake(self.frame.size.width - self.borderOffset,
                                       CGRectGetMidY(self.frame));
        CGRect borderRect = CGRectMake(borderPoint.x, borderPoint.y, self.borderOffset * 0.5, aSize.height);
        
        _offScreenNodeRight = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(CGRectGetWidth(self.frame), borderRect.size.height)];
		_offScreenNodeRight.position = CGPointMake(borderPoint.x + self.borderOffset,
												  borderPoint.y);
        
		[self addTrampolineToFrame:borderRect rotate:YES];
        
        borderPoint = CGPointMake(self.borderOffset * 0.5,
                                  CGRectGetMidY(self.frame));
        borderRect = CGRectMake(borderPoint.x, borderPoint.y, self.borderOffset * 0.5, aSize.height);
		
        _offScreenNodeLeft = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(CGRectGetWidth(self.frame), borderRect.size.height)];
		_offScreenNodeLeft.position = CGPointMake(borderPoint.x - self.borderOffset,
												 borderPoint.y);
        
		[self addTrampolineToFrame:borderRect rotate:NO];
		
		//Add offscreen Collision
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:borderRect.size];
		physicsBody.dynamic = NO;
		physicsBody.categoryBitMask = offScreenCategory;
		physicsBody.contactTestBitMask = ballCategory;
		physicsBody.collisionBitMask = 0;
		
		_offScreenNodeRight.physicsBody = [physicsBody copy];
		[self addChild:_offScreenNodeRight];
		
		_offScreenNodeLeft.physicsBody = [physicsBody copy];
		[self addChild:_offScreenNodeLeft];
		
		// Add Score
        
        CGFloat titleFontSize = isIPhone ? 30.f : 50.f;
        
		self.scoreLabel = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
        self.scoreLabel.fontSize = titleFontSize;
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
											   self.frame.size.height - (isIPhone ? 40 : 100.f));
        self.scoreLabel.zPosition = kPositionZLabels;
        [self addChild:self.scoreLabel];
        
        self.scoreBorder = [SKShapeNode node];
        self.scoreBorder.lineWidth = isIPhone ? 3 : 5.f;
        self.scoreBorder.strokeColor = [UIColor whiteColor];
        self.scoreBorder.zPosition = kPositionZLabels;
        
        self.scoreBorderShadow = [self.scoreBorder copy];
        self.scoreBorderShadow.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.scoreBorderShadow.glowWidth = 3;
        self.scoreBorderShadow.position = CGPointMake(1, -1);
        self.scoreBorderShadow.zPosition = kPositionZLabels - 1;
        
        [self.scoreLabel addChild:self.scoreBorder];
        [self.scoreLabel addChild:self.scoreBorderShadow];
        
        self.score = 0;
        
        self.collisionSound = [SKAction runBlock:^{
            
            [[SoundMaster sharedMaster] playEffect:@"pop.m4a"];
        }];
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
    
    for (BallObject *bal in self.bals)
    {
        [bal removeAllActions];
        [bal removeFromParent];
    }
    [self.bals removeAllObjects];
    
    for (TrampolineObject *trampoline in self.trampolines)
    {
        [trampoline removeAllActions];
        [trampoline removeFromParent];
    }
    [self.trampolines removeAllObjects];
    
    BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    BOOL isIPhone5 = (([[UIScreen mainScreen] bounds].size.height - 568.f)? NO : YES);
    
    if (isIPhone && !isIPhone5)
    {
        [self.bgImage removeFromParent];
        self.bgImage = nil;
    }
    
    [self.offScreenNodeRight removeAllActions];
    [self.offScreenNodeRight removeFromParent];
    [self.offScreenNodeLeft removeAllActions];
    [self.offScreenNodeLeft removeFromParent];
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
	
    if ([node.name isEqualToString:NSStringFromClass([TrampolineObject class])])
	{
        NSLog(@"Trampoline was touched!");
        TrampolineObject *trampoline = (TrampolineObject *)node.parent;
		[trampoline activateObjectWitDuration:YES];
    }
}

- (void)addTrampolineToFrame:(CGRect)rect rotate:(BOOL)rotate
{
	CGFloat iPhoneScale = 1.f;
    CGFloat yOffset = 10.f;
    
    BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    
    if (isIPhone)
    {
        iPhoneScale = 0.5f;
        yOffset = -40.f;
    }
    
	for (NSUInteger i = 0 ; i < TRAMPOLINECOUNT ; ++i)
	{
        CGFloat x = CGRectGetMidX(rect) + (rotate ? -15 : 15);
        if (isIPhone)
        {
            x = CGRectGetMidX(rect) + (rotate ? 15 : -15);
        }
        
		TrampolineObject *trampoline = [[TrampolineObject alloc] initLeftOrRight:rotate];
		trampoline.position = CGPointMake(x,
									  yOffset + OFFSET_Y*iPhoneScale * i + trampoline.size.height * (i + 1));
		
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
        
        [self clean];
        
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
        
        BOOL isIPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        
        CGFloat height = isIPhone ? 40.f : 70.f;
        CGFloat width = isIPhone ? 40.f : 70.f;
        
        if (score >= 1000)
        {
            width = isIPhone ? 100.f :130;
        }
        else if (score >= 100)
        {
            width = isIPhone ? 80.f :110;
        }
        else if (score >= 10)
        {
            width = isIPhone ? 60.f : 90;
        }
        
        CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(-(width*0.5), -(height*0.25) + self.scoreBorder.lineWidth * 0.5, width, height), (height*0.5), (height*0.5), nil);
        [self.scoreBorder setPath:path];
        [self.scoreBorderShadow setPath:path];
        CGPathRelease(path);
	});
}

@end
