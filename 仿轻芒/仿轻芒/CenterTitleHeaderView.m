//
//  CenterTitleHeaderView.m
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/19.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "CenterTitleHeaderView.h"
#import "CenterTitleHeaderBtn.h"

#define CenterTitleWidth (SCREEN_WIDTH / 2) //每个按钮的宽度
#define CenterTitleDragScale 2.0//手动拖动scrollVIew滑动比例1:4

@interface CenterTitleHeaderView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray<NSString *> *imageNameArray;
/** 所有按钮的数组 */
@property (nonatomic ,strong) NSMutableArray<UIButton *> *titleBtns;
// 记录上一个选中按钮
@property (nonatomic, weak) UIButton *selectButton;

@property (nonatomic, strong) UIScrollView *scrollView;

//滑动前的contentOfSet位置(主要用于手指滑动时,scrollVIew滑动距离为1/4)
@property(nonatomic,assign)CGPoint contentOfSet;
////表示是否有惯性(x = 0 表示无惯性, > 0表示往右滑动的惯性, <0 表示往左滑动的惯性)
//@property(nonatomic,assign)CGPoint velocity;


@end

@implementation CenterTitleHeaderView

#pragma mark - 界面搭建
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles imageNameArrays:(NSArray *)imageNameArray{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.imageNameArray = imageNameArray;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupInit];
    }
    return self;
}


- (void)setupInit {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    //    self.scrollView.decelerationRate = 0.1;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake((self.titles.count - 1) * CenterTitleWidth + self.width, 0);
    [self addSubview:self.scrollView];
    
    CGFloat btnW = CenterTitleWidth;
    CGFloat btnH = self.frame.size.height;
    [self.titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        CenterTitleHeaderBtn *btn = [[CenterTitleHeaderBtn alloc]initWithName:title withImageName:self.imageNameArray[idx]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        btn.tag = idx;
        btn.frame = (CGRect) {btnW * idx, 0, btnW, btnH};
        btn.centerX = (self.width / 2) + (idx * btnW);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:gray194LineColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        if (!idx) {
            [self titleClick:btn];
        }
        [self.scrollView addSubview:btn];
        [self.titleBtns addObject:btn];
    }];
    //滑动减速
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
    [self scrollViewDidScroll:self.scrollView];
}

//- (void)setCurrentTitleIndex:(NSInteger)index {
//    [self selectTitleButton:self.titleBtns[index]];
//}

#pragma mark - Action

#pragma mark 按钮点击时间
- (void)titleClick:(UIButton *)button {
    [RecordCurrentDragingManager shareManager].currentType = CenterScrollTitleViewType;
    // 0.获取角标
    NSInteger i = button.tag;
    //    !self.didTitleClickblock ? : self.didTitleClickblock(i);
    // 1.让标题按钮选中
    [self selectTitleButton:button];
    [self.scrollView setContentOffset:CGPointMake(button.tag * CenterTitleWidth, 0) animated:YES];
}

#pragma mark 标记选中的按钮,并且改变按钮颜色
- (void)selectTitleButton:(UIButton *)btn {
    //    // 恢复上一个按钮颜色
    //    [_selectButton setTitleColor:gray194LineColor forState:UIControlStateNormal];
    //    // 设置当前选中按钮的颜色
    //    [btn setTitleColor:blackTextColor forState:UIControlStateNormal];
    // 记录当前选中的按钮
    _selectButton = btn;
}

#pragma mark 由于外部其他scrollVIew滚动照成本scrollView也要滚动与之联动
- (void)scrollViewToBeScroll:(CGPoint)contentOffSet {
    [self.scrollView setContentOffset:CGPointMake(contentOffSet.x / (SCREEN_WIDTH / CenterTitleWidth), 0) animated:NO];
    //选中合适的按钮
    NSInteger targetIndex = round(self.scrollView.contentOffset.x / CenterTitleWidth);
    UIButton *btn = self.titleBtns[targetIndex];
    [self selectTitleButton:btn];

}

#pragma mark 给scrollView的panGestureRecognizer手势添加target,滑动时减速
- (void)panAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint p = [panGestureRecognizer translationInView:self.scrollView];
    //    NSLog(@"%ld",panGestureRecognizer.state);
    //    NSLog(@"%@",NSStringFromCGPoint(p));
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.contentOfSet = self.scrollView.contentOffset;
    }
    if(self.scrollView.bounces) {
        self.scrollView.contentOffset = CGPointMake( self.contentOfSet.x - p.x/CenterTitleDragScale , 0);
    } else {
        if((self.contentOfSet.x - p.x/CenterTitleDragScale) < 0) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } else if((self.contentOfSet.x - p.x/CenterTitleDragScale) > self.scrollView.contentSize.width - self.scrollView.width) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0);
        } else {
            self.scrollView.contentOffset = CGPointMake( self.contentOfSet.x - p.x/CenterTitleDragScale , 0);
        }
    }
}

