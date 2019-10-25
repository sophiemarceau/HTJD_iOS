//
//  consumptionTableViewCell.m
//  Massage
//
//  Created by 屈小波 on 15/11/20.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "consumptionTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation consumptionTableViewCell

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
    
    self.contentView.backgroundColor =C2UIColorGray;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self.contentView addSubview:self.BGView];
    [self.BGView addSubview:self.doorView];
    [self.BGView addSubview:self.arrowImageView];
    [self.doorView addSubview:self.doorLabel];
    [self.BGView addSubview:self.pictureImageView];
    [self.BGView addSubview:self.statusImageView];
    [self.BGView addSubview:self.lineImageView];
    [self.BGView addSubview:self.serviceTimeLabel];
    [self.BGView addSubview:self.serviceLabel];
    [self.BGView addSubview:self.serviceAddressLabel];
    [self.BGView addSubview:self.line1ImageView];
    [self.BGView addSubview:self.codeLabel];
     [self.BGView addSubview:self.codeLabel1];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake((50.5), 50.5));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(self.doorLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth)-10-50.5-10, 0.5));
    }];
    
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(96);
        make.top.mas_equalTo(self.lineImageView.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake((150), 15));
    }];
    
    [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.serviceLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth-96-10), 15));
    }];

    [self.serviceAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.serviceTimeLabel.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth-96-10), 36));
    }];

    
    self.codeLabel1.text = [self.data objectForKey:@"exchangeCode"];
//    CGSize codeLabelSize1 = [self.codeLabel1 intrinsicContentSize];
//    CGSize size = [self.codeLabel1.text sizeWithAttributes:@{NSFontAttributeName:self.codeLabel1.font}];
  
    
    [self.codeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);

        make.top.mas_equalTo(self.line1ImageView.mas_bottom).offset(10);
