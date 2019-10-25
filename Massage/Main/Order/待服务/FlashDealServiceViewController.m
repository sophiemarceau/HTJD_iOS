//
//  FlashDealServiceViewController.m
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDealServiceViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页

#import "AppDelegate.h"

@interface FlashDealServiceViewController ()

@end

@implementation FlashDealServiceViewController
{
    NSDictionary *DataDic;
    UIWebView *phoneCallWebView;
}

@synthesize orderID,isNotFromOrderList;

-(void)backAction
{
    if([isNotFromOrderList isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
        UIButton *tempbutton =[[UIButton alloc]init];
        tempbutton.tag =3;
        [mainVC selectorAction:tempbutton];
        
        NSInteger tag = 2;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"待服务";
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
        }
    } failuer:^(NSError *error) {
        
    }];
}

- (void)initView {
    //订单状态部分
    [self.payScrollView addSubview:self.orderStateView];
    self.storeTelPhoneLabel.text = [NSString stringWithFormat:@"联系门店：%@",[DataDic objectForKey:@"storeTel"]];
    [self.storeTelPhoneView addSubview:self.storeTelPhoneLabel];
    [self.storeTelPhoneView addSubview:self.storeTelPhoneImage];
    [self.payScrollView addSubview:self.storeTelPhoneView];
    //消费码部分
    self.payCodeLabel.text = [DataDic objectForKey:@"verifyCode"];
    [self.payCodeView addSubview:self.payCodeLabel];
    [self.payCodeView addSubview:self.payCodeStateLabel];
    [self.payScrollView addSubview:self.payCodeView];
    //订单详情部分
    [self.payScrollView addSubview:self.orderDetailView];
    //联系客服部分
    [self.callServiceView addSubview:self.callServiceButton];
    
    [self.view addSubview:self.callServiceView];
    [self.view addSubview:self.payScrollView];
#pragma mark - 添加约束(订单状态部分)
    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payScrollView.mas_top).offset(10);
        make.bottom.equalTo(self.orderStateView.serviceImageView.mas_bottom).offset(12);
//        make.height.mas_equalTo(160);
    }];
    UIImageView *xuXian1 = [[UIImageView alloc]init];
    xuXian1.image = [UIImage imageNamed:@"img_dottedline1"];
    [self.storeTelPhoneView addSubview:xuXian1];
    
    UIImageView *xuXian3 = [[UIImageView alloc]init];
    xuXian3.image = [UIImage imageNamed:@"img_dottedline2"];
    [self.storeTelPhoneView addSubview:xuXian3];
    
    [xuXian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left);
        make.right.equalTo(self.storeTelPhoneView.mas_right);
        make.top.equalTo(self.storeTelPhoneView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [xuXian3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeTelPhoneImage.mas_left).offset(-46);
        make.top.equalTo(self.storeTelPhoneView.mas_top).offset(8);
        make.bottom.equalTo(self.storeTelPhoneView.mas_bottom).offset(-8);
        make.width.mas_equalTo(1);
    }];
    
    [self.storeTelPhoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeTelPhoneView.mas_right).offset(-50);
        make.centerY.equalTo(self.storeTelPhoneView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.storeTelPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left).offset(10);
        make.right.equalTo(xuXian3.mas_left).offset(-10);
        make.centerY.equalTo(self.storeTelPhoneView.mas_centerY);
//        make.height.mas_equalTo(11);
    }];
    
    [self.storeTelPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderStateView.mas_bottom);
        make.height.mas_equalTo(41);
    }];
    UIImageView *bottomImageView = [[UIImageView alloc]init];
    bottomImageView.image = [UIImage imageNamed:@"img_scale"];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.payScrollView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.storeTelPhoneView.mas_bottom);
        make.height.mas_equalTo(12.5);
    }];
#pragma mark - 添加约束(消费码部分)
    [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.height.mas_equalTo(45);
    }];
    UILabel *xiaoFeiMa = [CommentMethod initLabelWithText:@"消费码" textAlignment:NSTextAlignmentLeft font:14];
    xiaoFeiMa.textColor = UIColorFromRGB(0x828383);
    [self.payCodeView addSubview:xiaoFeiMa];
    [xiaoFeiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.centerY.equalTo(self.payCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payCodeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payCodeView.mas_right).offset(-10);
        make.centerY.equalTo(self.payCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiaoFeiMa.mas_right).offset(10);
        make.centerY.equalTo(self.payCodeView.mas_centerY);
        make.right.equalTo(self.payCodeStateLabel.mas_left).offset(-10);
    }];
