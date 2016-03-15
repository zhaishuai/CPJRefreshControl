//
//  CPJRefreshControl.m
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/15/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "CPJRefreshControl.h"

@interface CPJRefreshControl ()


@end

@implementation CPJRefreshControl

- (instancetype)init{
    if(self = [super init]){
        [self addTarget:self action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
    
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    if(self.frame.origin.y - frame.origin.y > 0 && _controlSate!=CPJRefreshControlConnecting){
        _controlSate = CPJRefreshControlPulling;
    }else if(self.frame.origin.y - frame.origin.y < 0 && _controlSate!=CPJRefreshControlConnecting){
        _controlSate = CPJRefreshControlReleasing;
    }
    
    //    NSLog(@"%f  %f", frame.origin.y, self.frame.origin.y);
    
    [super setFrame:frame];

    
    [self movingDistance:-frame.origin.y];
}


- (void)movingDistance:(CGFloat)distance{
    NSLog(@"state :%d", self.controlSate);
}

- (void)beginRefreshing{
    [super beginRefreshing];
    _controlSate = CPJRefreshControlConnecting;
}

- (void)endRefreshing{
    
    
    
    [super endRefreshing];
    _controlSate = CPJRefreshControlReleasing;
}

@end
