//
//  MyFavoritesViewController.m
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//
#define betweenHeight 6
#define cellHeight 310*AUTO_SIZE_SCALE_X

#import "MyFavoritesViewController.h"
#import "BaseTableView.h"
#import "CustomCellTableViewCell.h"
#import "TechicianListCell.h"
#import "publicTableViewCell.h"
#import "StoreListTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "StoreDetailViewController.h"
#import "ServiceDetailViewController.h"
#import "TechnicianMyselfViewController.h"
#import "technicianViewController.h"
#import "StoreFoundViewController.h"
#import "ServiceFoundViewController.h"
#import "WorkerFoundViewController.h"
#import "DetailFoundViewController.h"

#import "noOrderView.h"
#import "noWifiView.h"
@interface MyFavoritesViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray * storeArray;
    NSMutableArray * serviceArray;
    NSMutableArray * workerArray;
    NSMutableArray * foundArray;
    
    UILabel * storeLabel;
    UILabel * serviceLabel;
    UILabel * workerLabel;
    UILabel * foundLabel;
    
    UIView * redlineView;
    
    BaseTableView * myTableView;
    noOrderView * noFavoritesView;
    noWifiView * failView;
    
    long currentShow;
    
    NSArray *listViewData;
    
    NSString * type;
    int _pageForHot;
    
    NSString * serviceType;
    
    UIAlertView * invalidAlert;
    
    NSDictionary * resultDic;

}
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) NSMutableArray *ALLData;
@end

@implementation MyFavoritesViewController

#pragma mark 接收广播
-(void)gotoServiceDetailController:(NSNotification *)notification
{
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:notification.object];
    ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
    vc.haveWorker = NO;
    vc.serviceType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]];
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
        vc.isStore = YES;
        vc.isSelfOwned = @"0";
    }else if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
        vc.isStore = NO;
        vc.isSelfOwned = @"1";
    }
    vc.serviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
    [vc returnText:^(NSString *change) {
        if ([change isEqualToString:@"1"]) {
            [self loadData];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @"我的收藏";
    type = @"0";
    storeArray = [[NSMutableArray alloc] initWithCapacity:0];
    serviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    workerArray = [[NSMutableArray alloc] initWithCapacity:0];
    foundArray = [[NSMutableArray alloc] initWithCapacity:0];
    currentShow = 1;
    
    invalidAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

    [self initTypeView];
    
    [self loadData];
}

-(void)loadData
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    NSString * pageOffset = @"15";
    if ([type isEqualToString:@"1"]) {
        pageOffset = @"30";
    }
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"type":type,//0 门店 1服务 2 技师 3 发现
                           @"latitude":latitude,
                           @"longitude":longitude,
                           @"pageStart":@"1",
                           @"pageOffset":pageOffset,
                           };
    NDLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] getUserCollections:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"查询收藏 %@",result);
        if ([[result objectForKey:@"code"]isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            resultDic = [NSDictionary dictionaryWithDictionary:result];
            NSString * invalidName = [NSString stringWithFormat:@"%@",[result objectForKey:@"invalidName"]];
            int invalidCount = [[NSString stringWithFormat:@"%@",[result objectForKey:@"invalidCount"]] intValue];
            NSLog(@"invalidCount-->%d",invalidCount);

            if (invalidCount == 1) {
                invalidAlert.title = @"提示";
                invalidAlert.message = [NSString stringWithFormat:@"您收藏的“%@”已下线，该收藏失效，敬请悉知",invalidName];
                [invalidAlert show];
            }else if(invalidCount > 1){
                invalidAlert.title = @"提示";
                invalidAlert.message = [NSString stringWithFormat:@"您收藏的多条信息已下线，该收藏失效，敬请悉知"];
                [invalidAlert show];
            }else{
                [self makeArray];
            }
            
            
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self makeArray];
    }
}

