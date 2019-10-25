//
//  DoorServiceHomePageViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/14.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.


#import "DoorServiceHomePageViewController.h"
#import "TouchPropagatedScrollView.h"
#import "QHCommonUtil.h"
#import "BaseTableView.h"
#import "CustomCellTableViewCell.h"
#import "advertisementCell.h"
#import "KxMenu.h"
#import "CityChangeViewController.h"
#import "StoreSearchViewController.h"
#import "RequestManager.h"
#import "TechicianListCell.h"

#import "CCLocationManager.h"
#import <AMapSearchKit/AMapSearchKit.h>

#import "TechnicianMyselfViewController.h"
#import "technicianViewController.h"
#import "ServiceDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "publicTableViewCell.h"

#import "ServiceActivityViewController.h"
#import "WorkerActivityViewController.h"
#import "SelectCityViewController.h"


#import "LoginViewController.h"
#import "MyFavoritesViewController.h"
#import "noWifiView.h"
#define MENU_HEIGHT 35
#define MENU_BUTTON_WIDTH  80
#define MIN_MENU_FONT  14.f
#define MAX_MENU_FONT  15.f
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define ImvHeight (kScreenWidth-20)/2
#define scrollViewHeight 35

@interface DoorServiceHomePageViewController ()<UIScrollViewDelegate,BaseTableViewDelegate,UITableViewDataSource,UITableViewDelegate, AMapSearchDelegate >{
    float _startPointX;
    NSMutableArray * ButtonArray;
    NSString * cityName;
    NSArray *listViewData;
    
    NSMutableArray *arT;
    NSMutableArray *baseTableViewArray;
    NSMutableArray *arrayGroup;
    long currentNum;
    NSString * navType;
    
    NSMutableArray * navigationListArray;
    NSString * navID;
    NSString * orderBy;
    NSString * contextType;
    
    int _pageForHot;
    
    UIImageView * iconrefreshImv;
    UILabel * logationLabel;
    UIActivityIndicatorView * activityIndicator;
    
    NSString * serviceType;
    
    NSMutableArray * adListArray;
     NSMutableArray * navTypeArray;
    
    UIImageView * zhixianImv;
//    UIButton * reloadbtn;
    NSString * formattedAddress;
    
    NSMutableDictionary * currentLocationDic;
    noWifiView *failView;

}

@property (nonatomic , strong) UIScrollView *contentScrollView;
@property (nonatomic , strong) UIButton *moreBtn;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIScrollView *myScrollView;
@property (nonatomic , strong) UIImageView *moreImageView;
@property (nonatomic , strong) NSMutableArray *fallsData;

@property (nonatomic , strong) NSMutableArray *techicianData;
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) NSMutableArray *ALLData;
@property (nonatomic , strong) NSMutableArray *ALLData1;
@property (nonatomic , strong) NSMutableArray *data1;

@property (nonatomic , strong) KxMenu *Menu;
@property (nonatomic , strong) UIButton *cityChangeBtn;
@property (nonatomic , strong) UIButton *SearchBtn;

@property (nonatomic , strong) UIView * locationView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation DoorServiceHomePageViewController

//查询分类导航
-(void)getNavigationList
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
//    reloadbtn.hidden = YES;
    zhixianImv.hidden = YES;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSLog(@"cityCode %@",cityCode);
    NSDictionary * dic = @{
                           @"cityCode":cityCode,
                           @"type":serviceType,//0到店，1上门
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] getNavigationList:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"分类导航result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            self.contentScrollView.hidden = NO;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            [navigationListArray removeAllObjects];
            [arT removeAllObjects];
            navigationListArray = [NSMutableArray arrayWithArray:[result objectForKey:@"navigationList"]];
            if (navigationListArray.count > 0) {
//                for (NSDictionary * dic in navigationListArray) {
//                    NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                    [arT addObject:name];
//                }
                for (int i = 0 ; i<navigationListArray.count; i++) {
                    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[navigationListArray objectAtIndex:i]];
                    NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                    [arT addObject:name];
                    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isDefault"]] isEqualToString:@"1"]) {
                        currentNum = i;
                    }
                }
                navID = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"ID"] ];
                contextType = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"contextType"] ];
                orderBy = @"0";
                
                zhixianImv.hidden = NO;
                
                //重新加载导航条 需要清空baseTableViewArray  arrayGroup   ButtonArray
                [baseTableViewArray removeAllObjects];
                [arrayGroup removeAllObjects];
                [ButtonArray removeAllObjects];
                [adListArray removeLastObject];
                [navTypeArray removeLastObject];
                
                for (int i = 0; i < [arT count]; i++)
                {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake((MENU_BUTTON_WIDTH) * i, 0, MENU_BUTTON_WIDTH, scrollViewHeight-1)];
                    [btn setTitle:[arT objectAtIndex:i] forState:UIControlStateNormal];
                    [btn setTitleColor:RedUIColorC1 forState:UIControlStateSelected];
                    [btn setTitleColor:UIColorFromRGB(0xc6b6b6b)  forState:UIControlStateNormal];
                    btn.tag = i + 1 ;
                    [ButtonArray addObject:btn];
                    if (i ==currentNum ) {
                        [btn setSelected:YES];
                        btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
                    }else{
                        [btn setSelected:NO];
                        btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
                    }
                    
                    [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
                    [self.myScrollView addSubview:btn];
                }
                [self.myScrollView setContentSize:CGSizeMake( (MENU_BUTTON_WIDTH )* [arT count]+20, scrollViewHeight-1)];
                float xx = self.myScrollView.frame.size.width * currentNum * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
                [self.myScrollView scrollRectToVisible:CGRectMake(xx, 0, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height) animated:NO];
                
                [self addView2Page:self.contentScrollView count:[arT count] frame:CGRectZero];

                //查询分类导航内容
                [self getNavContent];
                self.moreBtn.hidden = NO;
                
            }else{
                self.moreBtn.hidden = YES;
            }
            
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        self.moreBtn.hidden = YES;
        self.contentScrollView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
