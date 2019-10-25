//
//  AccountBalanceView.m
//  Massage
//
//  Created by htjd_IOS on 15/11/2.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AccountBalanceView.h"

@implementation AccountBalanceView
//@synthesize dataDic;
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
    
    [super layoutSubviews];
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    //订单号
    UILabel * orderIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X)];
    orderIDLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"tradeName"]];
    orderIDLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:orderIDLabel];
    
    //订单时间
    UILabel * addTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, orderIDLabel.frame.origin.y+orderIDLabel.frame.size.height, 180*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
    addTimeLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"transactionTime"]];
    addTimeLabel.font = [UIFont systemFontOfSize:11];
    addTimeLabel.textColor = C6UIColorGray;
    [self.contentView addSubview:addTimeLabel];
    
    //支付方式
    UILabel * tradeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderIDLabel.frame.origin.x+orderIDLabel.frame.size.width+5,0, kScreenWidth-10-(orderIDLabel.frame.origin.x+orderIDLabel.frame.size.width+5), 35*AUTO_SIZE_SCALE_X)];
    tradeTypeLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"tradeDesc"]];
    tradeTypeLabel.font = [UIFont systemFontOfSize:14];
    tradeTypeLabel.textColor = OrangeUIColorC4;
    tradeTypeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:tradeTypeLabel];
    
    //金额
    UILabel * amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderIDLabel.frame.origin.x+orderIDLabel.frame.size.width+5,orderIDLabel.frame.origin.y+orderIDLabel.frame.size.height, kScreenWidth-10-(orderIDLabel.frame.origin.x+orderIDLabel.frame.size.width+5), 20*AUTO_SIZE_SCALE_X)];
    if ([[self.dataDic objectForKey:@"amount"] floatValue]>=0) {
        float amontFloat = [[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"amount"]] floatValue]/100;
        amountLabel.text = [NSString stringWithFormat:@"+%0.2f",amontFloat];
    }else{
        float amontFloat = [[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"amount"]] floatValue]/100;
        amountLabel.text = [NSString stringWithFormat:@"%0.2f",amontFloat];
    }
    amountLabel.font = [UIFont systemFontOfSize:15];
    amountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:amountLabel];
}
@end
