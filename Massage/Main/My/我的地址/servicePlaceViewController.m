//
//  servicePlaceViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/3.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "servicePlaceViewController.h"
#import "publicTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CCLocationManager.h"
#define GeoPlaceHolder @"小区、大厦或街道名称"

@interface servicePlaceViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    UIView * searView;
    UITextField * searchField;
    
    UIView * LogationView;
    UILabel * logationLabel;
    
    UITableView * searchTableView;
    
    NSString * userArea;
    
    UIImageView * iconrefreshImv;
    
    UIActivityIndicatorView * activityIndicator;
    
    NSString * provinceName;
    
    NSMutableArray * cellArray;


}
//@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *tips;
@end

@implementation servicePlaceViewController
@synthesize mapView = _mapView;
@synthesize search  = _search;
@synthesize tips = _tips;
//@synthesize searchBar = _searchBar;

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"服务地址";
    
    cellArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self initSearch];
    
    
    [self initsearView];
    [self initLogationView];
    [self initTableView];
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] init ];
    [AMapSearchServices sharedServices].apiKey = GDMapKey;
    self.search.delegate = self;
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    if (key.length == 0)
    {
        return;
    }
    NSLog(@"key------------>%@",key);
    NSLog(@"cityCode------------>%@",cityCode);
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
//    tips.searchType = AMapSearchType_InputTips;
    
    tips.city =  cityCode ;
    [self.search AMapInputTipsSearch:tips];
}

-(void)initsearView
{
    searView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
    searView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searView];
    
    UIImageView * iconsearchImv = [[UIImageView alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X, (44-17)/2*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    iconsearchImv.image = [UIImage imageNamed:@"icon_location_search"];
    [searView addSubview:iconsearchImv];
    
    UIImageView * iconcancelImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-25*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, (44-15)/2*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    iconcancelImv.image = [UIImage imageNamed:@"icon_location_empty"];
    [searView addSubview:iconcancelImv];
    iconcancelImv.userInteractionEnabled = YES;
    UITapGestureRecognizer * cancleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTaped:)];
    [iconcancelImv addGestureRecognizer:cancleTap];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(iconsearchImv.frame.origin.x+iconsearchImv.frame.size.width+10*AUTO_SIZE_SCALE_X, 0, 220*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X)];
    searchField.delegate = self;
    searchField.placeholder = GeoPlaceHolder;
    searchField.tintColor = C6UIColorGray;
    searchField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    searchField.returnKeyType = UIReturnKeyDone;
    [searchField addTarget:self action:@selector(searchFieldChange) forControlEvents:UIControlEventEditingChanged];
    [searchField setValue:C6UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X] forKeyPath:@"_placeholderLabel.font"];
    searchField.textColor = [UIColor blackColor];
    [searView addSubview:searchField];
    
}

-(void)initLogationView
{
    LogationView = [[UIView alloc] initWithFrame:CGRectMake(7*AUTO_SIZE_SCALE_X, searView.frame.origin.y+searView.frame.size.height+5*AUTO_SIZE_SCALE_X, kScreenWidth-14*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X)];
    LogationView.layer.cornerRadius = 5.0;
    LogationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:LogationView];
    
    UIImageView * locationImv = [[UIImageView alloc] initWithFrame:CGRectMake(8*AUTO_SIZE_SCALE_X, (26-13)/2*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
    locationImv.image = [UIImage imageNamed:@"icon_location"];
    [LogationView addSubview:locationImv];
    
    logationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X, 0, 240*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X)];
    logationLabel.text = [NSString stringWithFormat:@"%@",@""];
    logationLabel.numberOfLines = 0;
    logationLabel.textColor = C6UIColorGray;
    logationLabel.font = [UIFont systemFontOfSize:11*AUTO_SIZE_SCALE_X];
    [LogationView addSubview:logationLabel];
    logationLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * logationLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logationLabelTaped:)];
    [logationLabel addGestureRecognizer:logationLabelTap];
    
    iconrefreshImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-(15+7+14)*AUTO_SIZE_SCALE_X, (26-15)/2*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    iconrefreshImv.image = [UIImage imageNamed:@"icon_location_refresh"];
    [LogationView addSubview:iconrefreshImv];
    iconrefreshImv.userInteractionEnabled = YES;
    UITapGestureRecognizer * iconrefreshImvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconrefreshImvTaped:)];
    [iconrefreshImv addGestureRecognizer:iconrefreshImvTap];
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//            regeoRequest.searchType = AMapSearchType_ReGeocode;
            regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
            regeoRequest.radius = 10000;
            regeoRequest.requireExtension = YES;
            
            //发起逆地理编码
            [_search AMapReGoecodeSearch: regeoRequest];
        }];
    }
    
    else{
        logationLabel.text = [NSString stringWithFormat:@"%@",@"请打开gps定位后刷新位置"];
    }
    
}

