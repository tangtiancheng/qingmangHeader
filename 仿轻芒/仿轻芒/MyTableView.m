//
//  MyTableView.m
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/16.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    if(contentSize.height < self.height) {
        [super setContentSize:CGSizeMake(contentSize.width, self.height) ];
    } else {
        [super setContentSize:contentSize];
    }
}

@end
