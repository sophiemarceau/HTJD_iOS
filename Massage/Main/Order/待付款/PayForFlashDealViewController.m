//
//  PayForFlashDealViewController.m
//  Massage
//
//  Created by 牛先 on 16/3/1.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "PayForFlashDealViewController.h"
#import "ServiceDetailViewController.h"//项目详情

#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"

#import "UIImageView+WebCache.h"

@interface PayForFlashDealViewController ()

@end

@implementation PayForFlashDealViewController
{
    NSDictionary *DataDic;
    NSDictionary *MyDocDic;
    NSDictionary *payWayDic;
    NSString * balanceStr;
}
@synthesize orderID;
#pragma mark 取消广播
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    self.titles = @"支付";
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
            
            CGFloat deposit = [[result objectForKey:@"deposit"]floatValue];
            deposit = deposit/100;
            balanceStr = [NSString stringWithFormat:@"%.2f",deposit];
            self.payModeView.balanceStr = balanceStr;
            
            [self getOrderDetaiData];
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        
    }];
}
- (void)getOrderDetaiData {
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
    //订单状态部分
    [self.serviceImageView setImageWithURL:[NSURL URLWithString:[DataDic objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    [self.orderStateView addSubview:self.serviceImageView];
    self.serviceNameLabel.text = [NSString stringWithFormat:@"项目名称：%@",[DataDic objectForKey:@"serviceName"]];
    [self.orderStateView addSubview:self.serviceNameLabel];
    self.servicePriceLabel.text = [NSString stringWithFormat:@"价格：￥%.2f",[[DataDic objectForKey:@"payment"] doubleValue]/100];
    [self.orderStateView addSubview:self.servicePriceLabel];
    [self.payScrollView addSubview:self.orderStateView];
    //支付方式部分
    self.payModeView.money = [NSString stringWithFormat:@"%.2f",[[DataDic objectForKey:@"payment"]doubleValue]/100];
    
    self.payModeView.balanceStr = balanceStr;
    [self.payModeView setDefaultMode];
    [self.payScrollView addSubview:self.payModeView];
    //确认支付部分
    [self.confirmView addSubview:self.confirmButton];
    
    [self.view addSubview:self.confirmView];
    [self.view addSubview:self.payScrollView];
#pragma mark - 添加约束(订单状态部分)
    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {//订单背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payScrollView.mas_top).offset(10);
        make.bottom.equalTo(self.serviceImageView.mas_bottom).offset(12);
//        make.height.mas_equalTo(86);
    }];
    [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderStateView.mas_left).offset(11);
        make.top.equalTo(self.orderStateView.mas_top).offset(11);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    [self.serviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceImageView.mas_right).offset(10);
        make.top.equalTo(self.orderStateView.mas_top).offset(22);
        make.right.equalTo(self.orderStateView.mas_right).offset(10);
        make.height.mas_equalTo(14);
    }];
    [self.servicePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceImageView.mas_right).offset(10);
        make.top.equalTo(self.serviceNameLabel.mas_bottom).offset(15);
        make.right.equalTo(self.orderStateView.mas_right).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    UIImageView *bottomImageView = [[UIImageView alloc]init];
    bottomImageView.image = [UIImage imageNamed:@"img_scale"];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.payScrollView addSubview:bottomImageView];
    
    NSMutableArray *reminderArray = [[NSMutableArray alloc]initWithCapacity:0];
//    [reminderArray addObjectsFromArray:@[@{@"content":@"说明一爱的方式发大水发撒打发"},@{@"content":@"说明二阿斯顿发空间大发啦"},@{@"content":@"说明三发狂了手机发"}]];
    [reminderArray addObjectsFromArray:[DataDic objectForKey:@"remindList"]];
    if (reminderArray.count>0) {
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.payScrollView addSubview:contentView];
        UIImageView *line4 = [[UIImageView alloc]init];
        line4.image = [UIImage imageNamed:@"img_dottedline1"];
        [contentView addSubview:line4];
        [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.mas_equalTo(1);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top).offset(6);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.mas_equalTo(1);
        }];
//        CGFloat height = 10;
        for (NSDictionary * dic in reminderArray) {
            UILabel *dian = [[UILabel alloc]init];
            dian.text = @"·";
            dian.textColor = C6UIColorGray;
            dian.font = [UIFont systemFontOfSize:12];
            [contentView addSubview:dian];
            
            UILabel * contentLabel = [[UILabel alloc]init];
            contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remindContext"]];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textColor = C6UIColorGray;
            contentLabel.numberOfLines = 0;
            [contentView addSubview:contentLabel];
            
            [dian mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom).offset(4);
                make.left.equalTo(self.view.mas_left).offset(10);
                make.height.equalTo(contentLabel.mas_height);
                make.width.mas_equalTo(10);
            }];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom).offset(4);
                make.left.equalTo(dian.mas_right);
                make.right.equalTo(self.view.mas_right).offset(-10);
            }];
