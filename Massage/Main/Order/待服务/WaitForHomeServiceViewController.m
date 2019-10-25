//
//  WaitForHomeServiceViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "WaitForHomeServiceViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页
#import "AddBeltAppointmentViewController.h"//加钟页
#import "AppDelegate.h"
@interface WaitForHomeServiceViewController ()
@end

@implementation WaitForHomeServiceViewController
{
    NSDictionary *DataDic;
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
    
    NSString *tranStr = [NSString stringWithFormat:@"%@",[DataDic objectForKey:@"transportationFee"]];
    NSString *bedStr = [NSString stringWithFormat:@"%@",[DataDic objectForKey:@"bedFee"]];
    
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
    if ([tranStr isEqualToString:@"0"] && [bedStr isEqualToString:@"0"]) {
        [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(bottomImageView.mas_bottom).offset(2);
//            make.height.mas_equalTo(384);//408-24
            make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
            make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
        }];
    }else {
        [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(bottomImageView.mas_bottom).offset(2);
//            make.height.mas_equalTo(408);//408-24
            make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
            make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
        }];
    }
    
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
- (void)serviceTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到项目详情页");
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
    vc.serviceID = [DataDic objectForKey:@"serviceID"];
    vc.serviceType = @"1";
    vc.isStore = NO;
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
        TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
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
//        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 626);
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
- (OrderDetaiWithContact *)orderDetailView {
    if (_orderDetailView == nil) {
        self.orderDetailView = [OrderDetaiWithContact new];
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
@end
