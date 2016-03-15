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

- (instancetype)init{
    if(self = [super init]){
        self.indicator = [LPRefreshIndicator new];
//        self.indicator.frame = self.bounds;
        self.indicator.backgroundColor = [UIColor blueColor];
        
        [self.contentView addSubview:self.indicator];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.indicator.frame = CGRectMake(frame.origin.x, 0, frame.size.width,  - frame.origin.y);
}

- (void)movingDistance:(CGFloat)distance{
    self.indicator.pullProgress = distance;
    
    
    
}


- (void)endRefreshing{
    
    [self.indicator refreshSuccess:YES];
    
    [super endRefreshing];
}

@end