//        reloadbtn.hidden = NO;
        
    }];
}

//查询分类导航内容
-(void)getNavContent
{
    BaseTableView  * currentBasetableView = [baseTableViewArray objectAtIndex:currentNum];
    currentBasetableView.userInteractionEnabled = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    _pageForHot = 1;
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"10";
    if ([contextType isEqualToString:@"0"]) {
        pageOffset = @"15";
    }
    else if ([contextType isEqualToString:@"1"])
    {
        pageOffset = @"30";
    }
    else
    {
        pageOffset = @"15";
    }
    
    NSDictionary * dic = @{
                           @"longitude":longitude,//用户经度
                           @"latitude":latitude,//用户纬度
                           @"ID":navID,//分类 导航ID
                           @"orderBy":orderBy,//0按距离，1 按评价数量，2 按订单数量，3 按价格
                           @"pageStart":page,//默认值为：1
                           @"pageOffset":pageOffset,//默认值为：10
                           };
//    NDLog(@"dic -- %@",dic);
    [[RequestManager shareRequestManager] getNavContent:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"查询分类导航内容result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            self.contentScrollView.hidden = NO;
            [self.contentScrollView setContentOffset:CGPointMake(kScreenWidth*currentNum, 0)];
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            navType = [NSString stringWithFormat:@"%@",[result objectForKey:@"navType"]];
            //            [adListArray removeAllObjects];
            //            [adListArray addObjectsFromArray:[result objectForKey:@"adList"]];
            //navTypeArray
            [navTypeArray replaceObjectAtIndex:currentNum withObject:navType];
            
            [adListArray replaceObjectAtIndex:currentNum withObject:[result objectForKey:@"adList"]];

            BaseTableView * currentTableView = [baseTableViewArray objectAtIndex:currentNum];
            if ([navType isEqualToString:@"2"]) {
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"skillList"] ];
                [arrayGroup replaceObjectAtIndex:currentNum withObject:array];
                //                NSLog(@"array---%@",array);
                // 1.根据数量判断是否需要隐藏上拉控件
                if (array.count < 15 || array.count ==0 ) {
                    [currentTableView.foot finishRefreshing];
                }else
                {
                    [currentTableView.foot endRefreshing];
                }
                
            }
            else if ([navType isEqualToString:@"1"]){
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"serviceList"] ];
                
                NSMutableArray * array0 =[[NSMutableArray alloc] initWithCapacity:0];
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
                
                [ array0 addObjectsFromArray:array1];
                
                [arrayGroup replaceObjectAtIndex:currentNum withObject:array0];
                // 1.根据数量判断是否需要隐藏上拉控件
                if (array.count < 15 || array.count ==0 ) {
                    [currentTableView.foot finishRefreshing];
                }else
                {
                    [currentTableView.foot endRefreshing];
                }
                
            }
            
            
            [currentTableView reloadData];
                    currentBasetableView.userInteractionEnabled = YES;

            
        }
        else
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        
        self.view.userInteractionEnabled = YES;

    } failuer:^(NSError *error) {
        currentBasetableView.userInteractionEnabled = YES;
        failView.hidden = NO;
        self.contentScrollView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        
        self.view.userInteractionEnabled = YES;

    }];
    
}

#pragma mark 接收广播
-(void)gotoServiceDetailController:(NSNotification *)notification
{
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:notification.object];
    ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
    vc.haveWorker = NO;
    vc.serviceType = serviceType;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
    
    //判断 当前locationLabel上的地址 是不是沙盒里的地址 如果不是 刷新界面
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * defaultsformattedAddress = [userDefaults objectForKey:@"formattedAddress"];
    NSString * defaultscityName = [userDefaults objectForKey:@"cityName"];
    if ([logationLabel.text isEqualToString:defaultsformattedAddress]) {
        
    }else{
        for (UIButton * btn in ButtonArray) {
            [btn removeFromSuperview];
        }
        for (BaseTableView * tabview in baseTableViewArray) {
            [tabview removeFromSuperview];
        }
        
        cityName = [userDefaults objectForKey:@"cityName"];
        [_cityChangeBtn setTitle:defaultscityName forState:UIControlStateNormal];//设置button的title
        logationLabel.text = defaultsformattedAddress;
        currentNum = 0;
        navType = @"";
        self.contentScrollView.contentOffset = CGPointMake(0, 0);
        self.myScrollView.contentOffset = CGPointMake(0, 0);
        //查询分类导航
        [self getNavigationList];
        [currentLocationDic removeAllObjects];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];


}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    
    zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavHeight+scrollViewHeight-0.5, kScreenWidth, 0.5)];
    zhixianImv.hidden = YES;
    zhixianImv.image = [UIImage  imageNamed:@"icon_zhixian"];
    [self.view  addSubview:zhixianImv];
    
}

