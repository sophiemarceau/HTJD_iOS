//
//  FlashDetailViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/9/17.
//  Copyright (c) 2015年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDetailViewController.h"
#import "publicTableViewCell.h"
#import "FlashPayViewController.h"
#import "NBTextField.h"
#import "PayView.h"
#import "CouponSelectViewController.h"
#import "WaitForCommentByQuickPassViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
@interface FlashDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource ,UIAlertViewDelegate>
{
    UIView * headView;
    UIView * footView;
    UITableView * myTableView;
    
    NSMutableArray * selectArray;
    
    UIView * bgView;
    UIView * messageView;
    
//    NBTextField * ConsumptionField;
    UITextField * ConsumptionField;
    
    UILabel * paymentLabel;
    
    BOOL isHaveDian;
    BOOL isHaveZero;
    
    NSString * currentStr;
    
    NSMutableArray * storeActListArray;//门店
    NSMutableArray * platActListArray;//平台
    
    UILabel * couponLabel;
    UILabel * couponInfoLabel;
    NSString * couponStr;
    UIImageView * couponNextView;
    
    PayView * payView;
    NSDictionary * payWayDic;
    
    NSArray * CouponListArray;
    NSString * couponID;
    float couponPrice;
    NSString * balanceStr;

    int platRow;
    int storeRow;
    
    float inputMoney;
    float storeactivityAmount;
    float platactivityAmount;
    
    UIButton * payBtn;
    
    NSString * storeDiscountID;
    NSString * platformDiscountID;
    
    NSString * orderID;

    NSString * newOrderID;
    NSString * serviceType;

}
@end

@implementation FlashDetailViewController
@synthesize storeID;

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

#pragma mark 改变支付方式
-(void)changePayWay:(NSNotification *)ntf
{
    payWayDic = [NSDictionary dictionaryWithDictionary:ntf.object];
    NSLog(@"支付方式 dic-->%@",payWayDic);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wechatMessaage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeChatPageDataNtf:) name:@"wechatMessaage" object:nil];

    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C2UIColorGray;
    
//    NSString * str = @"56.5";
//    double money = [str doubleValue];
//    NSLog(@"money %f",money);
    platRow = 10000;
    storeRow = 10000;
    inputMoney = 0;
    storeactivityAmount = 0;
    platactivityAmount = 0;
    couponPrice = 0;
    
    storeDiscountID = @"";
    platformDiscountID = @"";
    couponID = @"";
    couponPrice = 0;
    selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    storeActListArray = [[NSMutableArray alloc] initWithCapacity:0];
    platActListArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self downLoadData];

    
   
}

-(void)downLoadData
{
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userID = [userDefaults objectForKey:@"userID"];
//    NSDictionary * dic = @{
//                           @"userID":userID,
//                           @"status":@"0",//0 未使用1 已使用 2 已过期
//                           };
//    [[RequestManager shareRequestManager]  getUserCouponList:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"优惠券列表result -- %@",result);
//        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
    
//            CouponListArray = [NSArray arrayWithArray:[result objectForKey:@"couponList"]];
//            if (CouponListArray.count>0) {
//                couponID = [NSString stringWithFormat:@"%@",[[CouponListArray objectAtIndex:0] objectForKey:@"ID"]];
//                couponPrice = [[NSString stringWithFormat:@"%@",[[CouponListArray objectAtIndex:0] objectForKey:@"price"]] intValue]/100;
//            }
            [self  downLoadBalanceData];
            
//        }
        //        else{
        //            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        //        }
//    } failuer:^(NSError *error) {
//        
//    }];

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
            balanceStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"deposit"]];
//            [self initView];
            [self loadData];

        }
    } failuer:^(NSError *error) {
        
    }];
    
}

-(void)loadData
{
    NSDictionary * dic = @{
                           @"storeID":self.storeID,
                           };
    [[RequestManager shareRequestManager] getFastPayActivity:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"闪付优惠result-->%@",result);
        if([[result objectForKey:@"code"] isEqualToString:@"0000"]){
            NSArray *platActArray = [NSArray arrayWithArray:[result objectForKey:@"platActList"]];
            NSArray *storeActArray = [NSArray arrayWithArray:[result objectForKey:@"storeActList"]];
            if (platActArray) {
                [platActListArray addObjectsFromArray:platActArray];
            }
            if (storeActArray) {
                [storeActListArray addObjectsFromArray:storeActArray];
            }
            [self initheadView];
            
            [self initfootView];
            
            [self initTableView];
            
            [myTableView reloadData];
            myTableView.hidden = NO;
        }
    } failuer:^(NSError *error) {
        
    }];
}

