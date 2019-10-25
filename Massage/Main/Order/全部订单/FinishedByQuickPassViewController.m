//
//  FinishedByQuickPassViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "FinishedByQuickPassViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页
//预约的控制器
#import "StoreAppointmentFromServiceViewController.h"
#import "StoreAppointmentFromWorkerViewController.h"
#import "DoorAppointmentFromServiceViewController.h"
#import "DoorAppointmentFromWorkerViewController.h"

#import "UIImageView+WebCache.h"

#import "UMSocial.h"
@interface FinishedByQuickPassViewController () <UMSocialUIDelegate>

@end

@implementation FinishedByQuickPassViewController
{
    NSDictionary *DataDic;
}

@synthesize orderID;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"已完成";
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
        }
    } failuer:^(NSError *error) {
        
    }];
}
- (void)initView {
    //订单状态部分
    self.orderStateLabel.text = @"订单状态：已完成";
    //订单状态部分//文字变色
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
    self.orderStateLabel.attributedText = str;
    [self.orderStateView addSubview:self.orderStateLabel];
    
    [self.orderStateView addSubview:self.orderNumImageView];
    
    self.orderNumLabel.text = [DataDic objectForKey:@"orderID"];
    [self.orderStateView addSubview:self.orderNumLabel];
    
    [self.orderStateView addSubview:self.orderDateImageView];
    
    self.orderDateLabel.text = [DataDic objectForKey:@"orderTime"];
    [self.orderStateView addSubview:self.orderDateLabel];
    
    [self.serviceImageView setImageWithURL:[NSURL URLWithString:[DataDic objectForKey:@"storeIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    [self.orderStateView addSubview:self.serviceImageView];
    
    self.serviceNameLabel.text = [NSString stringWithFormat:@"店铺名称：%@",[DataDic objectForKey:@"storeName"]];
    [self.orderStateView addSubview:self.serviceNameLabel];
    [self.payScrollView addSubview:self.orderStateView];
    //地址部分
    self.addressLabel.text = [DataDic objectForKey:@"storeAddress"];
    [self.addressView addSubview:self.addressLabel];
    [self.payScrollView addSubview:self.addressView];
    //订单详情部分
    self.phoneNumber.text = [DataDic objectForKey:@"clientMobile"];
    [self.orderDetailView addSubview:self.phoneNumber];
    
    NSString *discountStr = [NSString stringWithFormat:@"%@",[DataDic objectForKey:@"discountAmount"]];
    NSString *couString = [NSString stringWithFormat:@"%@",[DataDic objectForKey:@"couponpay"]];
    if ([discountStr isEqualToString:@"0"] && [couString isEqualToString:@"0"]) {
        self.saveLabel.text = @"";
        self.totalSaveLabel.text = @"";
        self.saveLabel.hidden = YES;
        self.totalSaveLabel.hidden = YES;
    }else if (![discountStr isEqualToString:@"0"] && [couString isEqualToString:@"0"]) {
        self.saveLabel.text = [NSString stringWithFormat:@"闪付-￥%.2f",[[DataDic objectForKey:@"discountAmount"]doubleValue]/100];
        
//        self.totalSaveLabel.text = [NSString stringWithFormat:@"总计为您节省：￥%.2f",[[DataDic objectForKey:@"discountAmount"]doubleValue]/100>[[DataDic objectForKey:@"totalPrice"]doubleValue]/100?[[DataDic objectForKey:@"totalPrice"]doubleValue]/100:[[DataDic objectForKey:@"discountAmount"]doubleValue]/100];
        
        self.totalSaveLabel.text = [NSString stringWithFormat:@"总计为您节省：￥%.2f",[[DataDic objectForKey:@"discountAmount"]doubleValue]/100];
        self.saveLabel.hidden = NO;
        self.totalSaveLabel.hidden = NO;
    }else if ([discountStr isEqualToString:@"0"] && ![couString isEqualToString:@"0"]) {
        self.saveLabel.text = [NSString stringWithFormat:@"优惠券-￥%.2f",[[DataDic objectForKey:@"couponpay"]doubleValue]/100];
        
//        self.totalSaveLabel.text = [NSString stringWithFormat:@"总计为您节省：￥%.2f",[[DataDic objectForKey:@"couponpay"]doubleValue]/100>[[DataDic objectForKey:@"totalPrice"]doubleValue]/100?[[DataDic objectForKey:@"totalPrice"]doubleValue]/100:[[DataDic objectForKey:@"couponpay"]doubleValue]/100];
        
        self.totalSaveLabel.text = [NSString stringWithFormat:@"总计为您节省：￥%.2f",[[DataDic objectForKey:@"couponpay"]doubleValue]/100];
        self.saveLabel.hidden = NO;
        self.totalSaveLabel.hidden = NO;
    }else {
        self.saveLabel.text = [NSString stringWithFormat:@"闪付-￥%.2f  优惠券-￥%.2f",[[DataDic objectForKey:@"discountAmount"]doubleValue]/100,[[DataDic objectForKey:@"couponpay"]doubleValue]/100];
        
//        self.totalSaveLabel.text = [NSString stringWithFormat:@"总计为您节省：￥%.2f",[[DataDic objectForKey:@"discountAmount"] doubleValue]/100+[[DataDic objectForKey:@"couponpay"] doubleValue]/100>[[DataDic objectForKey:@"totalPrice"]doubleValue]/100?[[DataDic objectForKey:@"totalPrice"]doubleValue]/100:[[DataDic objectForKey:@"discountAmount"] doubleValue]/100+[[DataDic objectForKey:@"couponpay"] doubleValue]/100];
        
        self.totalSaveLabel.text = [NSString stringWithFormat:@"总计为您节省：￥%.2f",[[DataDic objectForKey:@"discountAmount"] doubleValue]/100+[[DataDic objectForKey:@"couponpay"] doubleValue]/100];
        self.saveLabel.hidden = NO;
        self.totalSaveLabel.hidden = NO;
    }
    [self.orderDetailView addSubview:self.saveLabel];
    [self.orderDetailView addSubview:self.totalSaveLabel];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"消费金额：￥%.2f",[[DataDic objectForKey:@"totalPrice"]doubleValue]/100];
    [self.orderDetailView addSubview:self.totalPriceLabel];
    
    self.actualPriceLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",[[DataDic objectForKey:@"payment"]doubleValue]/100];
    //对小字体进行处理
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc]initWithString:self.actualPriceLabel.text];
    [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,6)];
    self.actualPriceLabel.attributedText = astr;
    [self.orderDetailView addSubview:self.actualPriceLabel];
    [self.payScrollView addSubview:self.orderDetailView];
    [self.payScrollView addSubview:self.quickPassView];
    //分享领券部分
    [self.sharedView addSubview:self.sharedButton];
