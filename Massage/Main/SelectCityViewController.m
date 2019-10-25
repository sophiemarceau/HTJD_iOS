//
//  SelectCityViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/4.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "SelectCityViewController.h"
#import "CityChangeViewController.h"

#import "publicTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
//#import <AMapSearchKit/AMapSearchKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CCLocationManager.h"
#import "Reachability.h"

#import "HotAreaView.h"
#import "PositionHistoryTableViewCell.h"

#import "DBHelper.h"

@interface SelectCityViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, MAMapViewDelegate, AMapSearchDelegate,UIAlertViewDelegate>
{
    UILabel * cityNameLabel;
    UITextField * searchField;
    UIView * headerView;
    
    UITableView * searchTableView;
    NSMutableArray * cellArray;
    NSDictionary * chooseDic;
    
    NSString * cityName;
    NSString * cityCode;
    
    NSString * selectCityType;
    
    NSString * lon;
    NSString * lat;
    
    UIButton * saveAddressBtn;
    
    UIView * historyTitle;
    UITableView * positionHistoryTableView;
    
    HotAreaView * hotAreaView;
    
    NSMutableArray * historyArray;
    NSMutableArray * businessArray;
    
    UIView * hotAreaView1;
    UIView * btnView;
    
    UILabel * noresultLabel;
}
@property (nonatomic, strong) NSMutableArray *tips;

@end

@implementation SelectCityViewController
@synthesize tips = _tips;
@synthesize search  = _search;
@synthesize city;
- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark 查询热门商圈
-(void)getBusinessData
{
    [self showHudInView:self.view hint:@"正在加载"];
    NSDictionary * dic = @{
                           @"cityCode":cityCode,
                           };
    [[RequestManager shareRequestManager] getBusiness:dic viewController:self successData:^(NSDictionary *result) {
        //成功返回数据
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSLog(@"result -- >%@",result);
            //显示布局
            headerView.hidden = NO;
            btnView.hidden = NO;
            [businessArray addObjectsFromArray:[result objectForKey:@"areaBusiness"]];
            //有商圈,显示商圈view
            if (businessArray.count>0) {
                //热门商圈
                //热门商圈
                [self initHotView];
            }
            //无商圈,不显示商圈view
            else{
                //热门商圈
//                [self initHotView];
                //热门商圈
                [self initHotView];
                hotAreaView1.hidden = YES;
            }
            if (historyArray.count>0) {
                [positionHistoryTableView reloadData];
                historyTitle.hidden = NO;
                positionHistoryTableView.hidden = NO;
            }else{
                historyTitle.hidden = YES;
                positionHistoryTableView.hidden = YES;
            }

        }
        else{
            
            //热门商圈
            [self initHotView];
            hotAreaView1.hidden = YES;
            //显示布局
            headerView.hidden = NO;
            btnView.hidden = NO;
            if (historyArray.count>0) {
                [positionHistoryTableView reloadData];
                historyTitle.hidden = NO;
                positionHistoryTableView.hidden = NO;
            }else{
                historyTitle.hidden = YES;
                positionHistoryTableView.hidden = YES;
            }

        }
    } failuer:^(NSError *error) {
        
        [self hideHud];
        
        //热门商圈
        [self initHotView];
        hotAreaView1.hidden = YES;
        //显示布局
        headerView.hidden = NO;
        btnView.hidden = NO;
        if (historyArray.count>0) {
            [positionHistoryTableView reloadData];
            historyTitle.hidden = NO;
            positionHistoryTableView.hidden = NO;
        }else{
            historyTitle.hidden = YES;
            positionHistoryTableView.hidden = YES;
        }

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"服务地址";
    selectCityType = @"0";
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    cityName = [userDefaults objectForKey:@"cityName"];
    cityCode = [userDefaults objectForKey:@"cityCode"];
    
    historyArray = [[NSMutableArray alloc] initWithCapacity:0];
    businessArray = [[NSMutableArray alloc] initWithCapacity:0];
    cellArray = [[NSMutableArray alloc] initWithCapacity:0];
    
   
    noresultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 0)];
    noresultLabel.textColor = UIColorFromRGB(0xC8C8C8);
    noresultLabel.textAlignment = NSTextAlignmentCenter;
    noresultLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:noresultLabel];
    noresultLabel.hidden = YES;
   
    
    //手写搜索栏
    [self initHeaderView];
    
    [self initTableView];
    
   
    //历史纪律
    [self initHistoryTableView];
    
    [self initSearch];
    
    //打开db,查询数据库
    [self openDB];
    
    //获取热门商圈
     [self getBusinessData];
}

