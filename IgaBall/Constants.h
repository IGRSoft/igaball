//
//  Constants.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/27/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#ifndef IgaBall_Constants_h
#define IgaBall_Constants_h

static const uint32_t trampolineCategory    = 0x1 << 0;
static const uint32_t ballCategory			= 0x1 << 1;
static const uint32_t offScreenCategory		= 0x1 << 2;

static const NSUInteger ballsCount		 = 5;
static const CGFloat defaultDuration	 = 3.f;

typedef NS_ENUM(NSUInteger, BallDiraction)
{
	BallDiractionLeft	= 0,
	BallDiractionRight	= 0x1 << 0,
};

typedef NS_ENUM(NSUInteger, GameScheme)
{
	GameScheme1	= 0,
	GameScheme2	= 0x1 << 0,
};

#define kLeaderboardID @"com.igrsoft.IgaBallLeaderboard"

#define kAchievement10ID   @"10points"
#define kAchievement25ID   @"25points"
#define kAchievement50ID   @"50points"
#define kAchievement75ID   @"75points"
#define kAchievement100ID  @"100points"
#define kAchievement200ID  @"200points"
#define kAchievement1000ID @"1000points"

#define kAchievementCount  7

#define kUserDefaultsTotalBits @"TotalBits"

#define DEFAULT_BG_COLOR [SKColor colorWithRed:30.f/255.f green:193.f/255.f blue:239.f/255.f alpha:1.000]

static NSString * const kDefaultFont = @"Sniglet";
static NSString * const kUseSound = @"UseSound";

#define kPositionZBGImage       1
#define kPositionZBall          2
#define kPositionZTrampoline    2
#define kPositionZLabels        10

#endif
