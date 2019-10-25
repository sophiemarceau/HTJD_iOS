//
//  SeckillPayViewController.m
//  Massage
//
//  Created by htjd_IOS on 16/2/29.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "SeckillPayViewController.h"
#import "PayView.h"
#import "UIImageView+WebCache.h"

#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"

#import "FlashDealPayViewController.h"
#import "FlashDealServiceViewController.h"
@interface SeckillPayViewController ()<UIAlertViewDelegate>
{
    
    UITableView * tableView;
    UIView * headerView;
    UIView * serviceView;

    UIImageView * serviceIcon;
    UILabel * serviceNameLabel;
    UILabel * servicePriceLabel;

    PayView * payView;
    
    NSDictionary * payWayDic;
    NSString * balanceStr;
    float paymentPrice;
    
    NSString * newOrderID;
    UIButton * payBtn;
    
    float activitydescHeight;
}
@end

@implementation SeckillPayViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changePayWay" object:nil];
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
            [self initView];
        }
    } failuer:^(NSError *error) {
        
    }];
    
}

-(void)initView
{
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = C2UIColorGray;
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_X1)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setTableHeaderView:headerView];
    [self.view addSubview:tableView];
    
#pragma mark 项目介绍
    serviceView = [[UIView alloc] init];
    serviceView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:serviceView];
    
    serviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 58, 58)];
    [serviceIcon setImageWithURL:[NSURL URLWithString:self.servIcom] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    [serviceView addSubview:serviceIcon];
    
    serviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( serviceIcon.frame.origin.x+serviceIcon.frame.size.width+10, 20, kScreenWidth-serviceIcon.frame.origin.x-serviceIcon.frame.size.width-10-10, 14)];
    serviceNameLabel.textColor = UIColorFromFindRGB(0x1C1D1C);
    serviceNameLabel.font = [UIFont systemFontOfSize:14];
    serviceNameLabel.text = [NSString stringWithFormat:@"项目名称: %@",self.servName];
    [serviceView addSubview:serviceNameLabel];
    
    servicePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake( serviceIcon.frame.origin.x+serviceIcon.frame.size.width+10, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+12, kScreenWidth-serviceIcon.frame.origin.x-serviceIcon.frame.size.width-10-10, 14)];
    servicePriceLabel.textColor = UIColorFromFindRGB(0x1C1D1C);
    servicePriceLabel.font = [UIFont systemFontOfSize:14];
    paymentPrice = [self.minPrice floatValue]/100.0;
    servicePriceLabel.text = [NSString stringWithFormat:@"价格: ¥%0.2f",paymentPrice];
    [serviceView addSubview:servicePriceLabel];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, serviceIcon.frame.origin.y+serviceIcon.frame.size.height+10, kScreenWidth-20, 1)];
    line1.image = [UIImage imageNamed:@"img_dottedline1"];
    [serviceView addSubview:line1];
    
    if (self.activitydescArray.count == 0) {
        serviceView.frame = CGRectMake(0, 10, kScreenWidth, line1.frame.origin.y+line1.frame.size.height);
        line1.hidden = YES;
    }
    else{
        [self countActivitydescHeight];
        serviceView.frame = CGRectMake(0, 10, kScreenWidth, line1.frame.origin.y+line1.frame.size.height+15*AUTO_SIZE_SCALE_X1 + activitydescHeight);
    }
    
    UIImageView * scaleImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, serviceView.frame.origin.y+serviceView.frame.size.height, kScreenWidth, 10)];
    scaleImv.image = [UIImage imageNamed:@"img_scale"];
    [headerView addSubview:scaleImv];
    
#pragma mark 支付方式
    payView = [[PayView alloc] initWithFrame:CGRectMake(0, serviceView.frame.origin.y+serviceView.frame.size.height+10, kScreenWidth, 203*AUTO_SIZE_SCALE_X1)];
    payView.backgroundColor = [UIColor clearColor];
    paymentPrice = [self.minPrice floatValue]/100.0;
    payView.money = [NSString stringWithFormat:@"%0.2f",paymentPrice];
//    payView.money = [NSString stringWithFormat:@"%0.2f",192.3];
        float balanceFloat = [balanceStr floatValue]/100.0;
//    float balanceFloat = 0.1;
    payView.balanceStr = [NSString stringWithFormat:@"%0.2f",balanceFloat];;
    [payView setDefaultMode];
    [headerView addSubview:payView];
    NSLog(@"payView.money %@",payView.money);
    //从新调整headerView高度
    headerView.frame = CGRectMake(0, 0, kScreenWidth, payView.frame.origin.y+payView.frame.size.height);
    [tableView setTableHeaderView:headerView];
    