-(void)initView
{
    self.titles = @"华佗驾到";
    self.view.backgroundColor = C2UIColorGray;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    cityName = [userDefaults objectForKey:@"cityName"];
    formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
    NSLog(@"cityName-->%@",cityName);
    
    arT = [[NSMutableArray alloc] initWithCapacity:0];
    ButtonArray = [NSMutableArray arrayWithCapacity:0];
    baseTableViewArray = [NSMutableArray arrayWithCapacity:0];
    arrayGroup = [NSMutableArray arrayWithCapacity:0];
    adListArray = [[NSMutableArray alloc] initWithCapacity:0];
    navTypeArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentNum = 0;
    navType = @"";
    serviceType = @"1";
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-( kNavHeight+kTabHeight+35))];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    //加载失败页面
//    [self reloadView];
    
    //显示界面
    [self showView];
    
}
- (void)reloadButtonClick:(UIButton *)sender {
    
        //ButtonArray
        //baseTableViewArray
        
        for (UIButton * btn in ButtonArray) {
            [btn removeFromSuperview];
        }
        for (BaseTableView * tabview in baseTableViewArray) {
            [tabview removeFromSuperview];
        }
        
//        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//        cityName = [userDefaults objectForKey:@"cityName"];
//        formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
//        [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
//        logationLabel.text = formattedAddress;
        currentNum = 0;
       navType = @"";
        self.contentScrollView.contentOffset = CGPointMake(0, 0);
        self.myScrollView.contentOffset = CGPointMake(0, 0);
        //查询分类导航
        [self getNavigationList];
}
#pragma mark 下载数据失败 从新下载 加载界面
//-(void)reloadView{
//    reloadbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    reloadbtn.frame = CGRectMake(kScreenWidth/2-40*AUTO_SIZE_SCALE_X, kScreenHeight/2-20*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
//    [reloadbtn setTitle:@"重新加载" forState:UIControlStateNormal];
//    [reloadbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [reloadbtn addTarget:self action:@selector(reloadbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    reloadbtn.hidden = YES;
//    [self.view addSubview:reloadbtn];
//    
//}
//
//-(void)reloadbtnPressed:(UIButton *)sender
//{
//    [self getNavigationList];
//    
//}

-(void)showView
{
    //按钮 图片加文字 http://blog.csdn.net/worldzhy/article/details/41284157
    //城市选择按钮
    [self.navView addSubview:self.cityChangeBtn];
    //搜索按钮
    [self.navView addSubview:self.SearchBtn];
    //定位
    [self.view addSubview:self.locationView];
    
    [self.cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
    logationLabel.text = formattedAddress;
    
    //城市选择按钮
    [self.cityChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(70, navBtnHeight));
    }];
    
    //搜索按钮
    [self.SearchBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScreenWidth - 30*AUTO_SIZE_SCALE_X);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30*AUTO_SIZE_SCALE_X, navBtnHeight));
        
    }];
    
    //定位
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.frame.size.height-49-35);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , 35));
    }];
    
    //滚动选项
    [self.view addSubview:self.myScrollView];
    //滚动选项
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(290*AUTO_SIZE_SCALE_X, scrollViewHeight-1));
    }];
    //滚动view
    [self.view addSubview:self.contentScrollView];
    //底部scrollview 约束
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight+scrollViewHeight);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , kScreenHeight-kNavHeight-scrollViewHeight-49-35));
    }];
    //下拉更多按钮
    [self.view addSubview:self.moreBtn];
    //下拉更多按钮
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, scrollViewHeight-1));
    }];
    
    
    //查询分类导航
    [self getNavigationList];
    
}

-(UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavHeight+scrollViewHeight,kScreenWidth,kScreenHeight-kNavHeight-scrollViewHeight-49-35)];
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.bounces = NO;
        [_contentScrollView setShowsHorizontalScrollIndicator:NO];
        [_contentScrollView setShowsVerticalScrollIndicator:NO];
        [_contentScrollView setPagingEnabled:YES];
        [_contentScrollView setDelegate:self];
        [_contentScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    }
    return _contentScrollView;
}

-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    BOOL isPaning = NO;
    if(self.contentScrollView.contentOffset.x < 0)
    {
        isPaning = YES;
        //        isLeftDragging = YES;
        //        [self showMask];
    }
    else if(self.contentScrollView.contentOffset.x > (self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width))
    {
        isPaning = YES;
        //        isRightDragging = YES;
        //        [self showMask];
    }
    //    if(isPaning)
    //    {
    //        [[QHSliderViewController sharedSliderController] moveViewWithGesture:panParam];
    //    }
}

- (void)addView2Page:(UIScrollView *)scrollV count:(NSUInteger)pageCount frame:(CGRect)frame
{
    
    for (int i = 0; i < pageCount; i++)
    {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        [arrayGroup addObject:array];
        NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];
        [adListArray addObject:array1];
        NSMutableArray * array2 = [[NSMutableArray alloc] initWithCapacity:0];
        [navTypeArray addObject:array2];
    }
    
    for (int i = 0; i < pageCount; i++)
    {
//        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
//        [arrayGroup addObject:array];
//        NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];
//        [adListArray addObject:array1];
//        NSMutableArray * array2 = [[NSMutableArray alloc] initWithCapacity:0];
//        [navTypeArray addObject:array2];
        
        BaseTableView *DoorTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width * i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
        DoorTableView.tag = i + 1;
        
        DoorTableView.delegate = self;
        DoorTableView.dataSource = self;
        DoorTableView.delegates = self;
        DoorTableView.showsHorizontalScrollIndicator = NO;
        DoorTableView.showsVerticalScrollIndicator = YES;
        DoorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [DoorTableView setBackgroundColor:[QHCommonUtil getRandomColor]];
        
        [scrollV addSubview:DoorTableView];
        
        [baseTableViewArray addObject:DoorTableView];
        
    }
    [scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * pageCount, scrollV.frame.size.height)];
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] init];
    [AMapSearchServices sharedServices].apiKey = GDMapKey;
    self.search.delegate = self;
}


