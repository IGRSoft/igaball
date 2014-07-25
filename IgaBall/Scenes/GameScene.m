//
//  GameScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/26/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameScene.h"
#import "PillowObject.h"
#import "BallObject.h"
#import "Constants.h"
#import "ShadowLabelNode.h"

@interface GameScene () <SKPhysicsContactDelegate, PillowObjectDelegate>

@property () SKLabelNode  *scoreLabel;
@property () SKShapeNode  *scoreBorder;

@property (assign) BOOL isGameOver;
@property (nonatomic, assign) NSInteger score;
@property (assign) CGFloat borderOffset;

@property (assign) BOOL useSound;

@property () NSMutableArray *bals;

@end

#define PILLOWCOUNT 3
#define OFFSET_Y	0

@implementation GameScene

- (id)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{
    DBNSLog(@"%s", __func__);
    
    if (self = [super initWithSize:aSize gameController:gGameController])
	{
        BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        
		self.name = NSStringFromClass([self class]);
		
		SKTexture *texture = nil;
		if (isIPhone)
		{
            BOOL isIPhone5 = (([[UIScreen mainScreen] bounds].size.height - 568.f)? NO : YES);
            NSString *imgName = [NSString stringWithFormat:@"bg_game%@", isIPhone5 ? @"-568h" : @""];
			texture = [SKTexture textureWithImageNamed:imgName];
		}
		else
		{
			texture = [SKTexture textureWithImageNamed:@"bg_game"];
		}
        
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:texture size:aSize];
        
        if (isIPhone)
        {
            bgImage.zRotation = M_PI / 2;
            
            bgImage.position = CGPointMake(CGRectGetMidY(self.frame),
                                           CGRectGetMidX(self.frame));
        }
        else
        {
            bgImage.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
        }
        
        [self addChild:bgImage];
        
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        self.useSound = [ud boolForKey:kUseSound];
        
		self.physicsWorld.gravity = CGVectorMake(0,0);
		self.physicsWorld.contactDelegate = self;
		
		self.isGameOver = NO;
		self.score = -1;
		self.bals = [NSMutableArray array];
        
		self.name = NSStringFromClass([self class]);
		
		self.backgroundColor = DEFAULT_BG_COLOR;
		
		self.borderOffset = 50.f;
        
        CGPoint borderPoint = CGPointMake(self.frame.size.width - self.borderOffset,
                                       CGRectGetMidY(self.frame));
        CGRect borderRect = CGRectMake(borderPoint.x, borderPoint.y, self.borderOffset * 0.5, aSize.height);
        
        SKSpriteNode *offScreenNodeRight = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:borderRect.size];
		offScreenNodeRight.position = CGPointMake(borderPoint.x + self.borderOffset,
												  borderPoint.y);
        
		[self addPillowToFrame:borderRect rotate:YES];
        
        borderPoint = CGPointMake(self.borderOffset * 0.5,
                                  CGRectGetMidY(self.frame));
        borderRect = CGRectMake(borderPoint.x, borderPoint.y, self.borderOffset * 0.5, aSize.height);
		
        SKSpriteNode *offScreenNodeLeft = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:borderRect.size];
		offScreenNodeLeft.position = CGPointMake(borderPoint.x - self.borderOffset,
												 borderPoint.y);
        
		[self addPillowToFrame:borderRect rotate:NO];
		
		//Add offscreen Collision
		SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:borderRect.size];
		physicsBody.dynamic = NO;
		physicsBody.categoryBitMask = offScreenCategory;
		physicsBody.contactTestBitMask = ballCategory;
		physicsBody.collisionBitMask = 0;
		
		offScreenNodeRight.physicsBody = [physicsBody copy];
		[self addChild:offScreenNodeRight];
		
		offScreenNodeLeft.physicsBody = [physicsBody copy];
		[self addChild:offScreenNodeLeft];
		
		// Add Score
        self.scoreBorder = [SKShapeNode node];
        self.scoreBorder.lineWidth = 5;
        self.scoreBorder.strokeColor = [UIColor whiteColor];
        self.scoreBorder.position = CGPointMake(CGRectGetMidX(self.frame),
											   self.frame.size.height - 47.f);
        
        [self addChild:self.scoreBorder];
        
        CGFloat titleFontSize = isIPhone ? 30.f : 50.f;
        
		self.scoreLabel = [ShadowLabelNode labelNodeWithFontNamed:kDefaultFont];
        self.scoreLabel.fontSize = titleFontSize;
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
											   self.frame.size.height - 100.f);
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
    CGFloat yOffset = 20.f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        iPhoneScale = 0.5f;
        yOffset = 0.f;
    }
    
	for (NSUInteger i = 0 ; i < PILLOWCOUNT ; ++i)
	{
		PillowObject *pillow = [[PillowObject alloc] init];
		pillow.position = CGPointMake(CGRectGetMidX(rect) + (rotate ? -(15*iPhoneScale) : (15*iPhoneScale)),
									  yOffset + OFFSET_Y*iPhoneScale * i + pillow.size.height * (i + 1) - pillow.size.height * 0.5);
		
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
	
    NSInteger screeWidth = self.frame.size.width - self.borderOffset * 4;
	CGFloat minPos = self.borderOffset;
	CGFloat offset = arc4random() % screeWidth;
	ball.position = CGPointMake(minPos + offset,
								point.y);
    
	[self addChild:ball];
	
    //[self.bals addObject:ball];
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
    
    if (self.useSound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self runAction:[SKAction playSoundFileNamed:@"pop.m4a" waitForCompletion:NO]];
        });
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
        
        CGFloat height = 70.f;
        CGFloat width = 70.f;
        
        if (score >= 1000)
        {
            width = 130;
        }
        else if (score >= 100)
        {
            width = 110;
        }
        else if (score >= 10)
        {
            width = 90;
        }
        
        CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(-(width*0.5), -height, width, height), (height*0.5), (height*0.5), nil);
        [self.scoreBorder setPath:path];
        CGPathRelease(path);
	});
}

@end
