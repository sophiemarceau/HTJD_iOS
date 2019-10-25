//
//  PayInfo.m
//  Massage
//
//  Created by htjd_IOS on 15/11/25.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "PayInfo.h"

@implementation PayInfo

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
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth), 203*AUTO_SIZE_SCALE_X)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
#pragma mark 优惠券
    UILabel * couponShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    couponShowLabel.text = [NSString stringWithFormat:@"优惠券%@",@"-¥20"];
    couponShowLabel.textAlignment = NSTextAlignmentRight;
    couponShowLabel.font = [UIFont systemFontOfSize:13];
    CGSize couponShowLabelSize = [couponShowLabel intrinsicContentSize];
    couponShowLabel.frame = CGRectMake(kScreenWidth-couponShowLabelSize.width-10*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, couponShowLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:couponShowLabel];
    
#pragma mark 单价*钟数
    UILabel * allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    allPriceLabel.text = [NSString stringWithFormat:@"¥%d*%d=¥%d",138,2,276];
    allPriceLabel.textAlignment = NSTextAlignmentRight;
    allPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize allPriceLabelSize = [allPriceLabel intrinsicContentSize];
    allPriceLabel.frame = CGRectMake(kScreenWidth-(couponShowLabel.frame.origin.x+10*AUTO_SIZE_SCALE_X+allPriceLabelSize.width), 15*AUTO_SIZE_SCALE_X, allPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:allPriceLabel];

#pragma mark 交通费
    UILabel * busPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    busPriceLabel.text = [NSString stringWithFormat:@"交通费%@",@"¥100"];
    busPriceLabel.textAlignment = NSTextAlignmentRight;
    busPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize busPriceLabelSize = [busPriceLabel intrinsicContentSize];
    busPriceLabel.frame = CGRectMake(kScreenWidth-busPriceLabelSize.width-10*AUTO_SIZE_SCALE_X, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, busPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:busPriceLabel];
    
#pragma mark 带床上门
    UILabel * bedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    bedPriceLabel.text = [NSString stringWithFormat:@"带床上门%@",@"¥20"];
    bedPriceLabel.textAlignment = NSTextAlignmentRight;
    bedPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize bedPriceLabelSize = [bedPriceLabel intrinsicContentSize];
    bedPriceLabel.frame = CGRectMake(kScreenWidth-(busPriceLabel.frame.origin.x+10*AUTO_SIZE_SCALE_X+bedPriceLabelSize.width), allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, bedPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:bedPriceLabel];

#pragma mark 总时长
    UILabel * allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bedPriceLabel.frame.origin.y+bedPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    allTimeLabel.text = [NSString stringWithFormat:@"总时长: %@分钟",@"90"];
    allTimeLabel.textAlignment = NSTextAlignmentRight;
    allTimeLabel.font = [UIFont systemFontOfSize:13];
    CGSize allTimeLabelSize = [allTimeLabel intrinsicContentSize];
    allTimeLabel.frame = CGRectMake(kScreenWidth-(allTimeLabelSize.width+10*AUTO_SIZE_SCALE_X), bedPriceLabel.frame.origin.y+bedPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, allTimeLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:allTimeLabel];

#pragma mark 总计
    UILabel * paymentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allTimeLabel.frame.origin.y+allTimeLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    paymentPriceLabel.text = [NSString stringWithFormat:@"总计: ¥%@",@"198.5"];
    paymentPriceLabel.textAlignment = NSTextAlignmentRight;
    paymentPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize paymentPriceLabelSize = [paymentPriceLabel intrinsicContentSize];
    paymentPriceLabel.frame = CGRectMake(kScreenWidth-(paymentPriceLabelSize.width+10*AUTO_SIZE_SCALE_X), allTimeLabel.frame.origin.y+allTimeLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, paymentPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:paymentPriceLabel];

    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, paymentPriceLabel.frame.origin.y+paymentPriceLabel.frame.size.height+18*AUTO_SIZE_SCALE_X);
}

@end