-(UIButton *)cityChangeBtn
{
    //icon_header_dropdown
    if (!_cityChangeBtn) {
        UIImage * img = [UIImage imageNamed:@"icon_header_dropdown"];
        _cityChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _cityChangeBtn.backgroundColor = [UIColor blackColor];
        [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
        [_cityChangeBtn setImage:img forState:UIControlStateNormal];//给button添加image
        _cityChangeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGSize strSize = [cityName sizeWithFont:[UIFont systemFontOfSize:15]];
        
        CGFloat edgeLen = 12;
        [_cityChangeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70-edgeLen-img.size.width+5, 0, (edgeLen - strSize.width))];//(0,48,0,-18)
        [_cityChangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, (edgeLen - img.size.width), 0, edgeLen)];//(0,2,0,12)
        [_cityChangeBtn addTarget:self action:@selector(cityChangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cityChangeBtn;
}

-(UIButton *)SearchBtn
{
    //icon_header_dropdown
    if (!_SearchBtn) {
        _SearchBtn =[CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(onClickeSearchBtn:) Title:@""];
        [_SearchBtn setImage:[UIImage imageNamed:@"icon_header_search"] forState:UIControlStateNormal];
        _SearchBtn.backgroundColor =[UIColor clearColor];
    }
    return _SearchBtn;
}

-(UIScrollView *)myScrollView
{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] init];
        [_myScrollView setShowsHorizontalScrollIndicator:NO];
        [_myScrollView setShowsVerticalScrollIndicator:NO];
        _myScrollView.backgroundColor = UIColorFromFindRGB(0xf4f4f4);
        _myScrollView.bounces = NO;
        
        //        for (int i = 0; i < [arT count]; i++)
        //        {
        //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //            [btn setFrame:CGRectMake((MENU_BUTTON_WIDTH) * i, 0, MENU_BUTTON_WIDTH, scrollViewHeight-1)];
        //            [btn setTitle:[arT objectAtIndex:i] forState:UIControlStateNormal];
        //            [btn setTitleColor:RedUIColorC1 forState:UIControlStateSelected];
        //            [btn setTitleColor:UIColorFromRGB(0xc6b6b6b)  forState:UIControlStateNormal];
        //            btn.tag = i + 1 ;
        //            [ButtonArray addObject:btn];
        //            if (i ==0 ) {
        //                [btn setSelected:YES];
        //                btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
        //            }else{
        //                [btn setSelected:NO];
        //                btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
        //            }
        //
        //            [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        //            [self.myScrollView addSubview:btn];
        //        }
        //        [self.myScrollView setContentSize:CGSizeMake( (MENU_BUTTON_WIDTH )* [arT count], scrollViewHeight-1)];
    }
    return _myScrollView;
}

-(UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn =[CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(moreBtnPressed:) Title:@""];
        
        [_moreBtn setImage:[UIImage imageNamed:@"icon_filter_dropdown"] forState:UIControlStateNormal];
        _moreBtn.backgroundColor =[UIColor whiteColor];
        _moreBtn.alpha = 0.7;
        self.moreBtn.hidden = YES;

    }
    return _moreBtn;
}

-(UIView *)locationView
{
    if (!_locationView) {
        _locationView = [[UIView alloc] init ];
        //        _locationView.backgroundColor = [UIColor greenColor];
        UITapGestureRecognizer * selectCityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCityTaped:)];
        [_locationView addGestureRecognizer:selectCityTap];
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 35)]    ;
        bgView.image = [UIImage imageNamed:@"bg_location"];
        [self.locationView addSubview:bgView];
        
        UIImageView * locView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 13 , 13)];
        locView.image = [UIImage imageNamed:@"icon_location"];
        [self.locationView addSubview:locView];
        
        //        iconrefreshImv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-16-8-13, 10, 13 , 15)];
        //        iconrefreshImv.image = [UIImage imageNamed:@"icon_location_refresh"];
        //        [self.locationView addSubview:iconrefreshImv];
        //        iconrefreshImv.userInteractionEnabled = YES;
        //        UITapGestureRecognizer * iconrefreshImvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconrefreshImvTaped:)];
        //        [iconrefreshImv addGestureRecognizer:iconrefreshImvTap];
        
        logationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locView.frame.size.width+locView.frame.origin.x+10, 0, self.view.frame.size.width-(locView.frame.size.width+locView.frame.origin.x+10+10*AUTO_SIZE_SCALE_X), 35)];
        //        lable.backgroundColor = [UIColor redColor];
        logationLabel.textColor = UIColorFromRGB(0x999999);
        //        logationLabel.text = @"请稍等,正在更新您的位置...";
        logationLabel.text = formattedAddress;
        logationLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        [self.locationView addSubview:logationLabel];
        
        //        if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        //        {
        //            [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //
        //                AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        //                //                regeoRequest.searchType = AMapSearchType_ReGeocode;
        //                regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
        //                //    regeoRequest.radius = 10000;
        //                regeoRequest.requireExtension = YES;
        //
        //                //发起逆地理编码
        //                [_search AMapReGoecodeSearch: regeoRequest];
        //            }];
        //        }
        //
        //        else{
        //            logationLabel.text = [NSString stringWithFormat:@"%@",@"请打开gps定位后刷新位置"];
        //        }
        
    }
    return _locationView;
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
        //        NSLog(@"response: %@", response.regeocode.formattedAddress);
        //        NSLog(@"response.regeocode.addressComponent.province: %@//", response.regeocode.addressComponent.province);
        //        NSLog(@"response.regeocode.addressComponent.city: %@//", response.regeocode.addressComponent.city);
        //        NSLog(@"response.regeocode.addressComponent.district: %@//", response.regeocode.addressComponent.district);
        //        NSLog(@"response.regeocode.addressComponent.citycode: %@//", response.regeocode.addressComponent.citycode);
        
        
        
        logationLabel.text = [NSString stringWithFormat:@"%@",response.regeocode.formattedAddress ];
        [_locationView addSubview:iconrefreshImv];
        //        [timer invalidate];
        //        iconrefreshImv.transform=CGAffineTransformMakeRotation(0);
        [activityIndicator stopAnimating]; // 结束旋转
        [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        iconrefreshImv.userInteractionEnabled = YES;
    }
}

