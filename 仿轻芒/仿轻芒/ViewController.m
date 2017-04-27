//
//  ViewController.m
//  仿轻芒
//
//  Created by 唐天成 on 4017/4/16.
//  Copyright © 4017年 唐天成. All rights reserved.
//

#import "ViewController.h"
#import "NavigationTitleView.h"
#import "CenterTitleHeaderView.h"

@interface ViewController ()<UIScrollViewDelegate,BaseTableViewDelegate>


//头titleScrollView
@property (nonatomic, strong) NavigationTitleView *navigationTitleView;
//中部TitleScrollView
@property (nonatomic, strong) CenterTitleHeaderView *centerTitleHeaderView;
//最大tableScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//子控制器
@property (nonatomic, strong) NSArray<BaseTableViewController *> *viewControllerArray;
//单粒,用于记录主动滑动了那个scrollView,主动滑动了那个tableViewController
@property (nonatomic, strong) RecordCurrentDragingManager *recordCurrentDragingManager;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationTitleView];
    [self setupScrollView];
    [self setupChildViewControllers];
    [self setupCenterTitleView];
    [self scrollViewDidScroll:self.scrollView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
//    });
}

#pragma mark - 基本视图创建
//头部scrollTitleView创建
- (void)setupNavigationTitleView {
    self.navigationTitleView = [[NavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationTitleViewHeight) titles:@[@"一席演讲",@"枝丫",@"一个礼物",@"活动",@"记录"]];
    @weakify(self);
    //当titleVIew主动拖动需要引起其他scrollVIew的联动
    self.navigationTitleView.didDragScrollViewBlock = ^(CGFloat contentOffSetX) {
        @strongify(self);
        if([RecordCurrentDragingManager shareManager].currentType == TopNavigationTitleType) {
            [self.centerTitleHeaderView scrollViewToBeScroll:CGPointMake(contentOffSetX, 0)];
            [self.scrollView setContentOffset:CGPointMake(contentOffSetX, 0) animated:NO];
        }
    };
    [self.view addSubview:self.navigationTitleView];
}

////最大scrollView创建
- (void)setupScrollView
{
    // 不允许自动调整scrollView的内边距
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor randomColor];
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    scrollView.frame = CGRectMake(0, NavigationTitleViewHeight, SCREEN_WIDTH, BaseHomeTableViewHeight);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(5 * SCREEN_WIDTH, 0);
    [self.view addSubview:scrollView];
}

//子控制器创建
- (void)setupChildViewControllers
{
//    NSLog(@"%lf",self.scrollView.height);
    MyViewController1 *myViewController1 = [[MyViewController1 alloc] init];
    myViewController1.baseScrollViewDelegate = self;
    [self addChildViewController:myViewController1];
    myViewController1.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:myViewController1.view];
    
    MyViewController2 *myViewController2 = [[MyViewController2 alloc] init];
    myViewController2.baseScrollViewDelegate = self;
    [self addChildViewController:myViewController2];
    myViewController2.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:myViewController2.view];
    
    MyViewController3 *myViewController3 = [[MyViewController3 alloc] init];
    myViewController3.baseScrollViewDelegate = self;
    [self addChildViewController:myViewController3];
    myViewController3.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:myViewController3.view];
    
    MyViewController4 *myViewController4 = [[MyViewController4 alloc] init];
    myViewController4.baseScrollViewDelegate = self;
    [self addChildViewController:myViewController4];
    myViewController4.view.frame = CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:myViewController4.view];
    
    MyViewController5 *myViewController5 = [[MyViewController5 alloc] init];
    myViewController5.baseScrollViewDelegate = self;
    [self addChildViewController:myViewController5];
    myViewController5.view.frame = CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:myViewController5.view];
    
}

