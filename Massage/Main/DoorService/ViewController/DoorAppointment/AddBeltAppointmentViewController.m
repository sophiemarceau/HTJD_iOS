//
//  AddBeltAppointmentViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/24.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AddBeltAppointmentViewController.h"
#import "UIImageView+WebCache.h"
#import "PayView.h"
#import "CouponSelectViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"

#import "WaitForHomeSericeByStoreViewController.h"
#import "WaitForHomeServiceViewController.h"
#import "PayForWorkViewController.h"
#import "PayForWorkByStoreViewController.h"
@interface AddBeltAppointmentViewController ()<UITextViewDelegate>
{
    UITableView * tableView;
    UIView * headerView;
    UIView * serviceView;
    UIView * beltView;
    UIView * infoView;
    UIView * couponView;
    UIView * moneyView;
    PayView * payView;
    
    UILabel * beltNumLabel;
    UILabel * selectCouponLabel;
    UILabel * MoneyandTimeLabel;
    
    UITextView * remarkTextView;
    
    UIButton * Paybtn;
    
    NSString * balanceStr;
    NSString * couponID;
    
    NSDictionary * payWayDic;
    NSMutableArray * beltInfoArray;
    NSDictionary * beltInfoDic;
    float maxBelt;
    
    float beltNum;
    int perTime;
    float permoney;
    int bedPrice;
    float busPrice;
    float couponPrice;
    float paymentPrice;
    
    NSArray * CouponListArray;
    
    UILabel * couponShowLabel;
    UILabel * allPriceLabel;
    UILabel * busPriceLabel;
    UILabel * bedPriceLabel;
    UILabel * allTimeLabel;
    UILabel * paymentPriceLabel;
    
    NSString * newOrderID;
    NSString * serviceType;
}
@end

@implementation AddBeltAppointmentViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    NSLog(@"取消广播");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changePayWay" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePayWay:) name:@"changePayWay" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wechatMessaage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeChatPageDataNtf:) name:@"wechatMessaage" object:nil];
    
    self.titles = @"加钟";
    beltNum = 0.5;
    couponID = @"";
    couponPrice = 0;

    [self  downLoadBalanceData];
    
}


-(void)downLoadBalanceData
{
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    
    NSDictionary * dic = @{
                           @"userID":userID
                           };
    [[RequestManager shareRequestManager] GetMyUserInfo:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"result------------>%@",result);
        if(IsSucessCode(result)){
            balanceStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"deposit"]];//deposit
            [self getMakeExtention];
        }
    } failuer:^(NSError *error) {
        
    }];
    
}

-(void)getMakeExtention
{
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"orderID":self.orderID,
                           };
    NSLog(@"dic  %@",dic);
    [[RequestManager shareRequestManager] getMakeExtention:dic viewController:self successData:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            NDLog(@"加钟预约result--%@",result);
            self.serviceDic = [NSDictionary dictionaryWithDictionary:result];
            serviceType = [NSString stringWithFormat:@"%@",[result objectForKey:@"serviceType"]];
            NDLog(@"serviceType--%@",serviceType);
            perTime = [[self.serviceDic objectForKey:@"duration"] intValue];
            permoney = [[self.serviceDic objectForKey:@"gradePrice"] floatValue]/100.0;
            //            beltInfoDic= [NSDictionary dictinoaryWithdictinoary:[result objectForKey:@"ExtentionInfo"]];
            beltInfoDic = [NSDictionary dictionaryWithDictionary:[result objectForKey:@"ExtentionInfo"]];
            busPrice = [[[beltInfoDic objectForKey:@"1.0"] objectForKey:@"transportationFee"] floatValue];
            maxBelt = beltInfoDic.count/2.0;
            NSLog(@"%lu  %f",(unsigned long)beltInfoDic.count,maxBelt);
            [self donwLoadCouponData];

        }
        
    } failuer:^(NSError *error) {
        
    }];
}



-(void)donwLoadCouponData
{
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userID = [userDefaults objectForKey:@"userID"];
//    NSString *serviceID = [NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceID"]];
//    NSDictionary * dic = @{
//                           @"userID":userID,
//                           @"status":@"0",//0 未使用1 已使用 2 已过期
//                           @"serviceId":serviceID,
//                           };
//    [[RequestManager shareRequestManager]  getUserCouponList:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"优惠券列表result -- %@",result);
//        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            
//            CouponListArray = [NSArray arrayWithArray:[result objectForKey:@"couponList"]];
//            if (CouponListArray.count>0) {
//                couponID = [NSString stringWithFormat:@"%@",[[CouponListArray objectAtIndex:0] objectForKey:@"ID"]];
//                couponPrice = [[NSString stringWithFormat:@"%@",[[CouponListArray objectAtIndex:0] objectForKey:@"price"]] intValue]/100;
//            }
            [self initView];
            
//        }
//
//    } failuer:^(NSError *error) {
//        
//    }];
    
}