-(void)initTableView
{
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, LogationView.frame.origin.y+LogationView.frame.size.height+7*AUTO_SIZE_SCALE_X, self.view.frame.size.width, self.view.frame.size.height-(LogationView.frame.origin.y+LogationView.frame.size.height+7*AUTO_SIZE_SCALE_X+50*AUTO_SIZE_SCALE_X))];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.backgroundColor = [UIColor clearColor];
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.showsVerticalScrollIndicator = NO;
    searchTableView.rowHeight = 44*AUTO_SIZE_SCALE_X;
    [self.view addSubview:searchTableView];
    
    //保存布局
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, kScreenWidth, 500*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor  whiteColor];
    [self.view addSubview:btnView];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:zhixianImv];
    
    UIButton * saveAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddressBtn.frame = CGRectMake(15, 5*AUTO_SIZE_SCALE_X, kScreenWidth-30, 40*AUTO_SIZE_SCALE_X);
    [saveAddressBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [saveAddressBtn setTitle:@"保存地址" forState:UIControlStateNormal];
    [saveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    [saveAddressBtn addTarget:self action:@selector(saveAddressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:saveAddressBtn];

}

-(void)saveAddressBtnPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)logationLabelTaped:(UITapGestureRecognizer *)sender
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * cityName = [userDefaults objectForKey:@"cityName"];
        NSLog(@"provinceName %@",provinceName);
        NSLog(@"cityName %@",cityName);
        NSLog(@"logationLabel.text %@",logationLabel.text);
        
        if ([cityName isEqualToString:provinceName]) {
            userArea = logationLabel.text;
            [self.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"相同，可以回跳");
        }else{
            NSLog(@"不同，不可以回跳");
            [[RequestManager shareRequestManager] tipAlert:@"选择的城市和当前地位城市不符" viewController:self];
        }
        
    }
    
}

-(void)iconrefreshImvTaped:(UITapGestureRecognizer *)sender
{
    [iconrefreshImv removeFromSuperview];
    iconrefreshImv.userInteractionEnabled = NO;
    logationLabel.text = @"请稍等,正在更新您的位置...";
    logationLabel.userInteractionEnabled = NO;
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//            regeoRequest.searchType = AMapSearchType_ReGeocode;
            regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
            //    regeoRequest.radius = 10000;
            regeoRequest.requireExtension = YES;
            
            //发起逆地理编码
            [_search AMapReGoecodeSearch: regeoRequest];
            
            activityIndicator = [[UIActivityIndicatorView alloc]
                                 initWithActivityIndicatorStyle:
                                 UIActivityIndicatorViewStyleWhite];
            activityIndicator.color = [UIColor blackColor];
            activityIndicator.center = CGPointMake(iconrefreshImv.frame.origin.x+iconrefreshImv.frame.size.width/2, iconrefreshImv.frame.origin.y+iconrefreshImv.frame.size.height/2);;
            [activityIndicator startAnimating]; // 开始旋转
            [LogationView addSubview:activityIndicator];
        }];
    }
    
    else{
        logationLabel.text = [NSString stringWithFormat:@"%@",@"请打开gps定位后刷新位置"];
        [LogationView addSubview:iconrefreshImv];
        iconrefreshImv.userInteractionEnabled = YES;
        
    }
    
}