-(void)initHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView * changeCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (55+8+10), 45*AUTO_SIZE_SCALE_X)];
    changeCityView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:changeCityView];
    UITapGestureRecognizer * changeCityViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCityViewTaped:)];
    [changeCityView addGestureRecognizer:changeCityViewTap];
    
    cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 , (45-13)/2*AUTO_SIZE_SCALE_X, 40 , 13*AUTO_SIZE_SCALE_X)];
    cityNameLabel.text = [NSString stringWithFormat:@"%@市",self.city];
    cityNameLabel.font = [UIFont systemFontOfSize:13];
    [changeCityView addSubview:cityNameLabel];
    
    UIImageView * xiaImv = [[UIImageView alloc] initWithFrame:CGRectMake((55+8) , (45*AUTO_SIZE_SCALE_X-6)/2, 10 , 6)];
    xiaImv.image = [UIImage imageNamed:@"icon_city-switching"];
    [changeCityView addSubview:xiaImv];
    
    UIView * searView = [[UIView alloc] initWithFrame:CGRectMake(xiaImv.frame.origin.x+xiaImv.frame.size.width+8 , (45-28)/2*AUTO_SIZE_SCALE_X, kScreenWidth-(xiaImv.frame.origin.x+xiaImv.frame.size.width+8+10), 28*AUTO_SIZE_SCALE_X)];
    searView.backgroundColor = C8UIColorGray;
    searView.layer.cornerRadius = 3.0;
    [headerView addSubview:searView];
    
    UIImageView * searchImv = [[UIImageView alloc] initWithFrame:CGRectMake(5, (28*AUTO_SIZE_SCALE_X-13)/2, 13 , 13 )];
    searchImv.image = [UIImage imageNamed:@"icon_location_search"];
    [searView addSubview:searchImv];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchImv.frame.origin.x+searchImv.frame.size.width+8 , 0, searView.frame.size.width-(searchImv.frame.origin.x+searchImv.frame.size.width+8+5 ), 28*AUTO_SIZE_SCALE_X)];
    searchField.delegate = self;
    searchField.placeholder = @"小区、大厦或街道名称";
    searchField.textColor = [UIColor blackColor];
    searchField.tintColor = C7UIColorGray;
    searchField.backgroundColor = C8UIColorGray ;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchField setValue:C7UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [searchField addTarget:self action:@selector(searchFieldChange) forControlEvents:UIControlEventEditingChanged];
    [searView addSubview:searchField];
    
    headerView.hidden = YES;
}

