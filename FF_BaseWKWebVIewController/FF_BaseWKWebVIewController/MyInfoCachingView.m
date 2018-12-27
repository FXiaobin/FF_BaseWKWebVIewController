//
//  MyInfoCachingView.m
//  YiHuiBaoPro
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018 YiHuiBao. All rights reserved.
//

#import "MyInfoCachingView.h"

@implementation MyInfoCachingView

-(instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.frame = [UIScreen mainScreen].bounds;
        
        [self addSubview:self.icon];
        [self addSubview:self.titleLabel];
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-100);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(52);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.icon.mas_bottom).offset(20);
        }];
        
        
        
    }
    return self;
}


-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:@"my_06"];
        _icon.userInteractionEnabled = YES;

    }
    return _icon;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"正在打开...";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


@end
