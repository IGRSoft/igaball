//
//  BallObject.h
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 4/29/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BallObject : SKNode

@property (nonatomic, assign) CGFloat moveDuration;

- (CGSize)size;

@end
