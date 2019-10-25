//
//  OrderListViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/14.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "OrderListViewController.h"
#import "LoginViewController.h"
#import "menuVIew.h"
#import "noOrderView.h"
#import "BaseTableView.h"
#import "OrderListCell.h"
#import "PayForStoreViewController.h"
#import "PayForWorkViewController.h"
#import "PayForWorkByStoreViewController.h"
#import "PayViewController.h"
#import "WaitForStoreServiceViewController.h"
#import "WaitForHomeServiceViewController.h"
#import "WaitForHomeSericeByStoreViewController.h"
#import "WaitForStoreCommentViewController.h"
#import "WaitForHomeCommentViewController.h"
#import "WaitForHomeCommentByStoreViewController.h"
#import "WaitForCommentByQuickPassViewController.h"
#import "FinishedStoreViewController.h"
#import "FinishedHomeViewController.h"
#import "FinishedHomeByStoreViewController.h"
#import "FinishedByQuickPassViewController.h"
#import "PayBackStoreViewController.h"
#import "PayBackHomeViewController.h"
#import "PayBackHomeByStoreViewController.h"
#import "StoreCommentViewController.h"
#import "HomeCommentViewController.h"

#import "StoreDetailViewController.h"//店铺详情
#import "TechnicianMyselfViewController.h"//自营技师详情
#import "technicianViewController.h"//店铺技师详情
#import "ServiceDetailViewController.h"//项目详情
#import "RoutePlanViewController.h"//导航页
#import "AddBeltAppointmentViewController.h"//加钟页
#import "noWifiView.h"//没有网络页面
#import "FlashDealViewController.h"//秒杀订单

#import "UIImageView+WebCache.h"

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,menuViewDelegate>
//未登陆
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *signLabel;
@property (strong, nonatomic) UIButton *loginButton;
@property (nonatomic,assign) BOOL isLogin;
//已登陆
@property (strong, nonatomic) BaseTableView *orderTableView;
@property (strong, nonatomic) menuVIew *menuView;
//无订单
@property (strong, nonatomic) noOrderView *noOrderView;
//菜单栏相关属性
@property (strong, nonatomic) NSString *menuTag;
//@property (nonatomic,assign) BOOL isFirstPayClick;
//@property (nonatomic,assign) BOOL isFirstServiceClick;
//@property (nonatomic,assign) BOOL isFirstCommentClick;
//@property (nonatomic,assign) BOOL isFirstAllClick;
//存储接口返回数据
@property (strong, nonatomic) NSMutableArray *payArray;
@property (strong, nonatomic) NSMutableArray *serviceArray;
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (strong, nonatomic) NSMutableArray *allArray;
//秒杀订单按钮
@property (strong, nonatomic) UIButton *flashDealButton;
@end

@implementation OrderListViewController {
    //用来存储可删除的订单编号
    NSString *deleteOrderID;
    //订单页数
    int _pageForHot;
    noWifiView *failView;
    UIWebView *phoneCallWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @"订单";
    //初始化
    self.menuTag = @"1";
//    self.isFirstPayClick = YES;
//    self.isFirstServiceClick = YES;
//    self.isFirstCommentClick = YES;
//    self.isFirstAllClick = YES;
    self.payArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.serviceArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.commentArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.allArray = [[NSMutableArray alloc]initWithCapacity:0];
    deleteOrderID = @"";
    
    [self downloadData];
    
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSLog(@"userid === %@",userID);
    if ([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]] ||userID ==nil) {
        //未登录
        NSLog(@"未登录");
        self.isLogin = NO;
        [self initView];
    }else{
        //已登陆
        NSLog(@"已登陆");
        self.isLogin = YES;
        [self initView];
    }
    
    //接收登陆通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoginPageDataNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginPageDataNtf:) name:@"LoginPageDataNtf" object:nil];
    //接收menuView通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"menuViewKey" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuChange:) name:@"menuViewKey" object:nil];
    //接收评论订单变化的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CommentOrderNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentOrderDataNtf:) name:@"CommentOrderNtf" object:nil];
    //接收待付款订单变化的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PayOrderNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderDataNtf:) name:@"PayOrderNtf" object:nil];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    //接收menuView通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"menuViewKey" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuChange:) name:@"menuViewKey" object:nil];
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"menuViewKey" object:nil];
//}
#pragma mark 获取数据
- (void)downloadData {
    [self hideHud];
    [self showHudInView:self.view hint:@"正在加载"];
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSLog(@"userid === %@",userID);
    if ([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]] ||userID ==nil) {
        //未登录
        NSLog(@"未登录");
        self.isLogin = NO;
        [self hideHud];
    }else{
        //已登陆
        NSLog(@"已登陆");
        self.isLogin = YES;
        NSLog(@"运行时的menuTag:%@",self.menuTag);
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"orderStatus":self.menuTag,
                               @"type":@"1,2",
                               };
        [[RequestManager shareRequestManager] getOrderList:dic viewController:self successData:^(NSDictionary *result) {
            NDLog(@"menuTag=%@时的result--------- > %@",self.menuTag,result);
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            [self hideHud];
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //                self.orderTableView.hidden = NO;
                if ([self.menuTag isEqualToString:@"1"]) {
                    NSArray *payClassLesson = [result objectForKey:@"orderList"];
                    [self.payArray removeAllObjects];
                    [self.payArray addObjectsFromArray:payClassLesson];
                    if (self.payArray.count > 0) {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = YES;
                    }else {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = NO;
                    }
                    [self.orderTableView reloadData];
                    if (payClassLesson.count < 10 ||payClassLesson.count == 0) {
                        [self.orderTableView.foot finishRefreshing];
                    }
                    else{
                        [self.orderTableView.foot endRefreshing];
                    }
//                    self.isFirstPayClick = NO;
                }
                if ([self.menuTag isEqualToString:@"2"]) {
                    NSArray *serviceClassLesson = [result objectForKey:@"orderList"];
                    [self.serviceArray removeAllObjects];
                    [self.serviceArray addObjectsFromArray:serviceClassLesson];
                    if (self.serviceArray.count > 0) {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = YES;
                    }else {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = NO;
                    }
                    [self.orderTableView reloadData];
                    if (serviceClassLesson.count < 10 ||serviceClassLesson.count == 0) {
                        [self.orderTableView.foot finishRefreshing];
                    }
                    else{
                        [self.orderTableView.foot endRefreshing];
                    }
//                    self.isFirstServiceClick = NO;
                }
                if ([self.menuTag isEqualToString:@"3"]) {
                    NSArray *commentClassLesson = [result objectForKey:@"orderList"];
                    [self.commentArray removeAllObjects];
                    [self.commentArray addObjectsFromArray:commentClassLesson];
                    //                [self initView];
                    if (self.commentArray.count > 0) {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = YES;
                    }else {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = NO;
                    }
                    [self.orderTableView reloadData];
                    if (commentClassLesson.count < 10 ||commentClassLesson.count == 0) {
                        [self.orderTableView.foot finishRefreshing];
                    }
                    else{
                        [self.orderTableView.foot endRefreshing];
                    }
//                    self.isFirstCommentClick = NO;
                }
                if ([self.menuTag isEqualToString:@"4"]) {
                    NSArray *allClassLesson = [result objectForKey:@"orderList"];
                    [self.allArray removeAllObjects];
                    [self.allArray addObjectsFromArray:allClassLesson];
                    if (self.allArray.count > 0) {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = YES;
                    }else {
                        self.orderTableView.hidden = NO;
                        self.noOrderView.hidden = NO;
                    }
                    [self.orderTableView reloadData];
                    if (allClassLesson.count < 10 ||allClassLesson.count == 0) {
                        [self.orderTableView.foot finishRefreshing];
                    }
                    else{
                        [self.orderTableView.foot endRefreshing];
                    }
//                    self.isFirstAllClick = NO;
                }
            }else {
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            }
        } failuer:^(NSError *error) {
            failView.hidden = NO;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            [self hideHud];
        }];
    }
}

