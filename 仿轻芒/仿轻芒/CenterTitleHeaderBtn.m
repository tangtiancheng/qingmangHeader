//
//  CenterTitleHeaderBtn.m
//  Speech
//
//  Created by 唐天成 on 2017/4/25.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import "CenterTitleHeaderBtn.h"

@interface CenterTitleHeaderBtn ()


@end

@implementation CenterTitleHeaderBtn

- (instancetype)initWithName:(NSString *)name withImageName:(NSString *)imageName {
    if(self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
        [self setTitle:name forState:UIControlStateNormal];
        self.pictureImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.pictureImageView.clipsToBounds = YES;
        
        [self addSubview:self.pictureImageView];
        [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(self).multipliedBy(0.5);
            make.height.mas_equalTo(self).multipliedBy(0.5);
        }];
    }

    return self;
}



@end
