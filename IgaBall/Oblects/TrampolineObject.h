//
//  TrampolineObject.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/27/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol TrampolineObjectDelegate <NSObject>

- (void)wasFallStart;

@end

typedef NS_ENUM(NSUInteger, TrampolineDirection)
{
	TrampolineDirection_Left  = 1 << 0,
	TrampolineDirection_Right = 1 << 1
};

@interface TrampolineObject : SKNode

- (id)initWithDirection:(TrampolineDirection)aDirection;

@property (nonatomic, weak) id <TrampolineObjectDelegate> delegate;

- (CGSize)size;
- (void)activateObjectWitDuration:(BOOL)withDuration;
- (void)deactivateObject;

@end