#pragma mark - 通知相关方法
////menuView通知 点击切换不同的订单状态
//- (void)menuChange:(NSDictionary *)dic {
//    NSDictionary *dict = [dic valueForKey:@"userInfo"];
//    self.menuTag = [dict objectForKey:@"menuView"];
//    //待付款
//    if ([self.menuTag isEqualToString:@"1"]) {
//        [MobClick event:ORDER_NOPAY];
//        [self downloadData];
//        if (self.payArray.count > 0) {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = YES;
//        }else {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = NO;
//        }
//        [self.orderTableView reloadData];
//        //待服务
//    }else if ([self.menuTag isEqualToString:@"2"]) {
//        [MobClick event:ORDER_WAITSERVE];
//        [self downloadData];
//        if (self.serviceArray.count > 0) {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = YES;
//        }else {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = NO;
//        }
//        [self.orderTableView reloadData];
//        //待评论
//    }else if ([self.menuTag isEqualToString:@"3"]) {
//        [MobClick event:ORDER_WAITCOMMET];
//        [self downloadData];
//        if (self.commentArray.count > 0) {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = YES;
//        }else {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = NO;
//        }
//        [self.orderTableView reloadData];
//        //全部
//    }else if ([self.menuTag isEqualToString:@"4"]) {
//        [MobClick event:ORDER_ALL];
//        [self downloadData];
//        if (self.allArray.count > 0) {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = YES;
//        }else {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = NO;
//        }
//        [self.orderTableView reloadData];
//    }
//}
-(void)menuViewDidSelect:(NSInteger)number{
    self.menuTag = [NSString stringWithFormat:@"%ld",(long)number];
    switch (number) {
        case 1:
        {
            [MobClick event:ORDER_NOPAY];
            [self downloadData];
            if (self.payArray.count > 0) {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = YES;
            }else {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = NO;
            }
            [self.orderTableView reloadData];
        }
            break;
        case 2:
        {
            [MobClick event:ORDER_WAITSERVE];
            [self downloadData];
            if (self.serviceArray.count > 0) {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = YES;
            }else {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = NO;
            }
            [self.orderTableView reloadData];
        }
            break;
        case 3:
            [MobClick event:ORDER_WAITCOMMET];
            [self downloadData];
            if (self.commentArray.count > 0) {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = YES;
            }else {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = NO;
            }
            [self.orderTableView reloadData];
            break;
        case 4:
            [MobClick event:ORDER_ALL];
            [self downloadData];
            if (self.allArray.count > 0) {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = YES;
            }else {
                self.orderTableView.hidden = NO;
                self.noOrderView.hidden = NO;
            }
            [self.orderTableView reloadData];
            break;
            
    }
}
//登陆通知
-(void)LoginPageDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"ret"];
    if([ret isEqualToString:@"20001"]){
        //已登录
        self.isLogin = YES;
        [self.headImageView removeFromSuperview];
        [self.signLabel removeFromSuperview];
        [self.loginButton removeFromSuperview];
//        self.isFirstPayClick = YES;
//        self.isFirstServiceClick = YES;
//        self.isFirstCommentClick = YES;
//        self.isFirstAllClick = YES;
        self.menuTag = @"1";
        if ([self.menuTag isEqualToString:@"1"]) {
            self.menuView.selectedButton.selected = YES;
        }
        [self downloadData];
        [self initView];
        //未登录
    }else if([ret isEqualToString:@"20002"]) {
        self.isLogin = NO;
        [self.orderTableView removeFromSuperview];
        [self.menuView removeFromSuperview];
        self.menuView = nil;
        [self.noOrderView removeFromSuperview];
        [self initView];
    }
}
//评论订单通知
-(void)commentOrderDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *infoStr =[info objectForKey:@"comment"];
    if([infoStr isEqualToString:@"finished"]){
        [self downloadData];
        [self.orderTableView reloadData];
    }
}
//待付款订单通知
- (void)payOrderDataNtf:(NSNotification *)ntf {
    NSDictionary *info =ntf.object;
    NSString *infoStr =[info objectForKey:@"pay"];
    if([infoStr isEqualToString:@"changed"]){
        [self downloadData];
        [self.orderTableView reloadData];
    }
}