- (void)changeView:(float)x
{
    float xx = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
    
    float startX = xx;
    //    float endX = xx + MENU_BUTTON_WIDTH;
    int sT = (x)/self.contentScrollView.frame.size.width + 1;
    
    if (sT <= 0)
    {
        return;
    }
    UIButton *btn = (UIButton *)[self.myScrollView viewWithTag:sT];
    
    for (int i=0; i < ButtonArray.count; i++) {
        UIButton * tempButton = (UIButton *)[ButtonArray objectAtIndex:i];
        
        tempButton.selected =NO;
        
    }
    btn.selected =YES;
    
    
    float percent = (startX - MENU_BUTTON_WIDTH * (sT - 1))/MENU_BUTTON_WIDTH;
    
    
    float value = [QHCommonUtil lerp:(1 - percent) min:MIN_MENU_FONT max:MAX_MENU_FONT];
    btn.titleLabel.font = [UIFont systemFontOfSize:value];
    //    NSLog(@"value-- %f",value);
    
    
    if((int)xx%MENU_BUTTON_WIDTH == 0)
        return;
    
    UIButton *btn2 = (UIButton *)[self.myScrollView viewWithTag:sT + 1];
    float value2 = [QHCommonUtil lerp:percent min:MIN_MENU_FONT max:MAX_MENU_FONT];
    btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
    
    
}

#pragma mark - action

