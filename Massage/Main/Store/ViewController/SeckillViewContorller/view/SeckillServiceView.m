//
//  SeckillServiceView.m
//  Massage
//
//  Created by htjd_IOS on 16/2/25.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "SeckillServiceView.h"
#import "UIImageView+WebCache.h"
@implementation SeckillServiceView
{
    UIImageView * serviceIcon;
    UILabel * serviceNameLabel;
    UILabel * mendianLabel;
    UILabel * storeNameLabel;
    UIImageView * addressIcon;
    UILabel * addressLabel;
    
    UIView * variableView;
    
    UIButton * killBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView
{

    self.backgroundColor = [UIColor greenColor];
    
    serviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(9*AUTO_SIZE_SCALE_X1, 9, kScreenWidth-18*AUTO_SIZE_SCALE_X1, 267*AUTO_SIZE_SCALE_X1)];
    [self addSubview:serviceIcon];
    
    serviceNameLabel = [[UILabel alloc] init];
    serviceNameLabel.font = [UIFont boldSystemFontOfSize:16];
    serviceNameLabel.textColor = UIColorFromRGB(0x1D1D1D);
    [self addSubview:serviceNameLabel];
    
    mendianLabel = [[UILabel alloc] init];
    mendianLabel.font = [UIFont systemFontOfSize:11];
    mendianLabel.text = @"门店";
    mendianLabel.textColor = UIColorFromRGB(0x92969C);
    mendianLabel.textAlignment = NSTextAlignmentCenter;
    mendianLabel.backgroundColor = UIColorFromRGB(0xEFEFEF);
    mendianLabel.layer.cornerRadius = 1;
    mendianLabel.layer.masksToBounds = YES;
    [self addSubview:mendianLabel];
    
    storeNameLabel = [[UILabel alloc] init];
    storeNameLabel.font = [UIFont systemFontOfSize:13];
    storeNameLabel.textColor = UIColorFromRGB(0x747277);
    [self addSubview:storeNameLabel];
    
    addressIcon = [[UIImageView alloc] init];
    addressIcon.image = [UIImage imageNamed:@"icon_sd_awayfrom"];
    [self addSubview:addressIcon];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont boldSystemFontOfSize:13];
    addressLabel.textColor = UIColorFromRGB(0x747277);
    [self addSubview:addressLabel];
    
    variableView = [[UIView alloc] init];
    variableView.backgroundColor = [UIColor redColor];
    [self addSubview:variableView];
    
    killBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [killBtn setTitle:@"秒杀" forState:UIControlStateNormal];
    killBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [killBtn addTarget:self action:@selector(killBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    killBtn.frame = CGRectMake(274*AUTO_SIZE_SCALE_X1, 70*AUTO_SIZE_SCALE_X1+13*AUTO_SIZE_SCALE_X1, 90*AUTO_SIZE_SCALE_X1, 30*AUTO_SIZE_SCALE_X1);
    //可以秒杀
    if (1) {
        [killBtn setTitleColor:UIColorFromRGB(0x1D1D1D) forState:UIControlStateNormal];
        [killBtn setBackgroundColor:[UIColor whiteColor]];
        killBtn.layer.borderWidth = 1.0;
        killBtn.layer.borderColor = UIColorFromRGB(0x1D1D1D).CGColor;
    }
    //不能秒杀
    else{
        [killBtn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
        [killBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
        killBtn.layer.borderWidth = 1.0;
        killBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    [variableView addSubview:killBtn];


}

//-(void)setCount:(int)count
//{
//    _count = count;
//    NSLog(@"%d",_count%5);
//}
//
//-(void)setStoreName:(NSString *)storeName
//{
//    _storeName = storeName;
//    storeNameLabel.text = _storeName;
//    storeNameLabel.frame = CGRectMake(mendianLabel.frame.origin.x+mendianLabel.frame.size.width+6*AUTO_SIZE_SCALE_X1, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+14*AUTO_SIZE_SCALE_X1, kScreenWidth-(mendianLabel.frame.origin.x+mendianLabel.frame.size.width+10*AUTO_SIZE_SCALE_X1+10*AUTO_SIZE_SCALE_X1), 13*AUTO_SIZE_SCALE_X1);
//
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"%d",self.count);
    
//    if (variableView) {
//        [variableView removeFromSuperview];
//    }
    [serviceIcon setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    
    serviceNameLabel.text = @"丝袜小妹儿全套大保健";
    serviceNameLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, serviceIcon.frame.origin.y+serviceIcon.frame.size.height+13*AUTO_SIZE_SCALE_X1, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 16*AUTO_SIZE_SCALE_X1);

    mendianLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+12*AUTO_SIZE_SCALE_X1, 31*AUTO_SIZE_SCALE_X1, 15*AUTO_SIZE_SCALE_X1);
    
    storeNameLabel.text = @"包您满意休闲会所";
    storeNameLabel.frame = CGRectMake(mendianLabel.frame.origin.x+mendianLabel.frame.size.width+6*AUTO_SIZE_SCALE_X1, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+14*AUTO_SIZE_SCALE_X1, kScreenWidth-(mendianLabel.frame.origin.x+mendianLabel.frame.size.width+10*AUTO_SIZE_SCALE_X1+10*AUTO_SIZE_SCALE_X1), 13*AUTO_SIZE_SCALE_X1);

    addressIcon.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, mendianLabel.frame.origin.y+mendianLabel.frame.size.height+12*AUTO_SIZE_SCALE_X1, 10*AUTO_SIZE_SCALE_X1, 13*AUTO_SIZE_SCALE_X1);
    
    addressLabel.text = @"小胡同里面左拐右拐加左拐";
    addressLabel.frame = CGRectMake(addressIcon.frame.origin.x+addressIcon.frame.size.width+7*AUTO_SIZE_SCALE_X1, storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+13*AUTO_SIZE_SCALE_X1, kScreenWidth-(addressIcon.frame.origin.x+addressIcon.frame.size.width+7*AUTO_SIZE_SCALE_X1+10*AUTO_SIZE_SCALE_X1), 13*AUTO_SIZE_SCALE_X1);
    
//    variableView = [[UIView alloc] init];
//    variableView.backgroundColor = [UIColor redColor];
    variableView.frame = CGRectMake(0, addressLabel.frame.origin.y+addressLabel.frame.size.height+10*AUTO_SIZE_SCALE_X1, kScreenWidth, self.frame.size.height-(addressLabel.frame.origin.y+addressLabel.frame.size.height+10*AUTO_SIZE_SCALE_X1));
//    [self addSubview:variableView];
    
//    //需要判断，如果有提示，那么 添加第一个虚线 ·
//    UIImageView * line1 = [[UIImageView alloc] init];
//    line1.image = [UIImage imageNamed:@"img_dottedline1"];
//    line1.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, 0, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 1);
//    [variableView addSubview:line1];
//
//    float lbheight = 0;
//    for (int i = 0; i<3; i++) {
//        UILabel * lb = [[UILabel alloc] init];
//        lb.text = @"· 啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊";
//        lb.textColor = UIColorFromRGB(0x747277);
//        lb.numberOfLines = 0;
//        lb.font = [UIFont systemFontOfSize:12];
//        CGSize maxSize = CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X1, 200);
//        CGSize lbSize = [lb.text sizeWithFont:lb.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
//        lb.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1,lbheight+line1.frame.origin.y+line1.frame.size.height+10*AUTO_SIZE_SCALE_X1, kScreenWidth-30*AUTO_SIZE_SCALE_X1, lbSize.height);
//        lbheight = lbSize.height*(i+1)+4*AUTO_SIZE_SCALE_X1*(i+1);
//        [variableView addSubview:lb];
//    }
//
//    //秒杀，添加第二个虚线
//    UIImageView * line2 = [[UIImageView alloc] init];
//    line2.image = [UIImage imageNamed:@"img_dottedline1"];
//    line2.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, 70*AUTO_SIZE_SCALE_X1, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 1);
//    [variableView addSubview:line2];
//
//    //秒杀价
//    UILabel * killPriceLabel = [[UILabel alloc] init];
//    [variableView addSubview:killPriceLabel];
//    
//    //原价
//    UILabel * marketPriceLabel = [[UILabel alloc] init];
//    [variableView addSubview:marketPriceLabel];
//    
//    //服务等级
//    UILabel * serviceLevelLabel = [[UILabel alloc] init];
//    [variableView addSubview:serviceLevelLabel];
//    
//    //剩余量
//    UILabel * numLeftLabel = [[UILabel alloc] init];
//    [variableView addSubview:numLeftLabel];
//    
//    killBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [killBtn setTitle:@"秒杀" forState:UIControlStateNormal];
//    killBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [killBtn addTarget:self action:@selector(killBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    killBtn.frame = CGRectMake(274*AUTO_SIZE_SCALE_X1, 70*AUTO_SIZE_SCALE_X1+13*AUTO_SIZE_SCALE_X1, 90*AUTO_SIZE_SCALE_X1, 30*AUTO_SIZE_SCALE_X1);
//    //可以秒杀
//    if (1) {
//        [killBtn setTitleColor:UIColorFromRGB(0x1D1D1D) forState:UIControlStateNormal];
//        [killBtn setBackgroundColor:[UIColor whiteColor]];
//        killBtn.layer.borderWidth = 1.0;
//        killBtn.layer.borderColor = UIColorFromRGB(0x1D1D1D).CGColor;
//    }
//    //不能秒杀
//    else{
//        [killBtn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
//        [killBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
//        killBtn.layer.borderWidth = 1.0;
//        killBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    }
//    [variableView addSubview:killBtn];
//
//    //根据秒杀个数 添加更多虚线 用for循环创建
//    UIImageView * line3 = [[UIImageView alloc] init];
//    line3.image = [UIImage imageNamed:@"img_dottedline1"];
//    line3.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, line2.frame.origin.y+line2.frame.size.height+55*AUTO_SIZE_SCALE_X1, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 1);
//    [variableView addSubview:line3];
    
    
    
}

-(void)killBtnPressed:(UIButton *)sender
{
    NSLog(@"秒杀");
}

@end
