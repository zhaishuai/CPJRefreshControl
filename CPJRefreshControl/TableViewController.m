//
//  TableViewController.m
//  CPJRefreshControl
//
//  Created by shuaizhai on 3/15/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "TableViewController.h"
#import "CPJNomalRefreshControl.h"
#import "CPJFashionRefresh.h"

@interface TableViewController (){
    CPJFashionRefresh *refresh ;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    refresh = [[CPJFashionRefresh alloc] initWithScrollView:self.tableView];


    [refresh addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];

}

- (void)pullToRefresh
{
    //模拟网络访问
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [self.tableView reloadData];
        //刷新结束时刷新控件的设置
//        [refresh endRefreshingWithTitle:@"刷新成功"];
        [refresh endRefreshing];

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    });
}



@end