//centerScrollTitleView创建
- (void)setupCenterTitleView {
    self.centerTitleHeaderView = [[CenterTitleHeaderView alloc]initWithFrame:CGRectMake(0, NavigationTitleViewHeight, SCREEN_WIDTH, HomeHeadHeight) titles:@[@"一席演讲",@"枝丫",@"一个礼物",@"活动",@"记录"] imageNameArrays:@[@"SpeechCenterTitle", @"TreesCenterTitle", @"PresentCenterTitle", @"ActivityCenterTitle", @"ActivityCenterTitle"]];
    @weakify(self);
    //当titleVIew主动拖动需要引起其他scrollVIew的联动
    self.centerTitleHeaderView.didDragScrollViewBlock = ^(CGFloat contentOffSetX) {
        @strongify(self);
        if([RecordCurrentDragingManager shareManager].currentType == CenterScrollTitleViewType) {
            [self.navigationTitleView scrollViewToBeScroll:CGPointMake(contentOffSetX, 0)];
            [self.scrollView setContentOffset:CGPointMake(contentOffSetX, 0) animated:NO];
        }
    };
    [self.view addSubview:self.centerTitleHeaderView];
}

#pragma mark - JJBaseScrollViewDelegate

- (void)baseScrollViewWillBeginDragging:(UIScrollView *)scrollView withBaseTableViewController:(BaseTableViewController *)tabelViewController {
    for(int i = 0; i < self.childViewControllers.count; i++) {
        BaseTableViewController *vc = self.childViewControllers[i];
        if([vc.tableView isEqual:scrollView]) {
            self.recordCurrentDragingManager.currentDragingTableViewControllType = i;
            break;
        }
    }
}

- (void)baseScrollViewDidScroll:(UIScrollView *)scrollView withBaseTableViewController:(BaseTableViewController *)tabelViewController {
    CGPoint currentpoint= scrollView.contentOffset;    //0           last:64.5
    tabelViewController.changeY = currentpoint.y -  tabelViewController.lastContentOffSetY; //64.5       last:0
    tabelViewController.lastContentOffSetY = currentpoint.y;
    
    
    if([tabelViewController isEqual:self.childViewControllers[self.recordCurrentDragingManager.currentDragingTableViewControllType]]) {
//        DebugLog(@"shi");
        self.centerTitleHeaderView.alpha = (-tabelViewController.lastContentOffSetY)  / HomeHeadHeight;
        self.navigationTitleView.glassessAndPersonView.alpha = (-tabelViewController.lastContentOffSetY)  / HomeHeadHeight;
        self.navigationTitleView.self.verticalLineView.alpha = 1+ tabelViewController.lastContentOffSetY / HomeHeadHeight;
        self.navigationTitleView.scrollView.alpha = 1+ tabelViewController.lastContentOffSetY / HomeHeadHeight;
        
        //联动其他tableView
        if(tabelViewController.lastContentOffSetY >= 0) {
            for(BaseTableViewController *baseTableViewController in self.childViewControllers) {
                if(baseTableViewController != tabelViewController) {
                    baseTableViewController.tableView.contentOffset = CGPointMake(0, 0);
                }
            }
        } else if(tabelViewController.lastContentOffSetY <= -HomeHeadHeight) {
            for(BaseTableViewController *baseTableViewController in self.childViewControllers) {
                if(baseTableViewController != tabelViewController) {
                    baseTableViewController.tableView.contentOffset = CGPointMake(0, -HomeHeadHeight);
                }
            }
        } else {
            for(BaseTableViewController *baseTableViewController in self.childViewControllers) {
                if(baseTableViewController != tabelViewController) {
                    baseTableViewController.tableView.contentOffset = CGPointMake(0, tabelViewController.lastContentOffSetY);
                }
            }
        }
        if(tabelViewController.changeY >= 0) {//向上拖拽
            if(tabelViewController.lastContentOffSetY > (40 - HomeHeadHeight) && tabelViewController.lastContentOffSetY < - 40 && (scrollView.dragging || scrollView.decelerating)) {
                //                [scrollView setContentOffset:CGPointMake(0, headerViewHeight) animated:YES];
                scrollView.scrollEnabled = NO;
                [UIView animateWithDuration:0.1 animations:^{
                    scrollView.contentOffset = CGPointMake(0, 0);
                } completion:^(BOOL finished) {
                    scrollView.scrollEnabled = YES;
                }];
            }
        }
        if(tabelViewController.changeY < 0){//向下拖拽
            //新添加
            //当滑动到70~(headerViewHeight-70) 或者 滑动过快的原因跳过70~(headerViewHeight-70)时
            if( tabelViewController.lastContentOffSetY < - 40 && tabelViewController.lastContentOffSetY > (40 - HomeHeadHeight) && (scrollView.dragging || scrollView.decelerating) ) {
                //                DebugLog(@"出发了乐乐乐乐");
                //                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                scrollView.scrollEnabled = NO;
                scrollView.bounces = NO;
                [UIView animateWithDuration:0.1 animations:^{
                    scrollView.contentOffset = CGPointMake(0, -HomeHeadHeight);
                    //                    DebugLog(@"11111");
                } completion:^(BOOL finished) {
                    scrollView.scrollEnabled = YES;
                    scrollView.bounces = YES;
                    //                    DebugLog(@"22222");
                }];
            }
        }
    } else {
        DebugLog(@"bushi");
    }
}


