//
//  CenterTitleHeaderBtn.h
//  Speech
//
//  Created by 唐天成 on 2017/4/25.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterTitleHeaderBtn : UIButton

@property (nonatomic, strong) UIImageView *pictureImageView;

- (instancetype)initWithName:(NSString *)name withImageName:(NSString *)imageName;

@end