-(void)initheadView
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 60*AUTO_SIZE_SCALE_X)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
#pragma mark 消费
    UIView * ConsumptionView = [[UIView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, (50-16)*AUTO_SIZE_SCALE_X)];
    ConsumptionView.backgroundColor = C2UIColorGray;
    [headView addSubview:ConsumptionView];
    
    UILabel * ConsumptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 65*AUTO_SIZE_SCALE_X, (50-16)*AUTO_SIZE_SCALE_X)];
    ConsumptionLabel.text = @"消费金额:";
    ConsumptionLabel.textColor = [UIColor blackColor];
    ConsumptionLabel.font = [UIFont systemFontOfSize:13];
    [ConsumptionView addSubview:ConsumptionLabel];

    ConsumptionField = [[UITextField alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+ConsumptionLabel.frame.origin.x+ConsumptionLabel.frame.size.width, 0, ConsumptionView.frame.size.width-(15*AUTO_SIZE_SCALE_X+ConsumptionLabel.frame.origin.x+ConsumptionLabel.frame.size.width+10*AUTO_SIZE_SCALE_X), (50-16)*AUTO_SIZE_SCALE_X)];
//    ConsumptionField.NBregEx = REGEX_MONEY_TYPE;
    ConsumptionField.keyboardType = UIKeyboardTypeDecimalPad;
    ConsumptionField.textColor = [UIColor blackColor];
    ConsumptionField.font = [UIFont systemFontOfSize:13];
    ConsumptionField.textAlignment = NSTextAlignmentRight;
    [ConsumptionField setPlaceholder:@"请询问门店工作人员后录入"];
//    [ConsumptionField setValue:C6UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
//    [ConsumptionField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [ConsumptionField setReturnKeyType:UIReturnKeyDone];
    [ConsumptionField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    ConsumptionField.delegate = self;
    [ConsumptionView addSubview:ConsumptionField];

#pragma mark 提示
//    UIView * hintsView = [[UIView alloc] initWithFrame:CGRectMake(0, ConsumptionView.frame.origin.y+ConsumptionView.frame.size.height+8*AUTO_SIZE_SCALE_X, self.view.frame.size.width, 10*AUTO_SIZE_SCALE_X)];
//    hintsView.backgroundColor = UIColorFromRGB(0xE6E5DE);
//    [headView addSubview:hintsView];
    
    
}

-(void)initfootView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 304*AUTO_SIZE_SCALE_X)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIView * couponView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*AUTO_SIZE_SCALE_X, self.view.frame.size.width, 45*AUTO_SIZE_SCALE_X)];
    couponView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:couponView];
    UITapGestureRecognizer * couponViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponBgViewTaped:)];
    [couponView addGestureRecognizer:couponViewTap];
    
    couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 140*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-1)];
    couponLabel.text = @"现金券/抵用券/优惠券";
    couponLabel.textColor = C6UIColorGray;
    couponLabel.font = [UIFont systemFontOfSize:13];
    [couponView addSubview:couponLabel];
    
    couponNextView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-(15+7)*AUTO_SIZE_SCALE_X, (45*AUTO_SIZE_SCALE_X-1-14*AUTO_SIZE_SCALE_X)/2, 7*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
    couponNextView.image = [UIImage imageNamed:@"icon_sd_next"];
    [couponView addSubview:couponNextView];
    
    couponInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 45*AUTO_SIZE_SCALE_X-1)];
    couponInfoLabel.textColor = [UIColor blackColor];
    couponInfoLabel.font = [UIFont systemFontOfSize:13];
    couponInfoLabel.hidden = YES;
    [couponView addSubview:couponInfoLabel];
    
    
    UIImageView * couponLine = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, couponView.frame.origin.y+couponView.frame.size.height-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    couponLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [footView addSubview:couponLine];
    
    UIView * showView = [[UIView alloc] initWithFrame:CGRectMake(0, couponView.frame.origin.y+couponView.frame.size.height, self.view.frame.size.width, 45*AUTO_SIZE_SCALE_X)];
    showView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:showView];
    
    UILabel * nameLabel = [[UILabel  alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 100*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    nameLabel.text = @"实付金额";
    nameLabel.textColor = C6UIColorGray;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [showView addSubview:nameLabel];
    
    paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-110, 0, 100, 45*AUTO_SIZE_SCALE_X)];
    paymentLabel.text = @"¥0.00";
    paymentLabel.textColor = RedUIColorC1;
    paymentLabel.textAlignment = NSTextAlignmentRight;
    paymentLabel.font = [UIFont systemFontOfSize:13];
    [showView addSubview:paymentLabel];
    
    payView = [[PayView alloc] initWithFrame:CGRectMake(0, showView.frame.origin.y+showView.frame.size.height, kScreenWidth, 190*AUTO_SIZE_SCALE_X)];