#pragma mark - UIScrollViewDelegate
//开始用手拉动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    RecordCurrentDragingManager *manager = [RecordCurrentDragingManager shareManager];
    manager.currentType = CenterScrollTitleViewType;
}

// scrollView一滚动就会调用,字体颜色渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat curPage = scrollView.contentOffset.x / CenterTitleWidth;
    // 左边label角标
    NSInteger leftIndex = curPage;
    // 右边的label角标
    NSInteger rightIndex = leftIndex + 1;
    // 获取左边的btn
    CenterTitleHeaderBtn *leftBtn = self.titleBtns[leftIndex];
    // 获取右边的btn
    CenterTitleHeaderBtn *rightBtn;
    if (rightIndex < self.titleBtns.count ) {
        rightBtn = self.titleBtns[rightIndex];
    }
    // 计算下右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    // 计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    NSLog(@"leftScale--%f",leftScale);
    NSLog(@"rightScale--%f\n",rightScale);
    // 0 ~ 1
    // 1 ~ 2
    // 左边缩放
    leftBtn.pictureImageView.transform = CGAffineTransformMakeScale(leftScale * 1.0 + 1, leftScale * 1.0+ 1);
    leftBtn.pictureImageView.alpha = leftScale;
    leftBtn.titleLabel.alpha = 0.0;
    
    
    // 右边缩放
    rightBtn.pictureImageView.transform = CGAffineTransformMakeScale(rightScale * 1.0 + 1, rightScale * 1.0+ 1);
    rightBtn.pictureImageView.alpha = rightScale;
    rightBtn.titleLabel.alpha = 0.0;
    // 设置文字颜色渐变
    /*
     R G B
     黑色 0 0 0
     灰色 194 194 194
     */
    
    
//    [leftBtn setTitleColor:RGBA(194 * rightScale, 194 * rightScale, 194 * rightScale, 1) forState:UIControlStateNormal];
//    [rightBtn setTitleColor:RGBA(194 * leftScale, 194 * leftScale, 194 * leftScale, 1) forState:UIControlStateNormal];
    //拖动过快时无法完全监听到,有问题,需加如下代码
    if(leftScale == 1.0) {
        for(UIButton *btn in self.titleBtns) {
            if(![btn isEqual:leftBtn]) {
                [btn setTitleColor:gray194LineColor forState:UIControlStateNormal];
            }
        }
    }
    
    
    !self.didDragScrollViewBlock ? : self.didDragScrollViewBlock(self.scrollView.contentOffset.x * (SCREEN_WIDTH / CenterTitleWidth));
}



//#pragma mark - UIScrollVIewDelegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"nowContentOfSet:%@",NSStringFromCGPoint(scrollView.contentOffset));
//    if (decelerate)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            printf("STOP IT!!\n");
//            if(scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= (scrollView.contentSize.width - self.width)) {
//                [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//            }
//        });
//    }
//}



//停止拖拽且目标point
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //    NSLog(@"nowContentOfSet:%@  withVelocity:%@    targetContentOffset:%@",NSStringFromCGPoint(scrollView.contentOffset),NSStringFromCGPoint(velocity),NSStringFromCGPoint(CGPointMake(targetContentOffset -> x, targetContentOffset -> y)));
    
    if(velocity.x > 0) {//右划惯性
        if(self.selectButton != self.titleBtns.lastObject) {
            targetContentOffset -> x = (self.selectButton.tag + 1) * CenterTitleWidth;
            // 0.获取角标
            NSInteger i = self.selectButton.tag + 1;
            //                !self.didTitleClickblock ? : self.didTitleClickblock(i);
            // 1.让标题按钮选中
            [self selectTitleButton:self.titleBtns[i]];
            //                [self titleClick:self.titleBtns[self.selectButton.tag + 1]];
        } else {
            [self titleClick:self.selectButton];
        }
        return ;
    } else if (velocity.x < 0) {//左划惯性
        if(self.selectButton != self.titleBtns.firstObject) {
            targetContentOffset -> x = (self.selectButton.tag - 1) * CenterTitleWidth;
            // 0.获取角标
            NSInteger i = self.selectButton.tag - 1;
            
            //                !self.didTitleClickblock ? : self.didTitleClickblock(i);
            // 1.让标题按钮选中
            [self selectTitleButton:self.titleBtns[i]];
            
            //                [self titleClick:self.titleBtns[self.selectButton.tag - 1]];
        } else {
            [self titleClick:self.selectButton];
        }
        return;
    } else {//无惯性
        
        //回到适合的
        NSInteger targetIndex = round(scrollView.contentOffset.x / CenterTitleWidth);
        UIButton *btn = self.titleBtns[targetIndex];
        [self titleClick:btn];
        return;
    }
}


#pragma mark - 懒加载
- (NSMutableArray<UIButton *> *)titleBtns {
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}


@end