#warning 本版本暂无此功能 暂时隐藏控件
    self.sharedView.hidden = YES;
    
    [self.payScrollView addSubview:self.sharedView];
    [self.view addSubview:self.payScrollView];
    
#pragma mark - 添加约束(订单状态部分)
    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payScrollView.mas_top).offset(10);
        make.height.mas_equalTo(160);
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
    [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {//订单状态
        make.left.equalTo(self.orderStateView.mas_left).offset(10);
        make.top.equalTo(self.orderStateView.mas_top).offset(13);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.image = [UIImage imageNamed:@"img_dottedline1"];
    [self.orderStateView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderStateLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    [self.orderNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {//订单号图标
        make.centerY.equalTo(self.orderNumLabel.mas_centerY);
        make.left.equalTo(self.orderStateView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.orderNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {//订单号
        //计算文字宽度
        CGSize size = [self.orderNumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderNumLabel.font}];
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.left.equalTo(self.orderNumImageView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.orderDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {//订单日期
        //计算文字宽度
        CGSize size = [self.orderDateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderDateLabel.font}];
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.right.equalTo(self.orderStateView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.orderDateImageView mas_makeConstraints:^(MASConstraintMaker *make) {//订单日期图标
        make.centerY.equalTo(self.orderDateLabel.mas_centerY);
        make.right.equalTo(self.orderDateLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = C2UIColorGray;
    [self.orderStateView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderStateView.mas_left).offset(10);
        make.right.equalTo(self.orderStateView.mas_right);
        make.top.equalTo(self.orderDateLabel.mas_bottom).offset(11);
        make.height.mas_equalTo(1);
    }];
    
    [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {//项目图标
        make.left.equalTo(self.orderStateView.mas_left).offset(10);
        make.top.equalTo(line2.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    [self.serviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//项目名称
        make.left.equalTo(self.serviceImageView.mas_right).offset(10);
        make.right.equalTo(self.orderStateView.mas_right).offset(-10);
        make.centerY.equalTo(self.serviceImageView.mas_centerY);
//        make.height.mas_equalTo(14);
    }];
#pragma mark - 添加约束(地址部分)
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.height.mas_equalTo(68);
    }];
    UILabel *diZhi = [CommentMethod initLabelWithText:@"服务地址" textAlignment:NSTextAlignmentLeft font:14];
    diZhi.textColor = C6UIColorGray;
    [self.addressView addSubview:diZhi];
    [diZhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressView.mas_left).offset(10);
        make.top.equalTo(self.addressView.mas_top).offset(19);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {//服务地址
        make.left.equalTo(diZhi.mas_right).offset(10);
        make.centerY.equalTo(self.addressView.mas_centerY);
        make.right.equalTo(self.addressView.mas_right).offset(-28);
        make.height.mas_equalTo(34);
    }];
    UIImageView *jianTou = [[UIImageView alloc]init];
    [jianTou setImage:[UIImage imageNamed:@"uc_menu_link"]];
    [self.addressView addSubview:jianTou];
    [jianTou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView.mas_right).offset(-10);
        make.centerY.equalTo(self.addressLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
#pragma mark - 添加约束(订单详情部分)
    if ([discountStr isEqualToString:@"0"] && [couString isEqualToString:@"0"]) {
        [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.addressView.mas_bottom).offset(10);
//            make.height.mas_equalTo(112);
//            make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
            make.bottom.equalTo(self.actualPriceLabel.mas_bottom).offset(10);
        }];
    }else {
        [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.addressView.mas_bottom).offset(10);
//            make.height.mas_equalTo(160);
//            make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
            make.bottom.equalTo(self.actualPriceLabel.mas_bottom).offset(10);
        }];
    }
    UILabel *dianHua = [CommentMethod initLabelWithText:@"消费手机" textAlignment:NSTextAlignmentLeft font:14];
    dianHua.textColor = C6UIColorGray;
    [self.orderDetailView addSubview:dianHua];
    [dianHua mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderDetailView.mas_left).offset(10);
        make.top.equalTo(self.orderDetailView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {//联系电话
        make.left.equalTo(dianHua.mas_right).offset(10);
        make.top.equalTo(self.orderDetailView.mas_top).offset(15);
        make.right.equalTo(self.orderDetailView.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    UIImageView *line4 = [[UIImageView alloc]init];
    line4.backgroundColor = C2UIColorGray;
    [self.orderDetailView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderDetailView.mas_left).offset(10);
        make.right.equalTo(self.orderDetailView.mas_right);
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderDetailView.mas_left).offset(10);
        make.right.equalTo(self.orderDetailView.mas_right).offset(-10);
        make.top.equalTo(line4.mas_bottom).offset(15);
        make.height.mas_equalTo(14);
    }];
    [self.totalSaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderDetailView.mas_left).offset(10);
        make.right.equalTo(self.orderDetailView.mas_right).offset(-10);
        make.top.equalTo(self.saveLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];
    if ([discountStr isEqualToString:@"0"] && [couString isEqualToString:@"0"]) {
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderDetailView.mas_left).offset(10);
            make.right.equalTo(self.orderDetailView.mas_right).offset(-10);
            make.top.equalTo(line4.mas_bottom).offset(15);
            make.height.mas_equalTo(14);
        }];
    }else {
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderDetailView.mas_left).offset(10);
            make.right.equalTo(self.orderDetailView.mas_right).offset(-10);
            make.top.equalTo(self.totalSaveLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(14);
        }];
    }
    [self.actualPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderDetailView.mas_left).offset(10);
        make.right.equalTo(self.orderDetailView.mas_right).offset(-10);
        make.top.equalTo(self.totalPriceLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
#pragma mark - 添加约束(闪付介绍部分)
    UILabel *label1 = [CommentMethod initLabelWithText:@"1.为什么没有消费码？" textAlignment:NSTextAlignmentLeft font:12];
    label1.textColor = C7UIColorGray;
    label1.numberOfLines = 0;
    [self.quickPassView addSubview:label1];
    UILabel *label2 = [CommentMethod initLabelWithText:@"闪付不同于团购，是不会产生消费码的。您可以将你支付的订单号展示给门店。" textAlignment:NSTextAlignmentLeft font:12];
    label2.textColor = C7UIColorGray;
    label2.numberOfLines = 0;
    [self.quickPassView addSubview:label2];
    UILabel *label3 = [CommentMethod initLabelWithText:@"2.我买错了想退款怎么处理？" textAlignment:NSTextAlignmentLeft font:12];
    label3.textColor = C7UIColorGray;
    label3.numberOfLines = 0;
    [self.quickPassView addSubview:label3];
    UILabel *label4 = [CommentMethod initLabelWithText:@"闪付是到店消费，与门店确认买单金额后再进行支付，如果您买错了可以直接联系门店办理退款。" textAlignment:NSTextAlignmentLeft font:12];
    label4.textColor = C7UIColorGray;
    label4.numberOfLines = 0;
    [self.quickPassView addSubview:label4];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.quickPassView.mas_top).offset(10);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(label1.mas_bottom).offset(5);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(label2.mas_bottom).offset(10);
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(label3.mas_bottom).offset(5);
    }];
    [self.quickPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderDetailView.mas_bottom);
        make.bottom.equalTo(label4.mas_bottom).offset(10);
        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
    }];
