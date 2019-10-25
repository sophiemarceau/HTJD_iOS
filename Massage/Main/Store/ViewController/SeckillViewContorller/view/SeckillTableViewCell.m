//
//  SeckillTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 16/2/25.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "SeckillTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SeckillTableViewCell
{
    UIImageView * serviceIcon;
    UILabel * serviceNameLabel;
    UILabel * mendianLabel;
    UILabel * storeNameLabel;
    UIImageView * addressIcon;
    UILabel * addressLabel;
    
    UIView * variableView;
    UILabel * minPriceLabel;
    UILabel * marketPriceLabel;
    UILabel * servLevelLabel;
    UILabel * stockLabel;
    UIButton * killBtn;
    
    NSMutableArray * priceLabelArray;
    NSMutableArray * marketLabelArray;
    NSMutableArray * servLevelLabelArray;
    NSMutableArray * stockLabelArray;
    NSMutableArray * btnArray;
    NSMutableArray * activitydesc;
    NSMutableArray * lineArray;
    
    NSMutableArray * servArray;
    
    float activitydescHeight;
    
    UIView * bgView;
    
    UIImageView * lineImv;
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView
{
//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = C2UIColorGray;
//    _bgView = [[SeckillServiceView alloc] init ];
//     [self addSubview:_bgView];
    
    priceLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    marketLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    servLevelLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    stockLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    activitydesc = [[NSMutableArray alloc] initWithCapacity:0];
    lineArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0*AUTO_SIZE_SCALE_X1, kScreenWidth,  366*AUTO_SIZE_SCALE_X1)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    serviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(9*AUTO_SIZE_SCALE_X1, 9*AUTO_SIZE_SCALE_X1, kScreenWidth-18*AUTO_SIZE_SCALE_X1, 267*AUTO_SIZE_SCALE_X1)];
    serviceIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer * serviceIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceIconTaped:)];
    [serviceIcon addGestureRecognizer:serviceIconTap];
    [bgView addSubview:serviceIcon];
    
    serviceNameLabel = [[UILabel alloc] init];
    serviceNameLabel.font = [UIFont boldSystemFontOfSize:16];
    serviceNameLabel.textColor = UIColorFromRGB(0x1D1D1D);
    [bgView addSubview:serviceNameLabel];
    
    mendianLabel = [[UILabel alloc] init];
    mendianLabel.font = [UIFont systemFontOfSize:11];
    mendianLabel.text = @"门店";
    mendianLabel.backgroundColor = [UIColor clearColor];
    mendianLabel.textColor = UIColorFromRGB(0x92969C);
    mendianLabel.textAlignment = NSTextAlignmentCenter;
    mendianLabel.backgroundColor = UIColorFromRGB(0xEFEFEF);
    mendianLabel.layer.cornerRadius = 1;
    mendianLabel.layer.masksToBounds = YES;
    [bgView addSubview:mendianLabel];
    
    storeNameLabel = [[UILabel alloc] init];
    storeNameLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X1];
    storeNameLabel.textColor = UIColorFromRGB(0x747277);
    [bgView addSubview:storeNameLabel];
    
    addressIcon = [[UIImageView alloc] init];
    addressIcon.image = [UIImage imageNamed:@"icon_sd_awayfrom"];
    [bgView addSubview:addressIcon];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X1];
    addressLabel.textColor = UIColorFromRGB(0x747277);
    [bgView addSubview:addressLabel];
    
    variableView = [[UIView alloc] init];
    variableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:variableView];
    
    minPriceLabel = [[UILabel alloc] init];
    [variableView addSubview:minPriceLabel];
    
    marketPriceLabel = [[UILabel alloc] init];
    [variableView addSubview:marketPriceLabel];
    
    stockLabel = [[UILabel alloc] init];
    [variableView addSubview:stockLabel];
    
    servLevelLabel = [[UILabel alloc] init];
    [variableView addSubview:servLevelLabel];
    
    lineImv = [[UIImageView alloc] init];
    [variableView addSubview:lineImv];
    