#pragma mark - 添加约束(订单详情部分)
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payCodeView.mas_bottom).offset(10);
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
        //        make.height.mas_equalTo(360);//408-24
    }];
#pragma mark - 添加约束(联系客服部分)
    [self.callServiceView mas_makeConstraints:^(MASConstraintMaker *make) {//确认支付背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50*AUTO_SIZE_SCALE_X);
    }];
    [self.callServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.callServiceView.mas_centerY);
        make.left.equalTo(self.callServiceView.mas_left).offset(10);
        make.right.equalTo(self.callServiceView.mas_right).offset(-10);
        make.height.mas_equalTo(40*AUTO_SIZE_SCALE_X);
    }];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xB2B2B3);
    [self.callServiceView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.callServiceView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    //联系门店处添加点击事件
    UITapGestureRecognizer *storeTelPhoneViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storeTelPhoneViewTaped:)];
    [self.storeTelPhoneView addGestureRecognizer:storeTelPhoneViewTap];
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
- (void)storeTelPhoneViewTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"联系门店");
    NSString * tel =[NSString stringWithFormat:@"%@",[DataDic  objectForKey:@"storeTel"]];
    tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"－" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"（" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"）" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@":" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"：" withString:@""];
    
    NSLog(@"%@",tel);
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
    
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
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
- (void)callService:(UIButton *)sender {
    NSLog(@"联系客服");
    NSString * tel = @"4008551512";
    tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"－" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"（" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"）" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@":" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"：" withString:@""];
    
    NSLog(@"%@",tel);
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
    
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_X)];
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
- (UIView *)payCodeView {
    if (_payCodeView == nil) {
        self.payCodeView = [UIView new];
        self.payCodeView.backgroundColor = [UIColor whiteColor];
    }
    return _payCodeView;
}

- (UIView *)callServiceView {
    if (_callServiceView == nil) {
        self.callServiceView = [UIView new];
        self.callServiceView.backgroundColor = [UIColor clearColor];
    }
    return _callServiceView;
}

- (UILabel *)payCodeLabel {
    if (_payCodeLabel == nil) {
        self.payCodeLabel = [CommentMethod initLabelWithText:@"25515888598153" textAlignment:NSTextAlignmentLeft font:14];
        self.payCodeLabel.textColor = BlackUIColorC5;
    }
    return _payCodeLabel;
}

- (UILabel *)payCodeStateLabel {
    if (_payCodeStateLabel == nil) {
        self.payCodeStateLabel = [CommentMethod initLabelWithText:@"未使用" textAlignment:NSTextAlignmentRight font:14];
        self.payCodeStateLabel.textColor = UIColorFromRGB(0x8D8E8E);
    }
    return _payCodeStateLabel;
}

- (UIButton *)callServiceButton {
    if (_callServiceButton == nil) {
        self.callServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.callServiceButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [self.callServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.callServiceButton.backgroundColor = OrangeUIColorC4;
        self.callServiceButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.callServiceButton.layer.cornerRadius = 5.0;
        [self.callServiceButton addTarget:self action:@selector(callService:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callServiceButton;
}
- (UIView *)storeTelPhoneView {
    if (_storeTelPhoneView == nil) {
        self.storeTelPhoneView = [[UIView alloc]init];
        self.storeTelPhoneView.userInteractionEnabled = YES;
        self.storeTelPhoneView.backgroundColor = [UIColor whiteColor];
    }
    return _storeTelPhoneView;
}
- (UILabel *)storeTelPhoneLabel {
    if (_storeTelPhoneLabel == nil) {
        self.storeTelPhoneLabel = [CommentMethod initLabelWithText:@"测试电话：13888888888" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _storeTelPhoneLabel;
}
- (UIImageView *)storeTelPhoneImage {
    if (_storeTelPhoneImage == nil) {
        self.storeTelPhoneImage = [[UIImageView alloc]init];
        self.storeTelPhoneImage.image = [UIImage imageNamed:@"icon_phone"];
    }
    return _storeTelPhoneImage;
}

@end