////新添加
- (void)baseScrollViewDidEndDecelerating:(UIScrollView *)scrollView withBaseTableViewController:(BaseTableViewController *)tabelViewController {
//    DebugLog(@"%s",__func__);
    //有惯性时
    if(scrollView.contentOffset.y <= (40 - HomeHeadHeight) && scrollView.contentOffset.y > (-HomeHeadHeight)) {
        scrollView.scrollEnabled = NO;
        [UIView animateWithDuration:0.1 animations:^{
            scrollView.contentOffset = CGPointMake(0, -HomeHeadHeight);
        } completion:^(BOOL finished) {
            scrollView.scrollEnabled = YES;
        }];
    } else if(scrollView.contentOffset.y >= (- 40) && scrollView.contentOffset.y < 0) {
        scrollView.scrollEnabled = NO;
        [UIView animateWithDuration:0.1 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            scrollView.scrollEnabled = YES;
        }];
    }
    
}
//新添加
- (void)baseScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withBaseTableViewController:(BaseTableViewController *)tabelViewController {
//    DebugLog(@"%s",__func__);
    if(!decelerate) {
        //没有惯性滑动时
        if(scrollView.contentOffset.y <= (40 - HomeHeadHeight) && scrollView.contentOffset.y > (-HomeHeadHeight)) {
            scrollView.scrollEnabled = NO;
            [UIView animateWithDuration:0.1 animations:^{
                scrollView.contentOffset = CGPointMake(0, -HomeHeadHeight);
            } completion:^(BOOL finished) {
                scrollView.scrollEnabled = YES;
            }];
        } else if(scrollView.contentOffset.y >= (- 40) && scrollView.contentOffset.y < 0) {
            scrollView.scrollEnabled = NO;
            [UIView animateWithDuration:0.1 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                scrollView.scrollEnabled = YES;
            }];
        }
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    RecordCurrentDragingManager *manager = [RecordCurrentDragingManager shareManager];
    manager.currentType = LargestScrollViewType;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //当scrollVIew主动拖动需要引起其他scrollVIew的联动
    if([RecordCurrentDragingManager shareManager].currentType == LargestScrollViewType) {
        [self.navigationTitleView scrollViewToBeScroll:scrollView.contentOffset];
        [self.centerTitleHeaderView scrollViewToBeScroll:scrollView.contentOffset];
    }
    
    DebugLog(@"%lf %lf", SCREEN_WIDTH,scrollView.contentOffset.x);
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    BaseTableViewController *currentTableVIewController = self.childViewControllers[index];
    [currentTableVIewController firstTimeRequest];
    
}

- (RecordCurrentDragingManager *)recordCurrentDragingManager {
    if(!_recordCurrentDragingManager) {
        _recordCurrentDragingManager = [RecordCurrentDragingManager shareManager];
    }
    return _recordCurrentDragingManager;
}


@end