//    killBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [killBtn setTitle:@"秒杀" forState:UIControlStateNormal];
//    killBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [killBtn addTarget:self action:@selector(killBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [variableView addSubview:killBtn];
    
}

#pragma mark 倒计时
-(void)setTimeout:(BOOL)timeout
{
    _timeout = timeout;
    //    if (_timeout) {
    //        [killBtn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
    //        [killBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
    //        killBtn.layer.borderWidth = 1.0;
    //        killBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //        killBtn.userInteractionEnabled = NO;
    //        for (UIButton * btn in btnArray) {
    //            [btn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
    //            [btn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
    //            btn.layer.borderWidth = 1.0;
    //            btn.layer.borderColor = [UIColor whiteColor].CGColor;
    //            btn.userInteractionEnabled = NO;
    //        }
    //
    //    }
}

-(void)setTimebegin:(BOOL)timebegin
{
    _timebegin = timebegin;
}

#pragma mark 根据数据赋值
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [serviceIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    serviceIcon.frame = CGRectMake(9*AUTO_SIZE_SCALE_X1, 9*AUTO_SIZE_SCALE_X1, kScreenWidth-18*AUTO_SIZE_SCALE_X1, 267*AUTO_SIZE_SCALE_X1);
    
    serviceNameLabel.text = [dataDic objectForKey:@"servName"];
    serviceNameLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, serviceIcon.frame.origin.y+serviceIcon.frame.size.height+13*AUTO_SIZE_SCALE_X1, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 16*AUTO_SIZE_SCALE_X1);
    
    mendianLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+12*AUTO_SIZE_SCALE_X1, 31*AUTO_SIZE_SCALE_X1, 15);
    
    storeNameLabel.text = [dataDic objectForKey:@"storeName"];;
    storeNameLabel.frame = CGRectMake(mendianLabel.frame.origin.x+mendianLabel.frame.size.width+6*AUTO_SIZE_SCALE_X1, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+14*AUTO_SIZE_SCALE_X1, kScreenWidth-(mendianLabel.frame.origin.x+mendianLabel.frame.size.width+10*AUTO_SIZE_SCALE_X1+10*AUTO_SIZE_SCALE_X1), 13 );
    
    addressIcon.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, mendianLabel.frame.origin.y+mendianLabel.frame.size.height+12*AUTO_SIZE_SCALE_X1, 10*AUTO_SIZE_SCALE_X1, 13 );
    
    addressLabel.text = [dataDic objectForKey:@"address"];;
    addressLabel.frame = CGRectMake(addressIcon.frame.origin.x+addressIcon.frame.size.width+7*AUTO_SIZE_SCALE_X1, storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+13*AUTO_SIZE_SCALE_X1, kScreenWidth-(addressIcon.frame.origin.x+addressIcon.frame.size.width+7*AUTO_SIZE_SCALE_X1+10*AUTO_SIZE_SCALE_X1), 13*AUTO_SIZE_SCALE_X1);
    
    //    variableView.frame = CGRectMake(0, addressLabel.frame.origin.y+addressLabel.frame.size.height+10*AUTO_SIZE_SCALE_X1, kScreenWidth, self.frame.size.height-(addressLabel.frame.origin.y+addressLabel.frame.size.height+10*AUTO_SIZE_SCALE_X1));
    //    variableView.frame = CGRectMake(0, addressLabel.frame.origin.y+addressLabel.frame.size.height+10*AUTO_SIZE_SCALE_X1, kScreenWidth, ((22+16*3)+(55*(_mycount%3+1)))*AUTO_SIZE_SCALE_X1);
    
    [self cleanArray];

    [self countActivitydescHeight];

    if ([[dataDic objectForKey:@"servLevelList"] count]==0) {
        NSLog(@"1个等级");
        
        [self changeView:dataDic type:@"0"];
        
        [self addOneBtn];
//        variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1, kScreenWidth, ((22+16*3)+(55*1))*AUTO_SIZE_SCALE_X1);
    }
    else{
        NSLog(@"多个等级");
        [self changeView:[[dataDic objectForKey:@"servLevelList"] objectAtIndex:0]  type:@"1"];
        
//        [self cleanArray];

//        variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1, kScreenWidth, ((22+16*3)+(55*[[dataDic objectForKey:@"servLevelList"] count]))*AUTO_SIZE_SCALE_X1);
        
        [self addMorePriceLabel];
        [self addMoreMarketLabel];
        [self addMoreServLevelLabel];
        [self addMoreStockLabel];
        [self addMoreBtn];
        [self addLineView];
    }

}

