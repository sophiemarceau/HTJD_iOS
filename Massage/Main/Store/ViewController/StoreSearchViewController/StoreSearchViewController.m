//
//  StoreSearchViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/20.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.


#import "StoreSearchViewController.h"
#import "CustomCellTableViewCell.h"
#import "noneCellTableViewCell.h"
#import "KxMenu.h"
#import "BaseTableView.h"
#import "TechicianListCell.h"
#import "StoreListTableViewCell.h"
#import "DBHelper.h"
#import "HissotyTableViewCell.h"
#import "StoreDetailViewController.h"
#import "technicianViewController.h"
#import "TechnicianMyselfViewController.h"
#import "ServiceDetailViewController.h"
#define cellHeight 310*AUTO_SIZE_SCALE_X

@interface StoreSearchViewController ()<BaseTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>{
    NSString *flag;// 0 门店 1技师 2项目 －1 搜索历史
    NSString * cityCode;
    int _page;
}
@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UIButton *searchButton;
@property(nonatomic,strong) UIView *selectButton;
@property(nonatomic,strong) UIImageView *selectImageView;
@property(nonatomic,strong) UILabel *selectTitle;
@property(nonatomic,strong) UISearchBar *mySearchBar;
@property(nonatomic,strong) UITextField *mySearchField;
@property(nonatomic,strong) NSMutableArray *StoreData;
@property(nonatomic,strong) NSMutableArray *technicianData;
@property(nonatomic,strong) NSMutableArray *projectData;
@property(nonatomic,strong) NSMutableArray *hisStoryData;
@property(nonatomic,strong) BaseTableView *tabView;

@end

@implementation StoreSearchViewController

- (void)viewDidLoad {
    
    [self initData];
    
    [super viewDidLoad];
    
    WS(this_schedule);
    //搜索按钮
    [self.navView addSubview:self.searchButton];
    [self.navView addSubview:self.searchView];
    [self.searchView addSubview:self.selectButton];
    [self.searchView addSubview:self.mySearchField];
    [self.selectButton addSubview:self.selectTitle];
    [self.selectButton addSubview:self.selectImageView];
    [self.view addSubview:self.tabView];
    
    //搜索按钮
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(this_schedule.navView).offset(-13.5);
        make.size.mas_equalTo(CGSizeMake((28), 17));
    }];
    
    //搜索底图
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32.5);
        make.bottom.mas_equalTo(-6);
        make.size.mas_equalTo(CGSizeMake(240*AUTO_SIZE_SCALE_X, 32));
    }];
    
    //分类选项
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((50*AUTO_SIZE_SCALE_X), 32));
    }];
    
    //分类名称
    [self.selectTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 32));
    }];
    
    
    //分类箭头
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake((10), 6));
    }];
    
    //搜索输入框
    [self.mySearchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((240-50)*AUTO_SIZE_SCALE_X, 32));
    }];
    
    self.selectTitle.text = @"门店";
    flag = @"-1";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
}

#pragma mark 接收广播
-(void)gotoServiceDetailController:(NSNotification *)notification
{
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:notification.object];
    ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
    vc.haveWorker = NO;
    vc.serviceType = self.searchType;
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
        vc.isStore = YES;
        vc.isSelfOwned = @"0";
    }else if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
        vc.isStore = NO;
        vc.isSelfOwned = @"1";
    }
    vc.serviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
}


