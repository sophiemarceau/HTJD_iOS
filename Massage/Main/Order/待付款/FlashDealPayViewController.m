//
//  FlashDealPayViewController.m
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDealPayViewController.h"
#import "nxUILabel.h"
#import "FlashDealState.h"
#import "FlashDealDetail.h"
#import "MyPersonalInfoViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页

#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
@interface FlashDealPayViewController ()

@end

@implementation FlashDealPayViewController
{
    NSDictionary *DataDic;
    NSDictionary *MyDocDic;
    NSDictionary *payWayDic;
    NSString * balanceStr;
}
@synthesize orderID,isNotFromOrderList;

-(void)backAction
{
    if([isNotFromOrderList isEqualToString:@"1"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
        UIButton *tempbutton =[[UIButton alloc]init];
        tempbutton.tag =3;
        [mainVC selectorAction:tempbutton];
        mainVC.orderCountImg.hidden = YES;
        mainVC.countLabel.hidden = YES;
        
        NSInteger tag = 1;
        NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)tag];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:tagStr forKey:@"serviceBackActionKey"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"serviceBackAction" object:nil userInfo:dict];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([isNotFromOrderList isEqualToString:@"1"]) {
        // 禁用 返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([isNotFromOrderList isEqualToString:@"1"]) {
        // 开启
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    NSLog(@"取消广播");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changePayWay" object:nil];
}
#pragma mark 接收广播
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePayWay:) name:@"changePayWay" object:nil];
}
#pragma mark 改变支付方式
-(void)changePayWay:(NSNotification *)ntf {
    payWayDic = [NSDictionary dictionaryWithDictionary:ntf.object];
    NSLog(@"支付方式 dic-->%@",payWayDic);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"待付款";
    [self getMyUserInfo];
}
- (void)getMyUserInfo {
    NSUserDefaults * userDefualts = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefualts objectForKey:@"userID"];
    
    NSDictionary * dicD = @{
                            @"userID":userID
                            };
    [[RequestManager shareRequestManager] GetMyUserInfo:dicD viewController:self successData:^(NSDictionary *result) {
        NSLog(@"result------------>%@",result);
        if(IsSucessCode(result)){
            MyDocDic = [NSDictionary dictionaryWithDictionary:result];
            
//            NSString * payment = @"";
//            int payInt = [[NSString stringWithFormat:@"%@",[result objectForKey:@"deposit"]] intValue];
//            if (payInt%100 == 0) {
//                payInt = payInt/100;
//                payment = [NSString stringWithFormat:@"%d",payInt];
//            }
//            else{
//                float payFloat = [[NSString stringWithFormat:@"%@",[result objectForKey:@"deposit"]] floatValue];
//                payFloat = payFloat/100.0;
//                if (payInt%10 == 0){
//                    payment = [NSString stringWithFormat:@"%0.1f",payFloat];
//                }
//                else{
//                    payment = [NSString stringWithFormat:@"%0.2f",payFloat];
//                }
//            }
//            NSString *payMoney = [NSString stringWithFormat:@"￥%@",payment];
            
            
            CGFloat deposit = [[result objectForKey:@"deposit"]floatValue];
            deposit = deposit/100;
            balanceStr = [NSString stringWithFormat:@"%.2f",deposit];
            self.payModeView.balanceStr = balanceStr;
            
            [self getOrderDetailData];
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        
    }];
}
- (void)getOrderDetailData {
    NSUserDefaults * userDefualts = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefualts objectForKey:@"userID"];
    
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"orderID":self.orderID,
                           };
    NSLog(@"MyOrderViewController----orderID------------ > %@",dic);
    [[RequestManager shareRequestManager] spikeOrderDetail:dic viewController:self successData:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSLog(@"result ---------------- > %@",result);
            DataDic = [NSDictionary  dictionaryWithDictionary:result];
            
            [self initView];
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        
    }];
}
- (void)initView {
    //取消订单部分
    [self.cancleSignView addSubview:self.cancleImageView];
    [self.cancleSignView addSubview:self.cancleLabel];
    //订单状态部分
    [self.payScrollView addSubview:self.orderStateView];
    //订单详情部分
    [self.payScrollView addSubview:self.orderDetailView];
    //支付方式部分
    self.payModeView.money = [NSString stringWithFormat:@"%.2f",[[DataDic objectForKey:@"payment"]doubleValue]/100];
    
    self.payModeView.balanceStr = balanceStr;
    [self.payModeView setDefaultMode];
    [self.payScrollView addSubview:self.payModeView];
    //确认支付部分
    [self.confirmView addSubview:self.cancleButton];
    [self.confirmView addSubview:self.confirmButton];
    [self.payScrollView addSubview:self.confirmView];
    
    [self.view addSubview:self.cancleSignView];
    [self.view addSubview:self.payScrollView];
#pragma mark - 添加约束(取消订单部分)
    //约束
    [self.cancleLabel mas_makeConstraints:^(MASConstraintMaker *make) {//取消订单部分
        //计算文字宽度
        CGSize size = [self.cancleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        make.centerY.mas_equalTo(self.cancleSignView.mas_centerY);
        make.centerX.equalTo(self.cancleSignView.mas_centerX).offset(10);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.cancleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cancleSignView.mas_centerY);
        make.right.equalTo(self.cancleLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
#pragma mark - 添加约束(订单状态部分)
    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {//订单背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payScrollView.mas_top).offset(10);
        make.bottom.equalTo(self.orderStateView.serviceImageView.mas_bottom).offset(12);
//        make.height.mas_equalTo(160);
    }];
    UIImageView *bottomImageView = [[UIImageView alloc]init];
    bottomImageView.image = [UIImage imageNamed:@"img_scale"];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.payScrollView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderStateView.mas_bottom);
        make.height.mas_equalTo(12.5);
    }];