#pragma mark  支付按钮
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X1, kScreenWidth, 50*AUTO_SIZE_SCALE_X1)];
    btnView.backgroundColor = UIColorFromRGB(0xFBFBFB);
    [self.view addSubview:btnView];
    
    UIImageView * zhixianLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    zhixianLine.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:zhixianLine];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(10, 5*AUTO_SIZE_SCALE_X1, kScreenWidth-20, 50*AUTO_SIZE_SCALE_X1-10*AUTO_SIZE_SCALE_X1);
    [payBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:payBtn];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePayWay:) name:@"changePayWay" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wechatMessaage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeChatPageDataNtf:) name:@"wechatMessaage" object:nil];
    self.titles = @"支付";
    
    [self downLoadBalanceData];
    
    
    
}

#pragma mark 计算说明高度
-(void)countActivitydescHeight
{
    activitydescHeight = 0;
    if (self.activitydescArray.count>0) {
        //            activitydescHeight = 15*AUTO_SIZE_SCALE_X1;
        
        for (int j = 0; j<self.activitydescArray.count; j++) {
            NSString * str = [[self.activitydescArray objectAtIndex:j] objectForKey:@"content"];
            CGSize contentSize = CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X1, 2000);
            CGSize contentLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
            [self addActivityLabel:serviceIcon.frame.origin.y+serviceIcon.frame.size.height+10+activitydescHeight+ 5*AUTO_SIZE_SCALE_X1 Height:contentLabelSize.height  Data:[self.activitydescArray objectAtIndex:j]];
            activitydescHeight = activitydescHeight+contentLabelSize.height+5*AUTO_SIZE_SCALE_X1;
        }
    }
    else{
        activitydescHeight = 0.0;
    }
}

#pragma mark 添加说明
-(void)addActivityLabel:(CGFloat )y Height:(CGFloat)height Data:(NSDictionary *)dic
{
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X1, y, 10*AUTO_SIZE_SCALE_X1, 15*AUTO_SIZE_SCALE_X1)];
    label1.text = @" · ";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = UIColorFromRGB(0x777777);
    [serviceView addSubview:label1];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X1, y, kScreenWidth-40*AUTO_SIZE_SCALE_X1, height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    label.textColor = UIColorFromRGB(0x777777);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    [serviceView addSubview:label];
 }

#pragma mark 改变支付方式
-(void)changePayWay:(NSNotification *)ntf
{
    payWayDic = [NSDictionary dictionaryWithDictionary:ntf.object];
    NSLog(@"支付方式 dic-->%@",payWayDic);
}

#pragma mark 余额支付
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        payBtn.userInteractionEnabled = YES;
    }
    else if(buttonIndex == 1){
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSString * deviceToken = [userDefaults objectForKey:@"deviceToken"];
        
        NSLog(@"payWayDic %@",payWayDic);
        
        NSDictionary * dic = @{
                               @"userID":userID,//用户id
                               @"activityID":self.specialID, //秒杀活动id
                               @"priceID":self.priceID,//启用价格等级时必录
                               @"isPaidByDeposit":[payWayDic objectForKey:@"isPaidByDeposit"],
                               @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                               @"client":@"ios",
                               //                           @"redirectUrl":@"", //暂时无用
                               @"deviceToken":deviceToken,
                               };
        NSLog(@"dic --> %@",dic);
        [[RequestManager shareRequestManager] genSpikeOrder:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"秒杀支付result %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                payBtn.userInteractionEnabled = YES;
                NSString * pChannelCode = [result objectForKey:@"payChannelCode"];
                NSString * isPaidByDeposit = [result objectForKey:@"isPaidByDeposit"];
                newOrderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
                
                //code 0000 如果只是余额支付 那么成功支付 直接跳转
                if ([isPaidByDeposit isEqualToString:@"1"]&&[pChannelCode isEqualToString:@""]){
                    [self performSelector:@selector(gotoOrderDetail) withObject:nil afterDelay:1.0];
                    return ;
                }
                
//                if([pChannelCode isEqualToString:@"tenpay_app"]){
//                    [self sendPay:[result objectForKey:@"tenpayData"]];
//                    NSLog(@"pChannelCode-----tenpay_app-->%@",[result objectForKey:@"tenpayData"]);
//                    
//                }else if([pChannelCode isEqualToString:@"alipay_sdk"]){
//                    [self alipay:[result objectForKey:@"alipayData"]];
//                    
//                }
                
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                payBtn.userInteractionEnabled = YES;
            }
            
        } failuer:^(NSError *error) {
            payBtn.userInteractionEnabled = YES;
            
        }];

    }
}