- (void)initView {
    if (self.isLogin == NO) {
        [self.view addSubview:self.headImageView];
        [self.view addSubview:self.signLabel];
        [self.view addSubview:self.loginButton];
        //约束
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(103, 103));
        }];
        [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //计算文字宽度
            CGSize size = [self.signLabel.text sizeWithAttributes:@{NSFontAttributeName:self.signLabel.font}];
            make.top.equalTo(self.headImageView.mas_bottom).offset(20);
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
        }];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.signLabel.mas_centerY);
            make.left.equalTo(self.signLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 25));
        }];
    }else {
        [self.navView addSubview:self.flashDealButton];
        [self.view addSubview:self.menuView];
        [self.orderTableView addSubview:self.noOrderView];
        [self.view addSubview:self.orderTableView];
        [self.flashDealButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navView.mas_bottom);
            make.right.equalTo(self.navView.mas_right).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, navBtnHeight));
        }];
    }
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight+40, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight-40)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
}
#pragma mark - 按钮点击事件
- (void)reloadButtonClick:(UIButton *)sender {
    [self downloadData];
}
//登陆按钮
-(void)loginButtonPressed:(UIButton *)sender
{
    NSLog(@"跳转到登录界面");
    //转场动画
    CATransition *tran = [CATransition animation];
    tran.duration =.5;
    tran.type =@"oglFlip";
    tran.subtype =kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:tran forKey:nil];
    LoginViewController * vc = [[LoginViewController alloc] init];
    vc.isFromOrderList = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//项目或技师名称
- (void)storeBackViewTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"点击这里需要跳转到对应的项目详情或者技师详情页面--%ld",(long)sender.view.tag);
    [MobClick event:ORDER_STOREDETAIL];
