//
//  SelectWorkerViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "SelectWorkerViewController.h"
#import "TechicianListCell.h"
#import "BaseTableView.h"
#import "noOrderView.h"

@interface SelectWorkerViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>
{
    BaseTableView * workerTableView;
    NSMutableArray * workerArray;
    
    int _pageForHot;
    NSDictionary * selectWorkerDic;
    
    noOrderView * noDataView;

}
@end

@implementation SelectWorkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"选择技师";
    
    workerArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    workerTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    workerTableView.delegate = self;
    workerTableView.dataSource = self;
    workerTableView.delegates = self;
    workerTableView.showsVerticalScrollIndicator = NO;
    workerTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:workerTableView];
    
    [self downLoadData];
    
}

-(void)downLoadData
{
    _pageForHot = 1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
     NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"longitude":longitude,
                           @"latitude":latitude,
                           @"amount":self.amount,
                           @"serviceTime":self.serviceTime,
                           @"serviceType":self.serviceType,
                           @"serviceID":self.serviceID,
                           @"gradeID":self.gradeID,
                           @"addressID":self.addressID,
                           @"pageStart":@"1",
                           @"pageOffset":@"15",
                           };
    NSLog(@"dic--->%@",dic);
    [[RequestManager shareRequestManager] getstoreSkillListByServID:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@" 预约服务技师 result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            [workerArray addObjectsFromArray:[result objectForKey:@"skillList"]];
        }
        if (workerArray.count > 0) {
            [workerTableView reloadData];
        }else{
            noDataView = [[noOrderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
            noDataView.noOrderLabel.text = @"没有符合条件的技师";
            [self.view addSubview:noDataView];
            workerTableView.hidden = YES;
        }
        
    } failuer:^(NSError *error) {
        
    }];
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [workerArray count];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 380.0f*AUTO_SIZE_SCALE_X;;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *identify =@"TechicianListCell";
        TechicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[TechicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.data = [workerArray objectAtIndex:indexPath.row];
    
        cell.backgroundColor = [UIColor clearColor];
        return cell;
 
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectWorkerDic = [NSDictionary dictionaryWithDictionary:[workerArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 上拉加载
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else
    {
        _pageForHot++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSDictionary * dic = @{
                           //                           @"longitude":@"",
                           //                           @"latitude":@"",
                           @"amount":self.amount,
                           @"serviceTime":self.serviceTime,
                           @"serviceType":self.serviceType,
                           @"serviceID":self.serviceID,
                           @"gradeID":self.gradeID,
                           @"addressID":self.addressID,
                           @"pageStart":page,
                           @"pageOffset":@"15",
                           };
    [[RequestManager shareRequestManager] getstoreSkillListByServID:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@" 预约服务技师 result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"skillList"] ];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [workerArray removeAllObjects];
            }
            [workerArray addObjectsFromArray:array];
            [workerTableView reloadData];
            [refreshView endRefreshing];
            if (array.count < 15 || array.count ==0 ) {
                [workerTableView.foot finishRefreshing];
            }else
            {
                [workerTableView.foot endRefreshing];
            }
        }
        [workerTableView reloadData];
    } failuer:^(NSError *error) {
        
    }];


}

#pragma mark Block
-(void)returnWorkerSelectDic:(ReturnSelectWorkerBlock)block
{
    self.returnSelectWorkerBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    if (self.returnSelectWorkerBlock != nil) {
        self.returnSelectWorkerBlock(selectWorkerDic);
    }
}
#pragma mark -----------------------

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
