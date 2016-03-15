//
//  CPJRefreshControl.h
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/15/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CPJRefreshControlState{CPJRefreshControlPulling, CPJRefreshControlConnecting, CPJRefreshControlReleasing};

@interface CPJRefreshControl : UIRefreshControl

@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, assign, readonly)enum CPJRefreshControlState controlSate;

- (void)movingDistance:(CGFloat)distance;

@end
