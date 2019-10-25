//
//  SpecialSKTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 16/3/3.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "SpecialSKTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SpecialSKTableViewCell
{
    UIImageView * storeIcon;
    UIView * priceBgView;
    UILabel * priceLabel;
    UILabel * storeNameLabel;
    UILabel * scoreNameLabel;
}
- (void)awakeFromNib {
    // Initialization code
    [self _initView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
//    NSLog(@"1111");
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 322*AUTO_SIZE_SCALE_X1)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    storeIcon = [[UIImageView alloc] init];
    storeIcon.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1, 15*AUTO_SIZE_SCALE_X1, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 267*AUTO_SIZE_SCALE_X1);
    [bgView addSubview:storeIcon];
    
    priceBgView = [[UIView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X1, storeIcon.frame.size.height - 43*AUTO_SIZE_SCALE_X1, 87*AUTO_SIZE_SCALE_X1, 43*AUTO_SIZE_SCALE_X1)];
    priceBgView.backgroundColor = [UIColor blackColor];
    priceBgView.alpha = 0.3;
    [storeIcon addSubview:priceBgView];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X1+10*AUTO_SIZE_SCALE_X1, storeIcon.frame.size.height - 43*AUTO_SIZE_SCALE_X1, 87*AUTO_SIZE_SCALE_X1, 43*AUTO_SIZE_SCALE_X1)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [storeIcon addSubview:priceLabel];
    
    storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, storeIcon.frame.origin.y+storeIcon.frame.size.height+12*AUTO_SIZE_SCALE_X1, 230*AUTO_SIZE_SCALE_X1, 18*AUTO_SIZE_SCALE_X1)];
    storeNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    storeNameLabel.textColor = BlackUIColorC5   ;
    storeNameLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:storeNameLabel];
    
    scoreNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeNameLabel.frame.origin.x+storeNameLabel.frame.size.width+10, storeIcon.frame.origin.y+storeIcon.frame.size.height+14*AUTO_SIZE_SCALE_X1, kScreenWidth-storeNameLabel.frame.origin.x-storeNameLabel.frame.size.width-10-18*AUTO_SIZE_SCALE_X1, 15*AUTO_SIZE_SCALE_X1)];
    scoreNameLabel.textColor = UIColorFromRGB(0x747277) ;
    scoreNameLabel.textAlignment = NSTextAlignmentRight;
    scoreNameLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:scoreNameLabel];
    
//    scoreNameLabel.textColor = [UIColor colorWithRed:((float)((0x747277 & 0xFF0000) >> 16))/255.0 green:((float)((0x747277 & 0xFF00) >> 8))/255.0 blue:((float)(0x747277 & 0xFF))/255.0 alpha:1.0];
//    scoreNameLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0  ];
    
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [storeIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    
    NSString * moneyStr = @"";
    int monetInt = [[self.dataDic objectForKey:@"minPrice"] intValue];
    if (monetInt%100 == 0) {
        monetInt = monetInt/100;
        moneyStr = [NSString stringWithFormat:@"¥%d起",monetInt];
    }else{
        float money = [[self.dataDic objectForKey:@"minPrice"] floatValue];
        money = money/100.0;
        moneyStr = [NSString stringWithFormat:@"¥%0.2f起",money];
    }
    NSMutableAttributedString * attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attMoneyStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:13.0]
                        range:NSMakeRange(0, 1)];
    [attMoneyStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:13.0]
                        range:NSMakeRange(moneyStr.length-1, 1)];
    [attMoneyStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:24]
                        range:NSMakeRange( 1,moneyStr.length-2)];
    [attMoneyStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, moneyStr.length)];
    priceLabel.attributedText = attMoneyStr;
    CGSize priceLabelSize = [priceLabel intrinsicContentSize];
    priceLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X, storeIcon.frame.size.height - 43*AUTO_SIZE_SCALE_X, priceLabelSize.width, 43*AUTO_SIZE_SCALE_X);
    priceBgView.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, storeIcon.frame.size.height - 43*AUTO_SIZE_SCALE_X, priceLabelSize.width+20*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_X);

    
    if (monetInt == 0) {
        priceLabel.hidden = YES;
        priceBgView.hidden = YES;
    }
    if ([[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isReservable"]] isEqualToString:@"0"]) {
        priceLabel.hidden = YES;
        priceBgView.hidden = YES;
    }
    
    storeNameLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]];
    
    if ([self.dataDic objectForKey:@"stock"]) {
        scoreNameLabel.text = [NSString stringWithFormat:@"剩余%@份",[self.dataDic objectForKey:@"stock"]];
    }
    else{
        scoreNameLabel.text = [NSString stringWithFormat:@"剩余%@份",@"0"];
    }

    
}

@end