-(void)initView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2000)];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_X)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:headerView];
    
    [self.view addSubview:tableView];
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIImageView * btnImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    btnImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:btnImv];
    
    Paybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Paybtn.frame = CGRectMake(14*AUTO_SIZE_SCALE_X, 5*AUTO_SIZE_SCALE_X, kScreenWidth-28*AUTO_SIZE_SCALE_X, (50-10)*AUTO_SIZE_SCALE_X);
    [Paybtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    //    [yuyueBtn setBackgroundColor:[UIColor redColor]];
    [Paybtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [Paybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [Paybtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:Paybtn];
    
#pragma mark 服务项目信息
    serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 90*AUTO_SIZE_SCALE_X)];
    serviceView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:serviceView];
    
    UIImageView * touxiangImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X)];
    [touxiangImv setImageWithURL:[NSURL URLWithString:[self.serviceDic objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    touxiangImv.layer.borderColor = C6UIColorGray.CGColor;
    touxiangImv.layer.borderWidth = 1.0;
    touxiangImv.layer.cornerRadius = 5.0;
    touxiangImv.layer.masksToBounds = YES;
    [serviceView addSubview:touxiangImv];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(touxiangImv.frame.origin.x+touxiangImv.frame.size.width+10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 220*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
    nameLabel.text = [self.serviceDic objectForKey:@"serviceName"];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [serviceView addSubview:nameLabel];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 150*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
    timeLabel.text = [NSString stringWithFormat:@"%@分钟",[self.serviceDic objectForKey:@"duration"]];
    timeLabel.textColor = C6UIColorGray;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [serviceView addSubview:timeLabel];
    
    CGFloat fenmoney = [[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"gradePrice"]] floatValue]/100.0;
    NSString * moneyStr = [NSString stringWithFormat:@"¥%0.2f",fenmoney];
    NSMutableAttributedString * attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attMoneyStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:9]
                        range:NSMakeRange(0, 1)];
    [attMoneyStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:12]
                        range:NSMakeRange( 1,moneyStr.length-1)];
    [attMoneyStr addAttribute:NSForegroundColorAttributeName
                        value:RedUIColorC1
                        range:NSMakeRange(0, moneyStr.length)];
    UILabel * minPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, timeLabel.frame.origin.y+timeLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, 100, 12)];
    minPriceLabel.attributedText = attMoneyStr;
    CGSize minPriceLabelSize = [minPriceLabel intrinsicContentSize];
    minPriceLabel.frame = CGRectMake(minPriceLabel.frame.origin.x, minPriceLabel.frame.origin.y, minPriceLabelSize.width, 12*AUTO_SIZE_SCALE_X );
    [serviceView addSubview:minPriceLabel];
    
    CGFloat fentemoney = [[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"marketPrice"]] floatValue]/100.0;
    NSString * temoneyStr = [NSString stringWithFormat:@"¥%0.2f",fentemoney];
    NSMutableAttributedString * attTemoneyStr  = [[NSMutableAttributedString alloc] initWithString:temoneyStr];
    [attTemoneyStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:9]
                          range:NSMakeRange(0, 1)];
    [attTemoneyStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange( 1,temoneyStr.length-1)];
    [attTemoneyStr addAttribute:NSForegroundColorAttributeName
                          value:C6UIColorGray
                          range:NSMakeRange(0, temoneyStr.length)];
    [attTemoneyStr addAttribute:NSStrikethroughStyleAttributeName
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                          range:NSMakeRange( 1, temoneyStr.length-1)];
    UILabel * serviceTePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(minPriceLabel.frame.origin.x+minPriceLabel.frame.size.width, timeLabel.frame.origin.y+timeLabel.frame.size.height+12*AUTO_SIZE_SCALE_X,100, 12 )];
    serviceTePriceLabel.attributedText = attTemoneyStr;
    CGSize serviceTePriceLabelSize = [serviceTePriceLabel intrinsicContentSize];
    serviceTePriceLabel.frame = CGRectMake(minPriceLabel.frame.origin.x+minPriceLabel.frame.size.width+12*AUTO_SIZE_SCALE_X, timeLabel.frame.origin.y+timeLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, serviceTePriceLabelSize.width, 12*AUTO_SIZE_SCALE_X );
    [serviceView addSubview:serviceTePriceLabel];
    
