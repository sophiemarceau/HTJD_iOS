//
//  MyConsumptionCodeViewController.m
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MyConsumptionCodeViewController.h"
#import "menuVIew.h"
#import "consumptionTableViewCell.h"
#import "BaseTableView.h"
#import "StoreDetailViewController.h"
#import "noOrderView.h"
#import "noWifiView.h"
@interface MyConsumptionCodeViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,menuViewDelegate>{
     int _pageForHot;
}
@property (strong, nonatomic) menuVIew *menuView;
//菜单栏相关属性
@property (strong, nonatomic) NSString *menuTag;
@property (strong, nonatomic) BaseTableView *ConsumptionTableView;
@property (strong, nonatomic) noOrderView *noConsumptionView;
@property (strong, nonatomic) noWifiView *failView;

//存储接口返回数据
@property (strong, nonatomic) NSMutableArray *alreadyArray;
@property (strong, nonatomic) NSMutableArray *notyetArray;

@end

@implementation MyConsumptionCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alreadyArray = [NSMutableArray array];
    
    //初始化
    self.menuTag = @"2";
    self.titles = @"消费码";
    [self.view addSubview:self.menuView];
    self.noConsumptionView.noOrderLabel.text = @"您还没有消费码";
    if (self.alreadyArray.count == 0) {
        self.noConsumptionView.hidden = NO;
    }else {
        self.noConsumptionView.hidden = YES;
    }
    [self.ConsumptionTableView addSubview:self.noConsumptionView];
    [self.view addSubview:self.ConsumptionTableView];
    //加载数据失败时显示
    [self.failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.failView.hidden = YES;
    [self.view addSubview:self.failView];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoStoreController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoStoteDetailVC:) name:@"gotoStoreController" object:nil];
    [self initRequestDataWithTypr:self.menuTag];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self initRequestDataWithTypr:self.menuTag];
}

-(void)initRequestDataWithTypr:(NSString *)type{
    [self.failView.activityIndicatorView startAnimating];
    self.failView.activityIndicatorView.hidden = NO;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"state":type,
                           };

    [[RequestManager shareRequestManager] getConsumptionList:dic viewController:self successData:^(NSDictionary *result) {

        NDLog(@"getConsumptionList--------%@",result);
       
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            self.failView.hidden = YES;
            [self.failView.activityIndicatorView stopAnimating];
            self.failView.activityIndicatorView.hidden = YES;
            [self.alreadyArray removeAllObjects];
             NSArray *exchangeCoderList = [result objectForKey:@"exchangeCoderList"];
            if(exchangeCoderList !=nil &&exchangeCoderList.count !=0){
                
                [self.alreadyArray addObjectsFromArray:exchangeCoderList];
                
            }
            if (self.alreadyArray.count == 0) {
                self.noConsumptionView.hidden = NO;
            }else {
                self.noConsumptionView.hidden = YES;
            }

            [self.ConsumptionTableView reloadData];
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        self.failView.hidden = NO;
        [self.failView.activityIndicatorView stopAnimating];
        self.failView.activityIndicatorView.hidden = YES;
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //接收menuView通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"menuViewKey" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuChange:) name:@"menuViewKey" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"menuViewKey" object:nil];
}
#pragma mark - baseTableViewDelegate
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView {
    [self.failView.activityIndicatorView startAnimating];
    self.failView.activityIndicatorView.hidden = NO;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"state":self.menuTag,
                           };
    
    [[RequestManager shareRequestManager] getConsumptionList:dic viewController:self successData:^(NSDictionary *result) {
        
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            [self.alreadyArray removeAllObjects];
        }
        
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            self.failView.hidden = YES;
            [self.failView.activityIndicatorView stopAnimating];
            self.failView.activityIndicatorView.hidden = YES;
            
            NSArray *exchangeCoderList = [result objectForKey:@"exchangeCoderList"];
            if(exchangeCoderList !=nil &&exchangeCoderList.count !=0){
                [self.alreadyArray addObjectsFromArray:exchangeCoderList];
                if (self.alreadyArray.count == 0) {
                    self.noConsumptionView.hidden = NO;
                }else {
                    self.noConsumptionView.hidden = YES;
                }
                [self.ConsumptionTableView reloadData];
                [refreshView endRefreshing];
                [self.ConsumptionTableView.foot finishRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
//        [self.ConsumptionTableView.head finishRefreshing];
//        [self.ConsumptionTableView.foot finishRefreshing];
        [refreshView endRefreshing];
        self.failView.hidden = NO;
        [self.failView.activityIndicatorView stopAnimating];
        self.failView.activityIndicatorView.hidden = YES;
    }];
}
#pragma mark - delegate
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.menuTag isEqualToString:@"2"]) {
        return self.alreadyArray.count;

    }else if([self.menuTag isEqualToString:@"3"]){

          return self.alreadyArray.count;

    }else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identify =@"doorcell";
    
    consumptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[consumptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if ([self.alreadyArray count]>0) {
        cell.data = [self.alreadyArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 通知相关方法

//- (void)menuChange:(NSDictionary *)dic {
//    NSDictionary *dict = [dic valueForKey:@"userInfo"];
//    NSString  *menuView = [dict objectForKey:@"menuView"];
//
//    if ([menuView isEqualToString:@"1"]) {
//        self.menuTag = @"2";
//    }else if ([menuView isEqualToString:@"2"]) {
//        self.menuTag = @"3";
//
//    }
//     [self initRequestDataWithTypr:self.menuTag];
//}
-(void)menuViewDidSelect:(NSInteger)number{
    if (number == 1) {
        self.menuTag = @"2";
    }else{
        self.menuTag = @"3";
    }
    [self initRequestDataWithTypr:self.menuTag];
}

- (void)gotoStoteDetailVC:(NSNotification *)ntf {
    NSString *storeID = [ntf.object valueForKey:@"storeID"];
    StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
    vc.storeID = storeID;
    [self.navigationController pushViewController:vc animated:YES];
}


- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 35)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = NO;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"未使用", @"已使用"];
        
    }
    return _menuView;
}

-(UITableView *)ConsumptionTableView{
    if (_ConsumptionTableView ==nil) {
        _ConsumptionTableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavHeight+35, kScreenWidth, kScreenHeight-kNavHeight-35)];
        _ConsumptionTableView.backgroundColor = [UIColor clearColor];
        _ConsumptionTableView.delegate = self;
        _ConsumptionTableView.dataSource = self;
        _ConsumptionTableView.showsVerticalScrollIndicator = NO;
        _ConsumptionTableView.delegates = self;
        [_ConsumptionTableView.head removeFromSuperview];
        [_ConsumptionTableView.foot removeFromSuperview];
        _ConsumptionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _ConsumptionTableView;
}
- (noOrderView *)noConsumptionView {
    if (_noConsumptionView == nil) {
        self.noConsumptionView = [[noOrderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-40)];
    }
    return _noConsumptionView;
}
- (noWifiView *)failView {
    if (_failView == nil) {
        self.failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight+40, kScreenWidth, kScreenHeight-kNavHeight-40)];
    }
    return _failView;
}
@end
