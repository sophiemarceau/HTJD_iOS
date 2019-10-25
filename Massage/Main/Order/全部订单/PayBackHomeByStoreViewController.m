//
//  PayBackHomeByStoreViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "PayBackHomeByStoreViewController.h"
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

#import "AppDelegate.h"
#import "MainViewController.h"
@interface PayBackHomeByStoreViewController ()<UIAlertViewDelegate>

@end

@implementation PayBackHomeByStoreViewController
{
    NSDictionary *DataDic;
    
    NSDictionary *ServiceDic;

}

@synthesize orderID;
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.orderAgainButton.userInteractionEnabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"退款单";
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
    [self.payScrollView addSubview:self.orderStateView];
    //消费码部分
    self.payBackLabel.text = [NSString stringWithFormat:@"%.2f",[[DataDic objectForKey:@"payment"]doubleValue]/100];
    [self.payCodeView addSubview:self.payBackLabel];
    
    self.payBackTimeLabel.text = [NSString stringWithFormat:@"退款时间：%@",[DataDic objectForKey:@"dobackTime"]];
    [self.payCodeView addSubview:self.payBackTimeLabel];
    [self.payScrollView addSubview:self.payCodeView];
    //提示框部分
    [self.signView addSubview:self.signLabel];
    [self.payScrollView addSubview:self.signView];
    //订单详情部分
    [self.payScrollView addSubview:self.orderDetailView];
    //重新预约部分
    [self.orderAgainView addSubview:self.orderAgainButton];
    [self.payScrollView addSubview:self.orderAgainView];
    
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
#pragma mark - 添加约束(消费码部分)
    [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.height.mas_equalTo(45);
    }];
    UILabel *yiTuiKuan = [CommentMethod initLabelWithText:@"已退款" textAlignment:NSTextAlignmentLeft font:14];
    [self.payCodeView addSubview:yiTuiKuan];
    [yiTuiKuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.centerY.equalTo(self.payCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yiTuiKuan.mas_right).offset(10);
        make.centerY.equalTo(yiTuiKuan.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payBackTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payCodeView.mas_right).offset(-10);
        make.centerY.equalTo(self.payBackLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(180, 12));
    }];
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payCodeView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signView.mas_left).offset(10);
        make.right.equalTo(self.signView.mas_right).offset(-10);
        make.centerY.equalTo(self.signView.mas_centerY);
        make.height.mas_equalTo(40);
    }];
#pragma mark - 添加约束(订单详情部分)
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.signView.mas_bottom).offset(10);
//        make.height.mas_equalTo(408);//408-24
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
    }];
#pragma mark - 添加约束(重新预约部分)
    [self.orderAgainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderDetailView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.payScrollView.mas_bottom);
    }];
    [self.orderAgainButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderAgainView.mas_left).offset(15);
        make.right.equalTo(self.orderAgainView.mas_right).offset(-15);
        make.top.equalTo(self.orderAgainView.mas_top).offset(5);
        make.bottom.equalTo(self.orderAgainView.mas_bottom).offset(-5);
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

-(void)gotoAppointVC:(NSDictionary *)dic
{
    if ([dic objectForKey:@"storeState"]&&![[NSString stringWithFormat:@"%@",[dic objectForKey:@"storeState"]] isEqualToString:@""]) {
        NSString * storeState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"storeState"]];
        if ([storeState isEqualToString:@"9"]) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该门店已下线暂不可约,欢迎点选其他门店" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 1;
            [alert show];
            //            [[RequestManager shareRequestManager] tipAlert:@"该门店已下线暂不可约,欢迎点选其他门店" viewController:self];
            //            [self performSelector:@selector(gotoStoreVC) withObject:nil afterDelay:2.0];
            return ;
        }
    }
    if ([dic objectForKey:@"state"]&&![[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]] isEqualToString:@""]) {
        NSString * state = [NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
        if ([state isEqualToString:@"9"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该项目已下线暂不可约,欢迎点选其他服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
            //            [[RequestManager shareRequestManager] tipAlert:@"该项目已下线暂不可约,欢迎点选其他服务" viewController:self];
            //            [self performSelector:@selector(gotoStoreDetailVC) withObject:nil afterDelay:2.0];
            
            return ;
        }
    }
    if ([dic objectForKey:@"workerState"]&&![[NSString stringWithFormat:@"%@",[dic objectForKey:@"workerState"]] isEqualToString:@""]) {
        NSString * workerState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"workerState"]];
        if ([workerState isEqualToString:@"9"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该技师已下线暂不可约,欢迎点选本店其他技师" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 3;
            [alert show];
            //            [[RequestManager shareRequestManager] tipAlert:@"该技师已下线暂不可约,欢迎点选本店其他技师" viewController:self];
            //            [self performSelector:@selector(gotoAppointNoworkerVC) withObject:nil afterDelay:2.0];
            return ;
        }
    }
    
    if ([[DataDic objectForKey:@"workerName"]isEqualToString:@""]){
        DoorAppointmentFromServiceViewController *vc = [[DoorAppointmentFromServiceViewController alloc]init];
        vc.serviceID = [DataDic objectForKey:@"serviceID"];
        vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DoorAppointmentFromWorkerViewController *vc = [[DoorAppointmentFromWorkerViewController alloc]init];
        vc.serviceID = [DataDic objectForKey:@"serviceID"];
        vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(gotoStoreVC) withObject:nil afterDelay:0];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(gotoStoreDetailVC) withObject:nil afterDelay:0.0];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(gotoAppointNoworkerVC) withObject:nil afterDelay:0.0];
        }
    }
}