-(void)initTableView
{
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, self.view.frame.size.height-(headerView.frame.origin.y+headerView.frame.size.height+10*AUTO_SIZE_SCALE_X+50*AUTO_SIZE_SCALE_X))];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.backgroundColor = [UIColor clearColor];
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.showsVerticalScrollIndicator = NO;
    searchTableView.rowHeight = 44*AUTO_SIZE_SCALE_X;
    [self.view addSubview:searchTableView];
    searchTableView.hidden = YES;
    
    //保存布局
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor  whiteColor];
    [self.view addSubview:btnView];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:zhixianImv];
    
    saveAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddressBtn.frame = CGRectMake(15, 5*AUTO_SIZE_SCALE_X, kScreenWidth-30, 40*AUTO_SIZE_SCALE_X);
    [saveAddressBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [saveAddressBtn setTitle:@"定位为当前位置" forState:UIControlStateNormal];
    [saveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveAddressBtn addTarget:self action:@selector(saveAddressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:saveAddressBtn];
    btnView.hidden = YES;
}

-(void)initHotView
{
    //    hotAreaView = [[HotAreaView alloc] init];
    //    hotAreaView.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 0);
    //    hotAreaView.backgroundColor = [UIColor redColor];
    
    hotAreaView1 = [[UIView alloc] init];
    hotAreaView1.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth,0);
    hotAreaView1.backgroundColor = [UIColor clearColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 50, 38)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"热门商圈";
    titleLabel.textColor = UIColorFromRGB(0xC8C8C8);
    titleLabel.font = [UIFont systemFontOfSize:11];
    [hotAreaView1 addSubview:titleLabel];
    
    UIView * btnsView = [[UIView alloc] init];
    btnsView.backgroundColor = [UIColor clearColor];

    //标签页
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 10;//用来控制button距离父视图的高
    for (int i = 0; i < businessArray.count; i++) {
        UIButton * attitudeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        attitudeBtn.tag = 101 + i;
        attitudeBtn.backgroundColor = [UIColor whiteColor];
        [attitudeBtn addTarget:self action:@selector(attitudeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [attitudeBtn setTitleColor:C6UIColorGray forState:UIControlStateNormal];
        attitudeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        attitudeBtn.layer.cornerRadius = 3.0;
        attitudeBtn.layer.masksToBounds = YES;
        attitudeBtn.layer.borderColor = C7UIColorGray.CGColor;
        attitudeBtn.layer.borderWidth = 1.0;
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat length = [[[businessArray objectAtIndex:i] objectForKey:@"areaBusinessName"] boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [attitudeBtn setTitle:[[businessArray objectAtIndex:i] objectForKey:@"areaBusinessName"] forState:UIControlStateNormal];
        //设置button的frame
        attitudeBtn.frame = CGRectMake(12 + w, h, length + 12 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(12 + w + length + 12 > kScreenWidth){
            w = 0; //换行时将w置为0
            h = h + attitudeBtn.frame.size.height + 8;//距离父视图也变化
            attitudeBtn.frame = CGRectMake(12 + w, h, length + 12, 30);//重设button的frame
        }
        w = attitudeBtn.frame.size.width + attitudeBtn.frame.origin.x - 7;//间距为15-7
        [btnsView addSubview:attitudeBtn];
        //        [normalBtnArray addObject:attitudeBtn];
        
        btnsView.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height-12, kScreenWidth, attitudeBtn.frame.origin.y+attitudeBtn.frame.size.height);
        hotAreaView1.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, btnsView.frame.origin.y+btnsView.frame.size.height);

    }
    [hotAreaView1 addSubview:btnsView];
    [self.view addSubview:hotAreaView1];
    historyTitle.frame = CGRectMake(0, hotAreaView1.frame.origin.y+hotAreaView1.frame.size.height, kScreenWidth, 38);
    positionHistoryTableView.frame = CGRectMake(0, historyTitle.frame.origin.y+historyTitle.frame.size.height, kScreenWidth, kScreenHeight-(historyTitle.frame.origin.y+historyTitle.frame.size.height+50*AUTO_SIZE_SCALE_X));
//    hotAreaView1.hidden = YES;
}

-(void)initHistoryTableView
{
    historyTitle = [[UIView alloc] initWithFrame:CGRectMake(0, hotAreaView1.frame.origin.y+hotAreaView1.frame.size.height, kScreenWidth, 38)];
    historyTitle.backgroundColor = UIColorFromRGB(0xEBEBEB);
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 50, 38)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"搜索历史";
    titleLabel.textColor = UIColorFromRGB(0xC8C8C8);
    titleLabel.font = [UIFont systemFontOfSize:11];
    [historyTitle addSubview:titleLabel];
    
    positionHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, historyTitle.frame.origin.y+historyTitle.frame.size.height, kScreenWidth, kScreenHeight-(historyTitle.frame.origin.y+historyTitle.frame.size.height+50*AUTO_SIZE_SCALE_X))];
    positionHistoryTableView.delegate = self;
    positionHistoryTableView.dataSource = self;
    positionHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    positionHistoryTableView.rowHeight = 38;
    positionHistoryTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyTitle];
    [self.view addSubview:positionHistoryTableView];
    historyTitle.hidden = YES;
    positionHistoryTableView.hidden = YES;
}


-(void)cleanBtnPressed:(UIButton *)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除本城市的搜索记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    if (buttonIndex == 1) {
        [self cleanHistory:cityCode];
    }
}
//清除当前城市的搜索记录
-(void)cleanHistory:(NSString *)code
{
    NSString* sql = [NSString stringWithFormat:@"delete from PositionHistory where CityCode='%@'",code];
    
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
    
    //    [historyTitle removeFromSuperview];;
    //    [positionHistoryTableView removeFromSuperview];
    historyTitle.hidden = YES;
    positionHistoryTableView.hidden = YES;
}

