//
//  FinishedHomeByStoreViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "FinishedHomeByStoreViewController.h"
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

#import "UMSocial.h"

#import "AppDelegate.h"
#import "MainViewController.h"

@interface FinishedHomeByStoreViewController () <UMSocialUIDelegate,UIAlertViewDelegate>

@end

@implementation FinishedHomeByStoreViewController
{
    NSDictionary *DataDic;
    NSDictionary *ServiceDic;
}

@synthesize orderID;

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.againButton.userInteractionEnabled = YES;
}

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
    [self.payScrollView addSubview:self.orderStateView];
    //服务时间部分
    self.serviceBeginLabel.text = [DataDic objectForKey:@"serviceStartTime"];
    [self.serviceTimeView addSubview:self.serviceBeginLabel];
    
    self.serviceEndLabel.text = [DataDic objectForKey:@"serviceEndTime"];
    [self.serviceTimeView addSubview:self.serviceEndLabel];
    [self.payScrollView addSubview:self.serviceTimeView];
    //订单详情部分
    [self.payScrollView addSubview:self.orderDetailView];
    //分享领券部分
#warning 本版本暂无此功能 暂时隐藏该控件
    //    [self.sharedView addSubview:self.sharedButton];
    [self.sharedView addSubview:self.againButton];
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
#pragma mark - 添加约束(服务时间部分)
    [self.serviceTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.height.mas_equalTo(90);
    }];
    UILabel *beginTime = [CommentMethod initLabelWithText:@"服务开始时间" textAlignment:NSTextAlignmentLeft font:14];
    [self.serviceTimeView addSubview:beginTime];
    [beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceTimeView.mas_left).offset(10);
        make.top.equalTo(self.serviceTimeView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
    [self.serviceBeginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginTime.mas_right).offset(10);
        make.centerY.equalTo(beginTime.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = C2UIColorGray;
    [self.serviceTimeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceTimeView.mas_left).offset(10);
        make.right.equalTo(self.serviceTimeView.mas_right);
        make.top.equalTo(self.serviceBeginLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    UILabel *endLabel = [CommentMethod initLabelWithText:@"服务结束时间" textAlignment:NSTextAlignmentLeft font:14];
    [self.serviceTimeView addSubview:endLabel];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceTimeView.mas_left).offset(10);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
    [self.serviceEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endLabel.mas_right).offset(10);
        make.centerY.equalTo(endLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
#pragma mark - 添加约束(订单详情部分)
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.serviceTimeView.mas_bottom).offset(10);
        //        make.height.mas_equalTo(408);//408-24
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
    }];
#pragma mark - 添加约束(分享领券部分)
    [self.sharedView mas_makeConstraints:^(MASConstraintMaker *make) {//分享领券背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderDetailView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.payScrollView.mas_bottom);
    }];
    //    [self.sharedButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.sharedView.mas_centerY);
    //        make.right.equalTo(self.sharedView.mas_right).offset(-10);
    //        make.size.mas_equalTo(CGSizeMake(98, 40));
    //    }];
    //    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.sharedView.mas_centerY);
    //        make.right.equalTo(self.sharedButton.mas_left).offset(-5);
    //        make.size.mas_equalTo(CGSizeMake(98, 40));
    //    }];
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sharedView.mas_left).offset(15);
        make.right.equalTo(self.sharedView.mas_right).offset(-15);
        make.top.equalTo(self.sharedView.mas_top).offset(5);
        make.bottom.equalTo(self.sharedView.mas_bottom).offset(-5);
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