#pragma mark 钟数选择
    beltView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceView.frame.origin.y+serviceView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 64*AUTO_SIZE_SCALE_X)];
    beltView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:beltView];
    
    UILabel * zhongshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 0, 45*AUTO_SIZE_SCALE_X, 64*AUTO_SIZE_SCALE_X)];
    zhongshuLabel.text = @"钟数";
    zhongshuLabel.font = [UIFont systemFontOfSize:13];
    [beltView addSubview:zhongshuLabel];
    
    UIView * beltBtnBgView = [[UIView alloc] initWithFrame:CGRectMake(185*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X, 120*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
    beltBtnBgView.backgroundColor = [UIColor clearColor];
    beltBtnBgView.layer.borderColor = OrangeUIColorC4.CGColor;
    beltBtnBgView.layer.borderWidth = 1.0;
    beltBtnBgView.layer.cornerRadius = 5.0;
    [beltView addSubview:beltBtnBgView];
    
    UIButton * subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.frame = CGRectMake(0, 0, 40*AUTO_SIZE_SCALE_X-1, 40*AUTO_SIZE_SCALE_X);
    [subBtn setImage:[UIImage imageNamed:@"icon_reserve_clocknum_j"] forState:UIControlStateNormal];
    [subBtn setTitleColor:C6UIColorGray forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(subBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [beltBtnBgView addSubview:subBtn];
    
    beltNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*AUTO_SIZE_SCALE_X, 0, 40*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
    beltNumLabel.text = @"0.5";
    beltNumLabel.textAlignment = NSTextAlignmentCenter;
    beltNumLabel.font = [UIFont systemFontOfSize:13];
    [beltBtnBgView addSubview:beltNumLabel];
    
    UIView * shuView1 = [[UIView alloc] initWithFrame:CGRectMake(beltNumLabel.frame.origin.x-1, 0, 1, 40*AUTO_SIZE_SCALE_X)];
    shuView1.backgroundColor = UIColorFromRGB(0xbfc4ca);
    [beltBtnBgView addSubview:shuView1];
    
    UIView * shuView2 = [[UIView alloc] initWithFrame:CGRectMake(beltNumLabel.frame.origin.x+beltNumLabel.frame.size.width, 0, 1, 40*AUTO_SIZE_SCALE_X)];
    shuView2.backgroundColor = UIColorFromRGB(0xbfc4ca);;
    [beltBtnBgView addSubview:shuView2];

    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(80*AUTO_SIZE_SCALE_X+1, 0, 40*AUTO_SIZE_SCALE_X-1, 40*AUTO_SIZE_SCALE_X);
    [addBtn setImage:[UIImage imageNamed:@"icon_reserve_clocknum_add"] forState:UIControlStateNormal];
    [addBtn setTitleColor:C6UIColorGray forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [beltBtnBgView addSubview:addBtn];
    
    //服务时间View
    UIView * servTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, beltView.frame.origin.y+beltView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    servTimeView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:servTimeView];
    
    UILabel * servTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X,0, 90*AUTO_SIZE_SCALE_X,45*AUTO_SIZE_SCALE_X-1)];
    servTimeLabel.text = @"服务时间";
    servTimeLabel.textColor = C6UIColorGray;
    servTimeLabel.font = [UIFont systemFontOfSize:14];
    [servTimeView addSubview:servTimeLabel];
    
    UILabel * showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(servTimeLabel.frame.origin.x+servTimeLabel.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-1)];
    showTimeLabel.text = [NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceTime"]];
    showTimeLabel.textColor = C6UIColorGray;
    showTimeLabel.textAlignment = NSTextAlignmentRight;
    showTimeLabel.font = [UIFont systemFontOfSize:14];
    [servTimeView addSubview:showTimeLabel];
    
    UIImageView * servTimeLine = [[UIImageView alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-13*AUTO_SIZE_SCALE_X, 0.5)];
    servTimeLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [servTimeView addSubview:servTimeLine];
    
    //服务地址View
    UIView * servPlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, servTimeView.frame.origin.y+servTimeView.frame.size.height, kScreenWidth, 87*AUTO_SIZE_SCALE_X)];//无地址45，有地址87
    servPlaceView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:servPlaceView];
    
    UILabel * servPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X,0, 90*AUTO_SIZE_SCALE_X,45*AUTO_SIZE_SCALE_X-1)];
    servPlaceLabel.text = @"服务地址";
    servPlaceLabel.textColor = C6UIColorGray;
    servPlaceLabel.font = [UIFont systemFontOfSize:14];
    [servPlaceView addSubview:servPlaceLabel];
    
    UILabel * selectPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(servPlaceLabel.frame.origin.x+servPlaceLabel.frame.size.width, 15*AUTO_SIZE_SCALE_X, 185*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    selectPlaceLabel.text =  [NSString stringWithFormat:@"%@%@",[self.serviceDic objectForKey:@"clientArea"],[self.serviceDic objectForKey:@"clientAddress"]];
    
    selectPlaceLabel.textColor = C6UIColorGray;
    selectPlaceLabel.textAlignment = NSTextAlignmentLeft;
    selectPlaceLabel.font = [UIFont systemFontOfSize:14];
    selectPlaceLabel.numberOfLines = 0;
    selectPlaceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize maxSize = CGSizeMake(185*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X);
        selectPlaceLabel.textAlignment = NSTextAlignmentLeft;
        
        CGSize selectPlaceLabelSize = [selectPlaceLabel.text sizeWithFont:selectPlaceLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
        selectPlaceLabel.frame = CGRectMake(servPlaceLabel.frame.origin.x+servPlaceLabel.frame.size.width, 15*AUTO_SIZE_SCALE_X, 185*AUTO_SIZE_SCALE_X, selectPlaceLabelSize.height);
    [servPlaceView addSubview:selectPlaceLabel];
    
    
    NSString * kehuSex = @"";
    if ([[self.serviceDic objectForKey:@"clientGender"] isEqualToString:@"男"]) {
        kehuSex = @"先生";
    }
    else
    {
        kehuSex = @"女士";
    }
    UILabel * kehuInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(servPlaceLabel.frame.origin.x+servPlaceLabel.frame.size.width, selectPlaceLabel.frame.origin.y+selectPlaceLabel.frame.size.height+13*AUTO_SIZE_SCALE_X, 185*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    kehuInfoLabel.text = [NSString stringWithFormat:@"%@ %@  %@",[self.serviceDic objectForKey:@"clientName"],kehuSex,[self.serviceDic objectForKey:@"clientMobile"]];
    kehuInfoLabel.textColor = C6UIColorGray;
    kehuInfoLabel.textAlignment = NSTextAlignmentLeft;
    kehuInfoLabel.font = [UIFont systemFontOfSize:14];
    [servPlaceView addSubview:kehuInfoLabel];
    
    UIImageView * servPlaceLine = [[UIImageView alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 87*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-13*AUTO_SIZE_SCALE_X, 0.5)];
    servPlaceLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [servPlaceView addSubview:servPlaceLine];
    
    //技师选择View
    UIView * servWorkerView = [[UIView alloc] initWithFrame:CGRectMake(0, servPlaceView.frame.origin.y+servPlaceView.frame.size.height, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    servWorkerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:servWorkerView];
    
    UILabel * servWorkerLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X,0, 90*AUTO_SIZE_SCALE_X,45*AUTO_SIZE_SCALE_X-1)];
    servWorkerLabel.text = @"技师选择";
    servWorkerLabel.textColor = C6UIColorGray;
    servWorkerLabel.font = [UIFont systemFontOfSize:14];
    [servWorkerView addSubview:servWorkerLabel];
    
    UILabel * selectWorkerLabel = [[UILabel alloc] initWithFrame:CGRectMake(servWorkerLabel.frame.origin.x+servWorkerLabel.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-1)];
    if ([[self.serviceDic objectForKey:@"workerName"] isEqualToString:@""]) {
        selectWorkerLabel.text = @"推荐技师";
    }
    else
    {
         selectWorkerLabel.text = [NSString stringWithFormat:@"%@  %@",[self.serviceDic objectForKey:@"workerName"],[self.serviceDic objectForKey:@"workerGrade"]];
    }
    selectWorkerLabel.textColor = C6UIColorGray;
    selectWorkerLabel.textAlignment = NSTextAlignmentRight;
    selectWorkerLabel.font = [UIFont systemFontOfSize:14];
    [servWorkerView addSubview:selectWorkerLabel];
    
    UIImageView * servWorkerLine = [[UIImageView alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-13*AUTO_SIZE_SCALE_X, 0.5)];
    servWorkerLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [servWorkerView addSubview:servWorkerLine];
    
#pragma mark 优惠券
    couponView = [[UIView alloc] initWithFrame:CGRectMake(0, servWorkerView.frame.origin.y+servWorkerView.frame.size.height, kScreenWidth, 90*AUTO_SIZE_SCALE_X)];
    couponView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:couponView];
    
    UIView * couponBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    [couponView addSubview:couponBgView];
    UITapGestureRecognizer * couponBgViewTap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(couponBgViewTaped:)];
    [couponBgView addGestureRecognizer:couponBgViewTap];
    
    UILabel * couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 0,  90*AUTO_SIZE_SCALE_X,45*AUTO_SIZE_SCALE_X-1)];
    couponLabel.text = @"优惠券";
    couponLabel.textColor = C6UIColorGray;
    couponLabel.font = [UIFont systemFontOfSize:14];
    [couponBgView addSubview:couponLabel];
    
    selectCouponLabel = [[UILabel alloc] initWithFrame:CGRectMake(couponLabel.frame.origin.x+couponLabel.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-1)];
//    if (CouponListArray.count >0) {
//        selectCouponLabel.text = [NSString stringWithFormat:@"¥ %d",couponPrice];
//    }else{
        selectCouponLabel.text = [NSString stringWithFormat:@"%@",@"请选择优惠券"];