-(void)countActivitydescHeight
{
         NSArray * array = [_dataDic objectForKey:@"activitydesc"];
         activitydescHeight = 0;
        if (array.count>0) {
//            activitydescHeight = 15*AUTO_SIZE_SCALE_X1;
            lineImv.hidden = NO;
            lineImv.image = [UIImage imageNamed:@"img_dottedline1"];
            lineImv.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, 0, kScreenWidth-20*AUTO_SIZE_SCALE_X1, 1);
            for (int j = 0; j<array.count; j++) {
                NSString * str = [[array objectAtIndex:j] objectForKey:@"content"];
                CGSize contentSize = CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X1, 2000);
                CGSize contentLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
                [self addActivityLabel:activitydescHeight+5*AUTO_SIZE_SCALE_X1 Height:contentLabelSize.height  Data:[array objectAtIndex:j]];
                activitydescHeight = activitydescHeight+contentLabelSize.height+ 5*AUTO_SIZE_SCALE_X1;
            }
          }
        else{
            activitydescHeight = 0.0;
            lineImv.hidden = YES;
        }
 }

-(void)changeView:(NSDictionary *)dic type:(NSString *)level
{
    NSString * minPriceStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"minPrice"]];
    int minPrice = [minPriceStr intValue];
    if (minPrice%100 == 0) {
        minPrice = minPrice/100;
        minPriceStr = [NSString stringWithFormat:@"¥ %d",minPrice];
    }
    else if(minPrice%10 == 0){
        float minPriceFloat = [minPriceStr floatValue];
        minPriceFloat = minPriceFloat/100.0;
        minPriceStr = [NSString stringWithFormat:@"¥ %0.1f",minPriceFloat];
    }
    else{
        float minPriceFloat = [minPriceStr floatValue];
        minPriceFloat = minPriceFloat/100.0;
        minPriceStr = [NSString stringWithFormat:@"¥ %0.2f",minPriceFloat];
    }
    NSMutableAttributedString * minPriceAttStr = [[NSMutableAttributedString alloc] initWithString:minPriceStr];
    [minPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    [minPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1,minPriceStr.length-1 )];
    [minPriceAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD83219) range:NSMakeRange(0, minPriceStr.length)];
    minPriceLabel.attributedText = minPriceAttStr;
    CGSize size = [minPriceLabel intrinsicContentSize];
