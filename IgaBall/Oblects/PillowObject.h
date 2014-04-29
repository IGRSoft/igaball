//
//  PillowObject.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/27/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol PillowObjectDelegate <NSObject>

- (void)wasFallStart;

@end

@interface PillowObject : SKNode

@property (nonatomic, weak) id <PillowObjectDelegate> delegate;

- (CGSize)size;
- (void)activateObject;
- (void)deactivateObject;

@end
