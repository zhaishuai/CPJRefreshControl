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
        
        self.frame = CGRectMake(0, 0, scrollView.frame.size.width, 0);
        [scrollView addSubview:self];
        self.scrollView = scrollView;
        [self initializer];
        self.backgroundColor = [UIColor yellowColor];
        
        
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
    
    stateTransitionMatrix[CPJRefreshControlFinish][TO_START]     = CPJRefreshControlStart;
    stateTransitionMatrix[CPJRefreshControlFinish][PULL]         = CPJRefreshControlFinish;
    stateTransitionMatrix[CPJRefreshControlFinish][RELEASE]      = CPJRefreshControlFinish;
    stateTransitionMatrix[CPJRefreshControlFinish][CONNECT]      = CPJRefreshControlFinish;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addTarget:self action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
//    self.contentView = [[UIView alloc] init];
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.contentView];
    
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    self.backgroundColor = [UIColor redColor];
}

//- (void)setFrame:(CGRect)frame{
//    originFrame = frame;
//    [super setFrame:frame];
//}

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
        
        if(self.scrollView.isDragging){
            self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+64, self.frame.size.width,  -offset + self.scrollView.contentInset.top - 64);
        }else{
            if(-offset >= self.maxDistance){
                self.frame = CGRectMake(self.frame.origin.x, -self.maxDistance +offset, self.frame.size.width, self.maxDistance-offset);
                _controlState = CPJRefreshControlConnecting;
                self.scrollView.contentInset = UIEdgeInsetsMake(self.maxDistance + 64, 0.0f, 0.0f, 0.0f);
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }else{
                self.frame = CGRectMake(self.frame.origin.x, offset - self.scrollView.contentInset.top+64, self.frame.size.width,  -offset + self.scrollView.contentInset.top - 64);
            }
        }

        if(-offset <= START_LIMIT){
            _controlState = stateTransitionMatrix[self.controlState][TO_START];
        }else if(oldOffset - offset > 0 ){
            _controlState = stateTransitionMatrix[self.controlState][PULL];
        }else if(oldOffset - offset < 0 ){
            _controlState = stateTransitionMatrix[self.controlState][RELEASE];
        }

        [self movingDistance:-offset];
        
    }

}


- (void)movingDistance:(CGFloat)distance{
//    NSLog(@"distance:%f  state :%d", distance, self.controlState);
}

- (void)beginRefreshing{
//    [super beginRefreshing];
    _controlState = CPJRefreshControlConnecting;
}

- (void)endRefreshing{
    _controlState = CPJRefreshControlFinish;
    [UIView animateWithDuration:3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(63, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.scrollView.contentInset = UIEdgeInsetsMake(64, 0.0f, 0.0f, 0.0f);
    }];
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
}


@end