#pragma mark - 添加约束(订单详情部分)
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {//订单详情背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(15);
        //        make.height.mas_equalTo(360);
    }];
#pragma mark - 添加约束(支付方式部分)
    [self.payModeView mas_makeConstraints:^(MASConstraintMaker *make) {//支付方式背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderDetailView.mas_bottom);
        make.height.mas_equalTo(203*AUTO_SIZE_SCALE_X);
    }];
#pragma mark - 添加约束(确认支付部分)
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {//确认支付背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payModeView.mas_bottom);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.payScrollView.mas_bottom);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.confirmView.mas_centerY);
        make.right.equalTo(self.confirmView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(98, 40));
    }];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.confirmView.mas_centerY);
        make.right.equalTo(self.confirmButton.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(98, 40));
    }];
    //项目名称处添加点击事件
    UIView *xiangMu = [UIView new];
    xiangMu.backgroundColor = [UIColor clearColor];
    xiangMu.userInteractionEnabled = YES;
    UITapGestureRecognizer *serviceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceTaped:)];
    [xiangMu addGestureRecognizer:serviceTap];
    [self.orderStateView addSubview:xiangMu];
    [xiangMu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderStateView.mas_left);
        make.right.equalTo(self.orderStateView.mas_right);
        make.centerY.equalTo(self.orderStateView.serviceImageView.mas_centerY);
        make.bottom.equalTo(self.orderStateView.mas_bottom);
    }];
    //为地址添加点击事件
    UIView *addressTap = [UIView new];
    addressTap.backgroundColor = [UIColor clearColor];
    addressTap.userInteractionEnabled = YES;
    UITapGestureRecognizer *addressLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLabelTaped:)];
    [addressTap addGestureRecognizer:addressLabelTap];
    [self.orderDetailView addSubview:addressTap];
    [addressTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderDetailView.storeNameLabel.mas_bottom);
        make.left.equalTo(self.orderDetailView.mas_left);
        make.right.equalTo(self.orderDetailView.mas_right);
        make.bottom.equalTo(self.orderDetailView.addressLabel.mas_bottom).offset(10);
    }];
}
#pragma mark - 按钮点击事件
- (void)serviceTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到项目详情页");
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
    vc.serviceID = [DataDic objectForKey:@"serviceID"];
    vc.serviceType = @"0";
    vc.isStore = YES;