//        couponView.userInteractionEnabled = NO;
//    }
    selectCouponLabel.textColor = C6UIColorGray;
    selectCouponLabel.textAlignment = NSTextAlignmentRight;
    selectCouponLabel.font = [UIFont systemFontOfSize:14];
    [couponBgView addSubview:selectCouponLabel];
    
    UIImageView * couponImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-(7+13)*AUTO_SIZE_SCALE_X, (45*AUTO_SIZE_SCALE_X-1-14*AUTO_SIZE_SCALE_X)/2, 7*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
    couponImv.image = [UIImage imageNamed:@"icon_sd_next"];
    [couponBgView addSubview:couponImv];
    
    UIImageView * couponLine = [[UIImageView alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-13*AUTO_SIZE_SCALE_X, 0.5)];
    couponLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [couponBgView addSubview:couponLine];
    
    remarkTextView = [[UITextView alloc] initWithFrame:CGRectMake(13*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, kScreenWidth-26*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    remarkTextView.delegate = self;
    remarkTextView.text = @"说说还有什么要求（选填）";
    remarkTextView.backgroundColor = [UIColor whiteColor];
    remarkTextView.font = [UIFont systemFontOfSize:14.0f];
    remarkTextView.scrollEnabled = NO;
    remarkTextView.showsVerticalScrollIndicator = NO;
    remarkTextView.showsHorizontalScrollIndicator = NO;
    [couponView addSubview:remarkTextView];
    
#pragma mark 总计
    moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, couponView.frame.origin.y+couponView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 120*AUTO_SIZE_SCALE_X)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:moneyView];
    
    perTime = [[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"duration"]] intValue];
    
    // 优惠券
    couponShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    if (CouponListArray.count > 0) {
        couponShowLabel.text = [NSString stringWithFormat:@"优惠券-¥%0.2f",couponPrice];
        couponShowLabel.textAlignment = NSTextAlignmentRight;
        couponShowLabel.font = [UIFont systemFontOfSize:13];
        CGSize couponShowLabelSize = [couponShowLabel intrinsicContentSize];
        couponShowLabel.frame = CGRectMake(kScreenWidth-couponShowLabelSize.width-10*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, couponShowLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    }else{
        couponShowLabel.text = @"";
        couponShowLabel.frame = CGRectMake(kScreenWidth, 15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X);
    }
    [moneyView addSubview:couponShowLabel];
    
    // 单价*钟数
    allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    allPriceLabel.text = [NSString stringWithFormat:@"¥%0.2f×%0.1f=¥%0.2f",permoney,beltNum,permoney*beltNum];
    allPriceLabel.textAlignment = NSTextAlignmentRight;
    allPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize allPriceLabelSize = [allPriceLabel intrinsicContentSize];
    allPriceLabel.frame = CGRectMake(kScreenWidth-(10*AUTO_SIZE_SCALE_X)-(kScreenWidth-couponShowLabel.frame.origin.x)-allPriceLabelSize.width, 15*AUTO_SIZE_SCALE_X, allPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [moneyView addSubview:allPriceLabel];
    
    // 交通费
    busPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    busPriceLabel.text = [NSString stringWithFormat:@"交通费 ¥ %0.2f",busPrice];
    busPriceLabel.textAlignment = NSTextAlignmentRight;
    busPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize busPriceLabelSize = [busPriceLabel intrinsicContentSize];
    busPriceLabel.frame = CGRectMake(kScreenWidth-busPriceLabelSize.width-10*AUTO_SIZE_SCALE_X, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, busPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    if (busPrice == 0) {
        busPriceLabel.frame = CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height, 0, 0);
    }
    [moneyView addSubview:busPriceLabel];
    
    // 带床上门
    bedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    bedPriceLabel.text = [NSString stringWithFormat:@"带床上门%d",bedPrice];
    bedPriceLabel.textAlignment = NSTextAlignmentRight;
    bedPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize bedPriceLabelSize = [bedPriceLabel intrinsicContentSize];
    bedPriceLabel.frame = CGRectMake(kScreenWidth-(busPriceLabel.frame.size.width+10*AUTO_SIZE_SCALE_X+bedPriceLabelSize.width+10*AUTO_SIZE_SCALE_X), allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, bedPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    if (bedPrice == 0) {
        bedPriceLabel.frame = CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height, 0, 0);
    }
    [moneyView addSubview:bedPriceLabel];
    
    CGFloat changeheight = allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height;
    if (bedPrice != 0 || busPrice != 0) {
        changeheight = allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X+13.0*AUTO_SIZE_SCALE_X;
    }
    
    // 总时长
    allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bedPriceLabel.frame.origin.y+bedPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    allTimeLabel.text = [NSString stringWithFormat:@"总时长: %0.1f分钟",perTime*beltNum];
    allTimeLabel.textAlignment = NSTextAlignmentRight;
    allTimeLabel.font = [UIFont systemFontOfSize:13];
    CGSize allTimeLabelSize = [allTimeLabel intrinsicContentSize];
    allTimeLabel.frame = CGRectMake(kScreenWidth-(allTimeLabelSize.width+10*AUTO_SIZE_SCALE_X), changeheight+10*AUTO_SIZE_SCALE_X, allTimeLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [moneyView addSubview:allTimeLabel];
    
    // 总计
    paymentPrice = permoney*beltNum-couponPrice+bedPrice+busPrice;
    if (paymentPrice < 0) {
        paymentPrice = 0;
    }
    paymentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allTimeLabel.frame.origin.y+allTimeLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X)];
    paymentPriceLabel.text = [NSString stringWithFormat:@"总计: ¥%0.2f",paymentPrice];
    paymentPriceLabel.textAlignment = NSTextAlignmentRight;
    paymentPriceLabel.textColor = RedUIColorC1;
    paymentPriceLabel.font = [UIFont systemFontOfSize:13];
    CGSize paymentPriceLabelSize = [paymentPriceLabel intrinsicContentSize];
    paymentPriceLabel.frame = CGRectMake(kScreenWidth-(paymentPriceLabelSize.width+10*AUTO_SIZE_SCALE_X), allTimeLabel.frame.origin.y+allTimeLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, paymentPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    [moneyView addSubview:paymentPriceLabel];
    
    moneyView.frame = CGRectMake(0,  moneyView.frame.origin.y, kScreenWidth, paymentPriceLabel.frame.origin.y+paymentPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X);
#pragma mark 支付方式
    payView = [[PayView alloc] initWithFrame:CGRectMake(0, moneyView.frame.origin.y+moneyView.frame.size.height, kScreenWidth, 203*AUTO_SIZE_SCALE_X)];
    payView.backgroundColor = [UIColor clearColor];
    payView.money = [NSString stringWithFormat:@"%0.2f",paymentPrice];
    float balanceFloat = [balanceStr floatValue]/100.0;
    payView.balanceStr = [NSString stringWithFormat:@"%0.2f",balanceFloat];;
    [payView setDefaultMode];
    [headerView addSubview:payView];
    NSLog(@"payView.money %@",payView.money);
    //从新调整headerView高度
    headerView.frame = CGRectMake(0, 0, kScreenWidth, payView.frame.origin.y+payView.frame.size.height);
    [tableView setTableHeaderView:headerView];
    
    
}
#pragma mark ------------------------------------------------------------------------------
-(void)changeMonryView
{
    if (couponPrice > 0) {
        couponShowLabel.text = [NSString stringWithFormat:@"优惠券-¥%0.2f",couponPrice];
        couponShowLabel.font = [UIFont systemFontOfSize:13];
        CGSize couponShowLabelSize = [couponShowLabel intrinsicContentSize];
        couponShowLabel.frame = CGRectMake(kScreenWidth-couponShowLabelSize.width-10*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, couponShowLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    }else{
        couponShowLabel.text = @"";
        couponShowLabel.frame = CGRectMake(kScreenWidth, 15*AUTO_SIZE_SCALE_X, 0, 13*AUTO_SIZE_SCALE_X);
    }
    
    allPriceLabel.text = [NSString stringWithFormat:@"¥%0.2f×%0.1f=¥%0.2f",permoney,beltNum,permoney*beltNum];
    CGSize allPriceLabelSize = [allPriceLabel intrinsicContentSize];
    allPriceLabel.frame = CGRectMake(kScreenWidth-(10*AUTO_SIZE_SCALE_X)-(kScreenWidth-couponShowLabel.frame.origin.x)-allPriceLabelSize.width, 15*AUTO_SIZE_SCALE_X, allPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    
    busPriceLabel.text = [NSString stringWithFormat:@"交通费 ¥ %0.2f",busPrice];
    CGSize busPriceLabelSize = [busPriceLabel intrinsicContentSize];
    busPriceLabel.frame = CGRectMake(kScreenWidth-busPriceLabelSize.width-10*AUTO_SIZE_SCALE_X, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, busPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    if (busPrice == 0) {
        busPriceLabel.frame = CGRectMake(kScreenWidth, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height, 0, 0);
    }
    //    else{
    //        bedPriceLabel.frame = CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X,0, 13*AUTO_SIZE_SCALE_X);
    //    }
    
    bedPriceLabel.text = [NSString stringWithFormat:@"带床上门 ¥ %d",bedPrice];
    CGSize bedPriceLabelSize = [bedPriceLabel intrinsicContentSize];
    bedPriceLabel.frame = CGRectMake(kScreenWidth-(10*AUTO_SIZE_SCALE_X)-(kScreenWidth-busPriceLabel.frame.origin.x)-bedPriceLabelSize.width, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, bedPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    if (bedPrice == 0) {
        bedPriceLabel.frame = CGRectMake(0, allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height, 0, 0);
    }
    
    CGFloat changeheight = allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height;
    if (bedPrice != 0 || busPrice != 0) {
        changeheight = allPriceLabel.frame.origin.y+allPriceLabel.frame.size.height+10*AUTO_SIZE_SCALE_X+13.0*AUTO_SIZE_SCALE_X;
    }
    
    allTimeLabel.text = [NSString stringWithFormat:@"总时长: %0.1f分钟",perTime*beltNum];
    CGSize allTimeLabelSize = [allTimeLabel intrinsicContentSize];
    allTimeLabel.frame = CGRectMake(kScreenWidth-(allTimeLabelSize.width+10*AUTO_SIZE_SCALE_X), changeheight+10*AUTO_SIZE_SCALE_X, allTimeLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    
    
    paymentPrice = permoney*beltNum-couponPrice+bedPrice+busPrice;
    if (paymentPrice < 0) {
        paymentPrice = 0;
    }
//    payView.money = [NSString stringWithFormat:@"%0.2f",paymentPrice];

    paymentPriceLabel.text = [NSString stringWithFormat:@"总计: ¥%0.2f",paymentPrice];
    CGSize paymentPriceLabelSize = [paymentPriceLabel intrinsicContentSize];
    paymentPriceLabel.frame = CGRectMake(kScreenWidth-(paymentPriceLabelSize.width+10*AUTO_SIZE_SCALE_X), allTimeLabel.frame.origin.y+allTimeLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, paymentPriceLabelSize.width, 13*AUTO_SIZE_SCALE_X);
    
    moneyView.frame = CGRectMake(0,  couponView.frame.origin.y+couponView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, paymentPriceLabel.frame.origin.y+paymentPriceLabel.frame.size.height+15*AUTO_SIZE_SCALE_X);
    payView.frame = CGRectMake(0, moneyView.frame.origin.y+moneyView.frame.size.height, kScreenWidth, 203*AUTO_SIZE_SCALE_X);
    headerView.frame = CGRectMake(0, 0, kScreenWidth, payView.frame.origin.y+payView.frame.size.height);
    [tableView setTableHeaderView:headerView];
    
    payView.money = [NSString stringWithFormat:@"%0.2f",paymentPrice];
}

#pragma mark 钟数减
-(void)subBtnPressed:(UIButton *)sender
{
    if (beltNum == 0.5) {
        return;
    }
    beltNum = beltNum-0.5;
    beltNumLabel.text = [NSString stringWithFormat:@"%0.1f",beltNum];
    
    CGFloat numBelt = beltNum*1.0;
    busPrice = [[[beltInfoDic objectForKey:[NSString stringWithFormat:@"%0.1f",numBelt]] objectForKey:@"transportationFee"] floatValue];

    couponPrice = 0;
    selectCouponLabel.text = [NSString stringWithFormat:@"%@",@"请选择优惠券"];
    couponID = @"";
    paymentPrice = permoney*beltNum-couponPrice;
    if (paymentPrice < 0) {
        paymentPrice = 0;
    }
    [self changeMonryView];

    
    [payView setDefaultMode];
    
    
}
#pragma mark 钟数加
-(void)addBtnPressed:(UIButton *)sender
{
    if (beltNum > maxBelt-0.5) {
        return;
    }
    beltNum = beltNum+0.5;
    beltNumLabel.text = [NSString stringWithFormat:@"%0.1f",beltNum];
    
    CGFloat numBelt = beltNum*1.0;
    busPrice = [[[beltInfoDic objectForKey:[NSString stringWithFormat:@"%0.1f",numBelt]] objectForKey:@"transportationFee"] floatValue];
    
    couponPrice = 0;
    selectCouponLabel.text = [NSString stringWithFormat:@"%@",@"请选择优惠券"];
    couponID = @"";
    paymentPrice = permoney*beltNum-couponPrice;
    if (paymentPrice < 0) {
        paymentPrice = 0;
    }
    [self changeMonryView];

    
    
    [payView setDefaultMode];
    
}

#pragma mark 选择优惠券
-(void)couponBgViewTaped:(UITapGestureRecognizer *)sender
{
    [remarkTextView resignFirstResponder];

    NSLog(@"选择优惠券");
    CouponSelectViewController * vc = [[CouponSelectViewController alloc] init];
    vc.serviceID = [NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceID"]];
    vc.workerId = [NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"workerID"]];
    vc.storeID = @"";
    paymentPrice = permoney*beltNum+bedPrice+busPrice;
    NSLog(@"paymentPrice  -- %f",paymentPrice);
    vc.payment = [NSString stringWithFormat:@"%f",paymentPrice*100];
    [payView setDefaultMode];
    couponPrice = 0;
    couponID = @"";
    [self changeMonryView];
    [vc returnCouponInfo:^(NSDictionary *dic) {
        if (dic) {
//            selectCouponLabel.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"price"]];
//            couponID = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"ID"]];
            couponPrice = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]] floatValue]/100.0;
            selectCouponLabel.text = [NSString stringWithFormat:@"¥%0.2f",couponPrice];
            
            couponID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
            paymentPrice = permoney*beltNum-couponPrice;
            if (paymentPrice < 0) {
                paymentPrice = 0;
            }
            if (couponPrice == 0) {
                selectCouponLabel.text = @"请选择优惠券";
            }
            [self changeMonryView];
        }else if( [couponID isEqualToString:@""]){
            selectCouponLabel.text = @"请选择优惠券";
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 改变支付方式
-(void)changePayWay:(NSNotification *)ntf
{
    payWayDic = [NSDictionary dictionaryWithDictionary:ntf.object];
    NSLog(@"支付方式 dic-->%@",payWayDic);
}

-(void)ZeroPay
{
    NSString * remarkStr = @"";
    if ([remarkTextView.text isEqualToString:@"说说还有什么要求（选填）"]) {
        
    }else{
        remarkStr = remarkTextView.text;
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString *deviceTokenStr = [userDefaults objectForKey:@"deviceToken"];
    
    NSDictionary * dic = @{
                           @"amount":[NSString stringWithFormat:@"%0.1f",beltNum],
                           @"serviceTime":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceTime"]],
                           @"orderID":self.orderID,
                           @"servType":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceType"]],
                           @"workerID":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"workerID"]],
                           @"remark":remarkStr,
                           @"couponID":couponID,
                           @"userID":userID,
                           @"gradeID":[self.serviceDic objectForKey:@"workerGrade"],
                           @"client":@"ios",
                           @"addressID":[self.serviceDic objectForKey:@"addressID"],
                           @"isPaidByDeposit":[payWayDic objectForKey:@"isPaidByDeposit"],
                           @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                           @"deviceToken":deviceTokenStr,
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] genServiceOrder:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"确认支付 result %@",result);
        //        NSLog(@"确认支付 result %@", [result objectForKey:@"msg"]);
        
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
            newOrderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
            //code 0000 如果只是余额支付 那么成功支付 直接跳转
            if ([serviceType isEqualToString:@"3"]) {
                WaitForHomeServiceViewController * vc = [[WaitForHomeServiceViewController alloc] init];
                vc.orderID = newOrderID;
                vc.isNotFromOrderList = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([serviceType isEqualToString:@"2"]) {
                WaitForHomeSericeByStoreViewController * vc = [[WaitForHomeSericeByStoreViewController alloc] init];
                vc.orderID = newOrderID;
                vc.isNotFromOrderList = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
            
            
            
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
        
    } failuer:^(NSError *error) {
        Paybtn.userInteractionEnabled = YES;
        
    }];

}

#pragma mark 确认支付按钮
-(void)btnPressed:(UIButton *)sender
{
    NSLog(@"余额  %@  总计  %f",balanceStr,paymentPrice);

    //支付金额是0 直接掉接口 支付成功
    if (paymentPrice == 0) {
        [self ZeroPay];
        return;
    }
    
    Paybtn.userInteractionEnabled = NO;
    
    NSLog(@"确认支付");
    //所有支付方式都未选择
    if ([[payWayDic objectForKey:@"isPaidByDeposit"] isEqualToString:@""]&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择支付方式" viewController:self];
        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }
    //余额不足 且 未选择其余支付方式
//    float money = [payView.money floatValue];
    float balance = [balanceStr floatValue]/100.0;
    
    if (balance == 0&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择支付方式" viewController:self];
        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }
    
    if (balance < paymentPrice&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"余额不足" viewController:self];
        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }
    
    NSString * remarkStr = @"";
    if ([remarkTextView.text isEqualToString:@"说说还有什么要求（选填）"]) {
        
    }else{
        remarkStr = remarkTextView.text;
    }

    //余额支付 弹框确认
    if ([[payWayDic objectForKey:@"isPaidByDeposit"] isEqualToString:@"1"]&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        UIAlertView * aletView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"余额支付 ¥%0.2f",paymentPrice] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aletView show];
        return;
    }

    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString *deviceTokenStr = [userDefaults objectForKey:@"deviceToken"];
    NSLog(@"serviceType %@",serviceType);
    NSDictionary * dic = @{
                           @"amount":[NSString stringWithFormat:@"%0.1f",beltNum],
                           @"serviceTime":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceTime"]],
                           @"orderID":self.orderID,
                           @"servType":serviceType,
                           @"workerID":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"workerID"]],
                           @"remark":remarkStr,
                           @"couponID":couponID,
                           @"userID":userID,
                           @"gradeID":[self.serviceDic objectForKey:@"workerGrade"],
                           @"client":@"ios",
                           @"addressID":[self.serviceDic objectForKey:@"addressID"],
                           @"isPaidByDeposit":[payWayDic objectForKey:@"isPaidByDeposit"],
                           @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                           @"deviceToken":deviceTokenStr,
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] genServiceOrder:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"确认支付 result %@",result);
        //        NSLog(@"确认支付 result %@", [result objectForKey:@"msg"]);
        
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
            NSString * pChannelCode = [result objectForKey:@"payChannelCode"];
            newOrderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
            //code 0000 如果只是余额支付 那么成功支付 直接跳转
