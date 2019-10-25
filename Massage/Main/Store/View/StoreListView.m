//
//  StoreListView.m
//  Massage
//
//  Created by htjd_IOS on 15/11/5.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "StoreListView.h"
#import "UIImageView+WebCache.h"
@implementation StoreListView

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

-(void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic!=dataDic) {
        _dataDic =dataDic;
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    
//    NSLog(@"AUTO_SIZE_SCALE_X %f",16*AUTO_SIZE_SCALE_X);
//    NSLog(@"AUTO_SIZE_SCALE_X %f",AUTO_SIZE_SCALE_X);
//    NSLog(@"self.dataDic -- %@",self.dataDic);
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    UIImageView * logoImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, (kScreenWidth-20)/4*3)];
    logoImv.backgroundColor = [UIColor clearColor];
    [logoImv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
    logoImv.userInteractionEnabled = YES;
    [self.contentView addSubview:logoImv];
    
    UIView * priceBgView = [[UIView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, logoImv.frame.size.height - 43*AUTO_SIZE_SCALE_X, 87*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_X)];
    priceBgView.backgroundColor = [UIColor blackColor];
    priceBgView.alpha = 0.3;
    [logoImv addSubview:priceBgView];
    
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
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X, logoImv.frame.size.height - 43*AUTO_SIZE_SCALE_X, 87*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_X)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.attributedText = attMoneyStr;
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [logoImv addSubview:priceLabel];
    if (monetInt == 0) {
        priceLabel.hidden = YES;
        priceBgView.hidden = YES;
    }
    if ([[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isReservable"]] isEqualToString:@"0"]) {
        priceLabel.hidden = YES;
        priceBgView.hidden = YES;
    }
    
    CGSize priceLabelSize = [priceLabel intrinsicContentSize];
    priceLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X, logoImv.frame.size.height - 43*AUTO_SIZE_SCALE_X, priceLabelSize.width, 43*AUTO_SIZE_SCALE_X);
    priceBgView.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, logoImv.frame.size.height - 43*AUTO_SIZE_SCALE_X, priceLabelSize.width+20*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_X);
    
    UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, logoImv.frame.origin.y+logoImv.frame.size.height+12*AUTO_SIZE_SCALE_X, 250*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    storeNameLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]];
    storeNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    storeNameLabel.textColor = BlackUIColorC5   ;
    storeNameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:storeNameLabel];
    
    NSString * storeScoreStr = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"score"]];
    NSMutableAttributedString * storeScoreAttStr = [[NSMutableAttributedString alloc] initWithString:storeScoreStr];;
    [storeScoreAttStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:16]
                        range:NSMakeRange( 0,1)];
    [storeScoreAttStr addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:13]
                             range:NSMakeRange( storeScoreStr.length-1,1)];
    UILabel * scoreNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeNameLabel.frame.origin.x+storeNameLabel.frame.size.width+10, logoImv.frame.origin.y+logoImv.frame.size.height+15*AUTO_SIZE_SCALE_X, kScreenWidth-storeNameLabel.frame.origin.x-storeNameLabel.frame.size.width-10-18*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
//    scoreNameLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"score"]];
    scoreNameLabel.attributedText = storeScoreAttStr;
    scoreNameLabel.textColor = OrangeUIColorC4 ;
    scoreNameLabel.textAlignment = NSTextAlignmentRight;
//    scoreNameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:scoreNameLabel];
    
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, 220*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
    infoLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"introduction"]];
    infoLabel.textColor = C6UIColorGray ;
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:infoLabel];
    
    float dist = [[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"distance"]] floatValue];
    UILabel * farLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, 0, 12*AUTO_SIZE_SCALE_X)];
    if (dist>=1) {
        farLabel.text = [NSString stringWithFormat:@"%0.1fkm",dist];
    }else{
        int dis = dist*1000;
        farLabel.text = [NSString stringWithFormat:@"%dm",dis];
    }
    farLabel.textColor = C7UIColorGray ;
    farLabel.textAlignment = NSTextAlignmentRight;
    farLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:farLabel];
    CGSize farLabelSize = [farLabel intrinsicContentSize];
    farLabel.frame = CGRectMake(kScreenWidth-18-farLabelSize.width, storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, farLabelSize.width, 12*AUTO_SIZE_SCALE_X);
    
    UIImageView * farImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-18-farLabelSize.width-9-6, farLabel.frame.origin.y, 9*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X )];
    farImv.image = [UIImage imageNamed:@"icon_awayfrom"];
    [self.contentView addSubview:farImv];
    

}

@end
