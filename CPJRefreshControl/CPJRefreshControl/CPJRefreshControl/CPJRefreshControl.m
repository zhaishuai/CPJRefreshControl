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
    UIEdgeInsets originInsets;
}
@property (nonatomic, weak)UIScrollView *scrollView;



@end

@implementation CPJRefreshControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if(self = [super init]){
        
        self.frame = CGRectMake(0, CPJRefreshControlIDLE, scrollView.frame.size.width, 0);
        [scrollView addSubview:self];
        self.scrollView = scrollView;
        [self initializer];
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

- (void)initializer{
    self.maxDistance     = 70;
    self.loadingDistance = self.maxDistance;
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
    
    stateTransitionMatrix[CPJRefreshControlFinish][TO_START]     = CPJRefreshControlFinish;
    stateTransitionMatrix[CPJRefreshControlFinish][PULL]         = CPJRefreshControlFinish;
    stateTransitionMatrix[CPJRefreshControlFinish][RELEASE]      = CPJRefreshControlFinish;
    stateTransitionMatrix[CPJRefreshControlFinish][CONNECT]      = CPJRefreshControlFinish;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    originInsets = self.scrollView.contentInset;
//    self.backgroundColor = [UIColor redColor];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if(object ==self.scrollView && [keyPath isEqualToString:@"contentOffset"]){
        CGFloat oldOffset = [[change objectForKey:@"old"] CGPointValue].y + self.scrollView.contentInset.top;
        CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y + self.scrollView.contentInset.top;
        if(-offset <= 0 && self.scrollView.contentInset.top == originInsets.top ){
            self.hidden = YES;
        }else{
            self.hidden = NO;
        }

        
        if(-offset >= self.maxDistance && !self.scrollView.isDragging && self.controlState != CPJRefreshControlConnecting && self.controlState != CPJRefreshControlFinish){
            _controlState = CPJRefreshControlConnecting;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        
        if(-offset <= START_LIMIT){
            _controlState = stateTransitionMatrix[self.controlState][TO_START];
        }else if(oldOffset - offset > 0 ){
            _controlState = stateTransitionMatrix[self.controlState][PULL];
        }else if(oldOffset - offset < 0 ){
            _controlState = stateTransitionMatrix[self.controlState][RELEASE];
        }
        
        [self changeFrame:offset];
        [self movingDistance:-offset];
        
    }else if(object ==self.scrollView && [keyPath isEqualToString:@"contentInset"]){
        if(self.controlState == CPJRefreshControlStart)
            originInsets = [[change objectForKey:@"new"] UIEdgeInsetsValue];
    }

}

- (void)changeFrame:(CGFloat)offset{
    
    switch (self.controlState) {
        case CPJRefreshControlStart:{
            self.hidden = YES;
        }
            break;
        case CPJRefreshControlPulling:{
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+originInsets.top, self.frame.size.width,  -offset + self.scrollView.contentInset.top - originInsets.top);
        }
            break;
        case CPJRefreshControlConnecting:{
            
            
            self.frame = CGRectMake(self.frame.origin.x, -self.loadingDistance +offset, self.frame.size.width, self.loadingDistance-offset);
            self.scrollView.contentInset = UIEdgeInsetsMake(self.loadingDistance + originInsets.top, 0.0f, 0.0f, 0.0f);
        }
            break;
        case CPJRefreshControlReleasing:{
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+originInsets.top, self.frame.size.width,  -offset + self.scrollView.contentInset.top - originInsets.top);
        }
            break;
        case CPJRefreshControlFinish:{
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+originInsets.top, self.frame.size.width,  -offset + self.scrollView.contentInset.top - originInsets.top);
        }
            break;
            
        default:
            break;
    }
    
}


- (void)movingDistance:(CGFloat)distance{
    NSLog(@"distance:%f  state :%d", distance, self.controlState);
}

- (void)endRefreshing{
    _controlState = CPJRefreshControlFinish;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(originInsets.top - 1, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.scrollView.contentInset = UIEdgeInsetsMake(originInsets.top, 0.0f, 0.0f, 0.0f);
        _controlState = CPJRefreshControlStart;
    }];
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView = nil;
}


@end