//添加历史记录
-(void)insertHistoryCode:(NSString *)code  posotionInfo:(NSString *)info  latitude:(NSString *)latHis longitude:(NSString *)logHis
{
    NSString *sql = [NSString stringWithFormat:@"insert into PositionHistory(CityCode,PositionInfo,latitude,longitude) values('%@','%@','%@','%@')",code,info,latHis,logHis];
    //    NSString *sql = [NSString stringWithFormat:@"insert into PositionHistory(CityCode,PositionInfo,longitude) values('%@','%@','%@')",code,info,@"123123"];
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
    
    //删除表中多余的重复记录，重复记录是根据单个字段（peopleId）来判断，只留有rowid最小的记录
    NSString *sql1 = [NSString stringWithFormat:@"delete from PositionHistory where PositionInfo in (select  PositionInfo from PositionHistory group by PositionInfo having count(PositionInfo) > 1) and HistoryID not in (select min(HistoryID) from  PositionHistory group by PositionInfo having count(PositionInfo)>1)"];
    [[DBHelper sharedDBHelper] ExecuteSql:sql1];
}

#pragma mark 打开数据库 查询内容
-(void)openDB
{
    NSString *sql = [NSString stringWithFormat:@"select * from PositionHistory where  CityCode='%@'",cityCode];
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *CityCode = @"";
    NSString *PositionInfo = @"";
    NSString * latitude = @"";
    NSString * longitude = @"";
    while ([rs next])
    {
        CityCode  = [rs stringForColumn:@"CityCode"];
        PositionInfo  = [rs stringForColumn:@"PositionInfo"];
        if ([rs stringForColumn:@"latitude"]) {
            latitude  = [rs stringForColumn:@"latitude"];
        }
        if ([rs stringForColumn:@"longitude"]) {
            longitude  = [rs stringForColumn:@"longitude"];
        }
        NSLog(@"CityCode-->%@  PositionInfo-->%@  longitude-->%@  latitude-->%@",CityCode,PositionInfo,longitude,latitude);
        [historyArray addObject:@{@"CityCode":CityCode,@"PositionInfo":PositionInfo,@"latitude":latitude,@"longitude":longitude}];
    }
    [rs close];
   }

#pragma mark 点击商圈内容
-(void)attitudeBtnClick:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    searchField.text = sender.titleLabel.text;
    historyTitle.hidden = YES;
    positionHistoryTableView.hidden = YES;
    hotAreaView1.hidden = YES;
    searchTableView.hidden = NO;
    [self searchTipsWithKey:searchField.text];
}