- (void)actionbtn:(UIButton *)btn
{
    NSString * str = @"";
    if (arT.count> 0) {
        str = [arT objectAtIndex:btn.tag-1];
        NSLog(@"str %@",str);
        NSDictionary * dic = @{
                               @"tagName":str,
                               };
        [MobClick event:DOOR_HORIZONTAL_TAB attributes:dic];
    }
    
    [self.contentScrollView scrollRectToVisible:CGRectMake(self.contentScrollView.frame.size.width * (btn.tag -1), self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height) animated:NO];
    
    float xx = self.myScrollView.frame.size.width * (btn.tag-1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [self.myScrollView scrollRectToVisible:CGRectMake(xx, 0, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height) animated:NO];
    
    
    for (int i=0; i < ButtonArray.count; i++) {
        UIButton * tempButton = (UIButton *)[ButtonArray objectAtIndex:i];
        
        tempButton.selected =NO;
        tempButton.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
    }
    btn.selected =YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
    
    
    //0:普通导航,1:附近,2: 收藏(默认展示标签)
    if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"type"] ] isEqualToString:@"0"]) {
        navID = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"ID"] ];
        contextType = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"contextType"] ];
        currentNum = btn.tag - 1;
        if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
            navType = [navTypeArray objectAtIndex:currentNum];
            BaseTableView  * currentBasetableView = [baseTableViewArray objectAtIndex:currentNum];
            [currentBasetableView reloadData];
        }else{
            self.view.userInteractionEnabled = NO;
            [self getNavContent];
        }
    }
    if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"type"] ] isEqualToString:@"1"]) {
        navID = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"ID"] ];
        contextType = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"contextType"] ];
        currentNum = btn.tag - 1;
        if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
            navType = [navTypeArray objectAtIndex:currentNum];
            BaseTableView  * currentBasetableView = [baseTableViewArray objectAtIndex:currentNum];
            [currentBasetableView reloadData];
        }else{
            self.view.userInteractionEnabled = NO;
            [self getNavContent];
        }
    }
    if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"type"] ] isEqualToString:@"2"]) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        if (userID) {
            NSLog(@"跳转到收藏");
            MyFavoritesViewController * vc = [[MyFavoritesViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSLog(@"请先登录");
            LoginViewController * vc = [[LoginViewController alloc] init];
            vc.isFromOrderList = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView ==self.myScrollView ||scrollView ==self.contentScrollView) {
        _startPointX = scrollView.contentOffset.x;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView ==self.myScrollView ||scrollView ==self.contentScrollView) {
        
        [self changeView:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView ==self.myScrollView ||scrollView ==self.contentScrollView) {
        float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
        [self.myScrollView scrollRectToVisible:CGRectMake(xx, 0, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height) animated:YES];
        for (int i=0; i < ButtonArray.count; i++) {
            UIButton * tempButton = (UIButton *)[ButtonArray objectAtIndex:i];
            
            if(tempButton.selected){
                navID = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(tempButton.tag-1)] objectForKey:@"ID"] ];
                contextType = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(tempButton.tag-1)] objectForKey:@"contextType"] ];
                currentNum = tempButton.tag - 1;
                
                if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
                    navType = [navTypeArray objectAtIndex:currentNum];
                    BaseTableView  * currentBasetableView = [baseTableViewArray objectAtIndex:currentNum];
                    [currentBasetableView reloadData];
                }else{
                    self.view.userInteractionEnabled = NO;
                    [self getNavContent];
                }
            }
        }
        
    }
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if(tableView.tag ==1){
    //
    //        return self.ALLData1.count;
    //    }else{
    //        return self.ALLData.count;
    //    }
    
    if (section == 0) {
        return [[adListArray objectAtIndex:currentNum]count];
    }else if (section == 1)
    {
        if (arrayGroup.count>0) {
            if ([navType isEqualToString:@"2" ]) {
                return [[arrayGroup objectAtIndex:currentNum] count];
            }
            else if ([navType isEqualToString:@"1" ]){
                return [[arrayGroup objectAtIndex:currentNum] count];
            }else{
                return 0;
            }
        }
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(tableView.tag ==1){
    //        if (indexPath.row>self.fallsData.count-1) {
    //            return 380.0f*AUTO_SIZE_SCALE_X;
    //        }else{
    //            return (ImvHeight+20.0f+6.0f);
    //        }
    //    }else{
    //        if (indexPath.row>self.fallsData.count-1) {
    //            return (108.75f+10.0f+88.0f)*AUTO_SIZE_SCALE_X;
    //        }else{
    //            return (ImvHeight+20.0f+6.0f);
    //        }
    //    }
    
    if (indexPath.section == 0) {
        return 175*AUTO_SIZE_SCALE_X;
    }
    else if (indexPath.section == 1){
        if ([navType isEqualToString:@"2" ]) {
            return 380.0f*AUTO_SIZE_SCALE_X;;
        }
        return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f;
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(tableView.tag ==1){
    //        if (indexPath.row>self.fallsData.count-1) {
    //            static NSString *identify =@"TechicianCell";
    //            TechicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    //            if (!cell) {
    //                cell = [[TechicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    //            }
    //            if (self.data1.count>0) {
    //                cell.data = self.ALLData1[indexPath.row];
    //            }
    //
    //            return cell;
    //        }else{
    //            static NSString *identify =@"ADcell";
    //            advertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    //            if (!cell) {
    //                cell = [[advertisementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    //
    //            }
    //
    //
    //            if (self.data1.count>0) {
    //                cell.data = self.ALLData1[indexPath.row];
    //            }
    //            return cell;
    //
    //        }
    //    }else{
    //        if (indexPath.row>self.fallsData.count-1) {
    //            static NSString *identify =@"doorcell";
    //            CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    //            if (!cell) {
    //                cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    //            }
    //            if (self.data.count>0) {
    //                cell.data = self.ALLData[indexPath.row];
    //            }
    //            cell.backgroundColor = [UIColor clearColor];
    //
    //            return cell;
    //        }else{
    //            static NSString *identify =@"ADcell";
    //            advertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    //            if (!cell) {
    //                cell = [[advertisementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    //
    //            }
    //
    //
    //            if (self.data.count>0) {
    //                cell.data = self.ALLData[indexPath.row];
    //            }
    //            return cell;
    //
    //        }
    //    }
    
    
    if (indexPath.section == 0) {
        NSString * cellName = @"publicTableViewCell";
        publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil];
            cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([[adListArray  objectAtIndex:currentNum] count] > 0) {
            UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*AUTO_SIZE_SCALE_X)];
            bgView.backgroundColor = [UIColor whiteColor ];
            [cell addSubview:bgView];
            
            UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 150*AUTO_SIZE_SCALE_X)];
            ;
            [imv setImageWithURL:[NSURL URLWithString:[[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"banner默认图2比1"]];
            
            
            [bgView addSubview:imv];
            
            UILabel * sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 48*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
            sloganLabel.text = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"slogan"];
            sloganLabel.textColor = [UIColor whiteColor];
            sloganLabel.textAlignment = NSTextAlignmentCenter;
            sloganLabel.font = [UIFont systemFontOfSize:17];
            [imv addSubview:sloganLabel];
            
            if ([[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"introduction"]) {
                UILabel * introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X+sloganLabel.frame.origin.y+sloganLabel.frame.size.height, kScreenWidth-20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X)];
                introductionLabel.text = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"introduction"];
                introductionLabel.textColor = [UIColor whiteColor];
                introductionLabel.textAlignment = NSTextAlignmentCenter;
                introductionLabel.font = [UIFont systemFontOfSize:17];
                if ([introductionLabel.text isEqualToString:@""]) {
                    
                }else{
                    CGSize introductionLabelSize = [introductionLabel intrinsicContentSize];
                    introductionLabel.frame = CGRectMake((kScreenWidth-introductionLabelSize.width-30*AUTO_SIZE_SCALE_X)/2,  10*AUTO_SIZE_SCALE_X+sloganLabel.frame.origin.y+sloganLabel.frame.size.height, introductionLabelSize.width+30*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
                    introductionLabel.layer.borderColor = [UIColor whiteColor].CGColor;
                    introductionLabel.layer.borderWidth = 1.0;
                    [imv addSubview:introductionLabel];
                }
            }

        }
        
        
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }
    else if (indexPath.section == 1){
        if ([navType isEqualToString:@"2" ]) {
            //        if (indexPath.row>self.fallsData.count-1) {
            static NSString *identify =@"TechicianListCell";
            TechicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[TechicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
                
                cell.data = [[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row];
                
                cell.backgroundColor = [UIColor clearColor];
            }
            return cell;
            
            //        }
            //        else{
            //            static NSString *identify =@"ADcell";
            //            advertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            //            if (!cell) {
            //                cell = [[advertisementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            //
            //            }
            //
            //
            //            if (self.data1.count>0) {
            //                cell.data = self.ALLData1[indexPath.row];
            //            }
            //            return cell;
            //
            //        }
            
            
        }
        else {
            static NSString *identify =@"doorcell";
            CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
                //            cell.data = self.ALLData[indexPath.row];//[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row];
                cell.data = [[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row];
                //                NSLog(@"data %lu",(unsigned long)[[arrayGroup objectAtIndex:currentNum] count]);
                cell.backgroundColor = [UIColor clearColor];
            }
            
            
            return cell;
            
        }
        
    }
    else{
        NSString * cellName = @"publicTableViewCell";
        publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil];
            cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 170*AUTO_SIZE_SCALE_X)];
        bgView.backgroundColor = [UIColor whiteColor ];
        [cell addSubview:bgView];
        
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 150*AUTO_SIZE_SCALE_X)];
        imv.backgroundColor = [UIColor redColor];
        [bgView addSubview:imv];
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    navType = [navTypeArray objectAtIndex:currentNum];

    if (indexPath.section == 0) {
        if ([navType isEqualToString:@"2" ]){
            WorkerActivityViewController * vc = [[WorkerActivityViewController alloc] init];
            vc.ID = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"ID"];
            vc.name = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"name"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
            ServiceActivityViewController * vc = [[ServiceActivityViewController alloc] init];
            vc.ID = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"ID"];
            vc.name = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"name"];
            vc.serviceType = serviceType;
            [self.navigationController pushViewController:vc animated:YES    ];
        }
    }
    else if (indexPath.section == 1){
        //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
        //    [self.navigationController pushViewController:vc animated:YES];
        if ([navType isEqualToString:@"2" ]){
            [MobClick event:DOOR_TICHNICIANDETAIL];
            NDLog(@"技师信息 %@",[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row]);
            //        return;
            //门店上门 技师详情
            if ([[[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"isSelfOwned"] isEqualToString:@"0"]) {
                technicianViewController *VC =[[technicianViewController alloc] init];
                VC.flag = @"0";
                VC.workerID = [[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"ID"];
                //        [[RequestManager shareRequestManager].CurrMainController.navigationController pushViewController:VC animated:YES];
                [self.navigationController pushViewController:VC animated:YES    ];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
            }
            //自营上门 技师详情
            else if ([[[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"isSelfOwned"] isEqualToString:@"1"])
            {
                TechnicianMyselfViewController *VC =[[TechnicianMyselfViewController alloc] init];
                VC.workerID = [[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"ID"];
                //        [[RequestManager shareRequestManager].CurrMainController.navigationController pushViewController:VC animated:YES];
                [self.navigationController pushViewController:VC animated:YES    ];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
            }
            
        }
        
    }
    
}



-(void)moreBtnPressed:(UIButton *)sender{
    [MobClick event:DOOR_SCREEN];
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"离我最近"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"评价最高"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"订单最多"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      
      ];
    
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
    NSLog(@"pushMenuItem--------------->%@", sender);
    if([sender.title isEqualToString:@"离我最近"]){
        [MobClick event:DOOR_SCREEN_NEAR];
        orderBy = @"0";
        [self getNavContent];
    }
    else if([sender.title isEqualToString:@"订单最多"]){
        [MobClick event:DOOR_SCREEN_ORDER];
        orderBy = @"2";
        [self getNavContent];
        
    }
    else if([sender.title isEqualToString:@"评价最高"]){
        [MobClick event:DOOR_SCREEN_EVALUATE];
        orderBy = @"1";
        [self getNavContent];
        
    }
    //    else if([sender.title isEqualToString:@"价格最低"]){
    //        orderBy = @"3";
    //        [self getNavContent];
    //
    //    }
    
}



#pragma mark refreshViewStart

-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    
    BaseTableView * currentTableView = [baseTableViewArray objectAtIndex:currentNum];
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else
    {
        _pageForHot++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"10";
    if ([contextType isEqualToString:@"0"]) {
        pageOffset = @"15";
    }
    else if ([contextType isEqualToString:@"1"])
    {
        pageOffset = @"30";
    }
    else
    {
        pageOffset = @"15";
    }
    NSDictionary * dic = @{
                           @"longitude":longitude,//用户经度
                           @"latitude":latitude,//用户纬度
                           @"ID":navID,//分类 导航ID
                           @"orderBy":orderBy,//0按距离，1 按评价数量，2 按订单数量，3 按价格
                           @"pageStart":page,//默认值为：1
                           @"pageOffset":pageOffset,//默认值为：10
                           };
    [[RequestManager shareRequestManager] getNavContent:dic viewController:self successData:^(NSDictionary *result) {
                        NSLog(@"查询分类导航内容result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
//            navType = [NSString stringWithFormat:@"%@",[result objectForKey:@"navType"]];
            
            if ([navType isEqualToString:@"2"]) {
                NSMutableArray * currentarray = [NSMutableArray arrayWithArray:[arrayGroup objectAtIndex:currentNum]];
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"skillList"] ];
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [currentarray removeAllObjects];
                }
                [currentarray addObjectsFromArray:array];
                [arrayGroup replaceObjectAtIndex:currentNum withObject:currentarray];
                [currentTableView reloadData];
                [refreshView endRefreshing];
                //                NSLog(@"currentarray count -- %lu",(unsigned long)currentarray.count);
                // 1.根据数量判断是否需要隐藏上拉控件
                if (array.count < 15 || array.count ==0 ) {
                    [currentTableView.foot finishRefreshing];
                }else
                {
                    [currentTableView.foot endRefreshing];
                }
            }
            else if ([navType isEqualToString:@"1"]){
                
                NSMutableArray * currentarray = [NSMutableArray arrayWithArray:[arrayGroup objectAtIndex:currentNum]];
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"serviceList"] ];
                
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [currentarray removeAllObjects];
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
                [ currentarray addObjectsFromArray:array1];
                [arrayGroup replaceObjectAtIndex:currentNum withObject:currentarray];
                [currentTableView reloadData];
                [refreshView endRefreshing];
                
                // 1.根据数量判断是否需要隐藏上拉控件
                if (array.count < 30 || array.count ==0 ) {
                    [currentTableView.foot finishRefreshing];
                }else
                {
                    [currentTableView.foot endRefreshing];
                }
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
    } failuer:^(NSError *error) {
        [currentTableView.foot finishRefreshing];
        [currentTableView.head finishRefreshing];
        [refreshView endRefreshing];
        failView.hidden = NO;
        self.contentScrollView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
    }];
    
}



