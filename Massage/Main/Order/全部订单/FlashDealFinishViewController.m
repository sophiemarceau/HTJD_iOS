//
//  FlashDealFinishViewController.m
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDealFinishViewController.h"
#import "StoreCommentViewController.h"
#import "HomeCommentViewController.h"
#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页

@interface FlashDealFinishViewController ()

@end

@implementation FlashDealFinishViewController
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
    //消费码部分
        self.payCodeLabel.text = [DataDic objectForKey:@"verifyCode"];
    [self.payCodeView addSubview:self.payCodeLabel];
    [self.payCodeView addSubview:self.payCodeStateLabel];
    self.payTimeLabel.text = [DataDic objectForKey:@"verifyTime"];
    [self.payCodeView addSubview:self.payTimeLabel];
    [self.payScrollView addSubview:self.payCodeView];
    //订单详情部分
    [self.payScrollView addSubview:self.orderDetailView];
    
    [self.view addSubview:self.payScrollView];
#pragma mark - 添加约束(订单状态部分)
    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.payScrollView.mas_top).offset(10);
        make.bottom.equalTo(self.orderStateView.serviceImageView.mas_bottom).offset(12);
        //        make.height.mas_equalTo(160);
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
    xiaoFeiMa.textColor = UIColorFromRGB(0x828383);
    [self.payCodeView addSubview:xiaoFeiMa];
    [xiaoFeiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left).offset(10);
        make.top.equalTo(self.payCodeView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payCodeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payCodeView.mas_right).offset(-10);
        make.top.equalTo(self.payCodeView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.payCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiaoFeiMa.mas_right).offset(10);
        make.centerY.equalTo(xiaoFeiMa.mas_centerY);
        make.right.equalTo(self.payCodeStateLabel.mas_left).offset(-10);
    }];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = C2UIColorGray;
    [self.payCodeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCodeView.mas_left);
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
        make.bottom.equalTo(self.orderDetailView.totalPriceLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.payScrollView.mas_bottom);
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

#pragma mark - 懒加载
- (UIScrollView *)payScrollView {
    if (_payScrollView == nil) {
        self.payScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
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
- (UILabel *)payCodeLabel {
    if (_payCodeLabel == nil) {
        self.payCodeLabel = [CommentMethod initLabelWithText:@"25515888598153" textAlignment:NSTextAlignmentLeft font:14];
        self.payCodeLabel.textColor = BlackUIColorC5;
    }
    return _payCodeLabel;
}

- (UILabel *)payCodeStateLabel {
    if (_payCodeStateLabel == nil) {
        self.payCodeStateLabel = [CommentMethod initLabelWithText:@"已使用" textAlignment:NSTextAlignmentRight font:14];
        self.payCodeStateLabel.textColor = C7UIColorGray;
    }
    return _payCodeStateLabel;
}
- (UILabel *)payTimeLabel {
    if (_payTimeLabel == nil) {
        self.payTimeLabel = [CommentMethod initLabelWithText:@"2015-10-20  10:20" textAlignment:NSTextAlignmentLeft font:14];
        self.payTimeLabel.textColor = C7UIColorGray;
    }
    return _payTimeLabel;
}

@end