-(void)changeCityViewTaped:(UITapGestureRecognizer *)sender
{
    [self hideHud];
    
    [searchField resignFirstResponder];
    
    [cellArray removeAllObjects];
    searchField.text = @"";
    [searchTableView reloadData];
    
    CityChangeViewController * vc = [[CityChangeViewController alloc] init];
    [vc returnCityInfo:^(NSDictionary *dic) {
        if (dic) {
            cityNameLabel.text = [NSString stringWithFormat:@"%@市",[dic objectForKey:@"cityName"]];
            cityName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
            cityCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityCode"]];
            
            [historyArray removeAllObjects];
            [positionHistoryTableView reloadData];
            [self openDB];
            
            [businessArray removeAllObjects];
            [hotAreaView1 removeFromSuperview];
            [self getBusinessData];
            
           
        }
        else{
            [historyArray removeAllObjects];
            [positionHistoryTableView reloadData];
            [self openDB];
            
            [businessArray removeAllObjects];
            [hotAreaView1 removeFromSuperview];
            [self getBusinessData];
            
           
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cleanImvTaped:(UITapGestureRecognizer *)sender
{
    searchField.text = @"";
}

-(void)saveAddressBtnPressed:(UIButton *)sender
{
    saveAddressBtn.userInteractionEnabled = NO;
    if (![self isConnectionAvailable]) {
        [[RequestManager shareRequestManager] tipAlert:@"设置当前位置时请打开网络连接" viewController:self];
        saveAddressBtn.userInteractionEnabled = YES;
    }
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
            //                regeoRequest.searchType = AMapSearchType_ReGeocode;
            regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
            //    regeoRequest.radius = 10000;
            regeoRequest.requireExtension = YES;
            lat = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
            lon = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
            //发起逆地理编码
            [_search AMapReGoecodeSearch: regeoRequest];
        }];
    }
    
    else{
        [[RequestManager shareRequestManager] tipAlert:@"打开GPS后才可以选择当前位置" viewController:self];
        saveAddressBtn.userInteractionEnabled = YES;
    }
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"实现逆地理编码的回调函数");
    if(response.regeocode != nil)
    {
        NDLog(@"当前地址——>%@",response.regeocode.formattedAddress);
        NSString *  regeocodeprovince = @"";
        NSString *  regeocodecity = @"";
        if (response.regeocode.addressComponent.province) {
            regeocodeprovince = response.regeocode.addressComponent.province;
        }
        if (response.regeocode.addressComponent.city) {
            regeocodecity = response.regeocode.addressComponent.city;
        }
        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
        
        [[RequestManager shareRequestManager] GetMyCityInfo:nil viewController:nil successData:^(NSDictionary *result) {
            NSArray * cityArray =  [NSArray arrayWithArray: [result objectForKey:@"cityList"] ] ;
            for (NSDictionary * dic in cityArray) {
                NSString * city_Name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
                NSString * city_Code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityCode"]];
                NSLog(@"cityName  %@",city_Name);
                NSLog(@"province  %@",regeocodeprovince);
                NSLog(@"city  %@",regeocodecity);
                if ([regeocodecity rangeOfString:city_Name].location !=NSNotFound||[regeocodeprovince rangeOfString:city_Name].location !=NSNotFound||[city_Name isEqualToString:regeocodeprovince]||[city_Name isEqualToString:regeocodecity]) {
                    [userDefaults setObject:city_Name forKey:@"cityName"];
                    [userDefaults setObject:city_Code forKey:@"cityCode"];
                    [userDefaults setObject:lat forKey:@"latitude"];
                    [userDefaults setObject:lon forKey:@"longitude"];
                    //位置显示
                    [userDefaults setObject:response.regeocode.formattedAddress forKey:@"formattedAddress"];
                    [userDefaults synchronize];
                    selectCityType = @"1";
                    //                     return  ;
                }
                
            }
            if ([selectCityType isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
                saveAddressBtn.userInteractionEnabled = YES;
            }else{
                [[RequestManager shareRequestManager] tipAlert:@"您所在的城市未开通服务，请手动选择城市" viewController:self];
                saveAddressBtn.userInteractionEnabled = YES;
            }
            
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"当前位置设置失败，请重试" viewController:self];
            saveAddressBtn.userInteractionEnabled = YES;
        }];
        
    }
}


- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] init];
    [AMapSearchServices sharedServices].apiKey = GDMapKey;
    
    self.search.delegate = self;
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString * cityCode = [chooseDic objectForKey:@"cityCode"];
    
    if (key.length == 0)
    {
        return;
    }
    //    NSLog(@"key------------>%@",key);
    //    NSLog(@"cityCode------------>%@",cityCode);
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    //    tips.searchType = AMapSearchType_InputTips;
    
    tips.city =  cityName;
    [self.search AMapInputTipsSearch:tips];
    
}