#pragma mark - 添加约束(分享领券部分)
//    [self.sharedView mas_makeConstraints:^(MASConstraintMaker *make) {//分享领券背景
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.orderDetailView.mas_bottom).offset(10);
//        make.height.mas_equalTo(50);
//        make.bottom.equalTo(self.payScrollView.mas_bottom);
//    }];
//    [self.sharedButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.sharedView.mas_left).offset(15);
//        make.right.equalTo(self.sharedView.mas_right).offset(-15);
//        make.top.equalTo(self.sharedView.mas_top).offset(5);
//        make.bottom.equalTo(self.sharedView.mas_bottom).offset(-5);
//    }];
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
    //为地址添加点击事件
    self.addressView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addressLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLabelTaped:)];
    [self.addressView addGestureRecognizer:addressLabelTap];
}
#pragma mark - 按钮点击事件
- (void)serviceTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到店铺详情页");
    StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
    vc.storeID = [DataDic objectForKey:@"storeID"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addressLabelTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到导航页");
    RoutePlanViewController *vc = [[RoutePlanViewController alloc]init];
    vc.latitude = [[DataDic objectForKey:@"latitude"]doubleValue];
    vc.longitude = [[DataDic objectForKey:@"longitude"]doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sharedButtonClick:(UIButton *)sender {
    NSLog(@"分享");
    //添加"复制链接"的自定义按钮
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CustomPlatform"];
    snsPlatform.displayName = @"复制链接";
    snsPlatform.bigImageName = @"icon_share_Link";
    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        NSLog(@"点击自定义平台的响应");
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"测试华佗驾到分享复制链接专用文字";
        if (pasteboard == nil) {
            [[RequestManager shareRequestManager]tipAlert:@"复制失败" viewController:self];
            
        }else {
            [[RequestManager shareRequestManager]tipAlert:@"已复制到剪切板" viewController:self];
        }
        
    };
    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
    //设置你要在分享面板中出现的平台
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform"]];
    //微博 & 微信 & 朋友圈 & 复制链接
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:@"测试分享专用,http://baidu.com"
                                     shareImage:[UIImage imageNamed:@"icon_180.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform",nil]
                                       delegate:self];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
    
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
    
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
    
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";
}

