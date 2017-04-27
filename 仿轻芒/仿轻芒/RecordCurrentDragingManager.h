//
//  RecordCurrentDragingManager.h
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/18.
//  Copyright © 2017年 唐天成. All rights reserved.
// 用于管理当前拖动的scrollVIew是哪一个

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CurrentDragingType) {
    TopNavigationTitleType,//最上角的scrollView
    CenterScrollTitleViewType,//中间的scrollView
    LargestScrollViewType//最下层最大的scrollView
};

typedef NS_ENUM(NSUInteger, CurrentDragingTableViewControllType) {
    SpeechType,//一席演讲
    TreesType,//枝丫
    ActivityType,//一席礼物
    RecordType,//记录
    DiscoverType//发现
};


@interface RecordCurrentDragingManager : NSObject

+ (instancetype)shareManager;

//当前是那个scrollView在引起滚动
@property(nonatomic,assign)CurrentDragingType currentType;

//当前主动上下拖动的tableView是哪一个
@property(nonatomic,assign)CurrentDragingTableViewControllType currentDragingTableViewControllType;

@end