-(void)payBtnPressed:(UIButton *)sender
{
    NSLog(@"确认支付");
    sender.userInteractionEnabled = NO;
    
    
    
    //余额不足 且 未选择其余支付方式
    float balance = [balanceStr floatValue]/100.0;
    
    //余额支付 提示框
    if (balance >= paymentPrice&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]&&[[payWayDic objectForKey:@"isPaidByDeposit"] isEqualToString:@"1"]) {
        NSString * str = [NSString stringWithFormat:@"余额支付 ¥%@",payView.money];
        UIAlertView * aletView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [aletView show];
        return;
    }
    
    if (balance == 0&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择支付方式" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }
    if (balance < paymentPrice&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"余额不足" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }

    if ([[payWayDic objectForKey:@"isPaidByDeposit"] isEqualToString:@""]&&[[payWayDic objectForKey:@"payChannelCode"] isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择支付方式" viewController:self];
        sender.userInteractionEnabled = YES;
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * deviceToken = [userDefaults objectForKey:@"deviceToken"];

    NSLog(@"payWayDic %@",payWayDic);
    
    NSDictionary * dic = @{
                           @"userID":userID,//用户id
                           @"activityID":self.specialID, //秒杀活动id
                           @"priceID":self.priceID,//启用价格等级时必录
                           @"isPaidByDeposit":[payWayDic objectForKey:@"isPaidByDeposit"],
                           @"payChannelCode":[payWayDic objectForKey:@"payChannelCode"],
                           @"client":@"ios",
//                           @"redirectUrl":@"", //暂时无用
                           @"deviceToken":deviceToken,
                           };
    NSLog(@"dic --> %@",dic);
    [[RequestManager shareRequestManager] genSpikeOrder:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"秒杀支付result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            sender.userInteractionEnabled = YES;
            NSString * pChannelCode = [result objectForKey:@"payChannelCode"];
            NSString * isPaidByDeposit = [result objectForKey:@"isPaidByDeposit"];
            newOrderID = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderID"]];
            
            //code 0000 如果只是余额支付 那么成功支付 直接跳转
            if ([isPaidByDeposit isEqualToString:@"1"]&&[pChannelCode isEqualToString:@""]){
                [self performSelector:@selector(gotoOrderDetail) withObject:nil afterDelay:1.0];
                return ;
            }
            
            if([pChannelCode isEqualToString:@"tenpay_app"]){
                [self sendPay:[result objectForKey:@"tenpayData"]];
                NSLog(@"pChannelCode-----tenpay_app-->%@",[result objectForKey:@"tenpayData"]);
                
            }else if([pChannelCode isEqualToString:@"alipay_sdk"]){
                [self alipay:[result objectForKey:@"alipayData"]];
                
            }

        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            sender.userInteractionEnabled = YES;
        }
        
    } failuer:^(NSError *error) {
        sender.userInteractionEnabled = YES;

    }];
}

-(void)gotoOrderDetail
{
    FlashDealServiceViewController * vc = [[FlashDealServiceViewController alloc] init];
    vc.orderID = newOrderID;
    vc.isNotFromOrderList = @"1";
    [self.navigationController pushViewController:vc animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
    
}

-(void)gotoWaitForPayOrderDetail
{
    FlashDealPayViewController * vc = [[FlashDealPayViewController alloc] init];
    vc.orderID = newOrderID;
    vc.isNotFromOrderList = @"1";
    [self.navigationController pushViewController:vc animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderNtf" object:@{@"pay":@"changed"}];
    
}

#pragma mark 微信
-(void)WeChatPageDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"returnCode"];
    NSString *requestflag =[info objectForKey:@"requestflag"];
    
    if([ret isEqualToString:@"0"]){
        [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self];
        //        [self performSelector:@selector(delayShow) withObject:self afterDelay:3.0];
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
//        [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
        payBtn.userInteractionEnabled = YES;
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

//-(void)payBtncanuse
//{
//    Paybtn.userInteractionEnabled = YES;
//}
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
//            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoOrderDetail) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"8000"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单 正在处理中" viewController:self];
//            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"4000"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单支付失败 " viewController:self];
//            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"6001"]){
            [[RequestManager shareRequestManager] tipAlert:@"您中途取消了 订单支付" viewController:self];
//            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(gotoWaitForPayOrderDetail) withObject:nil afterDelay:1.0];
            
        }else if([resultStatus isEqualToString:@"6002"]){
            [[RequestManager shareRequestManager] tipAlert:@"您提交的订单 网络连接出错" viewController:self];
//            [self performSelector:@selector(payBtncanuse) withObject:nil afterDelay:1.0];
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