//    if ([self.orderDetailView.dateWorker.text isEqualToString:@"推荐技师"]) {
//        vc.haveWorker = NO;
//    }else {
//        vc.haveWorker = YES;
//        NSDictionary *workerInfoDic = @{@"ID":[DataDic objectForKey:@"workerID"],
//                                        @"name":[DataDic objectForKey:@"workerName"],
//                                        @"icon":[DataDic objectForKey:@"workerIcon"],
//                                        @"score":[DataDic objectForKey:@"skillScore"],
//                                        @"orderCount":[DataDic objectForKey:@"orderCount"],
//                                        @"commentCount":[DataDic objectForKey:@"commentCount"],};
//        vc.workerInfoDic = workerInfoDic;
//    }
    vc.haveWorker = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addressLabelTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到导航页");
    RoutePlanViewController *vc = [[RoutePlanViewController alloc]init];
    vc.latitude = [[DataDic objectForKey:@"latitude"]doubleValue];
    vc.longitude = [[DataDic objectForKey:@"longitude"]doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)cancleOrder:(UIButton *)sender {
    NSLog(@"取消订单");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否确定取消该订单"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}
- (void)confirmPay:(UIButton *)sender {
    self.confirmButton.enabled = NO;
    self.cancleButton.enabled = NO;
    //所有支付方式都未选择
    if ([[payWayDic objectForKey:@"isPaidByDeposit"] isEqualToString:@""]&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择支付方式" viewController:self];
        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }
    //余额不足 且 未选择其余支付方式
    float money = [self.payModeView.money floatValue];
    float balance = [balanceStr floatValue];
    if (balance < money&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"余额不足" viewController:self];
        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        return;
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"orderID":[DataDic objectForKey:@"orderID"],
                           @"orderType":@"0",
                           @"payType":@"1",
                           @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],//支付渠道编号,
                           @"isAccount":[payWayDic objectForKey:@"isPaidByDeposit"],//余额支付
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] getOrderPay:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"确认支付 result %@",result);
        self.confirmButton.enabled = YES;
        self.cancleButton.enabled = YES;
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
            NSString * pChannelCode = [result objectForKey:@"payChannelCode"];
            pChannelCode = (pChannelCode != nil) ? pChannelCode : @"";
            NSLog(@"pChannelCode------->%@",pChannelCode);
            if ([pChannelCode isEqualToString:@""]) {
                [[RequestManager shareRequestManager] tipAlert:@"\"余额\"支付成功 请在\"订单\"中查看状态" viewController:self];
                //发送待付款订单通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
                [self performSelector:@selector(delayShow) withObject:self afterDelay:2.0];
            }else {
                if([pChannelCode isEqualToString:@"tenpay_app"]){
                    [self sendPay:[result objectForKey:@"tenpayData"]];
                    NSLog(@"pChannelCode-----tenpay_app-->%@",[result objectForKey:@"tenpayData"]);
                }else if([pChannelCode isEqualToString:@"alipay_sdk"]){
                    [self alipay:[result objectForKey:@"alipayData"]];
                }
            }
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        }
    } failuer:^(NSError *error) {
        self.confirmButton.enabled = YES;
        self.cancleButton.enabled = YES;
    }];
}
- (void)WeChatPageDataNtf:(NSNotification *)ntf {
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"returnCode"];
    NSString *requestflag =[info objectForKey:@"requestflag"];
    self.confirmButton.enabled = YES;
    self.cancleButton.enabled = YES;
    
    if([ret isEqualToString:@"0"]){
        [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
        //发送待付款订单通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
        [self performSelector:@selector(delayShow) withObject:self afterDelay:3.0];
        
        
    }else if([ret isEqualToString:@"-2"]){
        [[RequestManager shareRequestManager] tipAlert:requestflag viewController:self];
    }
}

- (void)delayShow {
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.confirmButton.enabled = YES;
    self.cancleButton.enabled = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
    UIButton *tempbutton =[[UIButton alloc]init];
    tempbutton.tag =3;
    [mainVC selectorAction:tempbutton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wechatMessaage" object:nil];
}
#pragma mark 微信
- (void)onReq:(BaseReq *)req {
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (void)onResp:(BaseResp *)resp {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"wechat----------------------支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
                //发送待付款订单通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
                [self performSelector:@selector(delayShow) withObject:self afterDelay:3.0];
                self.confirmButton.enabled = YES;
                self.cancleButton.enabled = YES;
                break;
            case WXErrCodeUserCancel:
                strMsg = @"您已取消支付";
                NSLog(@"wechat----------------------支付取消－PaySuccess，retcode = %d", resp.errCode);
                [[RequestManager shareRequestManager] tipAlert:@"您中途取消了 订单支付" viewController:self];
                self.confirmButton.enabled = YES;
                self.cancleButton.enabled = YES;
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"wechat----------------------错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                self.confirmButton.enabled = YES;
                self.cancleButton.enabled = YES;
                break;
        }
    }
}
- (void)sendPay:(NSDictionary *)dict {
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
}

