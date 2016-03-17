//
//  CPJRefreshControl.h
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/15/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CPJRefreshControlState{CPJRefreshControlStart, CPJRefreshControlPulling, CPJRefreshControlReleasing, CPJRefreshControlConnecting, CPJRefreshControlFinish};

@interface CPJRefreshControl : UIControl

@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, assign, readonly)enum CPJRefreshControlState controlState;

- (void)movingDistance:(CGFloat)distance;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;

- (void)endRefreshing;

@end
