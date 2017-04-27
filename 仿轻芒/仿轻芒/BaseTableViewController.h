//
//  BaseTableViewController.h
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/16.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableView.h"

@class BaseTableViewController;

@protocol BaseTableViewDelegate <NSObject>

- (void)baseScrollViewWillBeginDragging:(UIScrollView *)scrollView withBaseTableViewController:(BaseTableViewController *)tabelViewController;
- (void)baseScrollViewDidScroll:(UIScrollView *)scrollView withBaseTableViewController:(BaseTableViewController *)tabelViewController;
- (void)baseScrollViewDidEndDecelerating:(UIScrollView *)scrollView withBaseTableViewController:(BaseTableViewController *)tabelViewController;
- (void)baseScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withBaseTableViewController:(BaseTableViewController *)tabelViewController;
- (void)baseScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset withBaseTableViewController:(BaseTableViewController *)tabelViewController;

@end


@interface BaseTableViewController : UIViewController

//@property (nonatomic, strong) NSMutableArray<NSString *> *array;

@property (nonatomic, strong) MyTableView *tableView;

@property (nonatomic, weak) id<BaseTableViewDelegate> baseScrollViewDelegate;
@property (nonatomic, assign) CGFloat lastContentOffSetY;
@property (nonatomic, assign) CGFloat changeY;

//首次进入界面加载数据请求
- (void)firstTimeRequest;

//loadRequest(确定首次进入该界面加载请求)
- (void)loadNewRequestWithDataList;

@end
