//
//  BaseScene.m
//  IgaBall
//
//  Created by Vitalii Parovishnyk on 7/7/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "BaseScene.h"

@interface BaseScene (Protected)

@property (weak, readwrite) GameController *gameController;

@end

@implementation BaseScene

- (instancetype)initWithSize:(CGSize)aSize gameController:(GameController *)gGameController
{	
    if (self = [super initWithSize:aSize])
	{
        self.gameController = gGameController;
        
        self.name = NSStringFromClass([self class]);
    }
    
    return self;
}

@end
