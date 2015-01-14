//
//  IgaBallTests.m
//  IgaBallTests
//
//  Created by Korich on 4/24/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BallObject.h"
#import "TrampolineObject.h"

@interface IgaBallTests : XCTestCase

@end

@implementation IgaBallTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBall
{
	BallObject *ball = [[BallObject alloc] init];
	XCTAssertNotNil(ball, @"Can't crate ball.");
}

- (void)testTrampoline
{
	TrampolineObject *trampolineRight = [[TrampolineObject alloc] initWithDirection:TrampolineDirection_Right];
	XCTAssertNotNil(trampolineRight, @"Can't crate trampoline.");
	
	TrampolineObject *trampolineLeft = [[TrampolineObject alloc] initWithDirection:TrampolineDirection_Left];
	XCTAssertNotNil(trampolineLeft, @"Can't crate trampoline.");
}

@end
