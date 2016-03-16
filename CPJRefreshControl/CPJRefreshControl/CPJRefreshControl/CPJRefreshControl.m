//
//  CPJRefreshControl.m
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/15/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "CPJRefreshControl.h"

#define START_LIMIT 3

#define TO_START    0
#define PULL        1
#define RELEASE     2
#define CONNECT     3



@interface CPJRefreshControl (){
    enum CPJRefreshControlState stateTransitionMatrix[5][4];
}

@end

@implementation CPJRefreshControl

- (instancetype)init{
    if(self = [super init]){
        memset(&stateTransitionMatrix, CPJRefreshControlStart, sizeof(stateTransitionMatrix));
        
        stateTransitionMatrix[CPJRefreshControlStart][TO_START]      = CPJRefreshControlStart;
        stateTransitionMatrix[CPJRefreshControlStart][PULL]          = CPJRefreshControlPulling;
        
        stateTransitionMatrix[CPJRefreshControlPulling][PULL]        = CPJRefreshControlPulling;
        stateTransitionMatrix[CPJRefreshControlPulling][RELEASE]     = CPJRefreshControlReleasing;
        stateTransitionMatrix[CPJRefreshControlPulling][TO_START]    = CPJRefreshControlStart;
        
        stateTransitionMatrix[CPJRefreshControlReleasing][RELEASE]   = CPJRefreshControlReleasing;
        stateTransitionMatrix[CPJRefreshControlReleasing][TO_START]  = CPJRefreshControlStart;
        stateTransitionMatrix[CPJRefreshControlReleasing][PULL]      = CPJRefreshControlPulling;
        
        stateTransitionMatrix[CPJRefreshControlConnecting][TO_START] = CPJRefreshControlConnecting;
        stateTransitionMatrix[CPJRefreshControlConnecting][PULL]     = CPJRefreshControlConnecting;
        stateTransitionMatrix[CPJRefreshControlConnecting][RELEASE]  = CPJRefreshControlConnecting;
        stateTransitionMatrix[CPJRefreshControlConnecting][CONNECT]  = CPJRefreshControlConnecting;
        
        stateTransitionMatrix[CPJRefreshControlFinish][TO_START]     = CPJRefreshControlStart;
        stateTransitionMatrix[CPJRefreshControlFinish][PULL]         = CPJRefreshControlFinish;
        stateTransitionMatrix[CPJRefreshControlFinish][RELEASE]      = CPJRefreshControlFinish;
        stateTransitionMatrix[CPJRefreshControlFinish][CONNECT]      = CPJRefreshControlFinish;
        [self initializer];
        
    }
    return self;
}

- (void)initializer{
    [self addTarget:self action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setFrame:(CGRect)frame{
    
    if(-frame.origin.y <= START_LIMIT){
        _controlState = stateTransitionMatrix[self.controlState][TO_START];
    }else if(self.frame.origin.y - frame.origin.y > 0 ){
        _controlState = stateTransitionMatrix[self.controlState][PULL];
    }else if(self.frame.origin.y - frame.origin.y < 0 ){
        _controlState = stateTransitionMatrix[self.controlState][RELEASE];
    }
    [super setFrame:frame];
    self.contentView.frame = CGRectMake(frame.origin.x, 0, frame.size.width,  - frame.origin.y);
    [self movingDistance:-frame.origin.y];
}


- (void)movingDistance:(CGFloat)distance{
//    NSLog(@"distance:%f  state :%d", distance, self.controlSate);
}

- (void)beginRefreshing{
    [super beginRefreshing];
    _controlState = CPJRefreshControlConnecting;
}

- (void)endRefreshing{                                                                                                           
    [super endRefreshing];
    _controlState = CPJRefreshControlFinish;
}

@end