//    minPriceLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, activitydescHeight, size.width, 55*AUTO_SIZE_SCALE_X1);
    minPriceLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, activitydescHeight, size.width, 55*AUTO_SIZE_SCALE_X1);
    
    NSString * marketPriceStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"marketPrice"]];
    int marketPrice = [marketPriceStr intValue];
    if (marketPrice%100 == 0) {
        marketPrice = marketPrice/100;
        marketPriceStr = [NSString stringWithFormat:@"¥%d",marketPrice];
    }
    else if(marketPrice%10 == 0){
        float marketPriceFloat = [marketPriceStr floatValue];
        marketPriceFloat = marketPriceFloat/100.0;
        marketPriceStr = [NSString stringWithFormat:@"¥%0.1f",marketPriceFloat];
    }
    else{
        float marketPriceFloat = [marketPriceStr floatValue];
        marketPriceFloat = marketPriceFloat/100.0;
        marketPriceStr = [NSString stringWithFormat:@"¥%0.2f",marketPriceFloat];
    }
    NSMutableAttributedString * marketPriceAttStr = [[NSMutableAttributedString alloc] initWithString:marketPriceStr];
    [marketPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [marketPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(1,marketPriceStr.length-1 )];
    [marketPriceAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x747474) range:NSMakeRange(0, marketPriceStr.length)];
    [marketPriceAttStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range:NSMakeRange(0, marketPriceStr.length)];
    marketPriceLabel .attributedText = marketPriceAttStr;
    CGSize marketPricesize = [marketPriceLabel intrinsicContentSize];
    marketPriceLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1+minPriceLabel.frame.origin.x+minPriceLabel.frame.size.width, activitydescHeight+24*AUTO_SIZE_SCALE_X1, marketPricesize.width, 12*AUTO_SIZE_SCALE_X1);
    
    //    servLevelLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"marketPrice"]];
    if ([level isEqualToString:@"0"]) {
        servLevelLabel.text = @"";
    }
    else if ([level isEqualToString:@"1"]){
        servLevelLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    servLevelLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X1];
    servLevelLabel.textColor = UIColorFromRGB(0x1D1D1D);
    CGSize servLevelsize = [servLevelLabel intrinsicContentSize];
    servLevelLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1+marketPriceLabel.frame.origin.x+marketPriceLabel.frame.size.width, activitydescHeight+24*AUTO_SIZE_SCALE_X1, servLevelsize.width, 12*AUTO_SIZE_SCALE_X1);
    
    if ([dic objectForKey:@"stock"]) {
        stockLabel.text = [NSString stringWithFormat:@"剩余%@份",[dic objectForKey:@"stock"]];
    }
    else{
        stockLabel.text = [NSString stringWithFormat:@"剩余%@份",@"0"];
    }
    stockLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X1];
    stockLabel.textColor = UIColorFromRGB(0x777777);
    CGSize stocksize = [stockLabel intrinsicContentSize];
    stockLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1+servLevelLabel.frame.origin.x+servLevelLabel.frame.size.width, activitydescHeight+24*AUTO_SIZE_SCALE_X1, stocksize.width, 12*AUTO_SIZE_SCALE_X1);
    
    
//    NSString * stocknum = [NSString stringWithFormat:@"%@",[ dic  objectForKey:@"stock" ]];
//    if (_timeout|| [stocknum isEqualToString:@"0"] ){
//        [killBtn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
//        [killBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
//        killBtn.layer.borderWidth = 1.0;
//        killBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        killBtn.userInteractionEnabled = NO;
//    }
//    //可以秒杀
//    else{
//        [killBtn setTitleColor:UIColorFromRGB(0x1D1D1D) forState:UIControlStateNormal];
//        [killBtn setBackgroundColor:[UIColor whiteColor]];
//        killBtn.layer.borderWidth = 1.0;
//        killBtn.layer.borderColor = UIColorFromRGB(0x1D1D1D).CGColor;
//    }
//    killBtn.frame = CGRectMake(274*AUTO_SIZE_SCALE_X1, activitydescHeight+13*AUTO_SIZE_SCALE_X1, 90*AUTO_SIZE_SCALE_X1, 30*AUTO_SIZE_SCALE_X1);
    
    if ([[_dataDic objectForKey:@"servLevelList"] count]==0) {
        if ([self.type isEqualToString:@"0"]) {
            variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1, kScreenWidth, ( (55*1))*AUTO_SIZE_SCALE_X1+activitydescHeight);
        }
        else{
            variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1+7*AUTO_SIZE_SCALE_X1, kScreenWidth, ( (55*1))*AUTO_SIZE_SCALE_X1+activitydescHeight);
        }
//        variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1, kScreenWidth, (0+(55*1))*AUTO_SIZE_SCALE_X1);
    }
    else{
        if ([self.type isEqualToString:@"0"]) {
            variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1, kScreenWidth, ((55*[[_dataDic objectForKey:@"servLevelList"] count]))*AUTO_SIZE_SCALE_X1+activitydescHeight) ;
        }
        else{
            variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1+7*AUTO_SIZE_SCALE_X1, kScreenWidth, ((55*[[_dataDic objectForKey:@"servLevelList"] count]))*AUTO_SIZE_SCALE_X1+activitydescHeight) ;

        }
