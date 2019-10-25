//
//  FlashDealViewController.m
//  Massage
//
//  Created by 牛先 on 16/2/23.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDealViewController.h"
#import "BaseTableView.h"
#import "menuVIew.h"
#import "noOrderView.h"
#import "noWifiView.h"
#import "FlashDealCell.h"
#import "FlashDealPayViewController.h"
#import "FlashDealServiceViewController.h"
#import "FlashDealCommentViewController.h"
#import "FlashDealFinishViewController.h"
#import "PayForFlashDealViewController.h"
#import "StoreDetailViewController.h"
#import "StoreCommentViewController.h"

#import "UIImageView+WebCache.h"

@interface FlashDealViewController () <UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,menuViewDelegate>

@property (strong, nonatomic) BaseTableView *orderTableView;
@property (strong, nonatomic) menuVIew *menuView;
//无订单
@property (strong, nonatomic) noOrderView *noOrderView;
//菜单栏相关属性
@property (strong, nonatomic) NSString *menuTag;
//存储接口返回数据
@property (strong, nonatomic) NSMutableArray *notFinishiArray;
@property (strong, nonatomic) NSMutableArray *finishiArray;
@end

@implementation FlashDealViewController {
    //用来存储可删除的订单编号
    NSString *deleteOrderID;
    //订单页数
    int _pageForHot;
    noWifiView *failView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"秒杀订单";
    //初始化
    self.menuTag = @"1";
    self.notFinishiArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.finishiArray = [[NSMutableArray alloc]initWithCapacity:0];
    deleteOrderID = @"";
    
    [self downloadData];
    [self initView];
    
    //接收评论订单变化的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CommentOrderNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentOrderDataNtf:) name:@"CommentOrderNtf" object:nil];
    //接收待付款订单变化的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PayOrderNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderDataNtf:) name:@"PayOrderNtf" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //接收menuView通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuChange:) name:@"menuViewKey" object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"menuViewKey" object:nil];
}
#pragma mark 获取数据
- (void)downloadData {
    [self showHudInView:self.view hint:@"正在加载"];
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSString *menuTag = [NSString stringWithFormat:@"%d",[self.menuTag intValue]+4];
    NSLog(@"运行时的menuTag:%@",menuTag);
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"orderStatus":menuTag,
                           @"type":@"3",
                           };
    [[RequestManager shareRequestManager] getOrderList:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"result --------未完成result--------- > %@",result);
        failView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            if ([self.menuTag isEqualToString:@"1"]) {
                NSArray *notFinishiClassLesson = [result objectForKey:@"orderList"];
                [self.notFinishiArray removeAllObjects];
                [self.notFinishiArray addObjectsFromArray:notFinishiClassLesson];
                if (self.notFinishiArray.count > 0) {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = YES;
                }else {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = NO;
                }
                [self.orderTableView reloadData];
                if (notFinishiClassLesson.count < 10 ||notFinishiClassLesson.count == 0) {
                    [self.orderTableView.foot finishRefreshing];
                }
                else{
                    [self.orderTableView.foot endRefreshing];
                }
            }
            if ([self.menuTag isEqualToString:@"2"]) {
                NSArray *finishiClassLesson = [result objectForKey:@"orderList"];
                [self.finishiArray removeAllObjects];
                [self.finishiArray addObjectsFromArray:finishiClassLesson];
                if (self.finishiArray.count > 0) {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = YES;
                }else {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = NO;
                }
                [self.orderTableView reloadData];
                if (finishiClassLesson.count < 10 ||finishiClassLesson.count == 0) {
                    [self.orderTableView.foot finishRefreshing];
                }
                else{
                    [self.orderTableView.foot endRefreshing];
                }
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
- (void)initView {
    [self.view addSubview:self.menuView];
    [self.orderTableView addSubview:self.noOrderView];
    [self.view addSubview:self.orderTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight+40, kScreenWidth, kScreenHeight-kNavHeight-40)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}
#pragma mark - 通知相关方法
//menuView通知 点击切换不同的订单状态
//- (void)menuChange:(NSDictionary *)dic {
//    NSDictionary *dict = [dic valueForKey:@"userInfo"];
//    self.menuTag = [dict objectForKey:@"menuView"];
//    //未完成
//    if ([self.menuTag isEqualToString:@"1"]) {
//        NDLog(@"未完成");
//        [self downloadData];
//        if (self.notFinishiArray.count > 0) {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = YES;
//        }else {
//            self.orderTableView.hidden = NO;
//            self.noOrderView.hidden = NO;
//        }
//        [self.orderTableView reloadData];
//    //已完成
//    }else {
//        NDLog(@"已完成");
//        [self downloadData];
//        if (self.finishiArray.count > 0) {
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
    if (number == 1) {
        NDLog(@"未完成");
        [self downloadData];
        if (self.notFinishiArray.count > 0) {
            self.orderTableView.hidden = NO;
            self.noOrderView.hidden = YES;
        }else {
            self.orderTableView.hidden = NO;
            self.noOrderView.hidden = NO;
        }
        [self.orderTableView reloadData];
    }else{
        [self downloadData];
        if (self.finishiArray.count > 0) {
            self.orderTableView.hidden = NO;
            self.noOrderView.hidden = YES;
        }else {
            self.orderTableView.hidden = NO;
            self.noOrderView.hidden = NO;
        }
        [self.orderTableView reloadData];
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
#pragma mark - 按钮点击事件
- (void)reloadButtonClick:(UIButton *)sender {
    [self downloadData];
}
//项目或技师名称
- (void)storeBackViewTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"点击这里需要跳转到对应的项目详情或者技师详情页面--%ld",(long)sender.view.tag);
    //未完成
    if ([self.menuTag isEqualToString:@"1"]) {
        StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
        vc.storeID = [[self.notFinishiArray objectAtIndex:sender.view.tag]objectForKey:@"storeID"];
        [self.navigationController pushViewController:vc animated:YES];
    //已完成
    }else {
        StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
        vc.storeID = [[self.finishiArray objectAtIndex:sender.view.tag]objectForKey:@"storeID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//"我要"按钮
- (void)IWantButtonClick:(UIButton *)sender {
    //未完成
    if ([self.menuTag isEqualToString:@"1"]) {
        //待付款
        if ([[[self.notFinishiArray objectAtIndex:sender.tag] objectForKey:@"status"] isEqualToString:@"1"]) {
            PayForFlashDealViewController *vc = [[PayForFlashDealViewController alloc]init];
            vc.orderID = [[self.notFinishiArray objectAtIndex:sender.tag]objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        //待服务
        }else if ([[[self.notFinishiArray objectAtIndex:sender.tag] objectForKey:@"status"] isEqualToString:@"2"]) {
            //do nothing...
        //待评论
        }else if ([[[self.notFinishiArray objectAtIndex:sender.tag] objectForKey:@"status"] isEqualToString:@"5"]) {
            StoreCommentViewController *vc = [[StoreCommentViewController alloc]init];
            vc.orderID = [[self.notFinishiArray objectAtIndex:sender.tag]objectForKey:@"ID"];
            vc.isFromFlashDeal = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    //已完成
    }else {
        //删除
        if ([[[self.finishiArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"6"]||[[[self.finishiArray objectAtIndex:sender.tag]objectForKey:@"status"]isEqualToString:@"-3"]) {
            NSLog(@"删除订单");
            deleteOrderID = [[self.finishiArray objectAtIndex:sender.tag] objectForKey:@"ID"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"是否确定删除该订单"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
    }
}
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //未完成
    if ([self.menuTag isEqualToString:@"1"]) {
        return self.notFinishiArray.count;
    //已完成
    }else {
        return self.finishiArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menuTag isEqualToString:@"1"]) {
        if ([[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]) {
            return 180;
        }else {
            return 241;
        }
    }else {
        return 241;//180
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"FlashDealCell";
    FlashDealCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[FlashDealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    //添加项目或技师名称的点击事件
    UITapGestureRecognizer *storeBackViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storeBackViewTaped:)];
    cell.storeBackView.tag = indexPath.row;
    [cell.storeBackView addGestureRecognizer:storeBackViewTap];
    //添加按钮点击事件
    [cell.IWantButton addTarget:self action:@selector(IWantButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.IWantButton.tag = indexPath.row;
    //未完成
    if ([self.menuTag isEqualToString:@"1"]) {
        //按钮名称        判断订单状态 更改按钮的文字
        if ([[[self.notFinishiArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"1"]) {
            cell.buttonBackView.hidden = NO;
            [cell.IWantButton setTitle:@"我要付款" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //状态
            cell.waitingForLabel.text = @"待付款";
        }else if ([[[self.notFinishiArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"2"]) {
            cell.buttonBackView.hidden = YES;
            //状态
            cell.waitingForLabel.text = @"待服务";
        }else if ([[[self.notFinishiArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"5"]) {
            cell.buttonBackView.hidden = NO;
            [cell.IWantButton setTitle:@"我要评论" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //状态
            cell.waitingForLabel.text = @"待评论";
        }
        //门店名称
        cell.storeNameLabel.text = [NSString stringWithFormat:@"门店：%@",[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"storeName"] ];
        //项目名称
        cell.serviceNameLabel.text = [[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
        //项目图片
        [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        //地址
        cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"storeAddress"]];
        //金额
        CGFloat payment = [[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"payment"]floatValue];
        payment = payment/100;
        cell.moneyLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f",payment];
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.moneyLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(6,cell.moneyLabel.text.length-6)];
        [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, cell.moneyLabel.text.length-5)];
        cell.moneyLabel.attributedText = str;
        return cell;
    }else {
        if ([[[self.finishiArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"6"]||[[[self.finishiArray objectAtIndex:indexPath.row]objectForKey:@"status"]isEqualToString:@"-3"]) {
            //按钮名称        判断订单状态 更改按钮的文字
            cell.buttonBackView.hidden = NO;
            [cell.IWantButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.IWantButton setBackgroundColor:[UIColor whiteColor]];
            //状态
            cell.waitingForLabel.text = @"已完成";
            //门店名称
            cell.storeNameLabel.text = [NSString stringWithFormat:@"门店：%@",[[self.finishiArray objectAtIndex:indexPath.row] objectForKey:@"storeName"] ];
            //项目名称
            cell.serviceNameLabel.text = [[self.finishiArray objectAtIndex:indexPath.row] objectForKey:@"serviceName"];
            //项目图片
            [cell.storeImageView setImageWithURL:[NSURL URLWithString:[[self.finishiArray objectAtIndex:indexPath.row] objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            //地址
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[self.finishiArray objectAtIndex:indexPath.row] objectForKey:@"storeAddress"]];
            //金额
            CGFloat payment = [[[self.finishiArray objectAtIndex:indexPath.row] objectForKey:@"payment"]floatValue];
            payment = payment/100;
            cell.moneyLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f",payment];
            //对小字体进行处理
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.moneyLabel.text];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(6,cell.moneyLabel.text.length-6)];
            [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, cell.moneyLabel.text.length-5)];
            cell.moneyLabel.attributedText = str;
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menuTag isEqualToString:@"1"]) {
        //待付款
        if ([[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"1"]) {
            FlashDealPayViewController *vc = [[FlashDealPayViewController alloc]init];
            vc.orderID = [[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        //待服务
        }else if ([[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"2"]) {
            FlashDealServiceViewController *vc = [[FlashDealServiceViewController alloc]init];
            vc.orderID = [[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        //待评论
        }else if ([[[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"5"]) {
            FlashDealCommentViewController *vc = [[FlashDealCommentViewController alloc]init];
            vc.orderID = [[self.notFinishiArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        //已完成
        FlashDealFinishViewController *vc = [[FlashDealFinishViewController alloc]init];
        vc.orderID = [[self.finishiArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
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
    NSString *menuTag = [NSString stringWithFormat:@"%d",[self.menuTag intValue]+4];
    NSLog(@"运行时的menuTag:%@",menuTag);
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"orderStatus":menuTag,//待付款
                           @"type":@"3",
                           @"pageStart":page,
                           @"pageOffset":@"10",
                           };
    [[RequestManager shareRequestManager] getOrderList:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"result --------未完成msg--------- > %@",[result objectForKey:@"msg"]);
        NSLog(@"result --------未完成result--------- > %@",result);
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            if ([self.menuTag isEqualToString:@"1"]) {
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [self.notFinishiArray removeAllObjects];
                }
                NSArray *notFinishiClassLesson = [result objectForKey:@"orderList"];
                [self.notFinishiArray addObjectsFromArray:notFinishiClassLesson];
                if (self.notFinishiArray.count > 0) {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = YES;
                }else {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = NO;
                }
                [self.orderTableView reloadData];
                self.orderTableView.userInteractionEnabled = YES;
                self.orderTableView.hidden = NO;
                [refreshView endRefreshing];
                // 1.根据数量判断是否需要隐藏上拉控件
                if (notFinishiClassLesson.count < 10 || notFinishiClassLesson.count ==0 ) {
                    [self.orderTableView.foot finishRefreshing];
                }else {
                    [self.orderTableView.foot endRefreshing];
                }
            }
            if ([self.menuTag isEqualToString:@"2"]) {
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [self.finishiArray removeAllObjects];
                }
                NSArray *finishiClassLesson = [result objectForKey:@"orderList"];
                [self.finishiArray addObjectsFromArray:finishiClassLesson];
                if (self.finishiArray.count > 0) {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = YES;
                }else {
                    self.orderTableView.hidden = NO;
                    self.noOrderView.hidden = NO;
                }
                [self.orderTableView reloadData];
                self.orderTableView.userInteractionEnabled = YES;
                [refreshView endRefreshing];
                // 1.根据数量判断是否需要隐藏上拉控件
                if (finishiClassLesson.count < 10 || finishiClassLesson.count ==0 ) {
                    [self.orderTableView.foot finishRefreshing];
                }else {
                    [self.orderTableView.foot endRefreshing];
                }
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        [self hideHud];
        [refreshView endRefreshing];
        self.orderTableView.userInteractionEnabled = YES;
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
    }];
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
- (BaseTableView *)orderTableView {
    if (_orderTableView == nil) {
        self.orderTableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavHeight+35+0.5, kScreenWidth, kScreenHeight-kNavHeight-35-0.5)];
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
        self.menuView.isNotification = NO;
        self.menuView.delegate = self;
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.menuArray = @[@"未完成", @"已完成"];
        
    }
    return _menuView;
}
- (noOrderView *)noOrderView {
    if (_noOrderView == nil) {
        self.noOrderView = [[noOrderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-35-0.5)];
        self.noOrderView.hidden = YES;
    }
    return _noOrderView;
}
@end
