//
//  CenterTitleHeaderView.h
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/19.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTitleView.h"

@interface CenterTitleHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles imageNameArrays:(NSArray *)imageNameArray;

@property (nonatomic, copy) DidDragScrollViewBlock didDragScrollViewBlock;

//- (void)setCurrentTitleIndex:(NSInteger)index;

//由于外部其他scrollVIew滚动照成本scrollView也要滚动与之联动
- (void)scrollViewToBeScroll:(CGPoint)contentOffSet;


@end
