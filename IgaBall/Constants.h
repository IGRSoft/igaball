//
//  Constants.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/27/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#ifndef IgaBall_Constants_h
#define IgaBall_Constants_h

static const uint32_t pillowCategory     = 0x1 << 0;
static const uint32_t ballCategory       = 0x1 << 1;

static const NSUInteger ballsCount		 = 5;

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

#endif