-(void)makeArray
{
    if ([type isEqualToString:@"0"]) {
        [storeArray removeAllObjects];
        NSArray * array = [resultDic objectForKey:@"storeList"];
        [storeArray addObjectsFromArray:array];
        [myTableView reloadData];
        if (array.count == 0) {
            noFavoritesView.hidden = NO;
        }else {
            noFavoritesView.hidden = YES;
        }
        // 1.根据数量判断是否需要隐藏上拉控件
        if (array.count < 15 || array.count ==0 ) {
            [myTableView.foot finishRefreshing];
        }else
        {
            [myTableView.foot endRefreshing];
        }
        
            }
    if ([type isEqualToString:@"1"]) {
        [serviceArray removeAllObjects];
        NSMutableArray * array = [NSMutableArray arrayWithArray: [resultDic objectForKey:@"serviceList"] ];
        if (array.count == 0) {
            noFavoritesView.hidden = NO;
        }else {
            noFavoritesView.hidden = YES;
        }
        NSMutableArray * array1 =[NSMutableArray array];
        if (array.count > 0) {
            NSMutableArray *cellArray = [array1 lastObject];
            for (int i = 0; i < array.count; i++) {
                if (cellArray.count == 2 || cellArray == nil) {
                    cellArray = [NSMutableArray arrayWithCapacity:2];
                    [array1 addObject:cellArray];
                }
                NSDictionary *dic = array[i];
                [cellArray addObject:dic];
            }
        }
        [ serviceArray addObjectsFromArray:array1];
        [myTableView reloadData];

        NDLog(@"查询收藏 array1------%@",array1);
        // 1.根据数量判断是否需要隐藏上拉控件
        if (array.count < 30 || array.count ==0 ) {
            [myTableView.foot finishRefreshing];
        }else
        {
            [myTableView.foot endRefreshing];
        }
        
    }
    if ([type isEqualToString:@"2"]) {
        [workerArray removeAllObjects];
        NSMutableArray * array = [NSMutableArray arrayWithArray: [resultDic objectForKey:@"skillList"] ];
        [workerArray addObjectsFromArray:array];
        [myTableView reloadData];
        if (array.count == 0) {
            noFavoritesView.hidden = NO;
        }else {
            noFavoritesView.hidden = YES;
        }
        // 1.根据数量判断是否需要隐藏上拉控件
        if (array.count < 15 || array.count ==0 ) {
            [myTableView.foot finishRefreshing];
        }else
        {
            [myTableView.foot endRefreshing];
        }
        
    }
    if ([type isEqualToString:@"3"]){
        [foundArray removeAllObjects];
        NSArray * array = [NSArray arrayWithArray:[resultDic objectForKey:@"discoverList"]];
        [foundArray addObjectsFromArray:array];
        [myTableView reloadData];
        if (array.count == 0) {
            noFavoritesView.hidden = NO;
        }else {
            noFavoritesView.hidden = YES;
        }
        // 1.根据数量判断是否需要隐藏上拉控件
        if (array.count < 15 || array.count ==0 ) {
            [myTableView.foot finishRefreshing];
        }else
        {
            [myTableView.foot endRefreshing];
        }
            }

}