-(void)gotoStoreVC
{
    self.againButton.userInteractionEnabled = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
    UIButton *tempbutton =[[UIButton alloc]init];
    tempbutton.tag =0;
    [mainVC selectorAction:tempbutton];
}
-(void)gotoStoreDetailVC
{
    self.againButton.userInteractionEnabled = YES;
    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    vc.storeID = [NSString stringWithFormat:@"%@",[DataDic objectForKey:@"storeID"]];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)gotoAppointNoworkerVC
{
    self.againButton.userInteractionEnabled = YES;
    
    DoorAppointmentFromServiceViewController *vc = [[DoorAppointmentFromServiceViewController alloc]init];
    vc.serviceID = [DataDic objectForKey:@"serviceID"];
    vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:ServiceDic];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)againButtonClick:(UIButton *)sender {
    NSLog(@"点击再次预约");
    [MobClick event:ORDER_ORDERDETAIL_AGAIN];
    self.againButton.userInteractionEnabled = NO;
    //无技师 从服务进预约页
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
                
                ServiceDic = [NSDictionary dictionaryWithDictionary:result];
                //storeState门店状态 state项目状态 workerState技师状态
                [self gotoAppointVC:result];
                
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                self.againButton.userInteractionEnabled = YES;
            }
        } failuer:^(NSError *error) {
            self.againButton.userInteractionEnabled = YES;
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
                ServiceDic = [NSDictionary dictionaryWithDictionary:result];
                //storeState门店状态 state项目状态 workerState技师状态
                [self gotoAppointVC:result];
                
                //                DoorAppointmentFromWorkerViewController *vc = [[DoorAppointmentFromWorkerViewController alloc]init];
                //                vc.serviceID = [DataDic objectForKey:@"serviceID"];
                //                vc.serviceInfoDic = [NSDictionary dictionaryWithDictionary:result];
                //                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                self.againButton.userInteractionEnabled = YES;
            }
        } failuer:^(NSError *error) {
            self.againButton.userInteractionEnabled = YES;
        }];
    }
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
        //        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 750);
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
- (UIView *)serviceTimeView {
    if (_serviceTimeView == nil) {
        self.serviceTimeView = [UIView new];
        self.serviceTimeView.backgroundColor = [UIColor whiteColor];
    }
    return _serviceTimeView;
}
- (UILabel *)serviceBeginLabel {
    if (_serviceBeginLabel == nil) {
        self.serviceBeginLabel = [CommentMethod initLabelWithText:@"2015-10-22  12:12" textAlignment:NSTextAlignmentLeft font:14];
        self.serviceBeginLabel.textColor = RedUIColorC1;
    }
    return _serviceBeginLabel;
}
- (UILabel *)serviceEndLabel {
    if (_serviceEndLabel == nil) {
        self.serviceEndLabel = [CommentMethod initLabelWithText:@"2015-10-22  14:12" textAlignment:NSTextAlignmentLeft font:14];
        self.serviceEndLabel.textColor = RedUIColorC1;
    }
    return _serviceEndLabel;
}
- (UIView *)sharedView {
    if (_sharedView == nil) {
        self.sharedView = [UIView new];
        self.sharedView.backgroundColor = [UIColor whiteColor];
    }
    return _sharedView;
}
//- (UIButton *)againButton {
//    if (_againButton == nil) {
//        self.againButton = [UIButton new];
//        [self.againButton setTitle:@"再次预约" forState:UIControlStateNormal];
//        [self.againButton setTitleColor:C6UIColorGray forState:UIControlStateNormal];
//        self.againButton.backgroundColor = [UIColor whiteColor];
//        self.againButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        self.againButton.layer.cornerRadius = 5.0;
//        self.againButton.layer.borderColor = C7UIColorGray.CGColor;
//        self.againButton.layer.borderWidth = 1.0;
//        [self.againButton addTarget:self action:@selector(againButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _againButton;
//}
- (UIButton *)againButton {
    if (_againButton == nil) {
        self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.againButton setTitle:@"再次预约" forState:UIControlStateNormal];
        [self.againButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.againButton.backgroundColor = OrangeUIColorC4;
        self.againButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.againButton.layer.cornerRadius = 5.0;
        [self.againButton addTarget:self action:@selector(againButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againButton;
}
- (UIButton *)sharedButton {
    if (_sharedButton == nil) {
        self.sharedButton = [UIButton new];
        self.sharedButton = [UIButton new];
        [self.sharedButton setTitle:@"分享领券" forState:UIControlStateNormal];
        [self.sharedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sharedButton.backgroundColor = OrangeUIColorC4;
        self.sharedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.sharedButton.layer.cornerRadius = 5.0;
        [self.sharedButton addTarget:self action:@selector(sharedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedButton;
}
@end
