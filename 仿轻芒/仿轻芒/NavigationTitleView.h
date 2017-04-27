//
//  NavigationTitleView.h
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/16.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidDragScrollViewBlock)(CGFloat);

@interface NavigationTitleView : UIView

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//小人头和放大镜View
@property (nonatomic, strong) UIView *glassessAndPersonView;
//verticalLine
@property (nonatomic, strong) UIView *verticalLineView;

@property (nonatomic, copy) DidDragScrollViewBlock didDragScrollViewBlock;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

//- (void)setCurrentTitleIndex:(NSInteger)index;

//由于外部其他scrollVIew滚动照成本scrollView也要滚动与之联动
- (void)scrollViewToBeScroll:(CGPoint)contentOffSet;

@end