//            height = height + contentLabel.frame.size.height+20;
            label = contentLabel;
        }
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderStateView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
//            make.bottom.equalTo(line4.mas_bottom).offset(height+5);
            make.bottom.equalTo(label.mas_bottom).offset(10);
        }];
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(contentView.mas_bottom);
            make.height.mas_equalTo(12.5);
        }];
    }else {
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.orderStateView.mas_bottom);
            make.height.mas_equalTo(12.5);
        }];
    }
    
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
        make.centerY.equalTo(self.serviceImageView.mas_centerY);
        make.bottom.equalTo(self.orderStateView.mas_bottom);
    }];
#pragma mark - 添加约束(支付方式部分)
    [self.payModeView mas_makeConstraints:^(MASConstraintMaker *make) {//支付方式背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(-7);
        make.height.mas_equalTo(203*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
    }];
//    UIView *placeHoldView = [UIView new];
//    placeHoldView.backgroundColor = RedUIColorC1;
//    [self.payScrollView addSubview:placeHoldView];
//    [placeHoldView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.payModeView.mas_bottom);
//        make.height.mas_equalTo(300);
//        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
//    }];
#pragma mark - 添加约束(确认支付部分)
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {//确认支付背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.confirmView.mas_centerY);
        make.left.equalTo(self.confirmView.mas_left).offset(10);
        make.right.equalTo(self.confirmView.mas_right).offset(-10);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_X);
    }];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xB2B2B3);
    [self.confirmView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - 按钮点击事件
- (void)serviceTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到项目详情页");
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
    vc.serviceID = [DataDic objectForKey:@"serviceID"];
    if ([[DataDic objectForKey:@"orderClass"]isEqualToString:@"1"]) {
        vc.serviceType = @"0";
    }else {
        vc.serviceType = @"1";
    }
    if ([[DataDic objectForKey:@"orderClass"]isEqualToString:@"3"]) {
        vc.isStore = NO;
    }else {
        vc.isStore = YES;
    }
    if ([[DataDic objectForKey:@"workerName"]isEqualToString:@""]) {
        vc.haveWorker = NO;
    }else {
        vc.haveWorker = YES;
        NSDictionary *workerInfoDic = @{@"ID":[DataDic objectForKey:@"workerID"],
                                        @"name":[DataDic objectForKey:@"workerName"],
                                        @"icon":[DataDic objectForKey:@"workerIcon"],
                                        @"score":[DataDic objectForKey:@"skillScore"],
                                        @"orderCount":[DataDic objectForKey:@"orderCount"],
                                        @"commentCount":[DataDic objectForKey:@"commentCount"],};
        vc.workerInfoDic = workerInfoDic;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)confirmPay:(UIButton *)sender {
    self.confirmButton.enabled = NO;
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
    }];
}
- (void)WeChatPageDataNtf:(NSNotification *)ntf {
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"returnCode"];
    NSString *requestflag =[info objectForKey:@"requestflag"];
    self.confirmButton.enabled = YES;
    
    if([ret isEqualToString:@"0"]){
        [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
        //发送待付款订单通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
        [self performSelector:@selector(delayShow) withObject:self afterDelay:3.0];
        
        
    }else if([ret isEqualToString:@"-2"]){
        [[RequestManager shareRequestManager] tipAlert:requestflag viewController:self];
    }
}

- (void)delayShow{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.confirmButton.enabled = YES;
    
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
                break;
            case WXErrCodeUserCancel:
                strMsg = @"您已取消支付";
                NSLog(@"wechat----------------------支付取消－PaySuccess，retcode = %d", resp.errCode);
                [[RequestManager shareRequestManager] tipAlert:@"您中途取消了 订单支付" viewController:self];
                self.confirmButton.enabled = YES;
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"wechat----------------------错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                self.confirmButton.enabled = YES;
                break;
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    
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

#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_X)];
        //        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 792);
        self.payScrollView.backgroundColor = C2UIColorGray;
        self.payScrollView.showsVerticalScrollIndicator = NO;
        self.payScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _payScrollView;
}
- (UIView *)orderStateView {
    if (_orderStateView == nil) {
        self.orderStateView = [UIView new];
        self.orderStateView.backgroundColor = [UIColor whiteColor];
    }
    return _orderStateView;
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
- (UIImageView *)serviceImageView {
    if (_serviceImageView == nil) {
        self.serviceImageView = [UIImageView new];
        self.serviceImageView.backgroundColor = [UIColor greenColor];
        self.serviceImageView.layer.cornerRadius = 5.0;
        self.serviceImageView.layer.masksToBounds = YES;
    }
    return _serviceImageView;
}
- (UILabel *)serviceNameLabel {
    if (_serviceNameLabel == nil) {
        self.serviceNameLabel = [CommentMethod initLabelWithText:@"项目名称：推拿按摩" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _serviceNameLabel;
}
- (UILabel *)servicePriceLabel {
    if (_servicePriceLabel == nil) {
        self.servicePriceLabel = [CommentMethod initLabelWithText:@"价格：￥415154" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _servicePriceLabel;
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