#pragma mark 高德地图

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    //    NSLog(@"response %@",response.tips);
    
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString * cityName = [chooseDic objectForKey:@"cityName"];
    [self.tips removeAllObjects];
    [cellArray removeAllObjects];
    [self.tips setArray:response.tips];
    for (int i = 0; i <self.tips.count;i++ ) {
        AMapTip *tip = self.tips[i];
        
        NSString * dis = tip.district;
        NSLog(@"dis -- %@",dis);
        if([dis rangeOfString:cityName].location !=NSNotFound&&dis){
            //            NSLog(@"找不到 和城市名字相同的");
            [cellArray addObject:tip];
        }
        else{
        }
    }
    //    NSLog(@"self.tips  %@",self.tips);
    //    NSLog(@"cellArray  %@",cellArray);
    [searchTableView reloadData];
    
    if (cellArray.count == 0) {
        noresultLabel.hidden = NO;
        if ([searchField.text isEqualToString:@""]) {
            noresultLabel.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 0);
        }
        else{
            noresultLabel.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 80);
            noresultLabel.text = @"没有搜索结果!";
        }
       
        hotAreaView1.frame = CGRectMake(0, noresultLabel.frame.origin.y+noresultLabel.frame.size.height, kScreenWidth, hotAreaView1.frame.size.height);
        historyTitle.frame = CGRectMake(0, hotAreaView1.frame.origin.y+hotAreaView1.frame.size.height, kScreenWidth, 38);
        positionHistoryTableView.frame = CGRectMake(0, historyTitle.frame.origin.y+historyTitle.frame.size.height, kScreenWidth, kScreenHeight-(historyTitle.frame.origin.y+historyTitle.frame.size.height+50*AUTO_SIZE_SCALE_X));
        if(businessArray.count >0){
            hotAreaView1.hidden = NO;
        }
        else{
            hotAreaView1.hidden = YES;
        }
        if (historyArray.count>0) {
            historyTitle.hidden = NO;
        }else{
            historyTitle.hidden = YES;
        }
        positionHistoryTableView.hidden = NO;
    }
    else{
        noresultLabel.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 0);
        hotAreaView1.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, hotAreaView1.frame.size.height);
        historyTitle.frame = CGRectMake(0, hotAreaView1.frame.origin.y+hotAreaView1.frame.size.height, kScreenWidth, 38);
        positionHistoryTableView.frame = CGRectMake(0, historyTitle.frame.origin.y+historyTitle.frame.size.height, kScreenWidth, kScreenHeight-(historyTitle.frame.origin.y+historyTitle.frame.size.height+50*AUTO_SIZE_SCALE_X));
        noresultLabel.hidden = YES;
        hotAreaView1.hidden = YES;
        historyTitle.hidden = YES;
        positionHistoryTableView.hidden = YES;
    }
}

-(void)searchFieldChange
{
    //    NSLog(@"searchField.text %@",searchField.text);
    if ([searchField.text isEqualToString:@""]) {
        noresultLabel.hidden = YES;
        noresultLabel.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 0);
        hotAreaView1.frame = CGRectMake(0, noresultLabel.frame.origin.y+noresultLabel.frame.size.height, kScreenWidth, hotAreaView1.frame.size.height);
        historyTitle.frame = CGRectMake(0, hotAreaView1.frame.origin.y+hotAreaView1.frame.size.height, kScreenWidth, 38);
        positionHistoryTableView.frame = CGRectMake(0, historyTitle.frame.origin.y+historyTitle.frame.size.height, kScreenWidth, kScreenHeight-(historyTitle.frame.origin.y+historyTitle.frame.size.height+50*AUTO_SIZE_SCALE_X));
        if (historyArray.count>0) {
            
            
            historyTitle.hidden = NO;
            
            
        }else{
            
            
            historyTitle.hidden = YES;
            
            
            
        }
        positionHistoryTableView.hidden = NO;
        if(businessArray.count >0){
            hotAreaView1.hidden = NO;
        }
        else{
            hotAreaView1.hidden = YES;
        }
        searchTableView.hidden = YES;
    }else{
        noresultLabel.hidden = YES;
        noresultLabel.frame = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, 0);
        historyTitle.hidden = YES;
        positionHistoryTableView.hidden = YES;
        hotAreaView1.hidden = YES;
        searchTableView.hidden = NO;
        [self searchTipsWithKey:searchField.text];
    }
    
    
}