//    payView.money = [self.serviceInfoDic objectForKey:@"minPrice"];
//    payView.backgroundColor = RedUIColorC1;
    payView.money = @"0";
    float balanceFloat = [balanceStr floatValue]/100.0;
    payView.balanceStr = [NSString stringWithFormat:@"%0.2f",balanceFloat];;
    if (balanceFloat == 0) {
        payView.frame = CGRectMake(0, showView.frame.origin.y+showView.frame.size.height, kScreenWidth, 140*AUTO_SIZE_SCALE_X);
    }
    [payView setDefaultMode];
    [footView addSubview:payView];

    UIView * MeanView = [[UIView alloc] init];
    MeanView.backgroundColor = UIColorFromRGB(0xFDF1C9);
    UILabel * flashPayMeanLabel = [[UILabel  alloc] init];
    flashPayMeanLabel.text = @"闪付是什么: 闪付是一个先到店消费，后通过手机进行买单的工具，并且在支付时还有机会参加各项优惠，比刷卡快还便利、优惠。";
    flashPayMeanLabel.numberOfLines = 0;
    flashPayMeanLabel.textColor = OrangeUIColorC4;
    flashPayMeanLabel.lineBreakMode = NSLineBreakByWordWrapping;
    flashPayMeanLabel.font = [UIFont systemFontOfSize:13];
    CGSize maxSize = CGSizeMake(kScreenWidth-24, 2000);
    CGSize size = [flashPayMeanLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    flashPayMeanLabel.frame = CGRectMake(12, 8, kScreenWidth-24,size.height);
    [MeanView addSubview:flashPayMeanLabel];
    MeanView.frame = CGRectMake(0, payView.frame.origin.y+payView.frame.size.height, kScreenWidth,size.height+16);
    [footView addSubview:MeanView];
    
    UIView * zhushiView = [[UIView alloc] init];
    UILabel * zhushiLabel = [[UILabel  alloc] init];
    zhushiLabel.text = @"*注: 闪付买单仅限到店支付,请勿提前购买,如需发票请您在消费时向门店咨询。";
    zhushiLabel.numberOfLines = 0;
    zhushiLabel.textColor = UIColorFromRGB(0xc8c8c8);
    zhushiLabel.lineBreakMode = NSLineBreakByWordWrapping;
    zhushiLabel.font = [UIFont systemFontOfSize:13];
    CGSize zhushimaxSize = CGSizeMake(kScreenWidth-24, 2000);
    CGSize zhushisize = [zhushiLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:zhushimaxSize lineBreakMode:NSLineBreakByWordWrapping];
    zhushiLabel.frame = CGRectMake(12, 8, kScreenWidth-24,zhushisize.height);
    [zhushiView addSubview:zhushiLabel];
    zhushiView.frame = CGRectMake(0, MeanView.frame.origin.y+MeanView.frame.size.height, kScreenWidth,zhushisize.height+16);
    [footView addSubview:zhushiView];
    
    footView.frame = CGRectMake(0, 0, kScreenWidth, zhushiView.frame.origin.y+zhushiView.frame.size.height);
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, kScreenWidth, kScreenHeight-(50*AUTO_SIZE_SCALE_X+headView.frame.origin.y+headView.frame.size.height))];
//    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-(50*AUTO_SIZE_SCALE_X+kNavHeight+60*AUTO_SIZE_SCALE_X))];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 45*AUTO_SIZE_SCALE_X;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.bounces = NO;
//    [myTableView setTableHeaderView:headView];
    [myTableView setTableFooterView:footView];
    [self.view addSubview:myTableView];
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, self.view.frame.size.width, 50*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * btnLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    btnLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:btnLine];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(14*AUTO_SIZE_SCALE_X, 5*AUTO_SIZE_SCALE_X, kScreenWidth-28*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
    [payBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.titleLabel.textColor = [UIColor whiteColor];
    payBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [payBtn addTarget:self action:@selector(payBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:payBtn];
    
    [self.view addSubview:btnView];
}

-(void)ZeroPay
{
    double yuanallprice = [ConsumptionField.text doubleValue];
    int yuanpayment = 0;
    NSString * fenAllpriceStr =[NSString stringWithFormat:@"%0.0f",yuanallprice*100];
    NSString * fenPaymentStr = [NSString stringWithFormat:@"%d",yuanpayment*100];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString *deviceTokenStr = [userDefaults objectForKey:@"deviceToken"];
    NSDictionary * dic = @{
                           @"storeID":self.storeID,
                           @"userID":userID,
                           @"payment":fenPaymentStr,//paymentLabel.text
                           @"totalPrice":fenAllpriceStr,//ConsumptionField.text
                           @"activityCouponID":couponID,
                           @"platformDiscountID":platformDiscountID,
                           @"storeDiscountID":storeDiscountID,
                           @"isPaidByDeposit":[NSString stringWithFormat:@"%@",[payWayDic objectForKey:@"isPaidByDeposit"] ],
                           @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                           @"deviceToken":deviceTokenStr,
                           };
    NSLog(@"dic  %@",dic);
    
//        return;
    [[RequestManager shareRequestManager] genQuickOrder:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"确认支付 result %@",result);
//        NSLog(@"确认支付 result %@", [result objectForKey:@"msg"]);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
            NSString * pChannelCode = [result objectForKey:@"payChannelCode"];
            orderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
            //code 0000 如果只是余额支付 那么成功支付 直接跳转
            if ([pChannelCode isEqualToString:@""]) {
                WaitForCommentByQuickPassViewController * vc = [[WaitForCommentByQuickPassViewController alloc] init];
                vc.orderID = orderID;
                vc.isNotFromOrderList = @"1";
                [self.navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
            }
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }
        
    } failuer:^(NSError *error) {
        
    }];

}