-(void)initTypeView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 35*AUTO_SIZE_SCALE_X)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35*AUTO_SIZE_SCALE_X-0.5,kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [headerView addSubview:zhixianImv];
    
    redlineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/4-45*AUTO_SIZE_SCALE_X)/2, (35-3-1)*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, 3*AUTO_SIZE_SCALE_X)];
    redlineView.backgroundColor = RedUIColorC1;
    [headerView addSubview:redlineView];
    
    storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4, 35*AUTO_SIZE_SCALE_X)];
    storeLabel.text = @"门店";
    storeLabel.tag = 1;
    storeLabel.textColor = RedUIColorC1;
    storeLabel.font = [UIFont systemFontOfSize:13];
    storeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:storeLabel];
    storeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * storeLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [storeLabel addGestureRecognizer:storeLabelTap];
    
    
    serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/4, 0, kScreenWidth/4, 35*AUTO_SIZE_SCALE_X)];
    serviceLabel.text = @"项目";
    serviceLabel.tag = 2;
    serviceLabel.font = [UIFont systemFontOfSize:13];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:serviceLabel];
    serviceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * serviceLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [serviceLabel addGestureRecognizer:serviceLabelTap];
    
    workerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/4, 35*AUTO_SIZE_SCALE_X)];
    workerLabel.text = @"技师";
    workerLabel.tag = 3;
    workerLabel.font = [UIFont systemFontOfSize:13];
    workerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:workerLabel];
    workerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * workerLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [workerLabel addGestureRecognizer:workerLabelTap];
    
    foundLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/4, 0, kScreenWidth/4, 35*AUTO_SIZE_SCALE_X)];
    foundLabel.text = @"发现";
    foundLabel.tag = 4;
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
//没有相关数据时显示
    noFavoritesView = [[noOrderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-( kNavHeight+35*AUTO_SIZE_SCALE_X))];
    noFavoritesView.noOrderLabel.text = @"您还没有收藏";
    noFavoritesView.hidden = YES;
//    if ([type isEqualToString:@"0"]) {
//        if (storeArray.count == 0) {
//            noFavoritesView.hidden = NO;
//        }else {
//            noFavoritesView.hidden = YES;
//        }
//    }
//    if ([type isEqualToString:@"1"]) {
//        if (serviceArray.count == 0) {
//            noFavoritesView.hidden = NO;
//        }else {
//            noFavoritesView.hidden = YES;
//        }
//    }
//    if ([type isEqualToString:@"2"]) {
//        if (workerArray.count == 0) {
//            noFavoritesView.hidden = NO;
//        }else {
//            noFavoritesView.hidden = YES;
//        }
//    }
//    if ([type isEqualToString:@"3"]) {
//        if (foundArray.count == 0) {
//            noFavoritesView.hidden = NO;
//        }else {
//            noFavoritesView.hidden = YES;
//        }
//    }
    [myTableView addSubview:noFavoritesView];
//加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight+35*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-( kNavHeight+35*AUTO_SIZE_SCALE_X))];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}
- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)headerViewTaped:(UITapGestureRecognizer *)sender
{
    redlineView.frame = CGRectMake((kScreenWidth/4-45*AUTO_SIZE_SCALE_X)/2+kScreenWidth/4*(sender.view.tag-1), (35-3-1)*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, 3*AUTO_SIZE_SCALE_X);
    storeLabel.textColor = [UIColor blackColor];
    serviceLabel.textColor = [UIColor blackColor];
    workerLabel.textColor = [UIColor blackColor];
    foundLabel.textColor = [UIColor blackColor];
    currentShow = sender.view.tag;
    NSLog(@" currentShow  %ld",currentShow);
    if (sender.view.tag == 1) {
        storeLabel.textColor = RedUIColorC1;
        type = [NSString stringWithFormat:@"%ld",currentShow-1];
        [self loadData];
        
    }else if (sender.view.tag == 2){
        serviceLabel.textColor = RedUIColorC1;
        type = [NSString stringWithFormat:@"%ld",currentShow-1];
        [self loadData];
        
    }else if (sender.view.tag == 3){
        workerLabel.textColor = RedUIColorC1;
        type = [NSString stringWithFormat:@"%ld",currentShow-1];
        [self loadData];
        
    }else if (sender.view.tag == 4){
        foundLabel.textColor = RedUIColorC1;
        type = [NSString stringWithFormat:@"%ld",currentShow-1];
        [self loadData];
        
    }
}

