//
//  WaitForHomeCommentByStoreViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "WaitForHomeCommentByStoreViewController.h"
#import "StoreCommentViewController.h"
#import "HomeCommentViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页

@interface WaitForHomeCommentByStoreViewController ()

@end

@implementation WaitForHomeCommentByStoreViewController
{
    NSDictionary *DataDic;
}

@synthesize orderID;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"待评论";
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
    //我要评论部分
    [self.commentView addSubview:self.commentButton];
    
    [self.view addSubview:self.commentView];
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
        make.bottom.equalTo(self.payScrollView.mas_bottom).offset(-10);
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(10);
    }];
#pragma mark - 添加约束(我要评论部分)
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {//确认支付背景
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentView.mas_left).offset(15);
        make.right.equalTo(self.commentView.mas_right).offset(-15);
        make.top.equalTo(self.commentView.mas_top).offset(5);
        make.bottom.equalTo(self.commentView.mas_bottom).offset(-5);
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
- (void)commentButtonClick:(UIButton *)sender {
    NSLog(@"我要评论");
    HomeCommentViewController *vc = [[HomeCommentViewController alloc]init];
    vc.orderID = self.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50)];
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
- (UIView *)commentView {
    if (_commentView == nil) {
        self.commentView = [UIView new];
        self.commentView.backgroundColor = [UIColor whiteColor];
    }
    return _commentView;
}
- (UIButton *)commentButton {
    if (_commentButton == nil) {
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setTitle:@"我要评论" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commentButton.backgroundColor = OrangeUIColorC4;
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.commentButton.layer.cornerRadius = 5.0;
        [self.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}
@end
