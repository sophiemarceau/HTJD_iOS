//
//  TechicianView.m
//  Massage
//
//  Created by htjd_IOS on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "TechicianView.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"

@implementation TechicianView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}


-(void)_initView{
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"data -- %@",self.data);
    
    [self.backView addSubview:self.dateImageView];
    [self.dateImageView addSubview:self.busyLabel];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.levelImageView];
    [self.backView addSubview:self.levelLabel];
    [self.backView addSubview:self.scoreLabel];
    [self.backView addSubview:self.orderLabel];
    [self.backView addSubview:self.distanceLabel];
    [self.backView addSubview:self.scoreNumLabel];
    [self.backView addSubview:self.orderNumLabel];
    [self.backView addSubview:self.distanceNumLabel];
    [self.backView addSubview:self.introduceLabel];
    [self.backView addSubview:self.belongLabel];
    [self.backView addSubview:self.yuYueButton];
    [self addSubview:self.contentView];
    [self.contentView  addSubview:self.backView];
    [self.contentView addSubview:self.headImageView];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {//整个背景
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10*AUTO_SIZE_SCALE_X);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {//背景图
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(35*AUTO_SIZE_SCALE_X);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {//头像
        make.centerX.equalTo(self.contentView.mas_centerX);
//        make.centerY.equalTo(self.contentView.mas_top);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(70*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X));
    }];