-(void)payBtnPressed:(UIButton *)sender
{
    [ConsumptionField resignFirstResponder];
    
    if ([ConsumptionField.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入消费金额" viewController:self];
        return;
    }
    
    float consut = [ConsumptionField.text floatValue];
    if (consut == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"消费金额不能为0" viewController:self];
        return;
    }
    
    //所有支付方式都未选择
    if ([[payWayDic objectForKey:@"isPaidByDeposit"] isEqualToString:@""]&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择支付方式" viewController:self];
        //        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }
    NSLog(@"余额  %@   实际支付金额  %@",balanceStr,paymentLabel.text);
//    double a = [ConsumptionField.text doubleValue];
    double yuanpayment = [paymentLabel.text doubleValue];
//    NSString * myAllprice =[NSString stringWithFormat:@"%0.2f",a*100];
//    NSString * fenPayment = [NSString stringWithFormat:@"%0.2f",yuanpayment*100];
    //支付金额是0 直接掉接口 支付成功
    if (![paymentLabel.text isEqualToString:@""]&&inputMoney-storeactivityAmount-platactivityAmount-couponPrice<=0) {
        [self ZeroPay];
        return;
    }
    float balance = [balanceStr floatValue];
    
    NSLog(@"balance  %f   yuanpayment*100 %f",balance ,yuanpayment*100);
    //余额不足 且 未选择其余支付方式
    if (balance < (inputMoney-storeactivityAmount-platactivityAmount-couponPrice)*100 &&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"余额不足" viewController:self];
        //        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }

    
    NSLog(@"确认支付");
    NSString * msg = [NSString stringWithFormat:@"您正在向%@进行支付操作，请与门店确认",self.titles];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    }else{
        NSLog(@"确定");
        [self confirmBtnPressed];
    }
}

-(void)cancelBtnPressed:(UIButton *)sender
{
    
}