//        make.size.mas_equalTo(CGSizeMake((codeLabelSize1.width), 15));
        make.size.mas_equalTo(CGSizeMake(120, 15));
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kScreenWidth-10-codeLabelSize1.width-60);
        make.left.mas_equalTo(kScreenWidth-10-120-60);
        make.top.mas_equalTo(self.line1ImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((100), 15));
    }];
    
    self.doorLabel.text =[self.data objectForKey:@"storeName"];
    if ([[self.data objectForKey:@"state"] isEqualToString:@"2"]) {
        [self.statusImageView setImage:[UIImage imageNamed:@"img_code_notused"]];
    }else if ([[self.data objectForKey:@"state"] isEqualToString:@"3"]) {
        
        [self.statusImageView setImage:[UIImage imageNamed:@"img_code_used"]];
    }
    
    [self.pictureImageView setImageWithURL:[NSURL URLWithString:[self.data objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.serviceLabel.text =[NSString stringWithFormat:@"%@",[self.data objectForKey:@"servName"]];
    self.serviceTimeLabel.text =[NSString stringWithFormat:@"预约服务时间: %@",[self.data objectForKey:@"serviceTime"]];
    self.serviceAddressLabel.text =[NSString stringWithFormat:@"预约地址: %@",[self.data objectForKey:@"storeAddress"]];
    
//    [self.codeLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ceilf(codeLabelSize1.width), 15));
//    }];
//    [self.codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kScreenWidth-10-codeLabelSize1.width-60);
//    }];
}

-(UIView *)BGView{
    if (_BGView ==nil) {
        _BGView = [UIView new];
        _BGView.backgroundColor =[UIColor whiteColor];
        _BGView.frame = CGRectMake(0, 10, kScreenWidth, 170);
        
    }
    return _BGView;
}

-(UIView *)doorView{
    if (_doorView ==nil) {
        _doorView = [UIView new];
        _doorView.backgroundColor =[UIColor clearColor];
        _doorView.frame = CGRectMake(0, 0, kScreenWidth, 35);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [_doorView addGestureRecognizer:tap];
    }
    return _doorView;
}

-(UILabel *)doorLabel{
    if (_doorLabel ==nil) {
        _doorLabel = [UILabel new];
        _doorLabel.backgroundColor =[UIColor clearColor];
        _doorLabel.frame = CGRectMake(10, 0, 145, 35);
        _doorLabel.textAlignment = NSTextAlignmentLeft;
        _doorLabel.font = [UIFont systemFontOfSize:13.0f];
        _doorLabel.textColor = BlackUIColorC5;
        
        
    }
    return _doorLabel;
}

-(UIImageView *)arrowImageView{
    if (_arrowImageView ==nil) {
        _arrowImageView = [UIImageView new];
        [_arrowImageView setImage:[UIImage imageNamed:@"uc_menu_link"]];
        _arrowImageView.backgroundColor =[UIColor clearColor];
        _arrowImageView.frame = CGRectMake(155, 10.5, 7, 14);
        
    }
    return _arrowImageView;
}

-(UIImageView *)statusImageView{
    if (_statusImageView ==nil) {
        _statusImageView = [UIImageView new];
//        [_statusImageView setImage:[UIImage imageNamed:@"uc_menu_link"]];
        _statusImageView.backgroundColor =[UIColor clearColor];
        
    }
    return _statusImageView;
}

-(UIImageView *)pictureImageView{
    if (_pictureImageView ==nil) {
        _pictureImageView = [UIImageView new];
        _pictureImageView.backgroundColor =[UIColor clearColor];
        _pictureImageView.frame = CGRectMake(10, 47	, 75, 75);

    }
    return _pictureImageView;
}

-(UIImageView *)lineImageView{
    if (_lineImageView ==nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineImageView;
}

-(UILabel *)serviceLabel{
    if (_serviceLabel ==nil) {
        _serviceLabel = [UILabel new];
        _serviceLabel.backgroundColor =[UIColor clearColor];
        _serviceLabel.frame = CGRectMake(96, 0, 150, 14);
        _serviceLabel.textAlignment = NSTextAlignmentLeft;
        _serviceLabel.text =[self.data objectForKey:@"_serviceLabel"];
        _serviceLabel.font = [UIFont systemFontOfSize:14.0f];
        _serviceLabel.textColor = BlackUIColorC5;
      
    }
    return _serviceLabel;
}

-(UILabel *)serviceTimeLabel{
    if (_serviceTimeLabel ==nil) {
        _serviceTimeLabel = [UILabel new];

        //        [_lineImageView setImage:[UIImage imageNamed:@"uc_menu_link"]];
        _serviceTimeLabel.backgroundColor =[UIColor clearColor];
        _serviceTimeLabel.textColor = C6UIColorGray;
        _serviceTimeLabel.font = [UIFont systemFontOfSize:11.0f];
//        _serviceTimeLabel.frame = CGRectMake(96, 10.5, 7, 14);
        
    }
    return _serviceTimeLabel;
}

-(UILabel *)serviceAddressLabel{
    if (_serviceAddressLabel ==nil) {
        _serviceAddressLabel = [UILabel new];
        _serviceAddressLabel.numberOfLines = 2;
        _serviceAddressLabel.backgroundColor =[UIColor clearColor];
        _serviceAddressLabel.font = [UIFont systemFontOfSize:11.0f];
        _serviceAddressLabel.textColor = C6UIColorGray;
        
    }
    return _serviceAddressLabel;
}

-(UIImageView *)line1ImageView{
    if (_line1ImageView == nil) {
        _line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 47+75+12, (kScreenWidth-10), 0.5)];
        _line1ImageView.backgroundColor = [UIColor clearColor];
        UIGraphicsBeginImageContext(_line1ImageView.frame.size);   //开始画线
        [_line1ImageView.image drawInRect:CGRectMake(0, 0, _line1ImageView.frame.size.width, _line1ImageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        CGFloat lengths[] = {5,2};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 0.5);    //开始画线
        CGContextAddLineToPoint(line, kScreenWidth, 0.5);
        CGContextStrokePath(line);
        
        _line1ImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        
    }
    return _line1ImageView;
}



-(UILabel *)codeLabel{
    if (_codeLabel==nil) {
        _codeLabel = [UILabel new];
        _codeLabel.backgroundColor =[UIColor clearColor];
        _codeLabel.text =@"消费码:";
        _codeLabel.font = [UIFont systemFontOfSize:14.0f];
        _codeLabel.textAlignment = NSTextAlignmentLeft;
        _codeLabel.textColor = C6UIColorGray;
        
    }
    return _codeLabel;
}


-(UILabel *)codeLabel1{
    if (_codeLabel1==nil) {
        _codeLabel1 = [UILabel new];
        _codeLabel1.backgroundColor =[UIColor clearColor];
        _codeLabel1.textAlignment = NSTextAlignmentRight;
        _codeLabel1.font = [UIFont systemFontOfSize:14.0f];
        _codeLabel1.textColor = BlackUIColorC5;
      
    }
    return _codeLabel1;
}

-(void)taped:(UITapGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoStoreController" object:self.data];
    
}

@end