//    [self.dateImageView mas_makeConstraints:^(MASConstraintMaker *make) {//可约
//        make.top.equalTo(self.backView.mas_top).offset(16*AUTO_SIZE_SCALE_X);
//        make.left.equalTo(self.backView.mas_left).offset(-2);
//        make.size.mas_equalTo(CGSizeMake(67*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X));
//    }];
    [self.dateImageView mas_makeConstraints:^(MASConstraintMaker *make) {//可约
        make.top.equalTo(self.backView.mas_top).offset(16*AUTO_SIZE_SCALE_X);
        make.left.equalTo(self.backView.mas_left).offset(-2);
        make.size.mas_equalTo(CGSizeMake(67 , 25 ));
    }];
    [self.busyLabel mas_makeConstraints:^(MASConstraintMaker *make) {//可约
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(4 );
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25 );
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//姓名
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.headImageView.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200, 16*AUTO_SIZE_SCALE_X));
    }];
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {//等级图标
        make.centerX.equalTo(self.backView.mas_centerX).offset(-30);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(14*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(12*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {//等级
        make.left.equalTo(self.levelImageView.mas_right).offset(6*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(14*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100, 12*AUTO_SIZE_SCALE_X));
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {//评分
        make.centerX.equalTo(self.backView.mas_centerX).offset(-84*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.levelLabel.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(84*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {//单数
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.levelLabel.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(84*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {//距离
        make.centerX.equalTo(self.backView.mas_centerX).offset(84*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.levelLabel.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(84*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.scoreNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {//评分详情
        make.centerX.equalTo(self.backView.mas_centerX).offset(-84*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(84*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {//单数详情
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.orderLabel.mas_bottom).offset(8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(84*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    [self.distanceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {//距离详情
        make.centerX.equalTo(self.backView.mas_centerX).offset(84*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(84*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.backgroundColor = [UIColor lightGrayColor];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = [UIColor lightGrayColor];
    UIImageView *line3 = [[UIImageView alloc]init];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:line1];
    [self.backView addSubview:line2];
    [self.backView addSubview:line3];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX).offset(-42*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.orderLabel.mas_top).offset(7*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.orderNumLabel.mas_bottom);
        make.width.mas_equalTo(0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX).offset(42*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.orderLabel.mas_top).offset(7*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.orderNumLabel.mas_bottom);
        make.width.mas_equalTo(0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(30);
        make.right.equalTo(self.backView.mas_right).offset(-30);
        make.top.equalTo(self.scoreNumLabel.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(0.5);
    }];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {//简介
        make.left.equalTo(line3.mas_left).offset(16*AUTO_SIZE_SCALE_X);
        make.right.equalTo(line3.mas_right).offset(-16*AUTO_SIZE_SCALE_X);
        make.top.equalTo(line3.mas_bottom).offset(14*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(50*AUTO_SIZE_SCALE_X);
    }];
    UIImageView *line4 = [[UIImageView alloc]init];
    line4.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(30);
        make.right.equalTo(self.backView.mas_right).offset(-30);
        make.top.equalTo(self.introduceLabel.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(0.5);
    }];
    [self.belongLabel mas_makeConstraints:^(MASConstraintMaker *make) {//所属
        make.top.equalTo(line4.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.centerX.equalTo(self.backView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.yuYueButton mas_makeConstraints:^(MASConstraintMaker *make) {//预约
        make.top.equalTo(self.belongLabel.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.centerX.equalTo(self.backView.mas_centerX);
//        make.left.mas_equalTo(60*AUTO_SIZE_SCALE_X);
//        make.bottom.mas_equalTo(-20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(194*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
    }];
}

#pragma mark - 懒加载
- (UIView *)contentView {
    if (_contentView == nil) {
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

//背景图
- (UIView *)backView {
    if (_backView == nil) {
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
//头像
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        self.headImageView.backgroundColor = [UIColor redColor];
        [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.data objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        self.headImageView.layer.cornerRadius = 35.0*AUTO_SIZE_SCALE_X;
        self.headImageView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer * headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
        self.headImageView.userInteractionEnabled = YES;
        [self.headImageView addGestureRecognizer:headImageTap];

    }
    return _headImageView;
}

-(void)showBigImage:(UITapGestureRecognizer * )sender
{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
    
}

//可约
- (UIImageView *)dateImageView {
    if (_dateImageView == nil) {
        self.dateImageView = [UIImageView new];
//        self.dateImageView.backgroundColor = [UIColor orangeColor];
        //可约
        if ([[NSString stringWithFormat:@"%@",[self.data objectForKey:@"isBusy"]] isEqualToString:@"2"]) {
            self.dateImageView.image = [UIImage imageNamed:@"icon_teachlist_normal"];
        }
        //满钟
        else if ([[NSString stringWithFormat:@"%@",[self.data objectForKey:@"isBusy"]] isEqualToString:@"1"]){
            self.dateImageView.image = [UIImage imageNamed:@"icon_teachlist_full"];
        }else{
            self.dateImageView.hidden = YES;
        }
    }
    return _dateImageView;
}
-(UILabel *)busyLabel
{
    if (_busyLabel == nil) {
        self.busyLabel = [UILabel new];
        //可约
        if ([[NSString stringWithFormat:@"%@",[self.data objectForKey:@"isBusy"]] isEqualToString:@"2"]) {
            self.busyLabel.text = @"今日可约";
        }
        //满钟
        else if ([[NSString stringWithFormat:@"%@",[self.data objectForKey:@"isBusy"]] isEqualToString:@"1"]){
            self.busyLabel.text = @"今日满钟";
        }
        else {
            self.busyLabel.hidden = YES;
        }
        self.busyLabel.textColor = [UIColor whiteColor];
        self.busyLabel.font = [UIFont systemFontOfSize:13];
        self.busyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _busyLabel;
}
//姓名
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        self.nameLabel = [UILabel new];
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[self.data objectForKey:@"name"]];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = RedUIColorC1;
    }
    return _nameLabel;
}
//等级图标
- (UIImageView *)levelImageView {
    if (_levelImageView == nil) {
        self.levelImageView = [UIImageView new];
        self.levelImageView.image = [UIImage imageNamed:@"icon_grade"];
    }
    return _levelImageView;
}
//等级
- (UILabel *)levelLabel {
    if (_levelLabel == nil) {
        self.levelLabel = [UILabel new];
        self.levelLabel.text = [NSString stringWithFormat:@"%@",[self.data objectForKey:@"gradeName"]];
        self.levelLabel.textAlignment = NSTextAlignmentLeft;
        self.levelLabel.font = [UIFont systemFontOfSize:13];
        self.levelLabel.textColor = C6UIColorGray;
    }
    return _levelLabel;
}
//评分
- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        self.scoreLabel = [UILabel new];
        self.scoreLabel.text = @"评分";
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel.font = [UIFont systemFontOfSize:11];
        self.scoreLabel.textColor = C6UIColorGray;
    }
    return _scoreLabel;
}
//单数
- (UILabel *)orderLabel {
    if (_orderLabel == nil) {
        self.orderLabel = [UILabel new];
        self.orderLabel.text = @"单数";
        self.orderLabel.textAlignment = NSTextAlignmentCenter;
        self.orderLabel.font = [UIFont systemFontOfSize:11];
        self.orderLabel.textColor = C6UIColorGray;
    }
    return _orderLabel;
}
//距离
- (UILabel *)distanceLabel {
    if (_distanceLabel == nil) {
        self.distanceLabel = [UILabel new];
        self.distanceLabel.text = @"距离";
        self.distanceLabel.textAlignment = NSTextAlignmentCenter;
        self.distanceLabel.font = [UIFont systemFontOfSize:11];
        self.distanceLabel.textColor = C6UIColorGray;
    }
    return _distanceLabel;
}
//评分详情
- (UILabel *)scoreNumLabel {
    if (_scoreNumLabel == nil) {
        self.scoreNumLabel = [UILabel new];
        self.scoreNumLabel.text = [NSString stringWithFormat:@"%@分",[self.data objectForKey:@"score"]] ;
        self.scoreNumLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreNumLabel.font = [UIFont systemFontOfSize:12];
        self.scoreNumLabel.textColor = OrangeUIColorC4;
    }
    return _scoreNumLabel;
}
//单数详情
- (UILabel *)orderNumLabel {
    if (_orderNumLabel == nil) {
        self.orderNumLabel = [UILabel new];
        self.orderNumLabel.text = [NSString stringWithFormat:@"%@单",[self.data objectForKey:@"orderCount"]];
        self.orderNumLabel.textAlignment = NSTextAlignmentCenter;
        self.orderNumLabel.font = [UIFont systemFontOfSize:12];
        self.orderNumLabel.textColor = OrangeUIColorC4;
    }
    return _orderNumLabel;
}
//距离详情
- (UILabel *)distanceNumLabel {
    if (_distanceNumLabel == nil) {
        self.distanceNumLabel = [UILabel new];
        self.distanceNumLabel.text = [NSString stringWithFormat:@"%@km",[self.data objectForKey:@"distance"]];
        self.distanceNumLabel.textAlignment = NSTextAlignmentCenter;
        self.distanceNumLabel.font = [UIFont systemFontOfSize:12];
        self.distanceNumLabel.textColor = OrangeUIColorC4;
    }
    return _distanceNumLabel;
}
//简介
- (UILabel *)introduceLabel {
    if (_introduceLabel == nil) {
        self.introduceLabel = [UILabel new];
        self.introduceLabel.numberOfLines = 0;
        self.introduceLabel.text = [NSString stringWithFormat:@"%@",[self.data objectForKey:@"introduction"]];
        self.introduceLabel.textAlignment = NSTextAlignmentLeft;
        self.introduceLabel.font = [UIFont systemFontOfSize:11];
        self.introduceLabel.textColor = C6UIColorGray;
        //        self.introduceLabel.backgroundColor = [UIColor greenColor];
    }
    return _introduceLabel;
}
//所属
- (UILabel *)belongLabel {
    if (_belongLabel == nil) {
        self.belongLabel = [UILabel new];
        self.belongLabel.text = [NSString stringWithFormat:@"所属:%@",[self.data objectForKey:@"storeName"]];
        self.belongLabel.textAlignment = NSTextAlignmentCenter;
        self.belongLabel.font = [UIFont systemFontOfSize:11];
        self.belongLabel.textColor = C6UIColorGray;
    }
    return _belongLabel;
}
//预约
- (UILabel *)yuYueButton {
    if (_yuYueButton == nil) {
        self.yuYueButton = [UILabel new];
        self.yuYueButton.font = [UIFont systemFontOfSize:15];
        self.yuYueButton.text = @"预约技师";
        self.yuYueButton.textColor = [UIColor blackColor];
//        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_teachappointment"]];
//        self.yuYueButton.backgroundColor = color;
        self.yuYueButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.yuYueButton.layer.borderWidth = 1.0;
        self.yuYueButton.textAlignment = NSTextAlignmentCenter;
//        self.yuYueButton
//        [self.yuYueButton setBackgroundImage:[UIImage imageNamed:@"btn_teachappointment"] forState:UIControlStateNormal];
//        [self.yuYueButton setTitle:@"预约技师" forState:UIControlStateNormal];
//        [self.yuYueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.yuYueButton addTarget:self action:@selector(yuYueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        self.yuYueButton.backgroundColor = [UIColor orangeColor];
    }
    return _yuYueButton;
}
- (void)yuYueButtonPressed:(UIButton *)sender {
    NSLog(@"预约技师");
}

@end
