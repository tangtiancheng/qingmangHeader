//
//  ShopCarBtn.m
//  Speech
//
//  Created by 唐天成 on 2017/4/25.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import "ShopCarBtn.h"

@interface ShopCarBtn ()

@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation ShopCarBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.hidden = YES;
        [self.numberLabel.layer setBackgroundColor:RGBA(206, 10, 0, 1).CGColor];
        [self.numberLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:6 andWidth:0];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont systemFontOfSize:11];
        self.numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(12);
            make.centerX.equalTo(self.imageView.mas_right);
            make.centerY.equalTo(self.imageView.mas_top);
        }];
    }
    return self;
}

- (void)setShopNumber:(NSInteger)shopNumber {
    _shopNumber = shopNumber;
    self.numberLabel.text = @(shopNumber).stringValue;
    if(shopNumber <= 0) {
        self.numberLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
    }
}

@end