//        variableView.frame = CGRectMake(0, 366*AUTO_SIZE_SCALE_X1, kScreenWidth, (0+(55*[[_dataDic objectForKey:@"servLevelList"] count]))*AUTO_SIZE_SCALE_X1);
        
    }
    

}

#pragma mark 清空各个数组和控件
-(void)cleanArray
{
    if (priceLabelArray.count > 0) {
        for (UILabel * label in priceLabelArray) {
            [label removeFromSuperview];;
        }
        [priceLabelArray removeAllObjects];
    }
    if (marketLabelArray.count > 0) {
        for (UILabel * label in marketLabelArray) {
            [label removeFromSuperview];;
        }
        [marketLabelArray removeAllObjects];
    }
    if (servLevelLabelArray.count > 0) {
        for (UILabel * label in servLevelLabelArray) {
            [label removeFromSuperview];;
        }
        [servLevelLabelArray removeAllObjects];
    }
    if (stockLabelArray.count > 0) {
        for (UILabel * label in stockLabelArray) {
            [label removeFromSuperview];;
        }
        [stockLabelArray removeAllObjects];
    }
    if (activitydesc.count > 0) {
        for (UILabel * label in activitydesc) {
            [label removeFromSuperview];;
        }
        [activitydesc removeAllObjects];
    }

    if (btnArray.count > 0) {
        for (UIButton * btn in btnArray) {
            [btn removeFromSuperview];;
        }
        [btnArray removeAllObjects];
    }
    if (lineArray.count > 0) {
        for (UIImageView * imv in lineArray) {
            [imv removeFromSuperview];
        }
         [lineArray removeAllObjects];
    }

}

