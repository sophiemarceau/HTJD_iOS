//
//  advertisementCell.m
//  Massage
//
//  Created by 屈小波 on 15/10/23.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "advertisementCell.h"
#import "QHCommonUtil.h"
#define ImvHeight (kScreenWidth-20)/2
#define ImvWidth (kScreenWidth-20)
@interface advertisementCell ()

@end

@implementation advertisementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)awakeFromNib
{

    [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.contView];
    
    [self.contentView addSubview:self.pictureView];
    
    
    self.contentView.backgroundColor =C2UIColorGray;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, ImvHeight+20.0f));
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(ImvWidth, ImvHeight));
    }];
    
    self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.contentButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];

    self.contentButton.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    [self.contentView addSubview:self.contentButton];

}

-(UIImageView *)pictureView{
    if (!_pictureView) {
        _pictureView = [UIImageView new];
//        _pictureView.backgroundColor =[UIColor yellowColor];
        _pictureView.backgroundColor = [QHCommonUtil getRandomColor];
    }
    return _pictureView;
}

-(UIView *)contView{
    if (!_contView) {
        _contView = [UIView new];
        _contView.backgroundColor =[UIColor whiteColor];
    }
    return _contView;
}

-(void)touchAction:(UIButton *)id{
    NSLog(@"touchAction------------");
}
@end