#pragma mark 高德地图

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    //    NSLog(@"response %@",response);
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityName = [userDefaults objectForKey:@"cityName"];
    [self.tips removeAllObjects];
    [cellArray removeAllObjects];
    [self.tips setArray:response.tips];
    for (int i = 0; i <self.tips.count;i++ ) {
        AMapTip *tip = self.tips[i];
        
        NSString * dis = tip.district;
        if([dis rangeOfString:cityName].location !=NSNotFound){
            NSLog(@"找不到 和城市名字相同的");
            [cellArray addObject:tip];
        }
        else{
        }
    }
    NSLog(@"self.tips  %@",self.tips);
    NSLog(@"cellArray  %@",cellArray);
    [searchTableView reloadData];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"error  %@",error);
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"实现逆地理编码的回调函数");
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode.addressComponent];
        NSLog(@"response: %@", response.regeocode.formattedAddress);
        NSLog(@"response.regeocode.addressComponent.province: %@//", response.regeocode.addressComponent.province);
        NSLog(@"response.regeocode.addressComponent.city: %@//", response.regeocode.addressComponent.city);
        NSLog(@"response.regeocode.addressComponent.district: %@//", response.regeocode.addressComponent.district);
        NSLog(@"response.regeocode.addressComponent.citycode: %@//", response.regeocode.addressComponent.citycode);
        
        if([response.regeocode.addressComponent.city isEqualToString:@""]||!response.regeocode.addressComponent.city){
            provinceName = response.regeocode.addressComponent.province;
        }else{
            provinceName =response.regeocode.addressComponent.city;
        }
        
        if ([provinceName isEqualToString:@""]) {
            
        }else{
            provinceName = [provinceName substringToIndex:provinceName.length-1];
        }
//        NSLog(@"provinceName ---> %@",provinceName);
        
        
        logationLabel.text = [NSString stringWithFormat:@"%@",response.regeocode.formattedAddress ];
        [LogationView addSubview:iconrefreshImv];
        //        [timer invalidate];
        //        iconrefreshImv.transform=CGAffineTransformMakeRotation(0);
        [activityIndicator stopAnimating]; // 结束旋转
        [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        iconrefreshImv.userInteractionEnabled = YES;
        logationLabel.userInteractionEnabled = YES;

    }
}

#pragma mark UITextFied事件
-(void)searchFieldChange
{
    NSLog(@"searchField.text %@",searchField.text);
    [self searchTipsWithKey:searchField.text];
    
}

-(void)cancelTaped:(UITapGestureRecognizer  *)sender
{
    searchField.text = @"";
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchField resignFirstResponder];
    return YES;
}
#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    [cell addSubview:nameLabel];
    
    
    UILabel * districtLabel = [[UILabel  alloc] initWithFrame:CGRectMake(kScreenWidth-12*AUTO_SIZE_SCALE_X-80*AUTO_SIZE_SCALE_X, 0, 80*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X)];
    districtLabel.numberOfLines = 0;
    districtLabel.text = tip.district;
    districtLabel.textColor = C6UIColorGray;
//    districtLabel.textAlignment = NSTextAlignmentRight;
    districtLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
    [cell addSubview:districtLabel];
    
    
    
    UIImageView * hengxianImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    hengxianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [cell addSubview:hengxianImv];
    
    if (cellArray.count == indexPath.row+1) {
        hengxianImv.frame = CGRectMake(0, 44*AUTO_SIZE_SCALE_X-1, kScreenWidth, 1);
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchField resignFirstResponder];

    AMapTip *tip = cellArray[indexPath.row];

    searchField.text = tip.name;
    NSLog(@"tip  %@",tip );
    
    NSLog(@"tip.name %@",tip.name);
    NSLog(@"tip.adcode %@",tip.adcode);
    NSLog(@"tip.district %@",tip.district);
    userArea = [NSString stringWithFormat:@"%@%@",tip.district,tip.name];
    
}

- (void)returnText:(ReturnServerAddressTextBlock)block {
    NSLog(@"returnText");
    self.returnServerAddressTextBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults ];
    NSString * cityName = [userDefaults objectForKey:@"cityName"];
    if (self.returnServerAddressTextBlock != nil) {
        self.returnServerAddressTextBlock(cityName , userArea);
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