#pragma mark BaseTableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([flag isEqualToString:@"0"]) {
        if ([self.StoreData count]>0) {
            return   [self.StoreData count];
        }else{
            return 1;
        }
        
    }else if([flag isEqualToString:@"1"]){
        
        if ([self.technicianData count]>0) {
            return   [self.technicianData count];
        }else{
            return 1;
        }
        
    }else if([flag isEqualToString:@"-1"]){
        
        return  [self.hisStoryData count];
        
    }else {
        
        if ([self.projectData count]>0) {
            return   [self.projectData count];
        }else{
            return 1;
        }
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([flag isEqualToString:@"-1"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.mySearchField.text = [[self.hisStoryData objectAtIndex:indexPath.row] objectForKey:@"SearchName"];
        
        
        NSString *searchFlag =    [[self.hisStoryData objectAtIndex:indexPath.row] objectForKey:@"SearchType"];
        
        
        if ([searchFlag isEqualToString:@"0"]) {
            self.selectTitle.text =@"门店";
            self.mySearchField.placeholder = @"请输入门店名称";
        }else if([searchFlag isEqualToString:@"1"]){
            self.selectTitle.text =@"技师";
            self.mySearchField.placeholder = @"请输入技师姓名";
        }else if([searchFlag isEqualToString:@"2"]){
            self.selectTitle.text =@"项目";
            self.mySearchField.placeholder = @"请输入项目名称";
        }
        
        [self requestDataFromInternet];
    }else if ([flag isEqualToString:@"0"]) {
        
        if(self.StoreData!=nil&&self.StoreData.count !=0){
            StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
            vc.storeID = [[self.StoreData objectAtIndex:indexPath.row] objectForKey:@"ID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else if([flag isEqualToString:@"1"]){
        
        if(self.technicianData!=nil&&self.technicianData.count !=0){
            //门店上门 技师详情
            
            if ([[[self.technicianData objectAtIndex:indexPath.row] objectForKey:@"isSelfOwned"] isEqualToString:@"0"]) {
                technicianViewController *VC =[[technicianViewController alloc] init];
                VC.flag = @"0";
                VC.workerID = [	[self.technicianData objectAtIndex:indexPath.row] objectForKey:@"ID"];
                //        [[RequestManager shareRequestManager].CurrMainController.navigationController pushViewController:VC animated:YES];
                [self.navigationController pushViewController:VC animated:YES    ];
                
            }
            //自营上门 技师详情
            else if ([[[self.technicianData objectAtIndex:indexPath.row]  objectForKey:@"isSelfOwned"] isEqualToString:@"1"])
            {
                TechnicianMyselfViewController *VC =[[TechnicianMyselfViewController alloc] init];
                VC.workerID = [[self.technicianData objectAtIndex:indexPath.row]  objectForKey:@"ID"];
                [self.navigationController pushViewController:VC animated:YES    ];
                
            }
        }
        
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([flag isEqualToString:@"0"]) {
        if ([self.StoreData count]>0) {
            return cellHeight;
        }else{
            return kScreenHeight-64;
        }
    }else if([flag isEqualToString:@"1"]){
        if ([self.technicianData count]>0) {
            return 380.0f*AUTO_SIZE_SCALE_X;
        }else{
            return kScreenHeight-64;
        }
        
        
    }else if([flag isEqualToString:@"-1"]){
        return  44*AUTO_SIZE_SCALE_X;
    }
    else {
        if ([self.projectData count]>0) {
            //            return (108.75f+10.0f+88.0f)*AUTO_SIZE_SCALE_X;
            return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f;
            
        }else{
            return kScreenHeight-64;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([flag isEqualToString:@"-1"]){
        
        if (self.hisStoryData.count ==0) {
            return 0;
        }else{
            return  44*AUTO_SIZE_SCALE_X;
        }
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([flag isEqualToString:@"-1"]){
        if (self.hisStoryData.count ==0) {
            return 0;
        }else{
            return  44*AUTO_SIZE_SCALE_X;
        }
        
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerview;
    if([flag isEqualToString:@"-1"]){
        headerview = [UIView new];
        headerview.backgroundColor = [UIColor whiteColor];
        headerview.frame = CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
        UILabel *headerTitle =[UILabel new];
        headerTitle.text =@"历史搜索";
        headerTitle.textColor = BlackUIColorC5;
        headerTitle.frame =CGRectMake(10, 6*AUTO_SIZE_SCALE_X, kScreenWidth-10, 32*AUTO_SIZE_SCALE_X);
        [headerview addSubview:headerTitle];
        UIImageView *lineImageView =[UIImageView new];
        lineImageView.backgroundColor = [UIColor lightGrayColor];
        [headerview addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(headerview.mas_bottom);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth), 0.5));
            
        }];
        return  headerview;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview;
    if([flag isEqualToString:@"-1"]){
        footview = [UIView new];
        footview.backgroundColor = [UIColor whiteColor];
        UIButton *footUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footUIButton setTitle:@"清空历史搜索" forState:UIControlStateNormal];
        [footUIButton setBackgroundColor:OrangeUIColorC4];
        [footUIButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        footUIButton.frame =CGRectMake((kScreenWidth-250*AUTO_SIZE_SCALE_X)/2, 7*AUTO_SIZE_SCALE_X, 250*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
        [footUIButton addTarget:self action:@selector(cleanButton:) forControlEvents:UIControlEventTouchUpInside];
        footview.frame = CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
        [footview addSubview:footUIButton];
        return  footview;
        
    }else{
        return nil;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"flag------>>%@",flag);
    if ([flag isEqualToString:@"0"]) {
        
        if (self.StoreData.count>0) {
            static NSString *identify =@"StoreListcell";
            StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[StoreListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.listArrayData = self.StoreData[indexPath.row];
            return cell;
        }else{
            NSString * identify = @"noneCell";
            
            noneCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[noneCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.noneView.text =@"很抱歉，没有搜索到相关门店";
            [cell.noneImageView setImage:[UIImage imageNamed:@"icon_no-store"]];
            return cell;
        }
    }else if([flag isEqualToString:@"1"]){
        if (self.technicianData.count>0) {
            static NSString *identify =@"TechicianCell";
            TechicianListCell *tcell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!tcell) {
                tcell = [[TechicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            
            tcell.data = self.technicianData[indexPath.row];
            
            return tcell;
        }else{
            NSString * identify = @"noneCell";
            
            noneCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[noneCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.noneView.text =@"很抱歉，没有搜索到相关技师";
            [cell.noneImageView setImage:[UIImage imageNamed:@"icon_no-people"]];
            return cell;
        }
        
    }else if([flag isEqualToString:@"-1"]){
        static NSString *identify =@"HisStoryCell";
        HissotyTableViewCell *tcell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!tcell) {
            tcell = [[HissotyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        if (self.hisStoryData.count>0) {
            
            tcell.textLabel.text = [self.hisStoryData[indexPath.row] objectForKey:@"SearchName"];
            
        }
        return tcell;
        
    }
    else {
        
        if (self.projectData.count>0) {
            static NSString *identify =@"doorcell";
            CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            
            cell.data = self.projectData[indexPath.row];
            
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }else{
            NSString * identify = @"noneCell";
            
            noneCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[noneCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.noneView.text =@"很抱歉，没有搜索到相关项目";
            [cell.noneImageView setImage:[UIImage imageNamed:@"icon_no-project"]];
            return cell;
        }
        
    }
}


-(void)cleanButton:(UIButton *)sender{
    if ([self.searchType isEqualToString:@"0"]) {
        [MobClick event:STORE_SEARCH_DELETE];
    }
    else if ([self.searchType isEqualToString:@"1"]){
        [MobClick event:DOOR_SEARCH_DELETE];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定清空历史搜索吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
    
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
        NSString* sql = @"delete from searchHistory";
        [[DBHelper sharedDBHelper] ExecuteSql:sql];
        [self.hisStoryData removeAllObjects];
        [self.tabView reloadData];
        
    }
}


- (void) pushMenuItem:(KxMenuItem *)sender
{
    if ([sender.title isEqualToString:@"门店"]) {
        if ([self.searchType isEqualToString:@"0"]) {
            [MobClick event:STORE_SEARCH_CHOOSE_STORE];
        }
        else if ([self.searchType isEqualToString:@"1"]){
            [MobClick event:DOOR_SEARCH_CHOOSE_STORE];
        }
        self.selectTitle.text =@"门店";
        self.mySearchField.placeholder = @"请输入门店名称";
    }else if([sender.title isEqualToString:@"技师"]){
        if ([self.searchType isEqualToString:@"0"]) {
            [MobClick event:STORE_SEARCH_CHOOSE_TICHNICIAN];
        }
        else if ([self.searchType isEqualToString:@"1"]){
            [MobClick event:DOOR_SEARCH_CHOOSE_TICHNICIAN];
        }
        self.selectTitle.text =@"技师";
        self.mySearchField.placeholder = @"请输入技师姓名";
    }else if([sender.title isEqualToString:@"项目"]){
        if ([self.searchType isEqualToString:@"0"]) {
            [MobClick event:STORE_SEARCH_CHOOSE_PROJECT];
        }
        else if ([self.searchType isEqualToString:@"1"]){
            [MobClick event:DOOR_SEARCH_CHOOSE_PROJECT];
        }
        self.selectTitle.text =@"项目";
        self.mySearchField.placeholder = @"请输入项目名称";
    }
}

-(void)selectButton:(id)sender{
    
    if ([self.searchType isEqualToString:@"0"]) {
        [MobClick event:STORE_SEARCH_CHOOSE];
    }
    else if ([self.searchType isEqualToString:@"1"]){
        [MobClick event:DOOR_SEARCH_CHOOSE];
    }
    
    self.mySearchField.text =@"";
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"门店"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"技师"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"项目"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      ];
    
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.selectImageView.frame.origin.x+32, self.selectImageView.frame.origin.y+32, self.selectImageView.frame.size.width, self.selectImageView.frame.size.height)
                 menuItems:menuItems];
}

-(NSMutableArray *)SelectSearchHistory{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from searchHistory "];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *SearchName = @"";
    NSString *SearchType = @"";
    while ([rs next])
    {
        SearchName  = [rs stringForColumn:@"SearchName"];
        SearchType  = [rs stringForColumn:@"SearchType"];
        
        [tempArray addObject:@{@"SearchType":SearchType,@"SearchName":SearchName}];
        
    }
    [rs close];
    
    
    return tempArray;
}

-(void)saveSearchHistory{
    NSString *str = [self.mySearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去除左右两边的 空格
    NSString *searchString =self.selectTitle.text ;
    NSString *flagString = @"";
    if ([searchString isEqualToString:@"门店" ]) {
        flagString =@"0";
    }else if ([searchString isEqualToString:@"技师" ]){
        flagString =@"1";
    }else if ([searchString isEqualToString:@"项目" ]){
        flagString =@"2";
    }	    NSString *sql = [NSString stringWithFormat:@"insert into searchHistory(SearchName,SearchType) values('%@','%@')",str,flagString];
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
    
    //删除表中多余的重复记录，重复记录是根据单个字段（peopleId）来判断，只留有rowid最小的记录
    NSString *sql1 = [NSString stringWithFormat:@"delete from searchHistory where SearchName in (select  SearchName from searchHistory group by SearchName having count(SearchName) > 1) and SID not in (select min(SID) from  searchHistory group by SearchName having count(SearchName)>1)"];
    [[DBHelper sharedDBHelper] ExecuteSql:sql1];
    
}


-(void)initData{
    
    self.hisStoryData =[NSMutableArray array];
    [self.hisStoryData addObjectsFromArray:[self SelectSearchHistory]];
    self.technicianData =[NSMutableArray array];
    _StoreData =[NSMutableArray array];
    _projectData=[NSMutableArray array];
    
    //    [self.hisStoryData removeAllObjects];
    
    //
    //    NSDictionary *banner1  = @{
    //                               @"title":@"测试1",
    //
    //
    //                               };
    //    NSDictionary *banner2  = @{
    //                               @"title":@"测试1",
    //
    //
    //                               };
    //    NSDictionary *banner3  = @{
    //                               @"title":@"测试1",
    //
    //                               };
    //
    //
    //
    //
    //
    //
    //    [self.technicianData removeAllObjects];
    //    [self.technicianData addObject:banner1];
    //    [self.technicianData addObject:banner2];
    //    [self.technicianData addObject:banner3];
    //    [_StoreData addObjectsFromArray:self.technicianData];
    //
    //
    ////    NSDictionary *data8  = @{@"title":@"测试1",};
    //  //    [_projectData addObject:data8];
    ////    [_projectData addObject:data8];
    ////    [_projectData addObject:data8];
    ////    [_projectData addObject:data8];
    ////    [_projectData addObject:data8];
    ////    [_projectData addObject:data8];
    //
    //
    //
    //
    //
    //
    //
    //
    //    NSDictionary *data1  = @{
    //                             @"title":@"测试1",
    //
    //
    //                             };
    //    NSDictionary *data2  = @{
    //                             @"title":@"测试1",
    //
    //
    //                             };
    //    NSDictionary *data3  = @{
    //                             @"title":@"测试1",
    //
    //
    //                             };
    //    NSDictionary *data4  = @{
    //                             @"title":@"测试1",
    //
    //
    //                             };
    //    NSDictionary *data5  = @{
    //                             @"title":@"测试1",
    //
    //
    //                             };
    //    NSDictionary *data6  = @{
    //                             @"title":@"测试1",
    //
    //
    //                             };
    //    NSDictionary *data7  = @{
    //                             @"title":@"测试1",
    //
    //                             };
    //    NSDictionary *data11  = @{
    //                              @"title":@"测试1",
    //
    //                              };
    //  NSArray *listViewData = @[data1,data2,data3,data4,data5,data6,data7,data11];
    //
    
    //
    //    }
    //
    //    [self.projectData removeAllObjects];
    //    [self.technicianData removeAllObjects];
    //    [_StoreData removeAllObjects];
    
}



-(void)searchBtnPressed:(id)sender{
    if ([self.searchType isEqualToString:@"0"]) {
        [MobClick event:STORE_SEARCH_SEARCH];
    }
    else if ([self.searchType isEqualToString:@"1"]){
        [MobClick event:DOOR_SEARCH_SEARCH];
    }
    
    if ([self.mySearchField.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入内容后再搜索" viewController:self];
        return;
    }
    [self requestDataFromInternet];
    [self saveSearchHistory];
    
}

-(void)requestDataFromInternet{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    cityCode = [userDefaults objectForKey:@"cityCode"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    NSDictionary *dic;
    _page = 1;
    //    [self.tabView.foot beginRefreshing];
    [_tabView.foot setHidden:NO];
    if([self.selectTitle.text isEqualToString:@"门店"]){//门店
        
        dic = @{
                @"name":self.mySearchField.text,
                @"cityCode":cityCode,
                @"longitude":longitude,
                @"latitude":latitude,
                @"userID":@"",
                @"orderBy":@"0",
                @"pageStart":@"1",
                @"pageOffset":@"10",
                };
        
        flag = @"0";
        [self.StoreData removeAllObjects];
    }else if([self.selectTitle.text isEqualToString:@"技师"]){//技师
        dic = @{
                @"name":self.mySearchField.text,
                @"cityCode":cityCode,
                @"longitude":longitude,
                @"latitude":latitude,
                @"userID":@"",
                @"orderBy":@"0",
                @"pageStart":@"1",
                @"pageOffset":@"10",
                };
        flag = @"1";
        [self.technicianData removeAllObjects];
    }else if([self.selectTitle.text isEqualToString:@"项目"]){//项目
        dic = @{
                @"type":self.searchType,
                @"name":self.mySearchField.text,
                @"longitude":longitude,
                @"latitude":latitude,
                @"userID":@"",
                @"orderBy":@"0",
                @"cityCode":cityCode,
                @"pageStart":@"1",
                @"pageOffset":@"20",
                };
        flag = @"2";
        [self.projectData removeAllObjects];
    }
    
    [self showHintNoHide:@"正在加载..."];
    
    NSLog(@"dic --- > %@",dic);
    [[RequestManager shareRequestManager]SearchContent:dic
                                        viewController:self
                                        SearchFlagType:flag
                                           successData:^(NSDictionary *result) {
                                               
                                               
                                               NSLog(@"result %@",result);
                                               if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                                                   
                                                   if([flag isEqualToString:@"0"]){//门店
                                                       [self.StoreData addObjectsFromArray:[result objectForKey:@"storeList"]];
                                                       if (self.StoreData.count < 10|| self.StoreData.count ==0 ) {
                                                           [self.tabView.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.tabView.foot endRefreshing];
                                                       }
                                                       
                                                       
                                                   }else if([flag isEqualToString:@"1"]){//技师
                                                       
                                                       
                                                       [self.technicianData addObjectsFromArray:[result objectForKey:@"skillList"]];
                                                       NSLog(@"self.technicianData-------->%@",self.technicianData);
                                                       if (self.technicianData.count < 10|| self.technicianData.count ==0 ) {
                                                           [self.tabView.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.tabView.foot endRefreshing];
                                                       }
                                                       
                                                   }else if([flag isEqualToString:@"2"]){//项目
                                                       
                                                       [self.projectData addObjectsFromArray:[self sortedArray:[result objectForKey:@"serviceList"]]];
                                                       if (self.projectData.count < 20|| self.projectData.count ==0 ) {
                                                           [self.tabView.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.tabView.foot endRefreshing];
                                                       }
                                                   }
                                                   
                                                   [self.tabView reloadData];
                                                   
                                               }else{
                                                   [[RequestManager shareRequestManager]resultFail:result];
                                               }
                                               [self hideHud];
                                               
                                           } failuer:^(NSError *error) {
                                               [self hideHud];
                                           }];
    
}

#pragma mark - 刷新
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        //        _page = 1;
        //        _dataArray = [[NSMutableArray alloc]init];
    }else{
        _page ++ ;
    }
    
    NSString *pageString =[NSString stringWithFormat:@"%d",_page];
    
    NSDictionary *dic;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    if([self.selectTitle.text isEqualToString:@"门店"]){//门店
        
        dic = @{
                @"name":self.mySearchField.text,
                @"cityCode":cityCode,
                @"longitude":longitude,
                @"latitude":latitude,
                @"userID":@"",
                @"orderBy":@"0",
                @"pageStart":pageString,
                @"pageOffset":@"10",
                };
        
        flag = @"0";
    }else if([self.selectTitle.text isEqualToString:@"技师"]){//技师
        dic = @{
                @"name":self.mySearchField.text,
                @"cityCode":cityCode,
                @"longitude":longitude,
                @"latitude":latitude,
                @"userID":@"",
                @"orderBy":@"0",
                @"pageStart":pageString,
                @"pageOffset":@"10",
                };
        flag = @"1";
        
    }else if([self.selectTitle.text isEqualToString:@"项目"]){//项目
        dic = @{
                @"type":self.searchType,
                @"name":self.mySearchField.text,
                @"longitude":longitude,
                @"latitude":latitude,
                @"userID":@"",
                @"orderBy":@"0",
                @"cityCode":cityCode,
                @"pageStart":pageString,
                @"pageOffset":@"20",
                };
        flag = @"2";
    }
    
    
    [[RequestManager shareRequestManager]SearchContent:dic
                                        viewController:self
                                        SearchFlagType:flag
                                           successData:^(NSDictionary *result) {
                                               
                                               
                                               if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                                                   
                                                   if([flag isEqualToString:@"0"]){//门店
                                                       
                                                       [self.StoreData addObjectsFromArray:[result objectForKey:@"storeList"]];
                                                       
                                                       if (self.StoreData.count < 10|| self.StoreData.count ==0 ) {
                                                           [self.tabView.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.tabView.foot endRefreshing];
                                                       }
                                                       
                                                   }else if([flag isEqualToString:@"1"]){//技师
                                                       [self.technicianData addObjectsFromArray:[result objectForKey:@"skillList"]];
                                                       if (self.technicianData.count < 10 || self.technicianData.count ==0 ) {
                                                           [self.tabView.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.tabView.foot endRefreshing];
                                                       }
                                                       
                                                       
                                                   }else if([flag isEqualToString:@"2"]){//项目
                                                       [self.projectData addObjectsFromArray:[self sortedArray:[result objectForKey:@"servList"]]];
                                                       if (self.projectData.count < 10 || self.projectData.count ==0 ) {
                                                           [self.tabView.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.tabView.foot endRefreshing];
                                                       }
                                                   }
                                                   [self.tabView reloadData];
                                                   
                                               }else{
                                                   [[RequestManager shareRequestManager]resultFail:result];
                                               }
                                               [refreshView endRefreshing];
                                               
                                           } failuer:^(NSError *error) {
                                               [refreshView endRefreshing];
                                               
                                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    
    
    
    [self searchBtnPressed:nil];
    return YES;
}

-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor  =UIColorFromRGB(0x9c2322);
        _searchView.layer.cornerRadius = 4.0;
        
        
    }
    return _searchView;
}

-(UISearchBar *)mySearchBar{
    if (!_mySearchBar) {
        _mySearchBar =[[UISearchBar alloc] initWithFrame:CGRectMake(30, 20, kScreenWidth-30, 44)];
        
        
        _mySearchBar.backgroundImage = [self imageWithColor:RedUIColorC1 size:_mySearchBar.bounds.size];
        
        _mySearchBar.barStyle =UIBarStyleBlackTranslucent;
        _mySearchBar.showsCancelButton =YES;
        
    }
    return _mySearchBar;
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(UIButton *)searchButton{
    if (!_searchButton) {
        
        
        _searchButton =[CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(searchBtnPressed:) Title:@"搜索"];
        
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _searchButton.titleLabel.textColor = [UIColor whiteColor];
        _searchButton.backgroundColor =[UIColor clearColor];
        
        
    }
    return _searchButton;
}


-(UIView *)selectButton{
    if (!_selectButton) {
        _selectButton =[UIView new];
        _selectButton.backgroundColor =[UIColor clearColor];
        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectButton:)];
        [_selectButton addGestureRecognizer:setDefaultViewTap];
        UIView *singleTapView = [setDefaultViewTap view];
        singleTapView.tag = 11000;
    }
    return _selectButton;
}

-(UITextField *)mySearchField{
    if (!_mySearchField) {
        _mySearchField = [UITextField new];
        _mySearchField.backgroundColor =[UIColor clearColor];
        _mySearchField.textColor =[UIColor whiteColor];
        _mySearchField.font =[UIFont systemFontOfSize:12];
        _mySearchField.placeholder = @"请输入门店名称";
        [_mySearchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _mySearchField.tintColor = [UIColor whiteColor];
        _mySearchField.textAlignment = UITextAlignmentLeft;
        _mySearchField.delegate = self;
        _mySearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mySearchField.returnKeyType=UIReturnKeySearch;
    }
    return _mySearchField;
}


-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView =[UIImageView new];
        _selectImageView.image = [UIImage imageNamed:@"icon_header_dropdown"];
        
    }
    return _selectImageView;
}

-(UIView *)selectTitle{
    if (!_selectTitle) {
        _selectTitle =[UILabel new];
        _selectTitle.textColor =[UIColor whiteColor];
        _selectTitle.textAlignment =NSTextAlignmentCenter;
        _selectTitle.font =[UIFont systemFontOfSize:12];
        
    }
    return _selectTitle;
    
}

-(BaseTableView *)tabView{
    if (!_tabView) {
        _tabView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor =[UIColor clearColor];
        [_tabView.head removeFromSuperview];
        _tabView.delegates = self;
        [_tabView.foot setHidden:YES];
    }
    return _tabView;
}

-(NSMutableArray *)sortedArray:(NSArray *)listViewData{
    NSMutableArray * _data =[NSMutableArray array];
    if (listViewData.count > 0) {
        NSMutableArray *cellArray = [_data lastObject];
        for (int i = 0; i < listViewData.count; i++) {
            if (cellArray.count == 2 || cellArray == nil) {
                cellArray = [NSMutableArray arrayWithCapacity:2];
                [_data addObject:cellArray];
                
            }
            NSDictionary *dic = listViewData[i];
            
            [cellArray addObject:dic];
        }
    }
    return _data;
}
@end
