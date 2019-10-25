//
//  WaitForHomeSericeByStoreViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "WaitForHomeSericeByStoreViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页
#import "AddBeltAppointmentViewController.h"//加钟页
#import "AppDelegate.h"
@interface WaitForHomeSericeByStoreViewController ()

@end

@implementation WaitForHomeSericeByStoreViewController
{
    NSDictionary *DataDic;
    UIWebView *phoneCallWebView;
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
    if ([[DataDic objectForKey:@"status"] isEqualToString:@"2"]) {
        self.signLabel.text = @"";
    }else if ([[DataDic objectForKey:@"status"] isEqualToString:@"3"]) {
        self.signLabel.text = [NSString stringWithFormat:@"技师已在%@出发",[DataDic objectForKey:@"workerDepartureTime"]];
    }else if ([[DataDic objectForKey:@"status"] isEqualToString:@"4"]) {
        self.signLabel.text = [NSString stringWithFormat:@"开始服务时间%@",[DataDic objectForKey:@"serviceStartTime"]];
    }
    [self.signView addSubview:self.signLabel];
    
    [self.payScrollView addSubview:self.orderStateView];
    
    self.storeTelPhoneLabel.text = [NSString stringWithFormat:@"联系门店：%@",[DataDic objectForKey:@"storeContactTel"]];
    [self.storeTelPhoneView addSubview:self.storeTelPhoneLabel];
    [self.storeTelPhoneView addSubview:self.storeTelPhoneImage];
    [self.payScrollView addSubview:self.storeTelPhoneView];
    
    [self.payScrollView addSubview:self.orderDetailView];
    
    [self.addBeltView addSubview:self.addBeltButton];
    [self.view addSubview:self.addBeltView];
    
    if ([[DataDic objectForKey:@"status"] isEqualToString:@"2"]) {
        self.signView.hidden = YES;
        self.payScrollView.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50);
    }else {
        self.signView.hidden = NO;
        self.payScrollView.frame = CGRectMake(0, kNavHeight+35, kScreenWidth, kScreenHeight-kNavHeight-35-50);
    }
    [self.view addSubview:self.signView];
    [self.view addSubview:self.payScrollView];
    //约束
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.signView.mas_centerX);
        make.centerY.equalTo(self.signView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(300, 14));
    }];
    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payScrollView.mas_top).offset(10);
        make.height.mas_equalTo(160);
    }];
    UIImageView *xuXian1 = [[UIImageView alloc]init];
    xuXian1.image = [UIImage imageNamed:@"img_dottedline1"];
    [self.storeTelPhoneView addSubview:xuXian1];
    
    UIImageView *xuXian3 = [[UIImageView alloc]init];
    xuXian3.image = [UIImage imageNamed:@"img_dottedline2"];
    [self.storeTelPhoneView addSubview:xuXian3];
    
    [xuXian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left).offset(10);
        make.right.equalTo(self.storeTelPhoneView.mas_right);
        make.top.equalTo(self.storeTelPhoneView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [xuXian3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeTelPhoneImage.mas_left).offset(-32);
        make.top.equalTo(self.storeTelPhoneView.mas_top).offset(8);
        make.bottom.equalTo(self.storeTelPhoneView.mas_bottom).offset(-8);
        make.width.mas_equalTo(1);
    }];
    
    [self.storeTelPhoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeTelPhoneView.mas_right).offset(-36);
        make.centerY.equalTo(self.storeTelPhoneView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.storeTelPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left).offset(10);
        make.right.equalTo(xuXian3.mas_left).offset(-20);
        make.centerY.equalTo(self.storeTelPhoneView.mas_centerY);
        make.height.mas_equalTo(11);
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
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
//        make.height.mas_equalTo(408);//408-24
        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
    }];
    [self.addBeltButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addBeltView).offset(15);
        make.right.equalTo(self.addBeltView).offset(-15);
        make.top.equalTo(self.addBeltView).offset(5);
        make.bottom.equalTo(self.addBeltView).offset(-5);
    }];
    [self.addBeltView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom);
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
    //为预约技师添加点击事件
    UIView *workerTap = [UIView new];
    workerTap.backgroundColor = [UIColor clearColor];
    workerTap.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateWorkerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateWorkerTaped:)];
    [workerTap addGestureRecognizer:dateWorkerTap];
    [self.orderDetailView addSubview:workerTap];
    [workerTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderDetailView.dateWorker.mas_top).offset(-15);
        make.left.equalTo(self.orderDetailView.mas_left);
        make.right.equalTo(self.orderDetailView.mas_right);
        make.bottom.equalTo(self.orderDetailView.addressLabel.mas_top);
    }];
    //为地址添加点击事件
    UIView *addressTap = [UIView new];
    addressTap.backgroundColor = [UIColor clearColor];
    addressTap.userInteractionEnabled = YES;
    UITapGestureRecognizer *addressLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLabelTaped:)];
    [addressTap addGestureRecognizer:addressLabelTap];
    [self.orderDetailView addSubview:addressTap];
    [addressTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workerTap.mas_bottom);
        make.left.equalTo(self.orderDetailView.mas_left);
        make.right.equalTo(self.orderDetailView.mas_right);
        make.bottom.equalTo(self.orderDetailView.addressLabel.mas_bottom).offset(10);
    }];
}
#pragma mark - 按钮点击事件
- (void)storeTelPhoneViewTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"联系门店");
    NSString * tel =[NSString stringWithFormat:@"%@",[DataDic  objectForKey:@"storeContactTel"]];
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
    vc.serviceType = @"1";
    vc.isStore = YES;
    if ([self.orderDetailView.dateWorker.text isEqualToString:@"推荐技师"]) {
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
- (void)dateWorkerTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到技师详情页");
    if ([self.orderDetailView.dateWorker.text isEqualToString:@"推荐技师"]) {
        //do nothing
    }else {
        technicianViewController *vc = [[technicianViewController alloc]init];
        vc.workerID = [DataDic objectForKey:@"workerID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)addressLabelTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到导航页");
}
- (void)addBelt:(UIButton *)sender {
    NSLog(@"我要加钟");
    if ([[DataDic objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
        AddBeltAppointmentViewController *vc = [[AddBeltAppointmentViewController alloc]init];
        vc.orderID = [DataDic objectForKey:@"orderID"];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [[RequestManager shareRequestManager] tipAlert:@"该订单不能加钟了哦~" viewController:self];
    }
}
#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+35, kScreenWidth, kScreenHeight-kNavHeight-35)];
//        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 650);
        self.payScrollView.backgroundColor = C2UIColorGray;
        self.payScrollView.showsVerticalScrollIndicator = NO;
        self.payScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _payScrollView;
}
- (UIView *)signView {
    if (_signView == nil) {
        self.signView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 35)];
        self.signView.backgroundColor = UIColorFromRGB(0xfdeebd);
    }
    return _signView;
}
- (UILabel *)signLabel {
    if (_signLabel == nil) {
        self.signLabel = [CommentMethod initLabelWithText:@"技师出发or开始服务" textAlignment:NSTextAlignmentCenter font:14];
        self.signLabel.textColor = OrangeUIColorC4;
    }
    return _signLabel;
}
- (OrderStateView *)orderStateView {
    if (_orderStateView == nil) {
        self.orderStateView = [OrderStateView new];
        self.orderStateView.data = DataDic;
    }
    return _orderStateView;
}
- (OrderDetaiWithStoreAndContact *)orderDetailView {
    if (_orderDetailView == nil) {
        self.orderDetailView = [OrderDetaiWithStoreAndContact new];
        self.orderDetailView.data = DataDic;
    }
    return _orderDetailView;
}
- (UIView *)addBeltView {
    if (_addBeltView == nil) {
        self.addBeltView = [UIView new];
        self.addBeltView.backgroundColor = [UIColor whiteColor];
    }
    return _addBeltView;
}
- (UIButton *)addBeltButton {
    if (_addBeltButton == nil) {
        self.addBeltButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addBeltButton setTitle:@"我要加钟" forState:UIControlStateNormal];
        [self.addBeltButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addBeltButton.backgroundColor = OrangeUIColorC4;
        self.addBeltButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.addBeltButton.layer.cornerRadius = 5.0;
        [self.addBeltButton addTarget:self action:@selector(addBelt:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBeltButton;
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
