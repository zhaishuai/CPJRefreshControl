//
//  CPJFashionRefresh.m
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/17/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "CPJFashionRefresh.h"
#import "MONActivityIndicatorView.h"

@interface CPJFashionRefresh ()<MONActivityIndicatorViewDelegate>

@property (nonatomic, strong)MONActivityIndicatorView *indicator;

@end

@implementation CPJFashionRefresh

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if(self = [super initWithScrollView:scrollView]){
        [self configer];
    }
    return self;
}
//
- (void)configer{

    
    MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] initWithFrame:self.bounds];
    self.indicator = indicatorView;
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 3;
    indicatorView.radius = 20;
    indicatorView.internalSpacing = 3;
    [indicatorView startAnimating];
    
//    self.backgroundColor = [UIColor redColor];
    
    [self addSubview:indicatorView];
//    self.indicator.backgroundColor = [UIColor yellowColor];
//    [self placeAtTheCenterWithView:indicatorView];
    [self.indicator sizeToFit];
    self.indicator.center = self.center;
    
}


- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    CGSize size = [self.indicator intrinsicContentSize];
    self.indicator.frame = CGRectMake(0, 0, size.width, size.height);
    self.indicator.frame = CGRectMake((frame.size.width - size.width)/2, -frame.origin.y-self.maxDistance/2, size.width,  size.height);

    
}

- (void)movingDistance:(CGFloat)distance{
    [super movingDistance:distance];
    if(self.controlState != CPJRefreshControlPulling)
        return;
    
}




- (void)placeAtTheCenterWithView:(UIView *)view {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
