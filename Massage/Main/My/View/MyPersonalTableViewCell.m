//
//  MyPersonalTableViewCell.m
//  Massage
//
//  Created by 牛先 on 16/1/28.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "MyPersonalTableViewCell.h"

@implementation MyPersonalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)awakeFromNib {
    [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.backView addSubview:self.titleImage];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.detailLabel];
    [self.backView addSubview:self.rightImage];
    [self.backView addSubview:self.line];
    [self.contentView addSubview:self.backView];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {//背景图
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.backView.mas_left).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.backView.mas_right).offset(-10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.titleImage.mas_right).offset(16*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.right.mas_equalTo(self.rightImage.mas_left).with.offset(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.backView.mas_right);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - 懒加载
- (UIView *)backView {
    if (_backView == nil) {
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UIImageView *)titleImage {
    if (_titleImage== nil) {
        self.titleImage = [UIImageView new];
        self.titleImage.image = [UIImage imageNamed:@""];
    }
    return _titleImage;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        self.titleLabel = [CommentMethod initLabelWithText:@"2015-11-30" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        self.detailLabel = [CommentMethod initLabelWithText:@"￥400" textAlignment:NSTextAlignmentRight font:13];
        self.detailLabel.textColor = C6UIColorGray;
    }
    return _detailLabel;
}
- (UIImageView *)rightImage {
    if (_rightImage == nil) {
        self.rightImage = [UIImageView new];
        self.rightImage.image = [UIImage imageNamed:@"uc_menu_link"];
    }
    return _rightImage;
}
- (UIImageView *)line {
    if (_line == nil) {
        self.line = [UIImageView new];
        self.line.backgroundColor = C2UIColorGray;
    }
    return _line;
}
@end
