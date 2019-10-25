//
//  PayViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "PayViewController.h"
#import "ServiceDetailViewController.h"//项目详情

#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"

#import "UIImageView+WebCache.h"
@interface PayViewController ()

@end

@implementation PayViewController
{
    NSDictionary *DataDic;
    NSDictionary *MyDocDic;
    NSDictionary *payWayDic;
    NSString * balanceStr;
}

@synthesize orderID;
#pragma mark 取消广播
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

    NSLog(@"取消广播");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changePayWay" object:nil];
}
#pragma mark 接收广播
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

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
            
            CGFloat deposit = [[result objectForKey:@"deposit"]floatValue];
            deposit = deposit/100;
            balanceStr = [NSString stringWithFormat:@"%.2f",deposit];
            
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
    [[RequestManager shareRequestManager] getOrderDetail:dic viewController:self successData:^(NSDictionary *result) {
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
    [self.serviceImageView setImageWithURL:[NSURL URLWithString:[DataDic objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    [self.orderStateView addSubview:self.serviceImageView];
    self.serviceNameLabel.text = [NSString stringWithFormat:@"项目名称：%@",[DataDic objectForKey:@"serviceName"]];
    [self.orderStateView addSubview:self.serviceNameLabel];
    self.servicePriceLabel.text = [NSString stringWithFormat:@"价格：￥%.2f",[[DataDic objectForKey:@"payment"] doubleValue]/100];
    [self.orderStateView addSubview:self.servicePriceLabel];
    //支付方式部分
    self.payModeView.money = [NSString stringWithFormat:@"%.2f",[[DataDic objectForKey:@"payment"]doubleValue]/100];
    
    self.payModeView.balanceStr = balanceStr;
    [self.payModeView setDefaultMode];
    //确认支付部分
    [self.confirmView addSubview:self.confirmButton];
    
    [self.view addSubview:self.cancleSignView];
    [self.view addSubview:self.orderStateView];
    [self.view addSubview:self.payModeView];
    [self.view addSubview:self.confirmView];
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
        make.top.equalTo(self.cancleSignView.mas_bottom).offset(10);
        make.height.mas_equalTo(86);
    }];
    UIImageView *bottomImageView = [[UIImageView alloc]init];
    bottomImageView.image = [UIImage imageNamed:@"img_scale"];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderStateView.mas_bottom);
        make.height.mas_equalTo(12.5);
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
    }];
#pragma mark - 添加约束(确认支付部分)
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {//确认支付背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.confirmView.mas_centerY);
        make.left.equalTo(self.confirmView.mas_left).offset(15);
        make.right.equalTo(self.confirmView.mas_right).offset(-15);
        make.height.mas_equalTo(40);
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
-(void)WeChatPageDataNtf:(NSNotification *)ntf{
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

-(void)delayShow{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.confirmButton.enabled = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
    UIButton *tempbutton =[[UIButton alloc]init];
    tempbutton.tag =3;
    [mainVC selectorAction:tempbutton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wechatMessaage" object:nil];
}
#pragma mark 微信
-(void)onReq:(BaseReq *)req{
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

-(void)onResp:(BaseResp *)resp{
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

-(void)payBtncanuse {
    self.confirmButton.enabled = YES;
}
#pragma mark 支付宝
-(void)alipay:(NSString *)alipayDataString {
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