//待付款
    if ([self.menuTag isEqualToString:@"1"]) {
        //判断为到店或到店上门 推出店铺详情
        if ([[[self.payArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]||[[[self.payArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"2"]) {
            StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
            vc.storeID = [[self.payArray objectAtIndex:sender.view.tag]objectForKey:@"storeID"];
            [self.navigationController pushViewController:vc animated:YES];
        //其他则推出技师详情
        }else {
            TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
            vc.workerID = [[self.payArray objectAtIndex:sender.view.tag]objectForKey:@"workerID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//待服务
    }else if ([self.menuTag isEqualToString:@"2"]) {
        //判断为到店或到店上门 推出店铺详情
        if ([[[self.serviceArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]||[[[self.serviceArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"2"]) {
            StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
            vc.storeID = [[self.serviceArray objectAtIndex:sender.view.tag]objectForKey:@"storeID"];
            [self.navigationController pushViewController:vc animated:YES];
            //其他则推出技师详情
        }else {
            TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
            vc.workerID = [[self.serviceArray objectAtIndex:sender.view.tag]objectForKey:@"workerID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//待评论
    }else if ([self.menuTag isEqualToString:@"3"]) {
        //判断为到店或到店上门 推出店铺详情
        if ([[[self.commentArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]||[[[self.commentArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"2"]) {
            StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
            vc.storeID = [[self.commentArray objectAtIndex:sender.view.tag]objectForKey:@"storeID"];
            [self.navigationController pushViewController:vc animated:YES];
            //其他则推出技师详情
        }else {
            TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
            vc.workerID = [[self.commentArray objectAtIndex:sender.view.tag]objectForKey:@"workerID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//全部
    }else {
        //判断为到店或到店上门 推出店铺详情
        if ([[[self.allArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]||[[[self.allArray objectAtIndex:sender.view.tag]objectForKey:@"serviceType"]isEqualToString:@"2"]) {
            StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
            vc.storeID = [[self.allArray objectAtIndex:sender.view.tag]objectForKey:@"storeID"];
            [self.navigationController pushViewController:vc animated:YES];
            //其他则推出技师详情
        }else {
            TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
            vc.workerID = [[self.allArray objectAtIndex:sender.view.tag]objectForKey:@"workerID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//门店联系方式
- (void)storeTelPhoneViewTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"联系门店");
    if ([self.menuTag isEqualToString:@"1"]) {
        
    }else if ([self.menuTag isEqualToString:@"2"]) {
        NSString * tel =[NSString stringWithFormat:@"%@",[[self.serviceArray objectAtIndex:sender.view.tag] objectForKey:@"storeTel"]];
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
    }else if ([self.menuTag isEqualToString:@"3"]) {
        
    }else if ([self.menuTag isEqualToString:@"4"]) {
        NSString * tel =[NSString stringWithFormat:@"%@",[[self.allArray objectAtIndex:sender.view.tag] objectForKey:@"storeTel"]];
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
}
//"我要"按钮
- (void)IWantButtonClick:(UIButton *)sender {
//待付款
    if ([self.menuTag isEqualToString:@"1"]) {
        NSLog(@"点击跳转付款页面--%ld",(long)sender.tag);
        PayViewController *vc = [[PayViewController alloc]init];
        vc.orderID = [[self.payArray objectAtIndex:sender.tag]objectForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:ORDER_PAY];
//待服务
    }else if ([self.menuTag isEqualToString:@"2"]) {
        NSLog(@"点击跳转加钟页面--%ld",(long)sender.tag);
        if ([[[self.serviceArray objectAtIndex:sender.tag]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
            AddBeltAppointmentViewController *vc = [[AddBeltAppointmentViewController alloc]init];
            vc.orderID = [[self.serviceArray objectAtIndex:sender.tag]objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [[RequestManager shareRequestManager] tipAlert:@"该订单不能加钟了哦~" viewController:self];
        }
        
//待评论
    }else if ([self.menuTag isEqualToString:@"3"]) {
        NSLog(@"点击跳转评论页面--%ld",(long)sender.tag);
        [MobClick event:ORDER_COMMENT];
        //判断是到店或者是闪付 推出到店评论页
        if ([[[self.commentArray objectAtIndex:sender.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]||[[[self.commentArray objectAtIndex:sender.tag]objectForKey:@"type"]isEqualToString:@"2"]) {
            StoreCommentViewController *vc = [[StoreCommentViewController alloc]init];
            vc.orderID = [[self.commentArray objectAtIndex:sender.tag] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
            //其他则推出上门评论页
        }else {
            HomeCommentViewController *vc = [[HomeCommentViewController alloc]init];
            vc.orderID = [[self.commentArray objectAtIndex:sender.tag] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//全部
    }else {
        NSLog(@"点击删除订单,刷新页面--%ld",(long)sender.tag);
        if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"1"]) {
            PayViewController *vc = [[PayViewController alloc]init];
            vc.orderID = [[self.allArray objectAtIndex:sender.tag]objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
            [MobClick event:ORDER_PAY];
        }
        //加钟
        if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"2"]||[[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"3"]||[[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"4"]) {
            //判断为上门 推出加钟页
            if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]) {
                NDLog(@"我是到店的订单--我不能加钟");
            }else {
                if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                    AddBeltAppointmentViewController *vc = [[AddBeltAppointmentViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:sender.tag]objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    [[RequestManager shareRequestManager] tipAlert:@"该订单不能加钟了哦~" viewController:self];
                }
            }
        }
        //评论
        if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"5"]) {
            //判断是到店或者是闪付 推出到店评论页
            if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"serviceType"]isEqualToString:@"1"]||[[[self.allArray objectAtIndex:sender.tag]objectForKey:@"type"]isEqualToString:@"2"]) {
                StoreCommentViewController *vc = [[StoreCommentViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:sender.tag] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                //其他则推出上门评论页
            }else {
                HomeCommentViewController *vc = [[HomeCommentViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:sender.tag] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        //删除
        if ([[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"6"]||[[[self.allArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"-3"]) {
            NSLog(@"删除订单");
            deleteOrderID = [[self.allArray objectAtIndex:sender.tag] objectForKey:@"ID"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"是否确定删除该订单"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
            [MobClick event:ORDER_DELETEORDER];
        }
    }
}
- (void)flashDealButtonClick {
    FlashDealViewController *vc = [[FlashDealViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//待付款
    if ([self.menuTag isEqualToString:@"1"]) {
        return self.payArray.count;
//待服务
    }else if ([self.menuTag isEqualToString:@"2"]) {
        return self.serviceArray.count;
//待评论
    }else if ([self.menuTag isEqualToString:@"3"]) {
        return self.commentArray.count;
//全部
    }else {
        return self.allArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//待付款
    if ([self.menuTag isEqualToString:@"1"]) {
        return 240;
//待服务
    }else if ([self.menuTag isEqualToString:@"2"]) {
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {
            return 222;
        }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {
            //判断是否可以加钟 可以则返回有按钮的高度240
            if ([[[self.serviceArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                return 282;
            }else {
                return 282;
            }
        }else {
            //判断是否可以加钟 可以则返回有按钮的高度240
            if ([[[self.serviceArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                return 240;
            }else {
                return 240;
            }
        }
        
//待评论
    }else if ([self.menuTag isEqualToString:@"3"]) {
        return 240;
//全部
    }else {
        if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"1"]) {
            return 240;
        }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"2"]||[[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"3"]||[[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"4"]) {
            if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"serviceType"]isEqualToString:@"1"]) {
                return 222;
            }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"serviceType"]isEqualToString:@"2"]) {
                //判断是否可以加钟 可以则返回有按钮的高度240
                if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                    return 282;
                }else {
                    return 282;
                }
            }else {
                //判断是否可以加钟 可以则返回有按钮的高度240
                if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                    return 240;
                }else {
                    return 240;
                }
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"5"]) {
            return 240;
        }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"6"]) {
            return 240;
        }else {
            return 240;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"TechicianCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    //添加项目或技师名称的点击事件
    UITapGestureRecognizer *storeBackViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storeBackViewTaped:)];
    cell.storeBackView.tag = indexPath.row;
    [cell.storeBackView addGestureRecognizer:storeBackViewTap];
    //添加门店联系方式的点击事件
    UITapGestureRecognizer *storeTelPhoneViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storeTelPhoneViewTaped:)];
    cell.storeTelPhoneView.tag = indexPath.row;
    [cell.storeTelPhoneView addGestureRecognizer:storeTelPhoneViewTap];
    //添加按钮点击事件
    [cell.IWantButton addTarget:self action:@selector(IWantButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.IWantButton.tag = indexPath.row;
//待付款
    if ([self.menuTag isEqualToString:@"1"]) {
        cell.buttonBackView.hidden = NO;
        cell.storeTelPhoneView.hidden = YES;
        [cell.IWantButton setTitle:@"我要付款" forState:UIControlStateNormal];
        [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
        //状态
        cell.waitingForLabel.text = @"待付款";
        //项目名称
        cell.serviceNameLabel.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
        //项目图片
        [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        //项目小图      判断为到店 显示到店小图
        if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_home"]];
            //             其他则显示上门小图
        }else {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_door"]];
        }
        //名称        判断为华佗自营上门 显示技师名称
        if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"3"]) {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"华佗驾到：%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"workerName"] ];
            //           其他方式则显示门店名称
        }else {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"门店：%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"storeName"] ];
        }
        //时间
        cell.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceStartTime"]];
        //地址        判断为到店 显示店铺地址
        if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"storeAddress"]];
            //           其他则显示用户地址
        }else {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"clientArea"],[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"clientAddress"]];
        }
        //金额
        CGFloat payment = [[[self.payArray objectAtIndex:indexPath.row]objectForKey:@"payment"]floatValue];
        payment = payment/100;
        cell.moneyLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f",payment];
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.moneyLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(6,cell.moneyLabel.text.length-6)];
        [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, cell.moneyLabel.text.length-5)];
        cell.moneyLabel.attributedText = str;
        return cell;
//待服务
    }else if ([self.menuTag isEqualToString:@"2"]) {
        //加钟        判断是否可以加钟 可以则展示"加钟"按钮
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {
            cell.buttonBackView.hidden = YES;
            cell.storeTelPhoneView.hidden = NO;
            cell.storeTelPhoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"storeTel"]];
        }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {
            cell.storeTelPhoneView.hidden = NO;
            cell.storeTelPhoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"storeTel"]];
            //判断是否可以加钟 可以则返回有按钮的高度282
            if ([[[self.serviceArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                cell.buttonBackView.hidden = NO;
                [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            }else {
                cell.buttonBackView.hidden = NO;
                [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                [cell.IWantButton setBackgroundColor:C6UIColorGray];
            }
        }else {
            cell.storeTelPhoneView.hidden = YES;
            //判断是否可以加钟 可以则返回有按钮的高度240
            if ([[[self.serviceArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                cell.buttonBackView.hidden = NO;
                [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            }else {
                cell.buttonBackView.hidden = NO;
                [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                [cell.IWantButton setBackgroundColor:C6UIColorGray];
            }
        }
        //        if ([[[self.serviceArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
        //            cell.buttonBackView.hidden = NO;
        //            [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
        //        }else {
        //            cell.buttonBackView.hidden = YES;
        //        }
        //状态        判断待服务订单状态
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {
            cell.waitingForLabel.text = @"待服务";
        }else {
            if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]) {
                cell.waitingForLabel.text = @"待出发";
            }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"3"]) {
                cell.waitingForLabel.text = @"已出发";
            }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"4"]) {
                cell.waitingForLabel.text = @"服务中";
            }
        }
        //        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]) {//待服务
        //            if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {
        //                cell.waitingForLabel.text = @"待服务";
        //            }else {
        //                cell.waitingForLabel.text = @"待出发";
        //            }
        //        }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"3"]) {
        //            cell.waitingForLabel.text = @"已出发";
        //        }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"4"]) {
        //            cell.waitingForLabel.text = @"服务中";
        //        }
        //项目名称
        cell.serviceNameLabel.text = [[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
        //项目图片
        [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        //项目小图      判断为到店 显示到店小图
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_home"]];
            //             其他则显示上门小图
        }else {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_door"]];
        }
        //名称        判断为华佗自营上门 显示技师名称
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"3"]) {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"华佗驾到：%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"workerName"] ];
            //           其他方式则显示门店名称
        }else {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"门店：%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"storeName"] ];
        }
        //时间
        cell.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceStartTime"]];
        //地址        判断为到店 显示店铺地址
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"storeAddress"]];
            //           其他则显示用户地址
        }else {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"clientArea"],[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"clientAddress"]];
        }
        //金额
        CGFloat payment = [[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"payment"]floatValue];
        payment = payment/100;
        cell.moneyLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f",payment];
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.moneyLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(6,cell.moneyLabel.text.length-6)];
        [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, cell.moneyLabel.text.length-5)];
        cell.moneyLabel.attributedText = str;
        return cell;
//待评论
    }else if ([self.menuTag isEqualToString:@"3"]) {
        cell.buttonBackView.hidden = NO;
        cell.storeTelPhoneView.hidden = YES;
        [cell.IWantButton setTitle:@"我要评论" forState:UIControlStateNormal];
        [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
        //状态
        cell.waitingForLabel.text = @"待评论";
        //项目名称
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
            cell.serviceNameLabel.text = @"闪付";
        }else {
            cell.serviceNameLabel.text = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
        }
        //项目图片      判断为闪付 显示门店头像
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
            [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"storeIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            //             其他则显示项目图标
        }else {
            [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        }
        //项目小图      判断为到店 显示到店小图
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_home"]];
            //             其他则显示上门小图
        }else {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_door"]];
        }
        //名称        判断为华佗自营上门 显示技师名称
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"3"]) {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"华佗驾到：%@",[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"workerName"] ];
            //           其他方式则显示门店名称
        }else {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"门店：%@",[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"storeName"] ];
        }
        //时间
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
            cell.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"orderTime"]];
        }else {
            cell.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@",[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceStartTime"]];
        }
        //地址        判断为到店 显示店铺地址
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"storeAddress"]];
            //           其他则显示用户地址
        }else {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"clientArea"],[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"clientAddress"]];
        }
        //金额
        CGFloat payment = [[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"payment"]floatValue];
        payment = payment/100;
        cell.moneyLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f",payment];
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.moneyLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(6,cell.moneyLabel.text.length-6)];
        [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, cell.moneyLabel.text.length-5)];
        cell.moneyLabel.attributedText = str;
        return cell;