- (void)payBtncanuse {
    self.confirmButton.enabled = YES;
    self.cancleButton.enabled = YES;
}
#pragma mark 支付宝
- (void)alipay:(NSString *)alipayDataString {
    [[AlipaySDK defaultService] payOrder:alipayDataString fromScheme:APPScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
            //发送待付款订单通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
            [self performSelector:@selector(delayShow) withObject:nil afterDelay:1.0];
            
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
}
#pragma mark - UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex == 0) {
        NSLog(@"取消");
        return;
    }
    if (buttonIndex == 1) {
        NSLog(@"确定");
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"orderID":self.orderID
                               };
        [[RequestManager shareRequestManager] cancelSpikeOrder:dic viewController:self successData:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //发送待付款订单通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            }
        } failuer:^(NSError *error) {
        }];
    }
}
#pragma mark - 懒加载
- (UIView *)cancleSignView {
    if (_cancleSignView == nil) {
        self.cancleSignView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 35)];
        self.cancleSignView.backgroundColor = UIColorFromRGB(0xfdeebd);
    }
    return _cancleSignView;
}
- (UIImageView *)cancleImageView {
    if (_cancleImageView == nil) {
        self.cancleImageView = [UIImageView new];
        self.cancleImageView.image = [UIImage imageNamed:@"icon_order_cancelorder"];
    }
    return _cancleImageView;
}
- (UILabel *)cancleLabel {
    if (_cancleLabel == nil) {
        self.cancleLabel = [CommentMethod initLabelWithText:@"10分钟内未完成支付，将取消订单" textAlignment:NSTextAlignmentCenter font:14];
        self.cancleLabel.textColor = OrangeUIColorC4;
    }
    return _cancleLabel;
}
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+35, kScreenWidth, kScreenHeight-kNavHeight-35)];
        //        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 792);
        self.payScrollView.backgroundColor = C2UIColorGray;
        self.payScrollView.showsVerticalScrollIndicator = NO;
        self.payScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _payScrollView;
}
- (FlashDealState *)orderStateView {
    if (_orderStateView == nil) {
        self.orderStateView = [FlashDealState new];
        self.orderStateView.data = DataDic;
    }
    return _orderStateView;
}
- (FlashDealDetail *)orderDetailView {
    if (_orderDetailView == nil) {
        self.orderDetailView = [FlashDealDetail new];
        self.orderDetailView.data = DataDic;
    }
    return _orderDetailView;
}
- (PayView *)payModeView {
    if (_payModeView == nil) {
        self.payModeView = [PayView new];
        self.payModeView.backgroundColor = [UIColor clearColor];
    }
    return _payModeView;
}
- (UIView *)confirmView {
    if (_confirmView == nil) {
        self.confirmView = [UIView new];
        self.confirmView.backgroundColor = [UIColor whiteColor];
    }
    return _confirmView;
}
- (UIButton *)cancleButton {
    if (_cancleButton == nil) {
        self.cancleButton = [UIButton new];
        [self.cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.cancleButton setTitleColor:C6UIColorGray forState:UIControlStateNormal];
        self.cancleButton.backgroundColor = [UIColor whiteColor];
        self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.cancleButton.layer.cornerRadius = 5.0;
        self.cancleButton.layer.borderColor = C7UIColorGray.CGColor;
        self.cancleButton.layer.borderWidth = 1.0;
        [self.cancleButton addTarget:self action:@selector(cancleOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        self.confirmButton = [UIButton new];
        [self.confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.backgroundColor = OrangeUIColorC4;
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.confirmButton.layer.cornerRadius = 5.0;
        [self.confirmButton addTarget:self action:@selector(confirmPay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
