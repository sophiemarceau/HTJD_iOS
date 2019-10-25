//
//  GridView.m
//  Pet
//
//  Created by ChinaSoft-Developer-01 on 14/7/24.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import "GridView.h"
#import "UIImageView+WebCache.h"
#import "technicianViewController.h"
#import "TechnicianMyselfViewController.h"

#import "ServiceDetailViewController.h"
@implementation GridView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}


-(void)_initView{
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor redColor];
    [self addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2-15, 108.75f*AUTO_SIZE_SCALE_X)];
    [self.contentView addSubview:self.imageView ];
    
    self.titleLabel = [[UILabel  alloc] init];
    self.titleLabel.backgroundColor =[UIColor clearColor];
    self.titleLabel.textColor = BlackUIColorC5;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel ];

    self.AddressLabel = [[UILabel alloc] init];
    self.AddressLabel.textColor = C6UIColorGray;
    self.AddressLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.AddressLabel];
    
    self.PriceLabel = [[UILabel alloc] init];
    self.PriceLabel.textColor = RedUIColorC3;
//    self.PriceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.PriceLabel];
    
    self.remarkPriceLabel = [[UILabel alloc] init];
    self.remarkPriceLabel.textColor = UIColorFromRGB(0x9c9c9c);
    self.remarkPriceLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:self.remarkPriceLabel];
    
    self.markLabel = [[UILabel alloc] init];
    self.markLabel.textColor = C6UIColorGray;
    self.markLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.markLabel];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];

    //当前view
    if ([self.lie isEqualToString:@"0"]) {
        _contentView.frame =  CGRectMake(10, 10, kScreenWidth/2-15, (108.75f+88.0f)*AUTO_SIZE_SCALE_X) ;
    }
    else if ([self.lie isEqualToString:@"1"])
    {
        _contentView.frame =  CGRectMake(5, 10, kScreenWidth/2-15, (108.75f+88.0f)*AUTO_SIZE_SCALE_X) ;
    }
    _contentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.contentView addGestureRecognizer:tap];
    
    //图片
    if ( [[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]] isEqualToString:@""]) {
        [self.imageView  setImage:[UIImage imageNamed:@"项目列表小图"]];
    }else{
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"项目列表小图"]];
    }
    
    //项目名称
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]];
    self.titleLabel.frame = CGRectMake(10, self.imageView.frame.origin.y+self.imageView.frame.size.height+12*AUTO_SIZE_SCALE_X, kScreenWidth/2-15-10.0, 14.0f*AUTO_SIZE_SCALE_X);
    
    //地址
    if ([self.dataDic objectForKey:@"storeName"]!=NULL &&[self.dataDic objectForKey:@"storeName"]!=nil && ![[self.dataDic objectForKey:@"storeName"] isEqualToString:@""]){
        self.AddressLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"storeName"]];
    }
    else{
        self.AddressLabel.text = [NSString stringWithFormat:@"%@",@"华佗驾到自营"];
    }
    self.AddressLabel.frame = CGRectMake(10, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+10*AUTO_SIZE_SCALE_X, kScreenWidth/2-15-10.0f, 12.0f*AUTO_SIZE_SCALE_X);
    
    //价格
    NSString * moneyStr = @"";
    int monetInt = [[self.dataDic objectForKey:@"minPrice"] intValue];
    if (monetInt%100 == 0) {
        monetInt = monetInt/100;
        moneyStr = [NSString stringWithFormat:@"¥ %d",monetInt];
    }else{
        float money = [[self.dataDic objectForKey:@"minPrice"] floatValue];
        money = money/100.0;
        moneyStr = [NSString stringWithFormat:@"¥ %0.2f",money];
    }
    NSMutableAttributedString * attmoneyStrStr;
    if ([[ NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isLevel"] ] isEqualToString:@"0"]){
        attmoneyStrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:9 ]
                               range:NSMakeRange(0, 1)];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:12 ]
                               range:NSMakeRange( 1,moneyStr.length-1)];