-(void)gotoStoreVC
{
    self.orderAgainButton.userInteractionEnabled = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
    UIButton *tempbutton =[[UIButton alloc]init];
    tempbutton.tag =0;
    [mainVC selectorAction:tempbutton];
}
-(void)gotoStoreDetailVC
{
    self.orderAgainButton.userInteractionEnabled = YES;
    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    vc.storeID = [NSString stringWithFormat:@"%@",[DataDic objectForKey:@"storeID"]];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)gotoAppointNoworkerVC
{
    self.orderAgainButton.userInteractionEnabled = YES;
    
    DoorAppointmentFromServiceViewController *vc = [[DoorAppointmentFromServiceViewController alloc]init];
    vc.serviceID = [DataDic objectForKey:@"serviceID"];
    vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:ServiceDic];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)orderAgainButtonClick:(UIButton *)sender {
    NSLog(@"点击重新预约");
    //无技师 从服务进预约页
    self.orderAgainButton.userInteractionEnabled = NO;

    if ([[DataDic objectForKey:@"workerName"]isEqualToString:@""]) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"ID":[DataDic objectForKey:@"serviceID"],
                               @"userID":userID,
                               @"longitude":@"",
                               @"latitude":@"",
                               @"skillWorkerID":[DataDic objectForKey:@"workerName"],
                               };
        [[RequestManager shareRequestManager] getSysServiceDetail:dic viewController:self successData:^(NSDictionary *result) {
            NDLog(@"项目详情result-->%@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//                DoorAppointmentFromServiceViewController *vc = [[DoorAppointmentFromServiceViewController alloc]init];
//                vc.serviceID = [DataDic objectForKey:@"serviceID"];
//                vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:result];
//                [self.navigationController pushViewController:vc animated:YES];
                ServiceDic = [NSDictionary dictionaryWithDictionary:result];
                [self gotoAppointVC:result];
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                self.orderAgainButton.userInteractionEnabled = YES;
            }
        } failuer:^(NSError *error) {
            self.orderAgainButton.userInteractionEnabled = YES;
        }];
        //有技师 从技师进预约页
    }else {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"ID":[DataDic objectForKey:@"serviceID"],
                               @"userID":userID,
                               @"longitude":@"",
                               @"latitude":@"",
                               @"skillWorkerID":[DataDic objectForKey:@"workerID"],
                               };
        [[RequestManager shareRequestManager] getSysServiceDetail:dic viewController:self successData:^(NSDictionary *result) {
            NDLog(@"项目详情result-->%@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//                DoorAppointmentFromWorkerViewController *vc = [[DoorAppointmentFromWorkerViewController alloc]init];
//                vc.serviceID = [DataDic objectForKey:@"serviceID"];
//                vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:result];
//                [self.navigationController pushViewController:vc animated:YES];
                ServiceDic = [NSDictionary dictionaryWithDictionary:result];
                [self gotoAppointVC:result];
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                self.orderAgainButton.userInteractionEnabled = YES;
            }
        } failuer:^(NSError *error) {
            self.orderAgainButton.userInteractionEnabled = YES;
        }];
    }
}
#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
//        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 745);//695-48
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
- (OrderDetaiWithStoreAndContact *)orderDetailView {
    if (_orderDetailView == nil) {
        self.orderDetailView = [OrderDetaiWithStoreAndContact new];
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
- (UILabel *)payBackLabel {
    if (_payBackLabel == nil) {
        self.payBackLabel = [CommentMethod initLabelWithText:@"￥4311" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _payBackLabel;
}
- (UILabel *)payBackTimeLabel {
    if (_payBackTimeLabel == nil) {
        self.payBackTimeLabel = [CommentMethod initLabelWithText:@"退款时间：2015-10-22  12:55" textAlignment:NSTextAlignmentRight font:12];
        self.payBackTimeLabel.textColor = C7UIColorGray;
    }
    return _payBackTimeLabel;
}
- (UIView *)signView {
    if (_signView == nil) {
        self.signView = [UIView new];
        self.signView.backgroundColor = UIColorFromRGB(0xfdeebd);
    }
    return _signView;
}
- (UILabel *)signLabel {
    if (_signLabel == nil) {
        self.signLabel = [CommentMethod initLabelWithText:@"注:返还金额根据您的付款方式原路退回，优惠券请在\"优惠兑换\"中查看" textAlignment:NSTextAlignmentLeft font:12];
        self.signLabel.textColor = UIColorFromRGB(0xccb076);
        self.signLabel.numberOfLines = 0;
    }
    return _signLabel;
}
- (UIView *)orderAgainView {
    if (_orderAgainView == nil) {
        self.orderAgainView = [UIView new];
        self.orderAgainView.backgroundColor = [UIColor whiteColor];
    }
    return _orderAgainView;
}
- (UIButton *)orderAgainButton {
    if (_orderAgainButton == nil) {
        self.orderAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.orderAgainButton setTitle:@"重新预约" forState:UIControlStateNormal];
        [self.orderAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.orderAgainButton.backgroundColor = OrangeUIColorC4;
        self.orderAgainButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.orderAgainButton.layer.cornerRadius = 5.0;
        [self.orderAgainButton addTarget:self action:@selector(orderAgainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderAgainButton;
}
@end