#pragma mark 添加多个秒杀价
-(void)addMorePriceLabel
{
    for (int i = 0; i<[[_dataDic objectForKey:@"servLevelList"] count]-1; i++) {
        UILabel * pricesLabel = [[UILabel alloc] init];
        
        NSString * minPriceStr = [NSString stringWithFormat:@"%@",[[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i+1] objectForKey:@"minPrice"]];
        int minPrice = [minPriceStr intValue];
        if (minPrice%100 == 0) {
            minPrice = minPrice/100;
            minPriceStr = [NSString stringWithFormat:@"¥ %d",minPrice];
        }
        else if(minPrice%10 == 0){
            float minPriceFloat = [minPriceStr floatValue];
            minPriceFloat = minPriceFloat/100.0;
            minPriceStr = [NSString stringWithFormat:@"¥ %0.1f",minPriceFloat];
        }
        else{
            float minPriceFloat = [minPriceStr floatValue];
            minPriceFloat = minPriceFloat/100.0;
            minPriceStr = [NSString stringWithFormat:@"¥ %0.2f",minPriceFloat];
        }
        NSMutableAttributedString * minPriceAttStr = [[NSMutableAttributedString alloc] initWithString:minPriceStr];
        [minPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
        [minPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1,minPriceStr.length-1 )];
        [minPriceAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD83219) range:NSMakeRange(0, minPriceStr.length)];
        pricesLabel.attributedText = minPriceAttStr;
        [variableView addSubview:pricesLabel];
        [priceLabelArray addObject:pricesLabel];
    }
    int i = 0;
    for (UILabel * pricesLabel in priceLabelArray) {
        i++;
        CGSize size = [pricesLabel intrinsicContentSize];
        pricesLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, activitydescHeight+55*AUTO_SIZE_SCALE_X1*i,  size.width, 55*AUTO_SIZE_SCALE_X1);
    }

}
#pragma mark 添加多个原价
-(void)addMoreMarketLabel
{
    for (int i = 0; i<[[_dataDic objectForKey:@"servLevelList"] count]-1; i++) {
        UILabel * marketsLabel = [[UILabel alloc] init];
        
        NSString * marketPriceStr = [NSString stringWithFormat:@"%@",[[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i+1] objectForKey:@"marketPrice"]];
        int marketPrice = [marketPriceStr intValue];
        if (marketPrice%100 == 0) {
            marketPrice = marketPrice/100;
            marketPriceStr = [NSString stringWithFormat:@"¥%d",marketPrice];
        }
        else if(marketPrice%10 == 0){
            float marketPriceFloat = [marketPriceStr floatValue];
            marketPriceFloat = marketPriceFloat/100.0;
            marketPriceStr = [NSString stringWithFormat:@"¥%0.1f",marketPriceFloat];
        }
        else{
            float marketPriceFloat = [marketPriceStr floatValue];
            marketPriceFloat = marketPriceFloat/100.0;
            marketPriceStr = [NSString stringWithFormat:@"¥%0.2f",marketPriceFloat];
        }
        NSMutableAttributedString * marketPriceAttStr = [[NSMutableAttributedString alloc] initWithString:marketPriceStr];
        [marketPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [marketPriceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(1,marketPriceStr.length-1 )];
        [marketPriceAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x747474) range:NSMakeRange(0, marketPriceStr.length)];
        [marketPriceAttStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range:NSMakeRange(0, marketPriceStr.length)];
        marketsLabel.attributedText = marketPriceAttStr;
        [variableView addSubview:marketsLabel];
        [marketLabelArray addObject:marketsLabel];
    }
    int i = 0;
    for (UILabel * marketsLabel in marketLabelArray) {
        i++;
        UILabel * pricesLabel = [priceLabelArray objectAtIndex:i-1];
        CGSize size = [marketsLabel intrinsicContentSize];
        marketsLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1+pricesLabel.frame.origin.x+pricesLabel.frame.size.width, activitydescHeight+55*AUTO_SIZE_SCALE_X1*i+24*AUTO_SIZE_SCALE_X1, size.width, 12*AUTO_SIZE_SCALE_X1);
//        [marketLabelArray replaceObjectAtIndex:i-1 withObject:marketsLabel];
    }

}
#pragma mark 添加多个服务等级
-(void)addMoreServLevelLabel
{
    for (int i = 0; i<[[_dataDic objectForKey:@"servLevelList"] count]-1; i++) {
        UILabel * servLevlesLabel = [[UILabel alloc] init];
        servLevlesLabel.text = [NSString stringWithFormat:@"%@",[[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i+1] objectForKey:@"name"]];
        servLevlesLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X1];
        servLevlesLabel.textColor = UIColorFromRGB(0x1D1D1D);
        UILabel * marketsLabel = [marketLabelArray objectAtIndex:i];
        CGSize size = [servLevlesLabel intrinsicContentSize];
        servLevlesLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1+marketsLabel.frame.origin.x+marketsLabel.frame.size.width, activitydescHeight+55*AUTO_SIZE_SCALE_X1*(i+1)+24*AUTO_SIZE_SCALE_X1, size.width, 12*AUTO_SIZE_SCALE_X1);
        [variableView addSubview:servLevlesLabel];
        [servLevelLabelArray addObject:servLevlesLabel];
    }
}
#pragma mark 添加多个剩余数
-(void)addMoreStockLabel
{
    for (int i = 0; i<[[_dataDic objectForKey:@"servLevelList"] count]-1; i++) {
        UILabel * stocksLabel = [[UILabel alloc] init];
        if ([[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i+1] objectForKey:@"stock"]) {
            stocksLabel.text = [NSString stringWithFormat:@"剩余%@份",[[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i+1] objectForKey:@"stock"]];
        }
        else{
            stocksLabel.text = [NSString stringWithFormat:@"剩余%@份",@"0"];
        }
        stocksLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X1];
        stocksLabel.textColor = UIColorFromRGB(0x777777);
        UILabel * servLevlesLabel = [servLevelLabelArray objectAtIndex:i];
        CGSize size = [stocksLabel intrinsicContentSize];
        stocksLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X1+servLevlesLabel.frame.origin.x+servLevlesLabel.frame.size.width, activitydescHeight+55*AUTO_SIZE_SCALE_X1*(i+1)+24*AUTO_SIZE_SCALE_X1, size.width, 12*AUTO_SIZE_SCALE_X1);
        [variableView addSubview:stocksLabel];
        [stockLabelArray addObject:stocksLabel];
    }
}