#pragma mark 按钮点击
-(void)cityChangeBtnPressed:(UIButton *)sender
{
    [MobClick event:DOOR_CITY];
    //    CityChangeViewController * vc = [[CityChangeViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"切换城市  cityName %@",cityName);
    //    CityChangeViewController * vc = [[CityChangeViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
    SelectCityViewController * vc = [[SelectCityViewController alloc] init];
    vc.city = cityName;
    [vc returnCityInfo:^(NSString *selectCityType) {
        
        
        if ([selectCityType isEqualToString:@"0"]) {
            
        }else{
            //ButtonArray
            //baseTableViewArray
            
            for (UIButton * btn in ButtonArray) {
                [btn removeFromSuperview];
            }
            for (BaseTableView * tabview in baseTableViewArray) {
                [tabview removeFromSuperview];
            }
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            cityName = [userDefaults objectForKey:@"cityName"];
            formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
            [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
            logationLabel.text = formattedAddress;
            currentNum = 0;
            navType = @"";
            self.contentScrollView.contentOffset = CGPointMake(0, 0);
            self.myScrollView.contentOffset = CGPointMake(0, 0);
            //查询分类导航
            [self getNavigationList];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)selectCityTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:DOOR_POSITION];
    NSLog(@"切换城市");
    //    CityChangeViewController * vc = [[CityChangeViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
    SelectCityViewController * vc = [[SelectCityViewController alloc] init];
    vc.city = cityName;
    [vc returnCityInfo:^(NSString *selectCityType) {
        
        
        if ([selectCityType isEqualToString:@"0"]) {
            
        }else{
            //ButtonArray
            //baseTableViewArray
            
            for (UIButton * btn in ButtonArray) {
                [btn removeFromSuperview];
            }
            for (BaseTableView * tabview in baseTableViewArray) {
                [tabview removeFromSuperview];
            }
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            cityName = [userDefaults objectForKey:@"cityName"];
            formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
            [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
            logationLabel.text = formattedAddress;
            currentNum = 0;
            navType = @"";
            self.contentScrollView.contentOffset = CGPointMake(0, 0);
            self.myScrollView.contentOffset = CGPointMake(0, 0);
            //查询分类导航
            [self getNavigationList];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)onClickeSearchBtn:(UIButton *)sender{
    [MobClick event:DOOR_SEARCH];
    StoreSearchViewController * vc = [[StoreSearchViewController alloc] init];
    vc.searchType =@"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView =[UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0xe6eded);
    }
    return _lineView;
}

-(KxMenu *)Menu{
    if(!_Menu){
        _Menu =[KxMenu new];
        
    }
    return _Menu;
}


#pragma mark 刷新地址
//-(void)iconrefreshImvTaped:(UITapGestureRecognizer *)sender
//{
//    [iconrefreshImv removeFromSuperview];
//    iconrefreshImv.userInteractionEnabled = NO;
//    logationLabel.text = @"请稍等,正在更新您的位置...";
//    
//    //    timer =   [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//    //    [timer fire];
//    
//    
//    
//    
//    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
//    {
//        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//            
//            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//            //            regeoRequest.searchType = AMapSearchType_ReGeocode;
//            regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
//            //    regeoRequest.radius = 10000;
//            regeoRequest.requireExtension = YES;
//            
//            //发起逆地理编码
//            [_search AMapReGoecodeSearch: regeoRequest];
//            
//            activityIndicator = [[UIActivityIndicatorView alloc]
//                                 initWithActivityIndicatorStyle:
//                                 UIActivityIndicatorViewStyleWhite];
//            activityIndicator.color = [UIColor blackColor];
//            activityIndicator.center = CGPointMake(self.view.frame.size.width-7-7-8-13+7, 17);;
//            [activityIndicator startAnimating]; // 开始旋转
//            [_locationView addSubview:activityIndicator];
//        }];
//    }
//    
//    else{
//        logationLabel.text = [NSString stringWithFormat:@"%@",@"请打开gps定位后刷新位置"];
//        [_locationView addSubview:iconrefreshImv];
//        iconrefreshImv.userInteractionEnabled = YES;
//        
//    }
//    
//}



@end