-(void)confirmBtnPressed
{
    NSLog(@"余额  %@   实际支付金额  %@",balanceStr,paymentLabel.text);
    double yuanallprice = [ConsumptionField.text doubleValue];
    double yuanpayment = inputMoney-storeactivityAmount-platactivityAmount-couponPrice;
    NSString * fenAllpriceStr =[NSString stringWithFormat:@"%0.2f",yuanallprice*100];
    NSString * fenPaymentStr = [NSString stringWithFormat:@"%0.2f",yuanpayment*100];
    
//        float balance = [balanceStr floatValue];
    
//    NSLog(@"balance  %f   p %f",balance ,yuanpayment*100);
//    //余额不足 且 未选择其余支付方式
//    if (balance < yuanpayment*100 &&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
//        [[RequestManager shareRequestManager] tipAlert:@"余额不足" viewController:self];
////        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
//        return;
//    }


    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString *deviceTokenStr = [userDefaults objectForKey:@"deviceToken"];
    NSDictionary * dic = @{
                           @"storeID":self.storeID,
                           @"userID":userID,
                           @"payment":fenPaymentStr,//paymentLabel.text
                           @"totalPrice":fenAllpriceStr,//ConsumptionField.text
                           @"activityCouponID":couponID,
                           @"platformDiscountID":platformDiscountID,
                           @"storeDiscountID":storeDiscountID,
                           @"isPaidByDeposit":[NSString stringWithFormat:@"%@",[payWayDic objectForKey:@"isPaidByDeposit"] ],
                           @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                           @"deviceToken":deviceTokenStr,
                           };
    NSLog(@"dic  %@",dic);
//    return;
    [[RequestManager shareRequestManager] genQuickOrder:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"确认支付 result %@",result);
                NSLog(@"确认支付 result %@", [result objectForKey:@"msg"]);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
            NSString * pChannelCode = [result objectForKey:@"payChannelCode"];
            orderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
            //code 0000 如果只是余额支付 那么成功支付 直接跳转
            if ([pChannelCode isEqualToString:@""]) {
                WaitForCommentByQuickPassViewController * vc = [[WaitForCommentByQuickPassViewController alloc] init];
                vc.orderID = orderID;
                vc.isNotFromOrderList = @"1";
                [self.navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
            }
            if([pChannelCode isEqualToString:@"tenpay_app"]){
                [self sendPay:[result objectForKey:@"tenpayData"]];
                NSLog(@"pChannelCode-----tenpay_app-->%@",[result objectForKey:@"tenpayData"]);
                
            }else if([pChannelCode isEqualToString:@"alipay_sdk"]){
                [self alipay:[result objectForKey:@"alipayData"]];
                
            }
            
            
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }

    } failuer:^(NSError *error) {
        
    }];
    
}

#pragma mark 微信