#pragma mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == searchTableView) {
        return 1;
    }
    else if(tableView == positionHistoryTableView){
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == searchTableView) {
        return 44*AUTO_SIZE_SCALE_X;
    }
    else if(tableView == positionHistoryTableView){
        if ( indexPath.section == 0) {
            return 45;
        }
        else if(indexPath.section == 1){
            return 60;
        }
    }
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchTableView) {
        return cellArray.count;
    }
    else if(tableView == positionHistoryTableView){
        if (section == 0) {
            return historyArray.count;
        }
        else if(section == 1){
            if (historyArray.count > 0) {
              return 1;
            }
            return 0;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == searchTableView) {
        static NSString *tipCellIdentifier = @"publicTableViewCell";
        
        publicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
        
        if (cell == nil)
        {
            NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:tipCellIdentifier owner:nil options:nil];
            cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
            
        }
        
        AMapTip *tip = cellArray[indexPath.row];
        
        UILabel * nameLabel = [[UILabel  alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 210*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X)];
        nameLabel.numberOfLines = 0;
        nameLabel.text = tip.name;
        nameLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:nameLabel];
        
        
        UILabel * districtLabel = [[UILabel  alloc] initWithFrame:CGRectMake(kScreenWidth-12*AUTO_SIZE_SCALE_X-80*AUTO_SIZE_SCALE_X, 0, 80*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X)];
        districtLabel.numberOfLines = 0;
        districtLabel.text = tip.district;
        districtLabel.textColor = C6UIColorGray;
        //    districtLabel.textAlignment = NSTextAlignmentRight;
        districtLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:districtLabel];
        
        
        
        UIImageView * hengxianImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
        hengxianImv.image = [UIImage imageNamed:@"icon_zhixian"];
        [cell addSubview:hengxianImv];
        
        if (cellArray.count == indexPath.row+1) {
            hengxianImv.frame = CGRectMake(0, 44*AUTO_SIZE_SCALE_X-1, kScreenWidth, 1);
        }
        
        return cell;
        
    }
    else if(tableView == positionHistoryTableView)
    {
        static NSString *tipCellIdentifier = @"publicTableViewCell";
        
        publicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
        
        if (cell == nil)
        {
            NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:tipCellIdentifier owner:nil options:nil];
            cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
            
        }
        
        if (indexPath.section == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * nameLabel = [[UILabel  alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, kScreenWidth-20*AUTO_SIZE_SCALE_X, 38)];
            nameLabel.numberOfLines = 0;
            nameLabel.text = [[historyArray objectAtIndex:indexPath.row] objectForKey:@"PositionInfo"];
            nameLabel.font = [UIFont systemFontOfSize:14];
            [cell addSubview:nameLabel];
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        else if (indexPath.section == 1){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton * cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cleanBtn.frame = CGRectMake((kScreenWidth-150)/2, 15, 150, 30);
            [cleanBtn setBackgroundImage:[UIImage imageNamed:@"bg_clearrecord"] forState:UIControlStateNormal];
            [cleanBtn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
            [cleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cleanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [cleanBtn addTarget:self action:@selector(cleanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cleanBtn];
            
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        return cell;
    }
    else{
        static NSString *tipCellIdentifier = @"publicTableViewCell";
        
        publicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
        
        if (cell == nil)
        {
            NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:tipCellIdentifier owner:nil options:nil];
            cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == searchTableView) {
        [searchField resignFirstResponder];
        AMapTip *tip = cellArray[indexPath.row];
        
        searchField.text = tip.name;
        //    NSLog(@"tip  %@",tip );
        AMapGeoPoint * location =tip.location;
        
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:cityCode forKey:@"cityCode"];
        [userDefaults setObject:cityName forKey:@"cityName"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@%@",tip.district,tip.name] forKey:@"formattedAddress"];
        [userDefaults setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"latitude"];
        [userDefaults setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"longitude"];
        //    [userDefaults setObject:[chooseDic objectForKey:@"openStatus"] forKey:@"openStatus"];
        [userDefaults synchronize];
        
        selectCityType = @"1";
        NSLog(@"cityCode--%@",cityCode);
        NSLog(@"cityName--%@",cityName);
        NSLog(@"tip.district,tip.name--%@%@",tip.district,tip.name);
        NSLog(@"latitude--%f",location.latitude);
        NSLog(@"longitude--%f",location.longitude);
        //    NSDictionary * locationDic = @{
        //                                   @"latitude":[NSString stringWithFormat:@"%f",location.latitude],
        //                                   @"longitude":[NSString stringWithFormat:@"%f",location.longitude],
        //                                   };
        //    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChange" object:locationDic];
        [self.navigationController popViewControllerAnimated:YES ];
        //    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
        //    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
        //    geo.address = tip.name;
        ////    geo.city = @[tip.adcode];
        //
        //    //发起正向地理编码
        //    [_search AMapGeocodeSearch: geo];
        
        
        //        NSString *sql11 = [NSString stringWithFormat:@"insert into PositionHistory(CityCode,PositionInfo,latitude,longitude) values('%@','%@','%@','%@')",cityCode,[NSString stringWithFormat:@"%@%@",tip.district,tip.name],[NSString stringWithFormat:@"%f",location.latitude],[NSString stringWithFormat:@"%f",location.longitude] ];
        //        [[DBHelper sharedDBHelper] ExecuteSql:sql11];
        
        [self insertHistoryCode:cityCode posotionInfo:[NSString stringWithFormat:@"%@%@",tip.district,tip.name] latitude:[NSString stringWithFormat:@"%f",location.latitude] longitude:[NSString stringWithFormat:@"%f",location.longitude] ];
        if (historyArray.count == 20) {
            NSString* sql = [NSString stringWithFormat:@"delete from PositionHistory where PositionInfo='%@'",[[historyArray objectAtIndex:0] objectForKey:@"PositionInfo"]];
            
            [[DBHelper sharedDBHelper] ExecuteSql:sql];
        }
    }
    if (tableView == positionHistoryTableView){
        if (indexPath.section == 0) {
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:cityCode forKey:@"cityCode"];
            [userDefaults setObject:cityName forKey:@"cityName"];
            [userDefaults setObject:[[historyArray objectAtIndex:indexPath.row] objectForKey:@"PositionInfo"] forKey:@"formattedAddress"];
            [userDefaults setObject:[[historyArray objectAtIndex:indexPath.row] objectForKey:@"latitude"] forKey:@"latitude"];
            [userDefaults setObject:[[historyArray objectAtIndex:indexPath.row] objectForKey:@"longitude"] forKey:@"longitude"];
            
            selectCityType = @"1";
            [self.navigationController popViewControllerAnimated:YES ];

        }
    }
    
    
    
    
}

//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    //    NSLog(@"response  ---> %@",  response   );
    //    NSLog(@"response.geocodes ---> %@",  response.geocodes  );
    
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    //    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@geocode: %@", strGeocodes, p.description];
    }
    //    NSString *result = [NSString stringWithFormat:@"strCount－－%@ \n strGeocodes－－%@", strCount, strGeocodes ];
    
    
    //    NSLog(@"Geocode:－》 %@", result);
    //    NSLog(@"response.geocodes ---> %@", response.geocodes );
    //    NSLog(@"[response.geocodes objectAtIndex:0] ---> %@",   [response.geocodes objectAtIndex:0]    );
    
    AMapGeocode * a = [response.geocodes objectAtIndex:0];
    NSLog(@"location.latitude ---> %f",  a.location.latitude  );
    NSLog(@"location.longitude ---> %f",  a.location.longitude  );
    //    NSDictionary * locationDic = @{
    //                                   @"latitude":[NSString stringWithFormat:@"%f",a.location.latitude],
    //                                   @"longitude":[NSString stringWithFormat:@"%f",a.location.longitude],
    //                                   };
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChange" object:locationDic];
    NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cityName forKey:@"cityName"];
    [userDefaults setObject:cityCode forKey:@"cityCode"];
    //        [userDefaults setObject:@"2" forKey:@"openStatus"];
    //位置显示
    [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
    //默认一个经纬度，公司经纬度
    [userDefaults setObject:[NSString stringWithFormat:@"%f",a.location.latitude] forKey:@"latitude"];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",a.location.longitude] forKey:@"longitude"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES ];
}

-(void)returnCityInfo:(ReturnselectCityInfo)block
{
    self.returnselectCityInfo = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideHud];
    
    if (self.returnselectCityInfo != nil) {
        self.returnselectCityInfo(selectCityType);
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
#pragma mark - 判断网络是否开启
-(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    //    if (!isExistenceNetwork) {
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
    //        hud.removeFromSuperViewOnHide =YES;
    //        hud.mode = MBProgressHUDModeText;
    //        hud.labelText = @"当前网络不可用，请检查网络连接";  //提示的内容
    //        hud.minSize = CGSizeMake(132.f, 108.0f);
    //        [hud hide:YES afterDelay:3];
    //        return NO;
    //    }
    
    return isExistenceNetwork;
}
@end
