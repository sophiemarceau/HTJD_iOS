//
//  WaitForStoreCommentViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "WaitForStoreCommentViewController.h"
#import "StoreCommentViewController.h"
#import "HomeCommentViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页

@interface WaitForStoreCommentViewController ()

@end

@implementation WaitForStoreCommentViewController
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
    //消费码部分
    self.payCodeLabel.text = [DataDic objectForKey:@"verifyCode"];
    [self.payCodeView addSubview:self.payCodeLabel];
    
    self.payTimeLabel.text = [DataDic objectForKey:@"verifyTime"];
    [self.payCodeView addSubview:self.payTimeLabel];
    
    [self.payScrollView addSubview:self.payCodeView];
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
#pragma mark - 添加约束(消费码部分)
    [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(bottomImageView.mas_bottom).offset(2);
        make.height.mas_equalTo(90);
    }];
    UILabel *xiaoFeiMa = [CommentMethod initLabelWithText:@"消费码" textAlignment:NSTextAlignmentLeft font:14];
    [self.payCodeView addSubview:xiaoFeiMa];
    [xiaoFeiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.top.equalTo(self.payCodeView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiaoFeiMa.mas_right).offset(10);
        make.centerY.equalTo(xiaoFeiMa.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    UILabel *alreadyLabel = [CommentMethod initLabelWithText:@"已使用" textAlignment:NSTextAlignmentRight font:14];
    alreadyLabel.textColor = C7UIColorGray;
    [self.payCodeView addSubview:alreadyLabel];
    [alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payCodeView.mas_right).offset(-10);
        make.top.equalTo(self.payCodeView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = C2UIColorGray;
    [self.payCodeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.right.equalTo(self.payCodeView.mas_right);
        make.top.equalTo(self.payCodeLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    UILabel *xiaoFeiShiJian = [CommentMethod initLabelWithText:@"消费时间" textAlignment:NSTextAlignmentLeft font:14];
    xiaoFeiShiJian.textColor = C7UIColorGray;
    [self.payCodeView addSubview:xiaoFeiShiJian];
    [xiaoFeiShiJian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiaoFeiShiJian.mas_right).offset(10);
        make.centerY.equalTo(xiaoFeiShiJian.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
#pragma mark - 添加约束(订单详情部分)
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payCodeView.mas_bottom).offset(10);
//        make.height.mas_equalTo(360);//408-24
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
- (void)commentButtonClick:(UIButton *)sender {
    NSLog(@"我要评论");
    StoreCommentViewController *vc = [[StoreCommentViewController alloc]init];
    vc.orderID = self.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50)];
//        self.payScrollView.contentSize = CGSizeMake(kScreenWidth, 702);//695-48
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
- (UIView *)commentView {
    if (_commentView == nil) {
        self.commentView = [UIView new];
        self.commentView.backgroundColor = [UIColor whiteColor];
    }
    return _commentView;
}
- (UILabel *)payCodeLabel {
    if (_payCodeLabel == nil) {
        self.payCodeLabel = [CommentMethod initLabelWithText:@"25515888598153" textAlignment:NSTextAlignmentLeft font:14];
        self.payCodeLabel.textColor = [UIColor blackColor];
    }
    return _payCodeLabel;
}
- (UILabel *)payTimeLabel {
    if (_payTimeLabel == nil) {
        self.payTimeLabel = [CommentMethod initLabelWithText:@"2015-10-20  10:20" textAlignment:NSTextAlignmentLeft font:14];
        self.payTimeLabel.textColor = C7UIColorGray;
    }
    return _payTimeLabel;
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
