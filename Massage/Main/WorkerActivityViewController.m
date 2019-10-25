//
//  WorkerActivityViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/20.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "WorkerActivityViewController.h"
#import "BaseTableView.h"
#import "TechicianListCell.h"

#import "technicianViewController.h"
#import "TechnicianMyselfViewController.h"
@interface WorkerActivityViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>

{
    NSString * orderBy;
    
    UILabel * storeLabel;
    UILabel * serviceLabel;
    UILabel * workerLabel;
    UILabel * foundLabel;
    
    UIView * redlineView;
    BaseTableView * myTableView;
    
    NSMutableArray * workerActArray;
    int _pageForHot;
    
}

@end

@implementation WorkerActivityViewController

-(void)backAction
{
    if ([self.backType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = self.name;
    orderBy = @"1";
    workerActArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initHeadView];
    
    [self loadData];

}

-(void)initHeadView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 35*AUTO_SIZE_SCALE_X)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35*AUTO_SIZE_SCALE_X-0.5,kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [headerView addSubview:zhixianImv];
    
    redlineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/3-55*AUTO_SIZE_SCALE_X)/2, (35-3-1)*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X, 3*AUTO_SIZE_SCALE_X)];
    redlineView.backgroundColor = RedUIColorC1;
    [headerView addSubview:redlineView];
    
    storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3, 35*AUTO_SIZE_SCALE_X)];
    storeLabel.text = @"离我最近";
    storeLabel.tag = 1;
    storeLabel.textColor = RedUIColorC1;
    storeLabel.font = [UIFont systemFontOfSize:13];
    storeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:storeLabel];
    storeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * storeLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [storeLabel addGestureRecognizer:storeLabelTap];
    
    
//    serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, 35*AUTO_SIZE_SCALE_X)];
//    serviceLabel.text = @"价格最低";
//    serviceLabel.tag = 2;
//    serviceLabel.font = [UIFont systemFontOfSize:13];
//    serviceLabel.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:serviceLabel];
//    serviceLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer * serviceLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
//    [serviceLabel addGestureRecognizer:serviceLabelTap];
    
    workerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, 35*AUTO_SIZE_SCALE_X)];
    workerLabel.text = @"评价最高";
    workerLabel.tag = 2;
    workerLabel.font = [UIFont systemFontOfSize:13];
    workerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:workerLabel];
    workerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * workerLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [workerLabel addGestureRecognizer:workerLabelTap];
    
    foundLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/3, 0, kScreenWidth/3, 35*AUTO_SIZE_SCALE_X)];
    foundLabel.text = @"订单最多";
    foundLabel.tag = 3;
    foundLabel.font = [UIFont systemFontOfSize:13];
    foundLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:foundLabel];
    foundLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * foundLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [foundLabel addGestureRecognizer:foundLabelTap];
    
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+35*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-( kNavHeight+35*AUTO_SIZE_SCALE_X))];
    myTableView.delegate = self;
    myTableView.dataSource  = self;
    myTableView.delegates = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    [myTableView.head removeFromSuperview];

}

-(void)headerViewTaped:(UITapGestureRecognizer *)sender
{
    redlineView.frame = CGRectMake((kScreenWidth/3-55*AUTO_SIZE_SCALE_X)/2+kScreenWidth/3*(sender.view.tag-1), (35-3-1)*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X, 3*AUTO_SIZE_SCALE_X);
    storeLabel.textColor = [UIColor blackColor];
    serviceLabel.textColor = [UIColor blackColor];
    workerLabel.textColor = [UIColor blackColor];
    foundLabel.textColor = [UIColor blackColor];
    
    if (sender.view.tag == 1) {
        storeLabel.textColor = RedUIColorC1;
        orderBy = @"1";
        
    }
//    else if (sender.view.tag == 2){
//        serviceLabel.textColor = RedUIColorC1;
//        orderBy = @"2";
//        
//    }
    else if (sender.view.tag == 2){
        workerLabel.textColor = RedUIColorC1;
        orderBy = @"3";
        
    }else if (sender.view.tag == 3){
        foundLabel.textColor = RedUIColorC1;
        orderBy = @"4";
        
    }
    [workerActArray removeAllObjects];
    [self loadData];
}

#pragma mark 加载数据
-(void)loadData
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    
    _pageForHot = 1;
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSDictionary * dic = @{
                           @"ID":self.ID,
                           @"latitude":latitude,
                           @"longitude":longitude,
                           @"pageStart":page,
                           @"pageOffset":@"15",
                           @"orderBy":orderBy,
                           };
    NSLog(@"dic --%@",dic);
    [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"技师活动result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSArray * array = [NSArray arrayWithArray:[result objectForKey:@"skillList"]];
            [workerActArray addObjectsFromArray:array];
            [myTableView reloadData];
            if (workerActArray.count >0) {
                [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            // 1.根据数量判断是否需要隐藏上拉控件
            if (array.count < 15 || array.count ==0 ) {
                [myTableView.foot finishRefreshing];
            }else
            {
                [myTableView.foot endRefreshing];
            }
            
        }
        NDLog(@"msg --> %@",[result objectForKey:@"msg"]);
    } failuer:^(NSError *error) {
        
    }];
}

#pragma mark refreshViewStart

-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];

    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else
    {
        _pageForHot++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"15";
    NSDictionary * dic = @{
                           @"ID":self.ID,
                           @"latitude":latitude,
                           @"longitude":longitude,
                           @"pageStart":page,
                           @"pageOffset":pageOffset,
                           @"orderBy":orderBy,
                           };
    [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"技师活动result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSArray * array = [NSArray arrayWithArray:[result objectForKey:@"skillList"]];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [workerActArray removeAllObjects];
            }
            [workerActArray addObjectsFromArray:array];
            [myTableView reloadData];
            [refreshView endRefreshing];
            // 1.根据数量判断是否需要隐藏上拉控件
            if (array.count < 15 || array.count ==0 ) {
                [myTableView.foot finishRefreshing];
            }else
            {
                [myTableView.foot endRefreshing];
            }
            
        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        //        NDLog(@"msg --> %@",[result objectForKey:@"msg"]);
    } failuer:^(NSError *error) {
        
    }];
    
    
}

#pragma mark UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380.0f*AUTO_SIZE_SCALE_X;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  workerActArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =@"StoreListcell";
    TechicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[TechicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.data = workerActArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSString stringWithFormat:@"%@",[[workerActArray objectAtIndex:indexPath.row] objectForKey:@"isSelfOwned"] ] isEqualToString:@"0"]) {
        technicianViewController *VC =[[technicianViewController alloc] init];
        VC.flag = @"0";
        VC.workerID = [[workerActArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        //        [[RequestManager shareRequestManager].CurrMainController.navigationController pushViewController:VC animated:YES];
        [self.navigationController pushViewController:VC animated:YES    ];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    }
    //自营上门 技师详情
    else if ([[NSString stringWithFormat:@"%@",[[workerActArray objectAtIndex:indexPath.row] objectForKey:@"isSelfOwned"]] isEqualToString:@"1"])
    {
        TechnicianMyselfViewController *VC =[[TechnicianMyselfViewController alloc] init];
        VC.workerID = [[workerActArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        //        [[RequestManager shareRequestManager].CurrMainController.navigationController pushViewController:VC animated:YES];
        [self.navigationController pushViewController:VC animated:YES    ];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