//全部
    }else {
        //按钮名称        判断订单状态 更改按钮的文字
        if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"1"]) {
            cell.buttonBackView.hidden = NO;
            cell.storeTelPhoneView.hidden = YES;
            [cell.IWantButton setTitle:@"我要付款" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //项目名称
            cell.serviceNameLabel.text = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
            //项目图片
            [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"2"]||[[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"3"]||[[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"4"]) {
            if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"serviceType"]isEqualToString:@"1"]) {
                cell.buttonBackView.hidden = YES;
                cell.storeTelPhoneView.hidden = NO;
                cell.storeTelPhoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"storeTel"]];
            }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"serviceType"]isEqualToString:@"2"]) {
                cell.storeTelPhoneView.hidden = NO;
                cell.storeTelPhoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"storeTel"]];
                if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                    cell.buttonBackView.hidden = NO;
                    [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                    [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
                }else {
                    cell.buttonBackView.hidden = NO;
                    [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                    [cell.IWantButton setBackgroundColor:C6UIColorGray];
                }
            }else {
                cell.storeTelPhoneView.hidden = YES;
                if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"isExtensible"]isEqualToString:@"1"]) {
                    cell.buttonBackView.hidden = NO;
                    [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                    [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
                }else {
                    cell.buttonBackView.hidden = NO;
                    [cell.IWantButton setTitle:@"我要加钟" forState:UIControlStateNormal];
                    [cell.IWantButton setBackgroundColor:C6UIColorGray];
                }
            }
            //项目名称
            cell.serviceNameLabel.text = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
            //项目图片
            [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"5"]) {
            cell.buttonBackView.hidden = NO;
            cell.storeTelPhoneView.hidden = YES;
            [cell.IWantButton setTitle:@"我要评论" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //项目名称
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
                cell.serviceNameLabel.text = @"闪付";
            }else {
                cell.serviceNameLabel.text = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
            }
            //项目图片      判断为闪付 显示门店头像
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
                [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"storeIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
                //             其他则显示项目图标
            }else {
                [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"6"]) {
            cell.buttonBackView.hidden = NO;
            cell.storeTelPhoneView.hidden = YES;
            [cell.IWantButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //项目名称
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
                cell.serviceNameLabel.text = @"闪付";
            }else {
                cell.serviceNameLabel.text = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
            }
            //项目图片      判断为闪付 显示门店头像
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
                [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"storeIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
                //             其他则显示项目图标
            }else {
                [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            }
        }else {
            cell.buttonBackView.hidden = NO;
            cell.storeTelPhoneView.hidden = YES;
            [cell.IWantButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //项目名称
            cell.serviceNameLabel.text = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
            //项目图片
            [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        }
        //状态        判断待服务订单状态
        if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"1"]) {
            cell.waitingForLabel.text = @"待付款";
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]) {//待服务
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {
                cell.waitingForLabel.text = @"待服务";
            }else {
                cell.waitingForLabel.text = @"待出发";
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"3"]) {
            cell.waitingForLabel.text = @"已出发";
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"4"]) {
            cell.waitingForLabel.text = @"服务中";
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"5"]) {
            cell.waitingForLabel.text = @"待评论";
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"6"]) {
            cell.waitingForLabel.text = @"已完成";
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"-3"]) {
            cell.waitingForLabel.text = @"已退款";
        }
        //项目小图      判断为到店 显示到店小图
        if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_home"]];
            //             其他则显示上门小图
        }else {
            [cell.homeOrStoreImageView setImage:[UIImage imageNamed:@"icon_order_door"]];
        }
        //名称        判断为华佗自营上门 显示技师名称
        if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"3"]) {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"华佗驾到：%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"workerName"] ];
            //           其他方式则显示门店名称
        }else {
            cell.storeNameLabel.text = [NSString stringWithFormat:@"门店：%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"storeName"] ];
        }
        //时间        判断为闪付 显示下单时间
        if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
            cell.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"orderTime"]];
            //          其他则显示预约时间
        }else {
            cell.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceStartTime"]];
        }
        
        //地址        判断为到店 显示店铺地址
        if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"]isEqualToString:@"1"]) {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"storeAddress"]];
            //           其他则显示用户地址
        }else {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"clientArea"],[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"clientAddress"]];
        }
        //金额
        CGFloat payment = [[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"payment"]floatValue];
        payment = payment/100;
        cell.moneyLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f",payment];
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.moneyLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(6,cell.moneyLabel.text.length-6)];
        [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, cell.moneyLabel.text.length-5)];
        cell.moneyLabel.attributedText = str;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:ORDER_ORDERDETAIL];
