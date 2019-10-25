//
//  MyOrderViewController.m
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MyOrderViewController.h"
#import "AccountBalanceTableViewCell.h"
#import "BaseTableView.h"
#import "noOrderView.h"
#import "noWifiView.h"
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>
{
    BaseTableView * myTableView;
    noOrderView * nothingView;
    noWifiView * failView;
    NSMutableArray * dataArray;
    int _pageForHot;
}
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.titles = @"账户明细";
    self.view.backgroundColor = C2UIColorGray;
    
    [self initTableView];

    [self downLoadData];
    
}

-(void)downLoadData
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"pageStart":page,
                           @"pageOffset":@"15",
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] CheckaccountDetail:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"账户明细 result --> %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            NSArray *classLesson = [result objectForKey:@"data"];

            [dataArray addObjectsFromArray:classLesson];
//            NSLog(@"账户明细 dataArray --> %@",dataArray);
            if (dataArray.count == 0) {
                nothingView.hidden = NO;
            }else {
                nothingView.hidden = YES;
            }
            [myTableView reloadData];
            if (classLesson.count < 15 || classLesson.count ==0 ) {
                [myTableView.foot finishRefreshing];
            }else
            {
                [myTableView.foot endRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
//        [myTableView.foot finishRefreshing];
//        [myTableView.head finishRefreshing];
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
    }];
}

-(void)initTableView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35*AUTO_SIZE_SCALE_X)];
    headerView.backgroundColor = [UIColor   whiteColor];
    UILabel * AccountBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-15*2, 35*AUTO_SIZE_SCALE_X)];
    AccountBalanceLabel.text = [NSString stringWithFormat:@"余额 : %.2f",[self.acStr doubleValue]/100];
    AccountBalanceLabel.textAlignment = NSTextAlignmentRight;
    AccountBalanceLabel.textColor = RedUIColorC1;
    AccountBalanceLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:AccountBalanceLabel];
    
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate =self;
    myTableView.dataSource = self;
    myTableView.delegates = self;
    [myTableView setTableHeaderView:headerView];
    [self.view addSubview:myTableView];
    //没有相关数据时显示
    nothingView = [[noOrderView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-35*AUTO_SIZE_SCALE_X)];
    nothingView.noOrderLabel.text = @"您还未进行过账户的充值或消费";
    if (dataArray.count == 0) {
        nothingView.hidden = NO;
    }else {
        nothingView.hidden = YES;
    }
    [myTableView addSubview:nothingView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}
- (void)reloadButtonClick:(UIButton *)sender {
    [self downLoadData];
}
#pragma mark UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67*AUTO_SIZE_SCALE_X;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =@"AccountBalanceTableViewCell";
 
     AccountBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[AccountBalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.listArrayData = [dataArray objectAtIndex:indexPath.row];

    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark 刷新数据
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    UITableView *tableView = (UITableView *)[refreshView superview];
    if (tableView == myTableView) {
        NSLog(@"刷新账户明细");
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            _pageForHot = 1;
        }
        else
        {
            _pageForHot++;
        }
        NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"pageStart":page,
                               @"pageOffset":@"15",
                               };
        [[RequestManager shareRequestManager] CheckaccountDetail:dic viewController:self successData:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                failView.hidden = YES;
                [failView.activityIndicatorView stopAnimating];
                failView.activityIndicatorView.hidden = YES;
                NSArray *classLesson = [result objectForKey:@"data"];
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [dataArray removeAllObjects];
                }
                [dataArray addObjectsFromArray:classLesson];
                [myTableView reloadData];
                [refreshView endRefreshing];
                //            [self performSelector:@selector(delayShow) withObject:self afterDelay:2.0];
                // 1.根据数量判断是否需要隐藏上拉控件
                if (classLesson.count < 15 || classLesson.count ==0 ) {
                    [myTableView.foot finishRefreshing];
                }else
                {
                    [myTableView.foot endRefreshing];
                }
            }else {
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            }
            
        } failuer:^(NSError *error) {
//            [myTableView.foot finishRefreshing];
//            [myTableView.head finishRefreshing];
            [refreshView endRefreshing];
            failView.hidden = NO;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
        }];
        
    }
}

@end
