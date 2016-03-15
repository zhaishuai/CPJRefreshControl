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
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    if(self.frame.origin.y - frame.origin.y > 0 && _controlSate!=CPJRefreshControlConnecting){
        _controlSate = CPJRefreshControlPulling;
    }else if(self.frame.origin.y - frame.origin.y < 0 && _controlSate!=CPJRefreshControlConnecting){
        _controlSate = CPJRefreshControlReleasing;
    }
    
    [super setFrame:frame];
    self.contentView.frame = CGRectMake(frame.origin.x, 0, frame.size.width,  - frame.origin.y);
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