//待付款
    if ([self.menuTag isEqualToString:@"1"]) {
        if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
            PayForStoreViewController *vc = [[PayForStoreViewController alloc]init];
            vc.orderID = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
            PayForWorkByStoreViewController *vc = [[PayForWorkByStoreViewController alloc]init];
            vc.orderID = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
            PayForWorkViewController *vc = [[PayForWorkViewController alloc]init];
            vc.orderID = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//待服务
    }else if ([self.menuTag isEqualToString:@"2"]) {
        if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
            WaitForStoreServiceViewController *vc = [[WaitForStoreServiceViewController alloc]init];
            vc.orderID = [[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
            WaitForHomeSericeByStoreViewController *vc = [[WaitForHomeSericeByStoreViewController alloc]init];
            vc.orderID = [[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
            WaitForHomeServiceViewController *vc = [[WaitForHomeServiceViewController alloc]init];
            vc.orderID = [[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//待评论
    }else if ([self.menuTag isEqualToString:@"3"]) {
        if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"2"]) {//闪付订单
            WaitForCommentByQuickPassViewController *vc = [[WaitForCommentByQuickPassViewController alloc]init];
            vc.orderID = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                WaitForStoreCommentViewController *vc = [[WaitForStoreCommentViewController alloc]init];
                vc.orderID = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                WaitForHomeCommentByStoreViewController *vc = [[WaitForHomeCommentByStoreViewController alloc]init];
                vc.orderID = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                WaitForHomeCommentViewController *vc = [[WaitForHomeCommentViewController alloc]init];
                vc.orderID = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
//全部
    }else {
        if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"1"]) {//待付款
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                PayForStoreViewController *vc = [[PayForStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                PayForWorkByStoreViewController *vc = [[PayForWorkByStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                PayForWorkViewController *vc = [[PayForWorkViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]) {//待服务or待出发
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                WaitForStoreServiceViewController *vc = [[WaitForStoreServiceViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                WaitForHomeSericeByStoreViewController *vc = [[WaitForHomeSericeByStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                WaitForHomeServiceViewController *vc = [[WaitForHomeServiceViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"3"]) {//已出发
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                WaitForStoreServiceViewController *vc = [[WaitForStoreServiceViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                WaitForHomeSericeByStoreViewController *vc = [[WaitForHomeSericeByStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                WaitForHomeServiceViewController *vc = [[WaitForHomeServiceViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"4"]) {//服务中
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                WaitForStoreServiceViewController *vc = [[WaitForStoreServiceViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                WaitForHomeSericeByStoreViewController *vc = [[WaitForHomeSericeByStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                WaitForHomeServiceViewController *vc = [[WaitForHomeServiceViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"5"]) {//待评论
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"2"]) {//闪付订单
                WaitForCommentByQuickPassViewController *vc = [[WaitForCommentByQuickPassViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                    WaitForStoreCommentViewController *vc = [[WaitForStoreCommentViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                    WaitForHomeCommentByStoreViewController *vc = [[WaitForHomeCommentByStoreViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                    WaitForHomeCommentViewController *vc = [[WaitForHomeCommentViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"6"]) {//已完成
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"2"]) {//闪付订单
                FinishedByQuickPassViewController *vc = [[FinishedByQuickPassViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                    FinishedStoreViewController *vc = [[FinishedStoreViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                    FinishedHomeByStoreViewController *vc = [[FinishedHomeByStoreViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                    FinishedHomeViewController *vc = [[FinishedHomeViewController alloc]init];
                    vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"-3"]) {//已退款
            if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"1"]) {//到店
                PayBackStoreViewController *vc = [[PayBackStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"2"]) {//到店上门
                PayBackHomeByStoreViewController *vc = [[PayBackHomeByStoreViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([[[self.allArray objectAtIndex:indexPath.row] objectForKey:@"serviceType"] isEqualToString:@"3"]) {//华佗上门
                PayBackHomeViewController *vc = [[PayBackHomeViewController alloc]init];
                vc.orderID = [[self.allArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
#pragma mark - baseTableViewDelegate
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView {
    [self showHudInView:self.view hint:@"正在加载"];
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    } else {
        _pageForHot++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    self.orderTableView.userInteractionEnabled = NO;
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSLog(@"userid === %@",userID);
    if ([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]] ||userID ==nil) {
        //未登录
        NSLog(@"未登录");
        self.isLogin = NO;
    }else{
        //已登陆
        NSLog(@"已登陆");
        self.isLogin = YES;
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"orderStatus":self.menuTag,//待付款
                               @"type":@"1,2",
                               @"pageStart":page,
                               @"pageOffset":@"10",
                               };
        [[RequestManager shareRequestManager] getOrderList:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"result --------待付款msg--------- > %@",[result objectForKey:@"msg"]);
            NSLog(@"result --------待付款result--------- > %@",result);
            [self hideHud];
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                failView.hidden = YES;
                [failView.activityIndicatorView stopAnimating];
                failView.activityIndicatorView.hidden = YES;
                if ([self.menuTag isEqualToString:@"1"]) {
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        [self.payArray removeAllObjects];
                    }
                    NSArray *payClassLesson = [result objectForKey:@"orderList"];
                    [self.payArray addObjectsFromArray:payClassLesson];
                    [self.orderTableView reloadData];
                    self.orderTableView.userInteractionEnabled = YES;
                    self.orderTableView.hidden = NO;
                    [refreshView endRefreshing];
                    //            self.isFirstPayClick = NO;
                    // 1.根据数量判断是否需要隐藏上拉控件
                    if (payClassLesson.count < 10 || payClassLesson.count ==0 ) {
                        [self.orderTableView.foot finishRefreshing];
                    }else {
                        [self.orderTableView.foot endRefreshing];
                    }
                }
                if ([self.menuTag isEqualToString:@"2"]) {
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        [self.serviceArray removeAllObjects];
                    }
                    NSArray *serviceClassLesson = [result objectForKey:@"orderList"];
                    [self.serviceArray addObjectsFromArray:serviceClassLesson];
                    [self.orderTableView reloadData];
                    self.orderTableView.userInteractionEnabled = YES;
                    [refreshView endRefreshing];
                    //                    self.isFirstServiceClick = NO;
                    // 1.根据数量判断是否需要隐藏上拉控件
                    if (serviceClassLesson.count < 10 || serviceClassLesson.count ==0 ) {
                        [self.orderTableView.foot finishRefreshing];
                    }else {
                        [self.orderTableView.foot endRefreshing];
                    }
                }
                if ([self.menuTag isEqualToString:@"3"]) {
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        [self.commentArray removeAllObjects];
                    }
                    NSArray *commentClassLesson = [result objectForKey:@"orderList"];
                    [self.commentArray addObjectsFromArray:commentClassLesson];
                    [self.orderTableView reloadData];
                    self.orderTableView.userInteractionEnabled = YES;
                    [refreshView endRefreshing];
                    //                    self.isFirstCommentClick = NO;
                    // 1.根据数量判断是否需要隐藏上拉控件
                    if (commentClassLesson.count < 10 || commentClassLesson.count ==0 ) {
                        [self.orderTableView.foot finishRefreshing];
                    }else {
                        [self.orderTableView.foot endRefreshing];
                    }
                }
                if ([self.menuTag isEqualToString:@"4"]) {
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        [self.allArray removeAllObjects];
                    }
                    NSArray *allClassLesson = [result objectForKey:@"orderList"];
                    [self.allArray addObjectsFromArray:allClassLesson];
                    [self.orderTableView reloadData];
                    self.orderTableView.userInteractionEnabled = YES;
                    [refreshView endRefreshing];
                    //                    self.isFirstAllClick = NO;
                    // 1.根据数量判断是否需要隐藏上拉控件
                    if (allClassLesson.count < 10 || allClassLesson.count ==0 ) {
                        [self.orderTableView.foot finishRefreshing];
                    }else {
                        [self.orderTableView.foot endRefreshing];
                    }
                }
            }else {
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            }
        } failuer:^(NSError *error) {
//            [self.orderTableView.foot finishRefreshing];
//            [self.orderTableView.head finishRefreshing];
            [self hideHud];
            [refreshView endRefreshing];
            self.orderTableView.userInteractionEnabled = YES;
            failView.hidden = NO;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            //                self.orderTableView.hidden = YES;
        }];
    }
}
- (void)delayShow
{
    [self hideHud];
}
#pragma mark - UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex == 0) {
        NSLog(@"取消");
        return;
    }
    if (buttonIndex == 1) {
        NSLog(@"确定");
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"orderID":deleteOrderID
                               };
        [[RequestManager shareRequestManager] deleteOrder:dic viewController:self successData:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                [self downloadData];
                [self.orderTableView reloadData];
            }else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            }
        } failuer:^(NSError *error) {
        }];
    }
}
#pragma mark - 懒加载
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_no-people"]];
        [self.headImageView.layer setMasksToBounds:YES];
        self.headImageView.layer.cornerRadius = 10.0;
        self.headImageView.layer.borderWidth = 0.5;
        self.headImageView.layer.borderColor = UIColorFromRGB(0xebeae5).CGColor;
    }
    return _headImageView;
}
- (UILabel *)signLabel {
    if (_signLabel == nil) {
        self.signLabel = [[UILabel alloc]init];
        self.signLabel.text = @"登录后才可以查看订单哦";
        self.signLabel.textAlignment = NSTextAlignmentCenter;
        self.signLabel.font = [UIFont systemFontOfSize:14];
        self.signLabel.textColor = C7UIColorGray;
    }
    return _signLabel;
}
- (UIButton *)loginButton {
    if (_loginButton == nil) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal ];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
        [self.loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.loginButton setTintColor:UIColorFromRGB(0xffffff)];
        [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (BaseTableView *)orderTableView {
    if (_orderTableView == nil) {
        self.orderTableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavHeight+35+0.5, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight-35)];
        self.orderTableView.backgroundColor = [UIColor clearColor];
        self.orderTableView.delegates = self;
        self.orderTableView.delegate = self;
        self.orderTableView.dataSource = self;
        self.orderTableView.showsVerticalScrollIndicator = NO;
        self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _orderTableView;
}
- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 35)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = YES;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"待付款", @"待服务", @"待评论", @"全部"];
        
    }
    return _menuView;
}
- (noOrderView *)noOrderView {
    if (_noOrderView == nil) {
        self.noOrderView = [[noOrderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight-35)];
    }
    return _noOrderView;
}
- (UIButton *)flashDealButton {
    if (_flashDealButton == nil) {
        self.flashDealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.flashDealButton setTitle:@"秒杀订单" forState:UIControlStateNormal];
        [self.flashDealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashDealButton setBackgroundColor:[UIColor clearColor]];
        [self.flashDealButton addTarget:self action:@selector(flashDealButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.flashDealButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.flashDealButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _flashDealButton;
}
@end