#pragma mark 添加单一按钮
-(void)addOneBtn
{

    
    UIButton * killsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [killsBtn setTitle:@"秒杀" forState:UIControlStateNormal];
    killsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [killsBtn addTarget:self action:@selector(killBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
   
    NSString * stock = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"stock"]];
    if (![_dataDic objectForKey:@"stock"]) {
        stock = @"0";
    }
    //不能秒杀
    if (!_timebegin|| [stock isEqualToString:@"0"] ) {
        [killsBtn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
        [killsBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
        killsBtn.layer.borderWidth = 1.0;
        killsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        killsBtn.userInteractionEnabled = NO;
    }
    //可以秒杀
    else{
        [killsBtn setTitleColor:UIColorFromRGB(0x1D1D1D) forState:UIControlStateNormal];
        [killsBtn setBackgroundColor:[UIColor whiteColor]];
        killsBtn.layer.borderWidth = 1.0;
        killsBtn.layer.borderColor = UIColorFromRGB(0x1D1D1D).CGColor;
    }
    killsBtn.frame = CGRectMake(274*AUTO_SIZE_SCALE_X1, activitydescHeight+13*AUTO_SIZE_SCALE_X1 , 90*AUTO_SIZE_SCALE_X1, 30*AUTO_SIZE_SCALE_X1);

    [variableView addSubview:killsBtn];
    [btnArray addObject:killsBtn];
    
    UIImageView * lineImv1 = [[UIImageView alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X1, killsBtn.frame.origin.y -10 , kScreenWidth-20*AUTO_SIZE_SCALE_X1, 1)];
    lineImv1.image = [UIImage imageNamed:@"img_dottedline1"];
    [variableView addSubview:lineImv1];
    [lineArray addObject:lineImv1];
}

#pragma mark 添加多个按钮
-(void)addMoreBtn
{
    for (int i = 0; i<[[_dataDic objectForKey:@"servLevelList"] count]; i++) {
        UIButton * killsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [killsBtn setTitle:@"秒杀" forState:UIControlStateNormal];
        killsBtn.tag = i;
        killsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [killsBtn addTarget:self action:@selector(killsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        NSString * stock = [NSString stringWithFormat:@"%@",[[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i] objectForKey:@"stock"]];
        //不能秒杀
        if (![[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:i] objectForKey:@"stock"]) {
            stock = @"0";
        }
        if (!_timebegin|| [stock isEqualToString:@"0"] ) {
            [killsBtn setTitleColor:UIColorFromRGB(0x92969C) forState:UIControlStateNormal];
            [killsBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
            killsBtn.layer.borderWidth = 1.0;
            killsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            killsBtn.userInteractionEnabled = NO;
        }
        //可以秒杀
        else{
            [killsBtn setTitleColor:UIColorFromRGB(0x1D1D1D) forState:UIControlStateNormal];
            [killsBtn setBackgroundColor:[UIColor whiteColor]];
            killsBtn.layer.borderWidth = 1.0;
            killsBtn.layer.borderColor = UIColorFromRGB(0x1D1D1D).CGColor;
        }
        [variableView addSubview:killsBtn];
        [btnArray addObject:killsBtn];
        
        

    }
    int i = 0;
    for (UIButton * btn in btnArray) {
        btn.frame = CGRectMake(274*AUTO_SIZE_SCALE_X1, activitydescHeight+13*AUTO_SIZE_SCALE_X1+(30*AUTO_SIZE_SCALE_X1+24*AUTO_SIZE_SCALE_X1)*i, 90*AUTO_SIZE_SCALE_X1, 30*AUTO_SIZE_SCALE_X1);
        i++;
    }
    
}

-(void)addLineView
{
    for (int i = 0; i<[[_dataDic objectForKey:@"servLevelList"] count]; i++) {
        UIImageView * lineImv1 = [[UIImageView alloc] init ];
        lineImv1.image = [UIImage imageNamed:@"img_dottedline1"];
        [variableView addSubview:lineImv1];
        [lineArray addObject:lineImv1];
    }
    int i = 0;
    for (UIImageView * imv in lineArray) {
        imv.frame = CGRectMake(20*AUTO_SIZE_SCALE_X1, activitydescHeight+13*AUTO_SIZE_SCALE_X1+(30*AUTO_SIZE_SCALE_X1+24*AUTO_SIZE_SCALE_X1)*i-10, kScreenWidth - 20*AUTO_SIZE_SCALE_X1, 1);
        i++;
    }

}

#pragma mark 添加说明
-(void)addActivityLabel:(CGFloat )y Height:(CGFloat)height Data:(NSDictionary *)dic
{
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X1, y, 10*AUTO_SIZE_SCALE_X1, 15*AUTO_SIZE_SCALE_X1)];
    label1.text = @" · ";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = UIColorFromRGB(0x777777);
    [variableView addSubview:label1];
    [activitydesc addObject:label1];

    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X1, y, kScreenWidth-40*AUTO_SIZE_SCALE_X1, height)];
//    label.backgroundColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
//    label.layer.borderWidth = 0.0;
    label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    label.textColor = UIColorFromRGB(0x777777);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    [variableView addSubview:label];
    [activitydesc addObject:label];
}

#pragma mark cell格式 上留空间type1 下留空间type0
-(void)setType:(NSString *)type
{
    _type = type;
    if ([_type isEqualToString:@"0"]) {
         bgView.frame = CGRectMake(0, 0*AUTO_SIZE_SCALE_X1, kScreenWidth,  366*AUTO_SIZE_SCALE_X1) ;
    }
    else{
        bgView.frame = CGRectMake(0, 7*AUTO_SIZE_SCALE_X1, kScreenWidth,  366*AUTO_SIZE_SCALE_X1) ;
    }
}
#pragma mark -------------

-(void)setMycount:(int)mycount
{
//    if (btnArray) {
//        for (UIButton * btn in btnArray) {
//            [btn removeFromSuperview];;
//        }
//
//        
//        [btnArray removeAllObjects];
//        
//    }
//    else{
//        btnArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    
//    
//    _mycount = mycount;
//    NSLog(@"按钮数量 %d",_mycount%3+1);
//    
//    if (_mycount%3+1>1) {
//        [self addMoreBtn];
//    }

}







-(void)killBtnPressed:(UIButton *)sender
{
    NSLog(@"秒杀");
    [_delegate gotoSecKillPay:self.dataDic];
}

-(void)killsBtnPressed:(UIButton *)sender
{
    NSLog(@"秒杀");
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[_dataDic objectForKey:@"servLevelList"] objectAtIndex:sender.tag]];
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic1 setValue:[dic objectForKey:@"minPrice"] forKey:@"minPrice"];
    [dic1 setValue:[dic objectForKey:@"ID"] forKey:@"priceID"];
    [dic1 setValue:[self.dataDic objectForKey:@"ID"] forKey:@"ID"];
    [dic1 setValue:[self.dataDic objectForKey:@"servName"] forKey:@"servName"];
    [dic1 setValue:[self.dataDic objectForKey:@"storeName"] forKey:@"storeName"];
    [dic1 setValue:[self.dataDic objectForKey:@"icon"] forKey:@"icon"];
    [dic1 setValue:[self.dataDic objectForKey:@"activitydesc"] forKey:@"activitydesc"];
    [_delegate gotoSecKillPay:dic1];
}

-(void)serviceIconTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"跳转到项目详情");
    [_delegate gotoServiceDetail:self.dataDic];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
 
//    self.bgView.frame = CGRectMake(0, 6*AUTO_SIZE_SCALE_X1, kScreenWidth, (366+(22+16*3)+(55*(self.count%5+1))-6)*AUTO_SIZE_SCALE_X1);
////    self.bgView.count = self.count;
//    self.bgView.storeName = @"包您满意休闲会所";
    
    
 
}
@end