//            if ([pChannelCode isEqualToString:@""]) {
//                if ([serviceType isEqualToString:@"3"]) {
//                    WaitForHomeServiceViewController * vc = [[WaitForHomeServiceViewController alloc] init];
//                    vc.orderID = newOrderID;
//                    vc.isNotFromOrderList = @"1";
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                if ([serviceType isEqualToString:@"2"]) {
//                    WaitForHomeSericeByStoreViewController * vc = [[WaitForHomeSericeByStoreViewController alloc] init];
//                    vc.orderID = newOrderID;
//                    vc.isNotFromOrderList = @"1";
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
//
//            }

            if([pChannelCode isEqualToString:@"tenpay_app"]){
                [self sendPay:[result objectForKey:@"tenpayData"]];
                NSLog(@"pChannelCode-----tenpay_app-->%@",[result objectForKey:@"tenpayData"]);
            }else if([pChannelCode isEqualToString:@"alipay_sdk"]){
                [self alipay:[result objectForKey:@"alipayData"]];
            }
            
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
        
    } failuer:^(NSError *error) {
        Paybtn.userInteractionEnabled = YES;
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //取消余额支付 跳转到 待支付界面
    if (buttonIndex == 0) {
        //        [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:0.5];
        Paybtn.userInteractionEnabled = YES;
        
    }
    //余额支付
    else if (buttonIndex == 1){
        NSString * remarkStr = @"";
        if ([remarkTextView.text isEqualToString:@"说说还有什么要求（选填）"]) {
            
        }else{
            remarkStr = remarkTextView.text;
        }

        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSString *deviceTokenStr = [userDefaults objectForKey:@"deviceToken"];
        
        NSDictionary * dic = @{
                               @"amount":[NSString stringWithFormat:@"%0.1f",beltNum],
                               @"serviceTime":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceTime"]],
                               @"orderID":self.orderID,
                               @"servType":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"serviceType"]],
                               @"workerID":[NSString stringWithFormat:@"%@",[self.serviceDic objectForKey:@"workerID"]],
                               @"remark":remarkStr,
                               @"couponID":couponID,
                               @"userID":userID,
                               @"gradeID":[self.serviceDic objectForKey:@"workerGrade"],
                               @"client":@"ios",
                               @"addressID":[self.serviceDic objectForKey:@"addressID"],
                               @"isPaidByDeposit":[payWayDic objectForKey:@"isPaidByDeposit"],
                               @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                               @"deviceToken":deviceTokenStr,
                               };
        NSLog(@"dic %@",dic);
        [[RequestManager shareRequestManager] genServiceOrder:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"确认支付 result %@",result);
            //        NSLog(@"确认支付 result %@", [result objectForKey:@"msg"]);
            
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                
                 newOrderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
                //code 0000 如果只是余额支付 那么成功支付 直接跳转
                     if ([serviceType isEqualToString:@"3"]) {
                        WaitForHomeServiceViewController * vc = [[WaitForHomeServiceViewController alloc] init];
                        vc.orderID = newOrderID;
                        vc.isNotFromOrderList = @"1";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([serviceType isEqualToString:@"2"]) {
                        WaitForHomeSericeByStoreViewController * vc = [[WaitForHomeSericeByStoreViewController alloc] init];
                        vc.orderID = newOrderID;
                        vc.isNotFromOrderList = @"1";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
                    
                
                
            }else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            }
            
            
        } failuer:^(NSError *error) {
            Paybtn.userInteractionEnabled = YES;
            
        }];
    }
    
}

