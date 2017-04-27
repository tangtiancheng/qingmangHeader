//
//  BaseTableViewController.m
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/16.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<UITableViewDataSource, UITableViewDelegate>

//是否是首次进入该界面
@property (nonatomic, assign) BOOL isFirstTimeToJoin;



@end

@implementation BaseTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DebugLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.array addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor randomColor];
    self.tableView.decelerationRate = 0.01;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.isFirstTimeToJoin = YES;
}

//首次进入界面加载数据请求
- (void)firstTimeRequest {
    if(self.isFirstTimeToJoin) {
        [self loadNewRequestWithDataList];
        self.isFirstTimeToJoin = NO;
    }
}

//loadRequest(确定首次进入该界面加载请求)
- (void)loadNewRequestWithDataList {
    
}


#pragma mark - UIScrollVIewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.baseScrollViewDelegate respondsToSelector:@selector(baseScrollViewWillBeginDragging:withBaseTableViewController:)]){
        [self.baseScrollViewDelegate baseScrollViewWillBeginDragging:scrollView withBaseTableViewController:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.baseScrollViewDelegate respondsToSelector:@selector(baseScrollViewDidScroll:withBaseTableViewController:)]){
        [self.baseScrollViewDelegate baseScrollViewDidScroll:scrollView withBaseTableViewController:self];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.baseScrollViewDelegate respondsToSelector:@selector(baseScrollViewDidEndDecelerating:withBaseTableViewController:)]) {
        [self.baseScrollViewDelegate baseScrollViewDidEndDecelerating:scrollView withBaseTableViewController:self];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([self.baseScrollViewDelegate respondsToSelector:@selector(baseScrollViewDidEndDragging:willDecelerate:withBaseTableViewController:)]) {
        [self.baseScrollViewDelegate baseScrollViewDidEndDragging:scrollView willDecelerate:decelerate withBaseTableViewController:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if([self.baseScrollViewDelegate respondsToSelector:@selector(baseScrollViewWillEndDragging:withVelocity:targetContentOffset:withBaseTableViewController:)]) {
        [self.baseScrollViewDelegate baseScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset withBaseTableViewController:self];
    }
}


#pragma mark - lazyLoad

- (UITableView *)tableView {
    if(!_tableView) {
        NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
        _tableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(HomeHeadHeight, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -HomeHeadHeight);
        _tableView.backgroundColor = [UIColor randomColor];
        self.lastContentOffSetY = -HomeHeadHeight;
        //头部下拉
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadNewRequestWithDataList];
        }];
        //尾部上啦
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadNewRequestWithDataList];
        }];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.with.offset(0);
            
        }];
    }
    return _tableView;
}

@end