#pragma mark 上下来刷新
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else
    {
        _pageForHot++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"15";
    if ([type isEqualToString:@"1"]) {
        pageOffset = @"30";
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"type":type,//0 门店 1服务 2 技师 3 发现
                           @"latitude":latitude,
                           @"longitude":longitude,
                           @"pageStart":page,
                           @"pageOffset":pageOffset,
                           };

    [[RequestManager shareRequestManager] getUserCollections:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"查询收藏 %@",result);
        if ([[result objectForKey:@"code"]isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            
//            resultDic = [NSDictionary dictionaryWithDictionary:result];
//            NSString * invalidName = [NSString stringWithFormat:@"%@",[result objectForKey:@"invalidName"]];
//            int invalidCount = [[NSString stringWithFormat:@"%@",[result objectForKey:@"invalidCount"]] intValue];
//            NSLog(@"invalidCount-->%d",invalidCount);
//            
//            if (invalidCount == 1) {
//                invalidAlert.title = @"提示";
//                invalidAlert.message = [NSString stringWithFormat:@"您收藏的“%@”已下线，该收藏失效，敬请悉知",invalidName];
//                [invalidAlert show];
//            }else if(invalidCount > 1){
//                invalidAlert.title = @"提示";
//                invalidAlert.message = [NSString stringWithFormat:@"您收藏的多条信息已下线，该收藏失效，敬请悉知"];
//                [invalidAlert show];
//            }else{
//                [self makeArray];
//            }

            if ([type isEqualToString:@"0"]) {
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [storeArray removeAllObjects];
                }
                NSArray * array = [result objectForKey:@"storeList"];
                [storeArray addObjectsFromArray:array];
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
            if ([type isEqualToString:@"1"]) {
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [serviceArray removeAllObjects];
                }
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"serviceList"] ];
                NSMutableArray * array1 =[NSMutableArray array];
                if (array.count > 0) {
                    NSMutableArray *cellArray = [array1 lastObject];
                    for (int i = 0; i < array.count; i++) {
                        if (cellArray.count == 2 || cellArray == nil) {
                            cellArray = [NSMutableArray arrayWithCapacity:2];
                            [array1 addObject:cellArray];
                        }
                        NSDictionary *dic = array[i];
                        [cellArray addObject:dic];
                    }
                }
                [ serviceArray addObjectsFromArray:array1];
                [myTableView reloadData];
                [refreshView endRefreshing];
                // 1.根据数量判断是否需要隐藏上拉控件
                if (array.count < 30 || array.count ==0 ) {
                    [myTableView.foot finishRefreshing];
                }else
                {
                    [myTableView.foot endRefreshing];
                }
                
            }
            if ([type isEqualToString:@"2"]) {
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [workerArray removeAllObjects];
                }
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"skillList"] ];
                [workerArray addObjectsFromArray:array];
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
            if ([type isEqualToString:@"3"]){
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [foundArray removeAllObjects];
                }
                NSArray * array = [NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
                [foundArray addObjectsFromArray:array];
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
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        NSLog(@"msg--%@",[result objectForKey:@"msg"]);
    } failuer:^(NSError *error) {
//        [myTableView.head finishRefreshing];
//        [myTableView.foot finishRefreshing];
        [refreshView endRefreshing];
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        
    }];

}