-(void)gotoOrderDetail
{
    if ([serviceType isEqualToString:@"3"]) {
        WaitForHomeServiceViewController * vc = [[WaitForHomeServiceViewController alloc] init];
        vc.orderID = newOrderID;
        vc.isNotFromOrderList = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([serviceType isEqualToString:@"2"]) {
        WaitForHomeSericeByStoreViewController * vc = [[WaitForHomeSericeByStoreViewController alloc] init];
        vc.orderID = newOrderID;
        vc.isNotFromOrderList = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
    
}

-(void)gotoWaitForPayOrderDetail
{
    //PayForWorkViewController
    if ([serviceType isEqualToString:@"3"]) {
        PayForWorkViewController * vc = [[PayForWorkViewController alloc] init];
        vc.orderID = newOrderID;
        vc.isNotFromOrderList = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([serviceType isEqualToString:@"2"]) {
        PayForWorkByStoreViewController * vc = [[PayForWorkByStoreViewController alloc] init];
        vc.orderID = newOrderID;
        vc.isNotFromOrderList = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
    
}

#pragma mark 微信


-(void)WeChatPageDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"returnCode"];
    NSString *requestflag =[info objectForKey:@"requestflag"];
    Paybtn.enabled = YES;
    
    if([ret isEqualToString:@"0"]){
        [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
        [self performSelector:@selector(gotoOrderDetail) withObject:nil afterDelay:1.0];
        
    }else if([ret isEqualToString:@"-2"]){
        [[RequestManager shareRequestManager] tipAlert:requestflag viewController:self];
        [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];

    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wechatMessaage" object:nil];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self];//移除通知
}

- (void)sendPay:(NSDictionary *)dict
{
    
    NSLog(@"sendPay-------------------------------------->%@",dict);
    NSMutableString *timeStamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = timeStamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    
    
    
    
    BOOL flagggg=[WXApi sendReq:req];
    NSLog(@"flagggg-----=%d",flagggg );
    if (flagggg == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请您安装微信客户端" viewController:self];
        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];

    }
    
    //    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //    //订单标题
    //    NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //    //订单金额，单位（元）
    //    NSString *ORDER_PRICE   = @"0.01";
    //
    //    //根据服务器端编码确定是否转码
    //    NSStringEncoding enc;
    //    //if UTF8编码
    //    //enc = NSUTF8StringEncoding;
    //    //if GBK编码
    //    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
    //                           SP_URL,
    //                           [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
    //                           [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
    //                           ORDER_PRICE];
    //
    //    //解析服务端返回json数据
    //    NSError *error;
    //    //加载一个NSURL对象
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //    //将请求的url数据放到NSData对象中
    //    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if ( response != nil) {
    //        NSMutableDictionary *dict = NULL;
    //        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //
    //        NSLog(@"url:%@",urlString);
    //        if(dict != nil){
    //            NSMutableString *retcode = [dict objectForKey:@"retcode"];
    //            if (retcode.intValue == 0){
    //                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    //
    //                //调起微信支付
    //                PayReq* req             = [[PayReq alloc] init];
    //                req.openID              = [dict objectForKey:@"appid"];
    //                req.partnerId           = [dict objectForKey:@"partnerid"];
    //                req.prepayId            = [dict objectForKey:@"prepayid"];
    //                req.nonceStr            = [dict objectForKey:@"noncestr"];
    //                req.timeStamp           = stamp.intValue;
    //                req.package             = [dict objectForKey:@"package"];
    //                req.sign                = [dict objectForKey:@"sign"];
    //                [WXApi sendReq:req];
    //                //日志输出
    //                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    //            }else{
    //                [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
    //            }
    //        }else{
    //            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
    //        }
    //    }else{
    //        [self alert:@"提示信息" msg:@"服务器返回错误"];
    //    }
}

-(void)payBtncanuse
{
    Paybtn.userInteractionEnabled = YES;


}


#pragma mark 支付宝
-(void)alipay:(NSString *)alipayDataString{
    //    /*============================================================================*/
    //    /*=======================需要填写商户app申请的===================================*/
    //    /*============================================================================*/
    //    NSString *partner = @"2088711331431963";
    //    NSString *seller = @"huatuojiadao@aliyun.com";
    //    NSString *privateKey =@"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAML3XB/nsyIiRpWVyG+Dm5yu2U/Ksgz3PnvK8vAD4hDLLUst9J6lk+VYf9RaJaGavLaaTTaMDC/caccOs0EsPQorNa86ZWJxoz9eRLyuRaSYlYgTw4xEownxZvHB1lL8125d4Kk3BIua113rOeVZRY58BNVnKG6/vjViuxtcopPJAgMBAAECgYEAiRbpnj2LhdrYCuJxN4gw6TFA+IwsOlW3h9AiloYEdY6H4K8FrG/82G0sJSLmBwYI39ULqek7wIOZlTBO9uqmV74gOQolUdZ5hA9gxlBaJKZmY7eGfxSgUgXfZ8TCxQSABPxqgjBoLAucjlTcqPiUf6Z8Ky6uZRLpLqlxS66JGgECQQD4t4B6edK08uFIMp41RGDl3+mg/+HkVinnrSdY4fVkVvnItn/6Nha3YXjcDDEAnJ+4SifcPIkF3/PRNHgkEc+pAkEAyKzrJowLIgKmXfOwUM3ccal8SJkp/JMaEVb2r1ZfqpWI/ZAete66/28KMboh9PeYOsIlZj9lJYdcvdixxt23IQJBAMCyq8A4kp/PbevaC+mJSOnRSdmLZyDaAS2WYl3i85UCLhTsEMtzDLaXtmQGrhCjSLwn+CoSXLdIhEcaN9r6UcECQHpdRn4YwukYKI39fDOpc5QzPr+d9YY3xJtyJbXAu1DvIbtL2A4j5g6/jL3Ju8798utRWzC/01NQ+PIiYjTbGUECQQCtdSNzQ6Jhff4Tk5ECtgMDefg0nbidhF+5NYAw3mGAKEZPyXsB0Qkk4pmJRg6Bb0AGYmgJLeyGjq/k4ZKcTytx";
    //    /*
    //     *生成订单信息及签名
    //     */
    //    //将商品信息赋予AlixPayOrder的成员变量
    //    Order *order = [[Order alloc] init];
    //    order.partner = partner;
    //    order.seller = seller;
    //    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    //    Product *product = [[Product alloc] init];
    //    order.productName = product.subject; //商品标题
    //    order.productDescription = product.body; //商品描述
    //    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    //    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    //
    //    order.service = @"mobile.securitypay.pay";
    //    order.paymentType = @"1";
    //    order.inputCharset = @"utf-8";
    //    order.itBPay = @"30m";
    //    order.showUrl = @"m.alipay.com";
    //
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    
    //
    //    //将商品信息拼接成字符串
    //    NSString *orderSpec = [order description];
    //    NSLog(@"orderSpec = %@",orderSpec);
    //
    //    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    //    NSString *signedString = [signer signString:orderSpec];
    //
    //    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    //    NSString *orderString = nil;
    //    if (signedString != nil) {
    //        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
    //                       orderSpec, signedString, @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:alipayDataString fromScheme:APPScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoOrderDetail) withObject:nil afterDelay:1.0];

        }else if([resultStatus isEqualToString:@"8000"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单 正在处理中" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"4000"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单支付失败 " viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];

            
        }else if([resultStatus isEqualToString:@"6001"]){
            [[RequestManager shareRequestManager] tipAlert:@"您中途取消了 订单支付" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];

            
        }else if([resultStatus isEqualToString:@"6002"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单 网络连接出错" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];

            
        }
    }];
    
    
    //    }
    
    
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // make sure the cell is at the top
    
    if ([textView.text isEqualToString:@"说说还有什么要求（选填）"]) {
        textView.text = @"";
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"说说还有什么要求（选填）";
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)theTextView
{
//    if ([theTextView.text isEqualToString:@"说说还有什么要求（选填）"]) {
//        theTextView.text = @"";
//    }
//    if ([theTextView.text isEqualToString:@""]) {
//        theTextView.text = @"说说还有什么要求（选填）";
//    }
    if (theTextView.text.length >  40) {
        theTextView.text = [theTextView.text substringToIndex:40];
    }
}

#pragma mark －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