-(void)WeChatPageDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"returnCode"];
    NSString *requestflag =[info objectForKey:@"requestflag"];
    payBtn.enabled = YES;
    
    if([ret isEqualToString:@"0"]){
        [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
        //        [self performSelector:@selector(delayShow) withObject:self afterDelay:3.0];
        WaitForCommentByQuickPassViewController * vc = [[WaitForCommentByQuickPassViewController alloc] init];
        vc.orderID = orderID;
        vc.isNotFromOrderList = @"1";
        [self.navigationController pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
        
    }else if([ret isEqualToString:@"-2"]){
        [[RequestManager shareRequestManager] tipAlert:requestflag viewController:self];
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
    payBtn.userInteractionEnabled = YES;
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
            WaitForCommentByQuickPassViewController * vc = [[WaitForCommentByQuickPassViewController alloc] init];
            vc.orderID = orderID;
            vc.isNotFromOrderList = @"1";
            [self.navigationController pushViewController:vc animated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
            
        }else if([resultStatus isEqualToString:@"8000"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单 正在处理中" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"4000"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单支付失败 " viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"6001"]){
            [[RequestManager shareRequestManager] tipAlert:@"您中途取消了 订单支付" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"6002"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单 网络连接出错" viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }
    }];
    
    
    //    }
    
    
}



#pragma mark 选择优惠券
-(void)couponBgViewTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"选择优惠券");
    [ConsumptionField resignFirstResponder];

    CouponSelectViewController * vc = [[CouponSelectViewController alloc] init];
    vc.serviceID = @"";
    vc.workerId = @"";
    vc.storeID = self.storeID;
    vc.payment = [NSString stringWithFormat:@"%f",inputMoney*100 ];//inputMoney元为单位 需要变成分
    [payView setDefaultMode];
    [vc returnCouponInfo:^(NSDictionary *dic) {
        if (dic) {
            if (dic) {
                couponNextView.hidden = YES;
//                couponLabel.text = @"优惠券";
                couponInfoLabel.hidden = NO;
                couponPrice = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]] floatValue]/100.0;
                couponInfoLabel.text = [NSString stringWithFormat:@"¥%0.2f",couponPrice];
                couponID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
                CGSize couponInfoLabelSize = [couponInfoLabel intrinsicContentSize];
                couponInfoLabel.frame = CGRectMake(kScreenWidth-10*AUTO_SIZE_SCALE_X-couponInfoLabelSize.width, 0, couponInfoLabelSize.width, 45*AUTO_SIZE_SCALE_X-1);
                couponInfoLabel.textAlignment = NSTextAlignmentRight;
                if (inputMoney-storeactivityAmount-platactivityAmount-couponPrice<=0) {
                    paymentLabel.text = [NSString stringWithFormat:@"%0.2f",0.00];

                }else{
                    paymentLabel.text = [NSString stringWithFormat:@"%0.2f",inputMoney-storeactivityAmount-platactivityAmount-couponPrice];
                }
                payView.money = paymentLabel.text;
                paymentLabel.text = [NSString stringWithFormat:@"¥%@",paymentLabel.text];
                if (couponPrice == 0) {
//                    couponInfoLabel.text = @"请选择优惠券";
                    couponNextView.hidden = NO;
                    couponInfoLabel.hidden = YES;

                }
//                float fenmoney = [paymentLabel.text floatValue];
//                payView.money = [NSString stringWithFormat:@"%f",fenmoney];
                [payView setDefaultMode];
                
            }else if( [couponID isEqualToString:@""]){
                couponInfoLabel.hidden = NO;
//                couponInfoLabel.text = @"没有可用的优惠券";
                couponPrice = 0;
                if (inputMoney-storeactivityAmount-platactivityAmount-couponPrice<=0) {
                    paymentLabel.text = [NSString stringWithFormat:@"%0.2f",0.00];
                    
                }else{
                    paymentLabel.text = [NSString stringWithFormat:@"%0.2f",inputMoney-storeactivityAmount-platactivityAmount-couponPrice];
                }
                payView.money = paymentLabel.text;
                paymentLabel.text = [NSString stringWithFormat:@"¥%@",paymentLabel.text];
//                float fenmoney = [paymentLabel.text floatValue];
//                payView.money = [NSString stringWithFormat:@"%f",fenmoney];
                [payView setDefaultMode];

            }
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        //返回门店优惠数量
        if (platActListArray.count>0) {
            return 10*AUTO_SIZE_SCALE_X;
        }
        else{
            return 0*AUTO_SIZE_SCALE_X;

        }
    }else if(section == 1){
        //返回平台优惠数量
        if (storeActListArray.count>0) {
            return 10*AUTO_SIZE_SCALE_X;
        }
        else{
            return  0*AUTO_SIZE_SCALE_X;

        }
        
    }

    return 0*AUTO_SIZE_SCALE_X;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        //返回门店优惠数量
        if (platActListArray.count>0) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10*AUTO_SIZE_SCALE_X)];
            view.backgroundColor = C2UIColorGray;;
            return view;
        }
        else{
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            
            return view;
        }
    }else if(section == 1){
        //返回平台优惠数量
        if (storeActListArray.count>0) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10*AUTO_SIZE_SCALE_X)];
            view.backgroundColor = C2UIColorGray;;
            return view;
        }
        else{
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            
            return view;
        }
        
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];

    return view;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (storeActListArray.count>0&&platActListArray.count>0) {
//        return 2;
//    }else if (storeActListArray.count==0&&platActListArray.count==0){
//        return 0;
//    }else{
//        return 1;
//    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        //返回平台优惠数量
        return platActListArray.count;

        
    }else if(section == 1){
        
        //返回门店优惠数量
        return storeActListArray.count;
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        UIView * discountView = [[UIView alloc] init];
        discountView.backgroundColor = [UIColor whiteColor];
        
        UIView * perView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45*AUTO_SIZE_SCALE_X)];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 250*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
        label.text = [NSString stringWithFormat:@"%@ %@",[[platActListArray objectAtIndex:indexPath.row] objectForKey:@"activityName"],[[platActListArray objectAtIndex:indexPath.row] objectForKey:@"activityDesc"]];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        [perView addSubview:label];
        
 
        UIImageView * choosebedImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-13*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X, (perView.frame.size.height-20*AUTO_SIZE_SCALE_X)/2, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
        if (platRow == indexPath.row) {
            choosebedImv.image = [UIImage imageNamed:@"icon_choice_p"];
            
        }else
        {
            choosebedImv.image = [UIImage imageNamed:@"icon_choice_n"];
        }
        [perView addSubview:choosebedImv];
       
        
        [cell addSubview:perView];
        
        return cell;

    }else if (indexPath.section == 1)
    {
        UIView * discountView = [[UIView alloc] init];
        discountView.backgroundColor = [UIColor whiteColor];
        
        UIView * perView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45*AUTO_SIZE_SCALE_X)];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 250*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
        label.text = [NSString stringWithFormat:@"%@ %@",[[storeActListArray objectAtIndex:indexPath.row] objectForKey:@"activityName"],[[storeActListArray objectAtIndex:indexPath.row] objectForKey:@"activityDesc"]];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        [perView addSubview:label];
        
     
        UIImageView * choosebedImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-13*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X, (perView.frame.size.height-20*AUTO_SIZE_SCALE_X)/2, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
        if (storeRow == indexPath.row) {
            choosebedImv.image = [UIImage imageNamed:@"icon_choice_p"];
        }else{
            choosebedImv.image = [UIImage imageNamed:@"icon_choice_n"];
        }
        [perView addSubview:choosebedImv];

        [cell addSubview:perView];
        
        return cell;

    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (storeRow == indexPath.row) {
            storeRow = 10000;
            storeactivityAmount = 0;
            storeDiscountID = @"";
        }
        else{
            if (inputMoney >= [[NSString stringWithFormat:@"%@",[[storeActListArray objectAtIndex:indexPath.row] objectForKey:@"minNeedPrice"] ] floatValue]/100.0) {
                
                storeRow = (int)indexPath.row;

                NSArray *  favourList = [NSArray arrayWithArray: [[storeActListArray objectAtIndex:indexPath.row] objectForKey:@"favourList"] ];
                
                for (NSDictionary * dic in favourList) {
                    NSString * thresholdAmountStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thresholdAmount"] ];
                    CGFloat thresholdAmount = [thresholdAmountStr floatValue];
                    thresholdAmount = thresholdAmount/100.0;
                    if (inputMoney >= thresholdAmount) {
                        storeactivityAmount = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityAmount"] ] floatValue];
                        storeactivityAmount = storeactivityAmount/100.0;
                    }
                }
                storeDiscountID = [NSString stringWithFormat:@"%@",[[storeActListArray objectAtIndex:indexPath.row] objectForKey:@"acticityID"]];
            }
            else{
                storeRow = 10000;
                storeactivityAmount = 0;
                storeDiscountID = @"";
                [[RequestManager shareRequestManager] tipAlert:@"消费金额不符合当前优惠活动" viewController:self];
            }
            
        }
    }
    else if(indexPath.section == 0){
        if (platRow == indexPath.row) {
            platRow = 10000;
            platactivityAmount = 0;
            platformDiscountID = @"";

        }
        else{
            
            if (inputMoney >= [[NSString stringWithFormat:@"%@",[[platActListArray objectAtIndex:indexPath.row] objectForKey:@"minNeedPrice"] ] floatValue]/100.0) {
                
                platRow = (int)indexPath.row;
                
                NSArray *  favourList = [NSArray arrayWithArray: [[platActListArray objectAtIndex:indexPath.row] objectForKey:@"favourList"] ];
                
                for (NSDictionary * dic in favourList) {
                    NSString * thresholdAmountStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thresholdAmount"] ];
                    CGFloat thresholdAmount = [thresholdAmountStr floatValue];
                    thresholdAmount = thresholdAmount/100.0;
                    if (inputMoney >= thresholdAmount) {
                        platactivityAmount = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityAmount"] ] floatValue];
                        platactivityAmount = platactivityAmount/100.0;
                    }
                }
                platformDiscountID = [NSString stringWithFormat:@"%@",[[platActListArray objectAtIndex:indexPath.row] objectForKey:@"acticityID"]];

            }
            else{
                platRow = 10000;
                platactivityAmount = 0;
                [[RequestManager shareRequestManager] tipAlert:@"消费金额不符合当前优惠活动" viewController:self];
                platformDiscountID = @"";

            }
            
        }
    }
    
    if (inputMoney-storeactivityAmount-platactivityAmount-couponPrice<=0) {
        paymentLabel.text = [NSString stringWithFormat:@"%0.2f",0.00];
        
    }else{
        paymentLabel.text = [NSString stringWithFormat:@"%0.2f",inputMoney-storeactivityAmount-platactivityAmount-couponPrice];
    }
    payView.money = paymentLabel.text;
    paymentLabel.text = [NSString stringWithFormat:@"¥%@",paymentLabel.text];
    NSLog(@"  payView.money -.-.- %@",payView.money);