#pragma mark UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentShow == 1) {
        return cellHeight;
    }else if(currentShow == 2) {
//        return (108.75f+10.0f+88.0f)*AUTO_SIZE_SCALE_X;
        return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f;

    }else if(currentShow == 3) {
        return 380.0f*AUTO_SIZE_SCALE_X;
    }else{
        return  226*AUTO_SIZE_SCALE_X;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentShow == 1) {
        return storeArray.count;
    }else if(currentShow == 2) {
        return serviceArray.count;
    }else if(currentShow == 3) {
        return workerArray.count;
    }else if(currentShow == 4) {
        return foundArray.count;
    }else{
        return  0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentShow == 1) {
        static NSString *identify =@"StoreListcell";
        StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[StoreListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        if (storeArray.count>0) {
            cell.listArrayData = storeArray[indexPath.row];
//            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.backgroundColor = [UIColor clearColor];

        return cell;
        
    }else if(currentShow == 2) {
        static NSString *identify =@"doorcell";
        
        CustomCellTableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier: identify];
        
        if (cell == nil) {
            cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        
       
        if (serviceArray.count>0) {
            cell.data = serviceArray[indexPath.row];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }else if(currentShow == 3) {
        static NSString *identify =@"TechicianCell";
        TechicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[TechicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        if (workerArray.count>0) {
            cell.data = workerArray[indexPath.row];
        }
        cell.backgroundColor = [UIColor clearColor];

        return cell;
        
    }
    else if(currentShow == 4){
        NSString * publicCell = @"publicTableViewCell";
        publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:publicCell];
        if (cell == nil) {
            NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:nil options:nil];
            cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (foundArray.count > 0) {
            UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 225*AUTO_SIZE_SCALE_X)];
            [imgV setImageWithURL:[NSURL URLWithString:[[foundArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            [cell addSubview:imgV];
            
            UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175*AUTO_SIZE_SCALE_X, 190*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
            
            infoLabel.text = [NSString stringWithFormat:@"%@",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
            infoLabel.textColor = [UIColor  whiteColor];
            infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
            infoLabel.numberOfLines = 0;
            infoLabel.font = [UIFont systemFontOfSize:15];
            [cell addSubview:infoLabel];
            
            UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-100*AUTO_SIZE_SCALE_X, 195*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
            timeLabel.text = [NSString stringWithFormat:@"%@发布",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"publishDate"]];
            timeLabel.textColor = C6UIColorGray;
            //    timeLabel.numberOfLines = 0;
            timeLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:timeLabel];

        }
        
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;

    }
    else {
        return  nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentShow == 1) {
        StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
        vc.storeID = [[storeArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        [vc returnText:^(NSString *change) {
            if ([change isEqualToString:@"1"]) {
                [self loadData];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];

    }else if(currentShow == 2) {
       
    }else if(currentShow == 3) {
        if ([[NSString stringWithFormat:@"%@",[[workerArray objectAtIndex:indexPath.row] objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
            TechnicianMyselfViewController * vc = [[TechnicianMyselfViewController alloc] init];
            vc.workerID = [NSString stringWithFormat:@"%@",[[workerArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            [vc returnText:^(NSString *change) {
                if ([change isEqualToString:@"1"]) {
                    [self loadData];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];

        }else{
            technicianViewController * vc = [[technicianViewController alloc] init];
            vc.workerID = [NSString stringWithFormat:@"%@",[[workerArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            vc.flag = @"0";
            [vc returnText:^(NSString *change) {
                if ([change isEqualToString:@"1"]) {
                    [self loadData];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];

        }
    }else if(currentShow == 4) {
        //DetailFoundViewController
        
        NSString * foundtype = [NSString stringWithFormat:@"%@",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
        //0 门店 1服务 2 技师 3图文 StoreFoundViewController
        if ([foundtype isEqualToString:@"0"]) {
            StoreFoundViewController * vc = [[StoreFoundViewController alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            [vc returnText:^(NSString *change) {
                if ([change isEqualToString:@"1"]) {
                    [self loadData];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
        }
        else if ([foundtype isEqualToString:@"1"]){
            ServiceFoundViewController * vc = [[ServiceFoundViewController alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            [vc returnText:^(NSString *change) {
                if ([change isEqualToString:@"1"]) {
                    [self loadData];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
        }
        else if ([foundtype isEqualToString:@"2"]){
            WorkerFoundViewController * vc = [[WorkerFoundViewController alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            [vc returnText:^(NSString *change) {
                if ([change isEqualToString:@"1"]) {
                    [self loadData];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
        }
        else if ([foundtype isEqualToString:@"3"]){
            DetailFoundViewController * vc = [[DetailFoundViewController alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",[[foundArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            [vc returnText:^(NSString *change) {
                if ([change isEqualToString:@"1"]) {
                    [self loadData];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];

        }
        
    }else{
        
    }
}

@end