//        [attmoneyStrStr addAttribute:NSFontAttributeName
//                               value:[UIFont systemFontOfSize:9 ]
//                               range:NSMakeRange(moneyStr.length-1, 1)];
        [attmoneyStrStr addAttribute:NSForegroundColorAttributeName
                               value:RedUIColorC3
                               range:NSMakeRange(0, moneyStr.length)];

    }else{
        moneyStr = [NSString stringWithFormat:@"%@ 起",moneyStr];
        attmoneyStrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:9 ]
                               range:NSMakeRange(0, 1)];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:12 ]
                               range:NSMakeRange( 1,moneyStr.length-1)];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:9 ]
                               range:NSMakeRange(moneyStr.length-1, 1)];
        [attmoneyStrStr addAttribute:NSForegroundColorAttributeName
                               value:RedUIColorC3
                               range:NSMakeRange(0, moneyStr.length)];

    }
    self.PriceLabel.attributedText = attmoneyStrStr;
    CGSize priceLabelSize = [self.PriceLabel intrinsicContentSize];
    self.PriceLabel.frame = CGRectMake(10, self.AddressLabel.frame.size.height+self.AddressLabel.frame.origin.y+12*AUTO_SIZE_SCALE_X, priceLabelSize.width, 12*AUTO_SIZE_SCALE_X);
    
//    [attmoneyStrStr addAttribute:NSStrikethroughStyleAttributeName
//                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
//                          range:NSMakeRange( 0, moneyStr.length-0)];
    
    //市场价
    NSString * remarkPrice = @"";
    int temonetInt = [[self.dataDic objectForKey:@"marketPrice"] intValue];
    if (temonetInt%100 == 0) {
        temonetInt = temonetInt/100;
        remarkPrice = [NSString stringWithFormat:@"%d ",temonetInt];
    }else{
        float temoney = [[self.dataDic objectForKey:@"marketPrice"] floatValue];
        temoney = temoney/100.0;
        remarkPrice = [NSString stringWithFormat:@"%0.2f ",temoney];
    }
    NSMutableAttributedString * attTemoneyStr  = [[NSMutableAttributedString alloc] initWithString:remarkPrice];
    [attTemoneyStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:9]
                          range:NSMakeRange( 0,remarkPrice.length)];
    [attTemoneyStr addAttribute:NSForegroundColorAttributeName
                          value:C6UIColorGray
                          range:NSMakeRange(0, remarkPrice.length)];
    [attTemoneyStr addAttribute:NSStrikethroughStyleAttributeName
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                          range:NSMakeRange( 0, remarkPrice.length)];
    self.remarkPriceLabel.attributedText = attTemoneyStr;
    CGSize remarkPriceLabelSize = [self.remarkPriceLabel intrinsicContentSize];
    self.remarkPriceLabel.frame = CGRectMake(self.PriceLabel.frame.origin.x+self.PriceLabel.frame.size.width+6, self.PriceLabel.frame.origin.y+self.PriceLabel.frame.size.height-9.5*AUTO_SIZE_SCALE_X, remarkPriceLabelSize.width, 9*AUTO_SIZE_SCALE_X);
    
    //分数
    self.markLabel.text = [NSString stringWithFormat:@"%@ 分",[self.dataDic objectForKey:@"score"]];
    CGSize scoreSize = [self.markLabel intrinsicContentSize];
    self.markLabel.frame = CGRectMake(self.contentView.frame.size.width-scoreSize.width-10, self.PriceLabel.frame.origin.y+self.PriceLabel.frame.size.height-10.5*AUTO_SIZE_SCALE_X, scoreSize.width, 10*AUTO_SIZE_SCALE_X);


}


-(void)taped:(UITapGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoServiceDetailController" object:self.dataDic];

//    ServiceDetailViewController *VC =[[ServiceDetailViewController alloc] init];
//    VC.haveWorker = NO;
//    if ([[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
//        VC.isStore = YES;
//    }else if([[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
//        VC.isStore = NO;
//    }
//    [[RequestManager shareRequestManager].CurrMainController.navigationController pushViewController:VC animated:YES];
}

-(void)setData:(NSString *)data{
    if (_data!=data) {
        _data =data;
    }
    [self setNeedsLayout];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic!=dataDic) {
        _dataDic =dataDic;
    }
    [self setNeedsLayout];
}

@end