//    float fenmoney = [paymentLabel.text floatValue]*100;
//    payView.money = [NSString stringWithFormat:@"%f",fenmoney];

    [payView setDefaultMode];
    [myTableView reloadData];
    
}
#pragma mark UITextField

- (void)textFieldDidChange:(UITextField *)textField
{
    platactivityAmount = 0;
    platRow = 10000;
    storeactivityAmount = 0;
    storeRow = 10000;
    [myTableView reloadData];
    
    double allPrice = [textField.text doubleValue];
    inputMoney = allPrice;
    couponPrice = 0;
    couponID = @"";
    
//    if (inputMoney-storeactivityAmount-platactivityAmount-couponPrice<=0) {
//        paymentLabel.text = [NSString stringWithFormat:@"%0.2f",0.00];
//        
//    }else{
//        paymentLabel.text = [NSString stringWithFormat:@"%0.2f",inputMoney-storeactivityAmount-platactivityAmount-couponPrice];
//    }
    couponInfoLabel.text = [NSString stringWithFormat:@"¥%0.2f",couponPrice];

//    [payView setDefaultMode];

    
    if ([ConsumptionField.text isEqualToString:@""]) {
        isHaveDian=NO;
        isHaveZero=NO;
        
    }
    
    double price = [ConsumptionField.text doubleValue];
    NSLog(@"price  %f",price);
    if (price >= 10000) {
        NSLog(@"price >= 10000");
        if (isHaveDian) {
            //            NSRange range = NSMakeRange(1, 7);
            //            ConsumptionField.text = [ConsumptionField.text substringWithRange:range];
            ConsumptionField.text = currentStr;
            inputMoney = [currentStr doubleValue];
            return;
        }
        else{
            //            ConsumptionField.text = [ConsumptionField.text substringToIndex:4];
            ConsumptionField.text = currentStr;
            inputMoney = [currentStr doubleValue];
            return;
        }
    }
    else{
        currentStr = textField.text;
        inputMoney = [currentStr doubleValue];

    }

}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为小数点
            if([ConsumptionField.text length]==0){
                if(single == '.'){
                    NSLog(@"亲，第一个数字不能为小数点");
                    [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }

                if (single=='0')
                {
                    if(!isHaveZero)
                    {
                        isHaveZero=YES;
//                        NSLog(@"文字  %@",ConsumptionField.text);

                        return YES;
                    }
                }
                
            }
            if([ConsumptionField.text length]==1){
                
                if (single >='0' && single<='9')
                {
                    if(!isHaveZero)
                    {
//                        NSLog(@"文字  %@",ConsumptionField.text);

                        return YES;
                    }else
                    {
                        NSLog(@"亲，0后面不能再有0－9");
                        
                        [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            

            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    isHaveZero = NO;
//                    NSLog(@"文字  %@",ConsumptionField.text);

                    return YES;
                }else
                {
                    NSLog(@"亲，您已经输入过小数点了");

                    [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[ConsumptionField.text rangeOfString:@"."];
                    int tt = range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        NSLog(@"亲，您最多输入两位小数");

                        return NO;
                    }
                }
                else
                {
//                    NSLog(@"文字  %@",ConsumptionField.text);

                    return YES;
                }
                
            }
        }else{//输入的数据格式不正确
            NSLog(@"亲，您输入的格式不正确");
            [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
//        NSLog(@"文字  %@",ConsumptionField.text);

        return YES;
    }
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@""]) {
        paymentLabel.text = @"0.00";
        payView.money = paymentLabel.text;
        paymentLabel.text = [NSString stringWithFormat:@"¥%@",paymentLabel.text];

    }
    double allPrice = [textField.text doubleValue];
    inputMoney = allPrice;

    if (inputMoney-storeactivityAmount-platactivityAmount-couponPrice<=0) {
        paymentLabel.text = [NSString stringWithFormat:@"%0.2f",0.00];
        
    }else{
        paymentLabel.text = [NSString stringWithFormat:@"%0.2f",inputMoney-storeactivityAmount-platactivityAmount-couponPrice];
    }
    float yuanmoney = [paymentLabel.text floatValue];
    payView.money = [NSString stringWithFormat:@"%0.2f",yuanmoney];
    paymentLabel.text = [NSString stringWithFormat:@"¥%@",paymentLabel.text];
    if (inputMoney-storeactivityAmount-platactivityAmount-couponPrice == 0) {
        [payView setDefaultMode];
    }
    [payView setDefaultMode];

}

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
