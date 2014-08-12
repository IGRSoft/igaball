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

@interface TrampolineObject : SKNode

- (id)initLeftOrRight:(BOOL)aLeft;

@property (nonatomic, weak) id <TrampolineObjectDelegate> delegate;

- (CGSize)size;
- (void)activateObjectWitDuration:(BOOL)withDuration;
- (void)deactivateObject;

@end
