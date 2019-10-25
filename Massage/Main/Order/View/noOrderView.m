//
//  noOrderView.m
//  Massage
//
//  Created by 牛先 on 15/11/11.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "noOrderView.h"

@implementation noOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.noOrderImageView];
    [self addSubview:self.noOrderLabel];
    //约束
    [self.noOrderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(140*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X));
    }];
    [self.noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.noOrderImageView.mas_bottom).offset(18);
        make.height.mas_equalTo(14);
    }];
}
#pragma mark - 懒加载
- (UIImageView *)noOrderImageView {
    if (_noOrderImageView == nil) {
        self.noOrderImageView = [UIImageView new];
        [self.noOrderImageView setImage:[UIImage imageNamed:@"img_nothing"]];
        self.noOrderImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noOrderImageView;
}
- (UILabel *)noOrderLabel {
    if (_noOrderLabel == nil) {
        self.noOrderLabel = [CommentMethod initLabelWithText:@"您还没有相关订单" textAlignment:NSTextAlignmentCenter font:11];
        self.noOrderLabel.textColor = C6UIColorGray;
    }
    return _noOrderLabel;
}
@end
