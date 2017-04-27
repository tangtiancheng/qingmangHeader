//
//  RecordCurrentDragingManager.m
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/18.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "RecordCurrentDragingManager.h"

@implementation RecordCurrentDragingManager

+ (instancetype)shareManager {
    static RecordCurrentDragingManager *recordCurrentDragingManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recordCurrentDragingManager = [[RecordCurrentDragingManager alloc]init];
    });
    return recordCurrentDragingManager;
}

@end
