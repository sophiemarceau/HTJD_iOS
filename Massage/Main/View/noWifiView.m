//
//  noWifiView.m
//  Massage
//
//  Created by 牛先 on 15/12/3.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "noWifiView.h"

@implementation noWifiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.backgroundColor = C2UIColorGray;
    }
    return self;
}
- (void)initView {
    [self addSubview:self.noWifiImageView];
    [self addSubview:self.noWifiLabel];
    [self addSubview:self.reloadButton];
    [self addSubview:self.activityIndicatorView];
    //约束
    [self.noWifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(125*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X, 110*AUTO_SIZE_SCALE_X));
    }];
    [self.noWifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.noWifiImageView.mas_bottom).offset(18);
        make.height.mas_equalTo(14);
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.noWifiLabel.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(90, 35));
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.noWifiLabel.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - 懒加载
- (UIImageView *)noWifiImageView {
    if (_noWifiImageView == nil) {
        self.noWifiImageView = [UIImageView new];
        [self.noWifiImageView setImage:[UIImage imageNamed:@"img_no-signal"]];
        self.noWifiImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noWifiImageView;
}
- (UILabel *)noWifiLabel {
    if (_noWifiLabel == nil) {
        self.noWifiLabel = [CommentMethod initLabelWithText:@"网络不给力，请稍后再试" textAlignment:NSTextAlignmentCenter font:11];
        self.noWifiLabel.textColor = C6UIColorGray;
    }
    return _noWifiLabel;
}
- (UIButton *)reloadButton {
    if (_reloadButton == nil) {
        self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.reloadButton.backgroundColor = [UIColor clearColor];
        self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.reloadButton.layer.borderColor = C6UIColorGray.CGColor;
        self.reloadButton.layer.borderWidth = 0.5;
    }
    return _reloadButton;
}
- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]init];
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.activityIndicatorView.color = [UIColor grayColor];
        self.activityIndicatorView.hidden = YES;
    }
    return _activityIndicatorView;
}
@end
