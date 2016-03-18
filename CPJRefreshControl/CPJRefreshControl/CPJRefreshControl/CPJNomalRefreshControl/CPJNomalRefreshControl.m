//
//  CPJNomalRefreshControl.m
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/15/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "CPJNomalRefreshControl.h"

#import "LPRefreshIndicator.h"

@interface CPJNomalRefreshControlIndicator ()

@end

@implementation CPJNomalRefreshControlIndicator


@end

@interface CPJNomalRefreshControl ()

@property(nonatomic, strong)LPRefreshIndicator *indicator;

@end

@implementation CPJNomalRefreshControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if(self = [super initWithScrollView:scrollView]){
        self.indicator = [LPRefreshIndicator new];

        [self addSubview:self.indicator];

    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    if(-frame.origin.y <= 36){
        self.indicator.frame = CGRectMake(frame.origin.x, -frame.origin.y-36, frame.size.width,  36);
    }else{
        self.indicator.frame = CGRectMake(frame.origin.x, 0, frame.size.width,  -frame.origin.y);
    }
    
    
}

- (void)movingDistance:(CGFloat)distance{
    [super movingDistance:distance];
    [self.indicator setPullProgress:distance withState:self.controlState];
}


- (void)endRefreshing{
    
    [self.indicator refreshSuccess:YES completion:^(BOOL finished) {
        NSLog(@"finish");
        [super endRefreshing];
    }];
    
    
}

@end
