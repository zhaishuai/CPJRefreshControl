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
    CGRect originFrame;
}
@property (nonatomic, weak)UIScrollView *scrollView;

@property (nonatomic, assign)CGFloat maxDistance;

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
    self.maxDistance = 80;
    
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

    self.backgroundColor = [UIColor redColor];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if(object ==self.scrollView && [keyPath isEqualToString:@"contentOffset"]){
        CGFloat oldOffset = [[change objectForKey:@"old"] CGPointValue].y + self.scrollView.contentInset.top;
        CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y + self.scrollView.contentInset.top;
        if(-offset <= 0 && self.scrollView.contentInset.top == 64 ){
            self.hidden = YES;
        }else{
            self.hidden = NO;
        }

        
        if(-offset >= self.maxDistance && !self.scrollView.isDragging && self.controlState != CPJRefreshControlConnecting && self.controlState != CPJRefreshControlFinish){
            _controlState = CPJRefreshControlConnecting;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
//            self.scrollView.scrollEnabled = NO;
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
        
    }

}

- (void)changeFrame:(CGFloat)offset{
    
    switch (self.controlState) {
        case CPJRefreshControlStart:{

        }
            break;
        case CPJRefreshControlPulling:{
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+64, self.frame.size.width,  -offset + self.scrollView.contentInset.top - 64);
        }
            break;
        case CPJRefreshControlConnecting:{
            self.frame = CGRectMake(self.frame.origin.x, -self.maxDistance +offset, self.frame.size.width, self.maxDistance-offset);
            self.scrollView.contentInset = UIEdgeInsetsMake(self.maxDistance + 64, 0.0f, 0.0f, 0.0f);
        }
            break;
        case CPJRefreshControlReleasing:{
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+64, self.frame.size.width,  -offset + self.scrollView.contentInset.top - 64);
        }
            break;
        case CPJRefreshControlFinish:{
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+64, self.frame.size.width,  -offset + self.scrollView.contentInset.top - 64);
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
        self.scrollView.contentInset = UIEdgeInsetsMake(63, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.scrollView.contentInset = UIEdgeInsetsMake(64, 0.0f, 0.0f, 0.0f);
        _controlState = CPJRefreshControlStart;
    }];
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
}


@end
