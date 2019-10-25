//
//  WaitForStoreServiceViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/5.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "WaitForStoreServiceViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页

#import "AppDelegate.h"
@interface WaitForStoreServiceViewController ()

@end

@implementation WaitForStoreServiceViewController
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
        NSLog(@"————————————发出通知%@——————————————————————————————————————————",dict);
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
    //取消订单部分
    [self.cancleSignView addSubview:self.cancleLabel];
    //订单状态部分
    [self.payScrollView addSubview:self.orderStateView];
    //消费码部分
    self.payCodeLabel.text = [DataDic objectForKey:@"verifyCode"];
    [self.payCodeView addSubview:self.payCodeLabel];
    [self.payScrollView addSubview:self.payCodeView];
    //订单详情部分
    [self.payScrollView addSubview:self.orderDetailView];
    //联系客服部分
    [self.customServiceView addSubview:self.callServiceButton];
    [self.payScrollView addSubview:self.customServiceView];
    
    [self.view addSubview:self.cancleSignView];
    [self.view addSubview:self.payScrollView];
#pragma mark - 添加约束(取消订单部分)
    //约束
    [self.cancleLabel mas_makeConstraints:^(MASConstraintMaker *make) {//取消订单部分
        make.left.equalTo(self.cancleSignView.mas_left).offset(10);
        make.right.equalTo(self.cancleSignView.mas_right).offset(-10);
        make.top.equalTo(self.cancleSignView.mas_top).offset(7);
        make.height.mas_equalTo(40);
    }];
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
#pragma mark - 添加约束(消费码部分)
    [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.height.mas_equalTo(45);
    }];
    UILabel *xiaoFeiMa = [CommentMethod initLabelWithText:@"消费码" textAlignment:NSTextAlignmentLeft font:14];
    [self.payCodeView addSubview:xiaoFeiMa];
    [xiaoFeiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.centerY.equalTo(self.payCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payCodeView.mas_right).offset(-10);
        make.centerY.equalTo(self.payCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
#pragma mark - 添加约束(订单详情部分)
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payCodeView.mas_bottom).offset(10);
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
//        make.height.mas_equalTo(360);//408-24
    }];

#pragma mark - 添加约束(联系客服部分)
    [self.customServiceView mas_makeConstraints:^(MASConstraintMaker *make) {//确认支付背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderDetailView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
    }];
    [self.callServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customServiceView.mas_left).offset(15);
        make.right.equalTo(self.customServiceView.mas_right).offset(-15);
        make.top.equalTo(self.customServiceView.mas_top).offset(5);
        make.bottom.equalTo(self.customServiceView.mas_bottom).offset(-5);
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
    vc.serviceType = @"0";
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
    RoutePlanViewController *vc = [[RoutePlanViewController alloc]init];
    vc.latitude = [[DataDic objectForKey:@"latitude"]doubleValue];
    vc.longitude = [[DataDic objectForKey:@"longitude"]doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)callService:(UIButton *)sender {
    NSLog(@"联系门店");
    NSString * tel =[NSString stringWithFormat:@"%@",[DataDic objectForKey:@"storeContactTel"]];
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
//    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
#pragma mark - 懒加载
- (UIView *)cancleSignView {
    if (_cancleSignView == nil) {
        self.cancleSignView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 55)];
        self.cancleSignView.backgroundColor = UIColorFromRGB(0xfdf1c9);
    }
    return _cancleSignView;
}
- (UILabel *)cancleLabel {
    if (_cancleLabel == nil) {
        self.cancleLabel = [CommentMethod initLabelWithText:@"温馨提示：未按预约时间到店，请与门店另行协调服务时间和技师" textAlignment:NSTextAlignmentCenter font:13];
        self.cancleLabel.textColor = OrangeUIColorC4;
        self.cancleLabel.numberOfLines = 0;
    }
    return _cancleLabel;
}
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight+55, kScreenWidth, kScreenHeight-kNavHeight-55)];
//        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 667);//695-48
        self.payScrollView.backgroundColor = C2UIColorGray;
        self.payScrollView.showsVerticalScrollIndicator = NO;
        self.payScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _payScrollView;
}
- (OrderStateView *)orderStateView {
    if (_orderStateView == nil) {
        self.orderStateView = [OrderStateView new];
        self.orderStateView.data = DataDic;
    }
    return _orderStateView;
}
- (OrderDetaiWithStore *)orderDetailView {
    if (_orderDetailView == nil) {
        self.orderDetailView = [OrderDetaiWithStore new];
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

- (UIView *)customServiceView {
    if (_customServiceView == nil) {
        self.customServiceView = [UIView new];
        self.customServiceView.backgroundColor = [UIColor clearColor];
    }
    return _customServiceView;
}

- (UILabel *)payCodeLabel {
    if (_payCodeLabel == nil) {
        self.payCodeLabel = [CommentMethod initLabelWithText:@"25515888598153" textAlignment:NSTextAlignmentRight font:14];
        self.payCodeLabel.textColor = RedUIColorC1;
    }
    return _payCodeLabel;
}

- (UIButton *)callServiceButton {
    if (_callServiceButton == nil) {
        self.callServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.callServiceButton setTitle:@"联系门店" forState:UIControlStateNormal];
        [self.callServiceButton setTitleColor:C6UIColorGray forState:UIControlStateNormal];
        self.callServiceButton.backgroundColor = [UIColor whiteColor];
        self.callServiceButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.callServiceButton.layer.cornerRadius = 5.0;
        self.callServiceButton.layer.borderColor = C6UIColorGray.CGColor;
        self.callServiceButton.layer.borderWidth = 1.0;
        [self.callServiceButton addTarget:self action:@selector(callService:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callServiceButton;
}

@end