#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
//        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 495);
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
- (UIView *)orderDetailView {
    if (_orderDetailView == nil) {
        self.orderDetailView = [UIView new];
        self.orderDetailView.backgroundColor = [UIColor whiteColor];
    }
    return _orderDetailView;
}
- (UIView *)addressView {
    if (_addressView == nil) {
        self.addressView = [UIView new];
        self.addressView.backgroundColor = [UIColor whiteColor];
    }
    return _addressView;
}
- (UIView *)sharedView {
    if (_sharedView == nil) {
        self.sharedView = [UIView new];
        self.sharedView.backgroundColor = [UIColor whiteColor];
    }
    return _sharedView;
}
- (UILabel *)orderStateLabel {
    if (_orderStateLabel == nil) {
        self.orderStateLabel = [CommentMethod initLabelWithText:@"订单状态：已完成" textAlignment:NSTextAlignmentLeft font:14];
        //文字变色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
        self.orderStateLabel.attributedText = str;
    }
    return _orderStateLabel;
}
- (UIImageView *)orderNumImageView {
    if (_orderNumImageView == nil) {
        self.orderNumImageView = [UIImageView new];
        [self.orderNumImageView setImage:[UIImage imageNamed:@"icon_order_ordernum"]];
    }
    return _orderNumImageView;
}
- (UILabel *)orderNumLabel {
    if (_orderNumLabel == nil) {
        self.orderNumLabel = [CommentMethod initLabelWithText:@"241241515214" textAlignment:NSTextAlignmentLeft font:12];
        self.orderNumLabel.textColor = C7UIColorGray;
    }
    return _orderNumLabel;
}
- (UIImageView *)orderDateImageView {
    if (_orderDateImageView == nil) {
        self.orderDateImageView = [UIImageView new];
        [self.orderDateImageView setImage:[UIImage imageNamed:@"icon_order_orderdate"]];
    }
    return _orderDateImageView;
}
- (UILabel *)orderDateLabel {
    if (_orderDateLabel == nil) {
        self.orderDateLabel = [CommentMethod initLabelWithText:@"2014-12-22 22:12:14" textAlignment:NSTextAlignmentLeft font:12];
        self.orderDateLabel.textColor = C7UIColorGray;
    }
    return _orderDateLabel;
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
- (nxUILabel *)addressLabel {
    if (_addressLabel == nil) {
        self.addressLabel = [nxUILabel new];
        self.addressLabel.text = @"朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888";
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.numberOfLines = 0;
        [self.addressLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _addressLabel;
}
- (UILabel *)phoneNumber {
    if (_phoneNumber == nil) {
        self.phoneNumber = [CommentMethod initLabelWithText:@"13888888888" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _phoneNumber;
}
- (UILabel *)saveLabel {
    if (_saveLabel == nil) {
        self.saveLabel = [CommentMethod initLabelWithText:@"闪付-￥40  优惠券-￥55" textAlignment:NSTextAlignmentRight font:14];
    }
    return _saveLabel;
}
- (UILabel *)totalSaveLabel {
    if (_totalSaveLabel == nil) {
        self.totalSaveLabel = [CommentMethod initLabelWithText:@"总计为您节省：￥95" textAlignment:NSTextAlignmentRight font:14];
    }
    return _totalSaveLabel;
}
- (UILabel *)totalPriceLabel {
    if (_totalPriceLabel == nil) {
        self.totalPriceLabel = [CommentMethod initLabelWithText:@"消费金额：￥895.5" textAlignment:NSTextAlignmentRight font:14];
    }
    return _totalPriceLabel;
}
- (UILabel *)actualPriceLabel {
    if (_actualPriceLabel == nil) {
        self.actualPriceLabel = [CommentMethod initLabelWithText:@"实际支付：￥800.5" textAlignment:NSTextAlignmentRight font:16];
        self.actualPriceLabel.textColor = RedUIColorC1;
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.actualPriceLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,6)];
        self.actualPriceLabel.attributedText = str;
    }
    return _actualPriceLabel;
}
- (UIButton *)sharedButton {
    if (_sharedButton == nil) {
        self.sharedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sharedButton setTitle:@"分享领券" forState:UIControlStateNormal];
        [self.sharedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sharedButton.backgroundColor = OrangeUIColorC4;
        self.sharedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.sharedButton.layer.cornerRadius = 5.0;
        [self.sharedButton addTarget:self action:@selector(sharedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedButton;
}
- (UIView *)quickPassView {
    if (_quickPassView == nil) {
        self.quickPassView = [UIView new];
        self.quickPassView.backgroundColor = C2UIColorGray;
    }
    return _quickPassView;
}

@end
