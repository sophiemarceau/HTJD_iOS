//
//  StoreServiceHomePageViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/14.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#define scrollViewHeight 35
#define ImvHeight (kScreenWidth-20)/2
#define betweenHeight 6
#define cellHeight 310*AUTO_SIZE_SCALE_X
#define MENU_BUTTON_WIDTH  80
#define MIN_MENU_FONT  14.f
#define MAX_MENU_FONT  15.f

#import "StoreServiceHomePageViewController.h"
#import "BaseTableView.h"
#import "publicTableViewCell.h"
#import "QRCodeViewController.h"
#import "StoreDetailViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "CCLocationManager.h"
#import "SelectCityViewController.h"
#import "StoreSearchViewController.h"
#import "KxMenu.h"
#import "CustomCellTableViewCell.h"
#import "QHCommonUtil.h"
#import "StoreListTableViewCell.h"
#import "StoreDetailViewController.h"
#import "ServiceDetailViewController.h"
#import "ProgressHUD.h"

#import "UIImageView+WebCache.h"

#import "StoreActivityViewController.h"
#import "ServiceActivityViewController.h"

#import "LoginViewController.h"
#import "MyFavoritesViewController.h"
#import "noWifiView.h"

#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"

#import "LCProgressHUD.h"

#import "SeckillViewController.h"

#import "SeckillTableViewCell.h"
#import "SeckillPayViewController.h"
#import "SpecialSKTableViewCell.h"

@interface StoreServiceHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate, MAMapViewDelegate, AMapSearchDelegate ,UIAlertViewDelegate,SeckillTableViewCellPayDelete>
{
    UIActivityIndicatorView * activityIndicator;
    UILabel * logationLabel;
    UIImageView * iconrefreshImv;
    
    NSMutableArray * ButtonArray;
    
    NSString * cityName;
    NSString * formattedAddress;
    
    NSMutableArray *arT;
    float _startPointX;
    NSArray *listViewData;
    
    NSMutableArray * navigationListArray;
    
    NSString * navID;
    NSString * orderBy;
    NSString * contextType;
    
    NSString * navType;
    
    NSMutableArray * baseTableViewArray;
    NSMutableArray * arrayGroup;
    
    long currentNum;
    int _pageForHot;
    NSString * serviceType;
    
    //    UIButton * reloadbtn;
    
    NSMutableArray * alladListArray;
    NSMutableArray * adListArray;
    
    NSMutableArray * navTypeArray;
    
    UIImageView* zhixianImv;
    
    NSMutableDictionary * currentLocationDic;
    noWifiView *failView;
    
    BOOL canUse;
    
    NSMutableArray * timeArray;
    UILabel * timeleftLabel;
    UIView * timeLineView;
    NSString * timeLeft;
    
    int hour;
    int min;
    int sec;
    NSTimer * timer;
    NSString * selectType;
    NSString * sortType;
    BOOL timeout;
    BOOL timebegin;
    
    UIView * sectionView;
    
    NSMutableArray * specialList;
    NSMutableArray * activityList;
    NSMutableArray * servList;
    NSMutableArray * adList;
    NSMutableArray * activitydesc;
    
    UIScrollView * scrView;
    NSArray * timeZoneList;
    
    NSTimer * timerToend;
    NSTimer * timerTobegin;
    int timeforbegin;
    int timeforend;
    
    NSString * currenttimeID;
    int currenttimeTag;
}
@property (nonatomic , strong) UIScrollView *contentScrollView;
@property (nonatomic , strong) UIButton * cityChangeBtn;
@property (nonatomic , strong) UIButton * searchBtn;
@property (nonatomic , strong) UIButton * erweimaBtn;
@property (nonatomic , strong) UIScrollView * myScrollView;
@property (nonatomic , strong) UIButton * moreBtn;
@property (nonatomic , strong) BaseTableView * baseTableView;
//@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) UIView * locationView;
//@property (nonatomic , strong) UIView * moreView;
//@property (nonatomic , strong) UIView * moreBgView;
//@property (nonatomic , strong) UIImageView * firstImv;
//@property (nonatomic , strong) UIImageView * secImv;
//@property (nonatomic , strong) UIImageView * thirdImv;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) NSMutableArray *ALLData;
@end

@implementation StoreServiceHomePageViewController

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
            if (navigationListArray.count >0) {
                //                for (NSDictionary * dic in navigationListArray) {
                //                    NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                //                    [arT addObject:name];
                //                    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"isDefault"]]) {
                //
                //                    }
                //                }
                //
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
                
                //清空秒杀内的数据
                [specialList removeAllObjects];
                [activityList removeAllObjects];
                [adList removeAllObjects];
                [servList removeAllObjects];
                [activitydesc removeAllObjects];
                currenttimeTag = 0;
                
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
                
                //标签类型是0
                if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"type"] ] isEqualToString:@"3"]) {
                    //查询秒杀时间轴列表
                    [self getTimeZoneList];
                }
                else  {
                    //查询分类导航内容
                    [self getNavContent];
                }
                
                self.moreBtn.hidden = NO;
                
            }
            else{
                self.moreBtn.hidden = YES;
            }
            
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        self.contentScrollView.hidden = YES;
        self.moreBtn.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
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
    
    //    NSLog(@"longitude  %@",longitude);
    //    NSLog(@"latitude  %@",latitude);
    
    NSDictionary * dic = @{
                           @"longitude":longitude,//用户经度
                           @"latitude":latitude,//用户纬度
                           @"ID":navID,//分类 导航ID
                           @"orderBy":orderBy,//0按距离，1 按评价数量，2 按订单数量，3 按价格
                           @"pageStart":page,//默认值为：1
                           @"pageOffset":pageOffset,//默认值为：10
                           };
    //    NSLog(@"dic -- %@",dic);
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
            if ([navType isEqualToString:@"0"]) {
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"storeList"] ];
                [arrayGroup replaceObjectAtIndex:currentNum withObject:array];
                
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
            
            
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        self.view.userInteractionEnabled = YES;
        
    } failuer:^(NSError *error) {
        currentBasetableView.userInteractionEnabled = YES;
        [currentBasetableView.foot finishRefreshing];
        [currentBasetableView.head finishRefreshing];
        failView.hidden = NO;
        self.contentScrollView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        
        self.view.userInteractionEnabled = YES;
        
    }];
    
    
}

-(void)getTimeZoneList
{
    
    NSDictionary * dic = @{
                           @"ID":navID,
                           };
    [[RequestManager shareRequestManager] getQueryTimeZoneList:dic viewController:self successData:^(NSDictionary *result) {
        self.view.userInteractionEnabled = YES;
        NSLog(@"查询秒杀时间轴列表 result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            timeZoneList rem
            timeZoneList = [NSArray arrayWithArray:[result objectForKey:@"timeZoneList"]];
            if (timeZoneList.count > 0) {
                sectionView.hidden = NO;
                
                for (int i = 0; i<timeZoneList.count; i++) {
                    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(110*i, 3, 110, 40*AUTO_SIZE_SCALE_X1-6)];
                    view.backgroundColor = [UIColor blackColor];
                    [scrView addSubview:view];
                    
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 40*AUTO_SIZE_SCALE_X1-6)];
                    label.text = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:i] objectForKey:@"startTime"]];
                    label.textColor = UIColorFromRGB(0x747474);
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:13];
                    label.tag = 200+i;
                    [view addSubview:label];
                    label.userInteractionEnabled = YES;
                    [timeArray addObject:label];
                    UITapGestureRecognizer * labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTaped:)];
                    [label addGestureRecognizer:labelTap];
                    
                    if (i == currenttimeTag) {
                        label.textColor = UIColorFromRGB(0xFFFFFF);
                        label.font = [UIFont systemFontOfSize:14];
                    }
                }
                scrView.contentSize = CGSizeMake(110*timeZoneList.count, 40*AUTO_SIZE_SCALE_X1);
                [self getTimeZoneContext:[NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:currenttimeTag] objectForKey:@"ID"]]];
                currenttimeID = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:currenttimeTag] objectForKey:@"ID"]];
                //                [self intervalFromLastDate:[[timeZoneList objectAtIndex:0] objectForKey:@"currTime"] toTheDate:[[timeZoneList objectAtIndex:0] objectForKey:@"endTime"]];
                //                [self intervalFromLastDate:timeStr toTheDate:@"18:12:34"];//
                
            }
            
        }
        else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        sectionView.hidden = YES;
        //        currentBasetableView.userInteractionEnabled = YES;
        //        [currentBasetableView.foot finishRefreshing];
        //        [currentBasetableView.head finishRefreshing];
        failView.hidden = NO;
        self.contentScrollView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)getTimeZoneContext:(NSString *)timeID
{
    timeleftLabel.text = @"正在加载...";
    BaseTableView  * currentBasetableView = [baseTableViewArray objectAtIndex:currentNum];
    currentBasetableView.userInteractionEnabled = NO;
    NSDictionary * dic = @{
                           @"ID":timeID,//时间轴ID
                           };
    NSLog(@"查询秒杀活动列表dic %@",dic);

    [[RequestManager shareRequestManager] getQueryTimeZoneContext:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"查询秒杀活动列表result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            [specialList removeAllObjects];
            [activityList removeAllObjects];
            [adList removeAllObjects];
            [servList removeAllObjects];
            [activitydesc removeAllObjects];
            
            [specialList addObjectsFromArray:[result objectForKey:@"specialList"]];
            [activityList addObjectsFromArray:[result objectForKey:@"activityList"]];
            [adList addObjectsFromArray:[result objectForKey:@"adList"]];
            NSArray * array = [NSArray arrayWithArray:[result objectForKey:@"servList"]];
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
            
            [servList addObjectsFromArray:array1];
            //            [activitydesc addObjectsFromArray:[activityList object:@"activitydesc"]];
            
            [self countActivitydescHeight];
            
            [timerTobegin invalidate];
            [timerToend invalidate];
            //当前时间 应从接口中获得 暂时 从上一个接口获得
            NSString * timeStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"currTime"]];
            timeStr = [timeStr substringFromIndex:11];
            NSLog(@"timeStr %@",timeStr);
            
            NSString * starttimeStr = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:currenttimeTag]objectForKey:@"startTime"]];
            NSString * endtimeStr = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:currenttimeTag]objectForKey:@"endTime"]];
            NSLog(@"starttimeStr %@",starttimeStr);
            NSLog(@"endtimeStr %@",endtimeStr);

            
            [self checkKillTime:timeStr startTime:starttimeStr endTime:endtimeStr];
            
            [currentBasetableView reloadData];
//            currentBasetableView.head.hidden = YES;
            [currentBasetableView.foot finishRefreshing];
            currentBasetableView.userInteractionEnabled = YES;
            
        }
    } failuer:^(NSError *error) {
        
    }];
}

#pragma mark 计算说明高度
-(void)countActivitydescHeight
{
    for (int i =0; i<activityList.count; i++) {
        NSArray * array = [[activityList objectAtIndex:i] objectForKey:@"activitydesc"];
        float height = 0;
        if (array.count>0) {
            for (int j = 0; j<array.count; j++) {
                NSString * str = [[array objectAtIndex:j] objectForKey:@"content"];
                CGSize contentSize = CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X1, 2000);
                CGSize contentLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
                height = height+contentLabelSize.height+ 5*AUTO_SIZE_SCALE_X1;
            }
            NSString * heightStr = [NSString stringWithFormat:@"%f",height];
            NSLog(@"heightStr %@",heightStr);
            [activitydesc addObject:heightStr];
        }
        else{
            NSString * heightStr = [NSString stringWithFormat:@"%f",0.0];
            [activitydesc addObject:heightStr];
        }
    }
}


//// 获取当前是星期几
//- (NSInteger)getNowWeekday {
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSDate *now = [NSDate date];
//    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
//    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    comps = [calendar components:unitFlags fromDate:now];
//    return [comps weekday];
//}

//#pragma mark 计算时间差
//- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
//{
//    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
//    dateString1=[timeArray1 objectAtIndex:0];
//    
//    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
//    dateString2=[timeArray2 objectAtIndex:0];
//    
//    NSLog(@"%@.....%@",dateString1,dateString2);
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    //    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [date setDateFormat:@"HH:mm:ss"];
//    
//    NSDate *d1=[date dateFromString:dateString1];
//    
//    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
//    
//    NSDate *d2=[date dateFromString:dateString2];
//    
//    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
//    
//    NSTimeInterval cha=late2-late1;
//    NSString *timeString=@"";
//    NSString *house=@"";
//    NSString *mins=@"";
//    NSString *sen=@"";
//    
//    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
//    //        min = [min substringToIndex:min.length-7];
//    //    秒
//    sen=[NSString stringWithFormat:@"%@", sen];
//    
//    mins = [NSString stringWithFormat:@"%d", (int)cha/60%60];
//    //        min = [min substringToIndex:min.length-7];
//    //    分
//    mins=[NSString stringWithFormat:@"%@", mins];
//    
//    //    小时
//    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
//    //        house = [house substringToIndex:house.length-7];
//    house=[NSString stringWithFormat:@"%@", house];
//    
//    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,mins,sen];
//    NSLog(@"timeString %@",timeString);
//    return timeString;
//}

#pragma mark 检查秒杀时间
-(void)checkKillTime:(NSString *)currentT startTime:(NSString *)startT endTime:(NSString *)endT
{
    
    BaseTableView  * currentBasetableView = [baseTableViewArray objectAtIndex:currentNum];

    timeleftLabel.text = @"正在加载...";

    NSArray * currentTarray = [currentT componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *currentTHH = currentTarray[0];
    NSString *currentTMM= currentTarray[1];
    NSString *currentTss = currentTarray[2];
    NSInteger currentTh = [currentTHH integerValue];
    NSInteger currentTm = [currentTMM integerValue];
    NSInteger currentTs = [currentTss integerValue];
    NSInteger currentThms = currentTh*3600 + currentTm*60 +currentTs;
    
    NSArray * startTarray = [startT componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *startTHH = startTarray[0];
    NSString *startTMM= startTarray[1];
    NSString *startTss = startTarray[2];
    NSInteger startTh = [startTHH integerValue];
    NSInteger startTm = [startTMM integerValue];
    NSInteger startTs = [startTss integerValue];
    NSInteger startThms = startTh*3600 + startTm*60 +startTs;
    
    NSArray * endTarray = [endT componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *endTHH = endTarray[0];
    NSString *endTMM= endTarray[1];
    NSString *endTss = endTarray[2];
    NSInteger endTh = [endTHH integerValue];
    NSInteger endTm = [endTMM integerValue];
    NSInteger endTs = [endTss integerValue];
    NSInteger endThms = endTh*3600 + endTm*60 +endTs;
    
    
    
    
    
    timeforbegin = (int)(startThms - currentThms);
    //    NSLog(@"  currentThms %d  startThms %d  endThms %d",currentThms,startThms,endThms);
    //活动未开始 当前时间<开始时间
    if (currentThms < startThms) {
        timeforend = (int)(endThms - startThms );

         timerTobegin = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodtobegin:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timerTobegin forMode:NSRunLoopCommonModes];
    }
    //活动进行中 开始时间<=当前时间<结束时间
    else if (startThms <= currentThms && currentThms< endThms) {
        timebegin = YES;
        timeforend = (int)(endThms - currentThms );
         timerToend = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodtoend:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timerToend forMode:NSRunLoopCommonModes];
    }
    //活动结束 当前时间>=结束时间
    else if (currentThms >= endThms) {
        NSLog(@"本场活动已结束 ");
        timeleftLabel.text = @"本场活动已结束 ";
        timeout = YES;
        timebegin = NO;
        [timerTobegin invalidate];
        [timerToend invalidate];
        [currentBasetableView reloadData];
    }
    
}

- (void)timerFireMethodtoend:(NSTimer *)theTimer
{
    timeforend--;
    hour = timeforend/3600;
    min = timeforend%3600/60;
    sec = timeforend%60;
    //还有小时
    if (hour != 0) {
        sec--;
        if (sec < 0) {
            sec = 59;
            min--;
        }
        if (min<0) {
            min = 59;
            hour--;
        }
    }
    //没有小时
    else{
        //还有分钟
        if (min != 0) {
            sec--;
            if (sec<0) {
                sec = 59;
                min--;
            }
            
        }
        //没有分钟
        else{
            //还有秒
            if (sec != 0) {
                sec--;
                if (sec == 0) {
                    timeout = YES;
                }
            }
            else{
                timeout = YES;
            }
        }
    }
    
    timeLeft = [NSString stringWithFormat:@"距离本场结束时间还剩 %d小时 %d分 %d秒",hour,min,sec];
    timeleftLabel.text = timeLeft;
    //    timeleftLabel.text = [NSString stringWithFormat:@"距离本场结束时间还剩%d秒",timeforend];
    if (timeforend == 0) {
        [theTimer invalidate];
        timeleftLabel.text = @"本场活动已结束 ";
        timeout = YES;
        [self getTimeZoneContext:currenttimeID];
        
    }
    
    
    
}

- (void)timerFireMethodtobegin:(NSTimer *)theTimer
{
    timeforbegin--;
    hour = timeforbegin/3600;
    min = timeforbegin%3600/60;
    sec = timeforbegin%60;
    //还有小时
    if (hour != 0) {
        sec--;
        if (sec < 0) {
            sec = 59;
            min--;
        }
        if (min<0) {
            min = 59;
            hour--;
        }
    }
    //没有小时
    else{
        //还有分钟
        if (min != 0) {
            sec--;
            if (sec<0) {
                sec = 59;
                min--;
            }
            
        }
        //没有分钟
        else{
            //还有秒
            if (sec != 0) {
                sec--;
                if (sec == 0) {
                    //                        [timer invalidate];
                    //                        NSLog(@"时间到");
                    timeout = YES;
                    //                        [seckillTableView reloadData];
                }
            }
            else{
                //                    [timer invalidate];
                //                    NSLog(@"时间到");
                timeout = YES;
                //                    [seckillTableView reloadData];
            }
        }
    }
    
    timeLeft = [NSString stringWithFormat:@"距离本场开始时间还剩 %d小时 %d分 %d秒",hour,min,sec];
    timeleftLabel.text = timeLeft;
    //    timeleftLabel.text = [NSString stringWithFormat:@"距离本场开始时间还剩%d秒",timeforbegin];
    if (timeforbegin == 0) {
        [theTimer invalidate];
//        timerToend = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodtoend:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timerToend forMode:NSRunLoopCommonModes];
        [self getTimeZoneContext:currenttimeID];

    }
}

//
//一个时间距现在的时间
//
//- (NSString *)intervalSinceNow: (NSString *) theDate
//{
//    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
//    theDate=[timeArray objectAtIndex:0];
//
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *d=[date dateFromString:theDate];
//
//    NSTimeInterval late=[d timeIntervalSince1970]*1;
//
//    NSDate* dat = [NSDate date];
//    NSTimeInterval now=[dat timeIntervalSince1970]*1;
//    NSString *timeString=@"";
//
//    NSTimeInterval cha=late-now;
//
//    if (cha/3600<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/60];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"剩余%@分", timeString];
//
//    }
//    if (cha/3600>1&&cha/86400<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"剩余%@小时", timeString];
//    }
//    if (cha/86400>1)
//    {
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"剩余%@天", timeString];
//
//    }
//     return timeString;
//}

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

-(void)viewWillAppear:(BOOL)animated
{
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
    canUse = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeToCurrentCity" object:nil];
    canUse = YES;
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CityChange" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeToCurrentCity" object:nil];
    
}


//-(void)changeToCurrentCity:(NSNotification *)ntf
//{
////    NSLog(@"刷新到当前位置  %d",self.navigationController.viewControllers.count);
//
//    currentLocationDic = [NSMutableDictionary dictionaryWithDictionary:ntf.object];
//
//    if (self.navigationController.viewControllers.count == 1) {
//        UIAlertView * aletView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前的位置和已选地址不同，是否切换到当前位置" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        [aletView show];
//           }
//
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        NSLog(@"不切换");
//    }
//    else if (buttonIndex == 1){
//        NSLog(@"切换到当前位置 并刷新数据");
//        NSUserDefaults * userDefauls = [NSUserDefaults standardUserDefaults];
//
//        [userDefauls setObject:[currentLocationDic objectForKey:@"cityName"] forKey:@"cityName"];
//        [userDefauls setObject:[currentLocationDic objectForKey:@"cityCode"] forKey:@"cityCode"];
//        [userDefauls setObject:[currentLocationDic objectForKey:@"formattedAddress"] forKey:@"formattedAddress"];
//        [userDefauls setObject:[currentLocationDic objectForKey:@"latitude"] forKey:@"latitude"];
//        [userDefauls setObject:[currentLocationDic objectForKey:@"longitude"] forKey:@"longitude"];
//        [userDefauls synchronize];
//
//        for (UIButton * btn in ButtonArray) {
//            [btn removeFromSuperview];
//        }
//        for (BaseTableView * tabview in baseTableViewArray) {
//            [tabview removeFromSuperview];
//        }
//
//        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//        cityName = [userDefaults objectForKey:@"cityName"];
//        formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
//        [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
//        currentNum = 0;
//        self.contentScrollView.contentOffset = CGPointMake(0, 0);
//        self.myScrollView.contentOffset = CGPointMake(0, 0);
//        //查询分类导航
//        [self getNavigationList];
//        [currentLocationDic removeAllObjects];
//
//
//    }
//}

-(void)ReloadSecKill
{
    if (currenttimeID) {
        [self getTimeZoneContext:currenttimeID];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"AUTO_SIZE_SCALE_X1 %f",AUTO_SIZE_SCALE_X1 );
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    cityName = [userDefaults objectForKey:@"cityName"];
    //    formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
    //    NSLog(@"cityName-->%@",cityName);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadSecKill" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(ReloadSecKill) name:@"ReloadSecKill" object:nil];

    [self initView];
    
    zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavHeight+scrollViewHeight-0.5, kScreenWidth, 0.5)];
    zhixianImv.hidden = YES;
    zhixianImv.image = [UIImage  imageNamed:@"icon_zhixian"];
    [self.view   addSubview:zhixianImv];
    //    //加载数据失败时显示
    //    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-(kNavHeight+kTabHeight+35))];
    //    failView.userInteractionEnabled = YES;
    //    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    failView.hidden = YES;
    //    [self.view addSubview:failView];
    //    canUse = NO;
    //    if (!canUse) {
    //
    //        if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    //        {
    //            NSLog(@"开启定位");
    //            [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    //
    //                NSLog(@"latitude %f longitude %f",locationCorrrdinate.latitude ,locationCorrrdinate.longitude);
    //                //根据经纬度 反编译地址
    //                _search = [[AMapSearchAPI alloc] init];
    //                [AMapSearchServices sharedServices].apiKey = GDMapKey;
    //                self.search.delegate = self;
    //                AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //                //            regeoRequest.searchType = AMapSearchType_ReGeocode;
    //                regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
    //                //    regeoRequest.radius = 10000;
    //                regeoRequest.requireExtension = YES;
    //
    //                NSString * lat = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
    //                NSString * lon = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    //                NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    //                [userDefaults setObject:lat forKey:@"latitude"];
    //                [userDefaults setObject:lon forKey:@"longitude"];
    //                //假数据--------------------------------------------------
    //                //                [userDefaults setObject:@"北京" forKey:@"cityName"];
    //                //                [userDefaults setObject:@"110100" forKey:@"cityCode"];
    //                //                //位置显示
    //                //                [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
    //                //--------------------------------------------------------
    //                [userDefaults setBool:YES forKey:@"secLaunch"];
    //                [userDefaults synchronize];
    //
    //                //发起逆地理编码
    //                [_search AMapReGoecodeSearch: regeoRequest];
    //
    //            }];
    //
    //        }else{
    //            NSLog(@"关闭定位");
    //            NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    //            [userDefaults setObject:@"北京" forKey:@"cityName"];
    //            [userDefaults setObject:@"110100" forKey:@"cityCode"];
    //            //        [userDefaults setObject:@"2" forKey:@"openStatus"];
    //            //位置显示
    //            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
    //            //默认一个经纬度，公司经纬度
    //            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
    //            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
    //
    //            [userDefaults setBool:YES forKey:@"secLaunch"];
    //            [userDefaults synchronize];
    //            [self initView];
    //
    //        }
    //    }
    
    
    
    
}

//- (void)timerFireMethod:(NSTimer *)theTimer
//{
//    //还有小时
//    if (hour != 0) {
//        sec--;
//        if (sec < 0) {
//            sec = 59;
//            min--;
//        }
//        if (min<0) {
//            min = 59;
//            hour--;
//        }
//    }
//    //没有小时
//    else{
//        //还有分钟
//        if (min != 0) {
//            sec--;
//            if (sec<0) {
//                sec = 59;
//                min--;
//            }
//            
//        }
//        //没有分钟
//        else{
//            //还有秒
//            if (sec != 0) {
//                sec--;
//                if (sec == 0) {
//                    //                    [timer invalidate];
//                    //                    NSLog(@"时间到");
//                    timeout = YES;
//                    //                    [seckillTableView reloadData];
//                }
//            }
//            else{
//                //                [timer invalidate];
//                //                NSLog(@"时间到");
//                timeout = YES;
//                //                [seckillTableView reloadData];
//            }
//        }
//    }
//    
//    timeLeft = [NSString stringWithFormat:@"剩余时间 %d小时 %d分 %d秒",hour,min,sec];
//    timeleftLabel.text = timeLeft;
//    NSLog(@"timeLeft %@",timeLeft);
//}


-(void)initView
{
    [self getUserInfo];
    self.titles = @"华佗驾到";
    self.view.backgroundColor = C2UIColorGray;
    //    [LCProgressHUD showLoading:@"正在加载"];
    
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
    
    
    specialList = [[NSMutableArray alloc] initWithCapacity:0];
    activityList = [[NSMutableArray alloc] initWithCapacity:0];
    servList = [[NSMutableArray alloc] initWithCapacity:0];
    adList = [[NSMutableArray alloc] initWithCapacity:0];
    activitydesc = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentNum = 0;
    navType = @"";
    serviceType = @"0";
    currenttimeTag = 0;
//    int i = 65;
//    hour = i/3600;
//    min = i%3600/60;
//    sec = i%60;
    
    //    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //    [timer fire];
    
//    timeLeft = [NSString stringWithFormat:@"剩余时间 %d小时 %d分 %d秒",hour,min,sec];
//    NSLog(@"timeLeft %@",timeLeft);
    
    selectType = @"1";
    timeout = NO;
    sortType = @"";
    timeArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-(kNavHeight+kTabHeight+35))];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    //    加载失败页面
    //    [self reloadView];
    
    //显示界面
    [self showView];
    
}
- (void)reloadButtonClick:(UIButton *)sender {
    for (UIButton * btn in ButtonArray) {
        [btn removeFromSuperview];
    }
    for (BaseTableView * tabview in baseTableViewArray) {
        [tabview removeFromSuperview];
    }
    
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    cityName = [userDefaults objectForKey:@"cityName"];
    //    formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
    //    [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
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
    [self.navView addSubview:self.searchBtn];
    //二维码按钮
    [self.navView addSubview:self.erweimaBtn];
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
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScreenWidth - 30*AUTO_SIZE_SCALE_X);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
    //二维码按钮
    [self.erweimaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScreenWidth - 30*AUTO_SIZE_SCALE_X -5 -30*AUTO_SIZE_SCALE_X);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
    
    
    //定位
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.frame.size.height-49-35);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , 35));
    }];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * defaultsformattedAddress = [userDefaults objectForKey:@"formattedAddress"];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 35)]    ;
    bgView.image = [UIImage imageNamed:@"bg_location"];
    [self.locationView addSubview:bgView];
    
    UIImageView * locView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 13 , 13)];
    locView.image = [UIImage imageNamed:@"icon_location"];
    [self.locationView addSubview:locView];
    
    logationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locView.frame.size.width+locView.frame.origin.x+10, 0, self.view.frame.size.width-(locView.frame.size.width+locView.frame.origin.x+10+10*AUTO_SIZE_SCALE_X), 35)];
    logationLabel.text = defaultsformattedAddress;
    logationLabel.textColor = UIColorFromRGB(0x999999);
    logationLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    [self.locationView addSubview:logationLabel];
    
    
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
        make.size.mas_equalTo(CGSizeMake( kScreenWidth, kScreenHeight-kNavHeight-scrollViewHeight-49-35));
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
        //        _contentScrollView.backgroundColor = C2UIColorGray;
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
        
    }
    else if(self.contentScrollView.contentOffset.x > (self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width))
    {
        isPaning = YES;
        
    }
    
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
        if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:i] objectForKey:@"type"] ] isEqualToString:@"3"]) {
            if (sectionView) {
                [sectionView removeFromSuperview];
            }
            sectionView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X1+40*AUTO_SIZE_SCALE_X1)];
            sectionView.backgroundColor = [UIColor whiteColor];
            sectionView.hidden = YES;
            
            scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
            scrView.delegate = self;
            scrView.showsHorizontalScrollIndicator = NO;
            scrView.backgroundColor = [UIColor blackColor];
            scrView.tag = 999;
            [sectionView addSubview:scrView];
            
            timeLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40*AUTO_SIZE_SCALE_X1-3, 80, 3)];
            timeLineView.backgroundColor = UIColorFromRGB(0xC03230);
            [scrView addSubview:timeLineView];
            
            
            
            UIView * timeView = [[UIView alloc] initWithFrame:CGRectMake(0,40*AUTO_SIZE_SCALE_X1, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
            timeView.backgroundColor = C2UIColorGray;
            [sectionView addSubview:timeView];
            
            timeleftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
//            timeleftLabel.text = timeLeft;
            timeleftLabel.textAlignment = NSTextAlignmentCenter;
            timeleftLabel.font = [UIFont systemFontOfSize:13];
            timeleftLabel.textColor = UIColorFromRGB(0x747474);
            [timeView addSubview:timeleftLabel];
            
            [scrollV addSubview:sectionView];
            
            BaseTableView *StoreTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width * i, 80*AUTO_SIZE_SCALE_X1, scrollV.frame.size.width, scrollV.frame.size.height-80*AUTO_SIZE_SCALE_X1)];
            StoreTableView.tag = i + 1000;
            
            StoreTableView.delegate = self;
            StoreTableView.dataSource = self;
                        StoreTableView.delegates = self;
            StoreTableView.showsHorizontalScrollIndicator = NO;
            StoreTableView.showsVerticalScrollIndicator = YES;
            StoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            [scrollV addSubview:StoreTableView];
            
            [baseTableViewArray addObject:StoreTableView];
        }
        else{
            BaseTableView *StoreTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width * i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
            StoreTableView.tag = i + 1;
            
            StoreTableView.delegate = self;
            StoreTableView.dataSource = self;
            StoreTableView.delegates = self;
            StoreTableView.showsHorizontalScrollIndicator = NO;
            StoreTableView.showsVerticalScrollIndicator = YES;
            StoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            [scrollV addSubview:StoreTableView];
            
            [baseTableViewArray addObject:StoreTableView];
            
        }
        
    }
    [scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * pageCount, scrollV.frame.size.height)];
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] init];
    [AMapSearchServices sharedServices].apiKey = GDMapKey;
    self.search.delegate = self;
}


-(void)labelTaped:(UITapGestureRecognizer *)sender
{
    [specialList removeAllObjects];
    [activityList removeAllObjects];
    [adList removeAllObjects];
    [servList removeAllObjects];
    NSLog(@"time id %@",[[timeZoneList objectAtIndex:(sender.view.tag-200)] objectForKey:@"ID"]);
    NSString * timeID = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:(sender.view.tag-200)] objectForKey:@"ID"]];
    currenttimeTag = (int)(sender.view.tag-200);
    currenttimeID = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:currenttimeTag] objectForKey:@"ID"]];

    timeout = NO;
    timebegin = NO;
    timeleftLabel.text = @"正在加载...";
    [self getTimeZoneContext:timeID];
    timeLineView.frame = CGRectMake(15+110*(sender.view.tag-200), 40*AUTO_SIZE_SCALE_X1-3, 80, 3);
    for (UILabel * label in timeArray) {
        label.textColor = UIColorFromRGB(0x747474);
        label.font = [UIFont systemFontOfSize:13];
        if (label.tag == sender.view.tag) {
            label.textColor = UIColorFromRGB(0xFFFFFF);
            label.font = [UIFont systemFontOfSize:14];
        }
    }
}

-(UIButton *)cityChangeBtn
{
    
    if (!_cityChangeBtn) {
        //        UIImage * img = [UIImage imageNamed:@"icon_header_dropdown"];
        //        _cityChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_cityChangeBtn setImage:img forState:UIControlStateNormal];//给button添加image
        //        _cityChangeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //        CGSize strSize = [cityName sizeWithFont:[UIFont systemFontOfSize:15]];
        //
        //        CGFloat edgeLen = 12;
        //        [_cityChangeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70-edgeLen-img.size.width+5, 0, (edgeLen - strSize.width))];//(0,48,0,-18)
        //        [_cityChangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, (edgeLen - img.size.width), 0, edgeLen)];//(0,2,0,12)
        //        [_cityChangeBtn addTarget:self action:@selector(cityChangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
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

-(UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn =[CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(searchBtnPressed:) Title:@""];
        [_searchBtn setImage:[UIImage imageNamed:@"icon_header_search"] forState:UIControlStateNormal];
        _searchBtn.backgroundColor =[UIColor clearColor];
    }
    return _searchBtn;
}

-(UIButton *)erweimaBtn
{
    if (!_erweimaBtn) {
        _erweimaBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(erweimaBtnPressed:) Title:@""];
        [_erweimaBtn setImage:[UIImage imageNamed:@"icon_header_qrcode"] forState:UIControlStateNormal];
        _erweimaBtn.backgroundColor =[UIColor clearColor];
    }
    return _erweimaBtn;
}

-(UIScrollView *)myScrollView
{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] init];
        //        _myScrollView.contentSize = CGSizeMake(600, scrollViewHeight-1);
        _myScrollView.backgroundColor = UIColorFromFindRGB(0xf4f4f4);
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.showsVerticalScrollIndicator = NO;
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
        
        //        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"bg_filter_dropdown"] forState:UIControlStateNormal];
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
        UITapGestureRecognizer * selectCityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCityTaped:)];
        [_locationView addGestureRecognizer:selectCityTap];
        
        
        //        iconrefreshImv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-16-8-13, 10, 13 , 15)];
        //        iconrefreshImv.image = [UIImage imageNamed:@"icon_location_refresh"];
        //        [_locationView addSubview:iconrefreshImv];
        //        iconrefreshImv.userInteractionEnabled = YES;
        //        UITapGestureRecognizer * iconrefreshImvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconrefreshImvTaped:)];
        //        [iconrefreshImv addGestureRecognizer:iconrefreshImvTap];
        
        
        
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
        //        }
        
    }
    
    return _locationView;
}


//#pragma mark 刷新地址
//-(void)iconrefreshImvTaped:(UITapGestureRecognizer *)sender
//{
//    [iconrefreshImv removeFromSuperview];
//    iconrefreshImv.userInteractionEnabled = NO;
//
//    //    timer =   [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//    //    [timer fire];
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
//        [_locationView addSubview:iconrefreshImv];
//        iconrefreshImv.userInteractionEnabled = YES;
//
//    }
//
//}

#pragma mark 实现逆地理编码的回调函数
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    NSLog(@"实现逆地理编码的回调函数");
//    if(response.regeocode != nil)
//    {
//        NSString *  province = @"";
//        NSString *  city = @"";
//        if (response.regeocode.addressComponent.province) {
//            province = response.regeocode.addressComponent.province;
//        }
//        if (response.regeocode.addressComponent.city) {
//            city = response.regeocode.addressComponent.city;
//        }
//        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
//
//        [[RequestManager shareRequestManager] GetMyCityInfo:nil viewController:nil successData:^(NSDictionary *result) {
//            NSArray * cityArray =  [NSArray arrayWithArray: [result objectForKey:@"cityList"] ] ;
//            for (NSDictionary * dic in cityArray) {
//                NSString * city_Name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
//                NSString * city_Code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityCode"]];
//                NSLog(@"cityName  %@",city_Name);
//                NSLog(@"province  %@",province);
//                NSLog(@"city  %@",city);
//                if ([city rangeOfString:city_Name].location !=NSNotFound||[province rangeOfString:city_Name].location !=NSNotFound||[city_Name isEqualToString:province]||[city_Name isEqualToString:city]) {
//                    [userDefaults setObject:city_Name forKey:@"cityName"];
//                    [userDefaults setObject:city_Code forKey:@"cityCode"];
//                    //位置显示
//                    [userDefaults setObject:response.regeocode.formattedAddress forKey:@"formattedAddress"];
//                    [userDefaults synchronize];
//                    [self initView];
//                    return  ;
//                }
//
//            }
//            [userDefaults setObject:@"北京" forKey:@"cityName"];
//            [userDefaults setObject:@"110100" forKey:@"cityCode"];
//            //位置显示
//            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
//            //默认一个经纬度，公司经纬度
//            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
//            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
//            [userDefaults synchronize];
//            [self initView];
//        } failuer:^(NSError *error) {
//            [userDefaults setObject:@"北京" forKey:@"cityName"];
//            [userDefaults setObject:@"110100" forKey:@"cityCode"];
//            //位置显示
//            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
//            //默认一个经纬度，公司经纬度
//            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
//            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
//            [userDefaults synchronize];
//            [self initView];
//        }];
//
//    }
//}

#pragma mark - action

- (void)actionbtn:(UIButton *)btn
{
    NSLog(@"刷新数据");
    NSString * str = @"";
    if (arT.count> 0) {
        str = [arT objectAtIndex:btn.tag-1];
        NSLog(@"str %@",str);
        NSDictionary * dic = @{
                                   @"tagName":str,
                                   };
        [MobClick event:STORE_HORIZONTAL_TAB attributes:dic];
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
    
    
    //    if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"type"] ] isEqualToString:@"3"]) {
    //        //查询秒杀时间轴列表
    //        [self getTimeZoneList];
    //    }
    //    else  {
    //        //查询分类导航内容
    //        [self getNavContent];
    //    }
    
    
    //0:普通导航,1:附近,2: 收藏(默认展示标签)
    if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"type"] ] isEqualToString:@"0"]) {
        navID = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"ID"] ];
        contextType = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"contextType"] ];
        currentNum = btn.tag - 1;
        if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
            navType = [navTypeArray objectAtIndex:currentNum];
            BaseTableView * currentTableView = [baseTableViewArray objectAtIndex:currentNum];
            [currentTableView reloadData];
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
            BaseTableView * currentTableView = [baseTableViewArray objectAtIndex:currentNum];
            [currentTableView reloadData];
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
    if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"type"] ] isEqualToString:@"3"]) {
        navID = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"ID"] ];
        contextType = [NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:(btn.tag-1)] objectForKey:@"contextType"] ];
        currentNum = btn.tag - 1;
        //        if ([[arrayGroup objectAtIndex:currentNum] count]>0) {
        //            navType = [navTypeArray objectAtIndex:currentNum];
        //            BaseTableView * currentTableView = [baseTableViewArray objectAtIndex:currentNum];
        //            [currentTableView reloadData];
        //        }else{
        self.view.userInteractionEnabled = NO;
        //查询秒杀时间轴列表
//        currenttimeTag = 0;
        [self getTimeZoneList];
        //        }
        
    }
    
    
}

#pragma mark 按钮点击
-(void)cityChangeBtnPressed:(UIButton *)sender
{
    NSLog(@"切换城市");
    [MobClick endEvent:STORE_CITY];
    //    CityChangeViewController * vc = [[CityChangeViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * newCityName = [userDefaults objectForKey:@"cityName"];
    NSString * currentCode = [userDefaults objectForKey:@"cityCode"];
    SelectCityViewController * vc = [[SelectCityViewController alloc] init];
    vc.city = newCityName;
    vc.currentCode = currentCode;
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
            
            //            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            //            NSString * newcityName = [userDefaults objectForKey:@"cityName"];
            //            NSString * newformattedAddress = [userDefaults objectForKey:@"formattedAddress"];
            //             [_cityChangeBtn setTitle:newcityName forState:UIControlStateNormal];//设置button的title
            //            logationLabel.text = newformattedAddress;
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
    NSLog(@"切换城市");
    [MobClick endEvent:STORE_POSITION];
    //    CityChangeViewController * vc = [[CityChangeViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * newCityName = [userDefaults objectForKey:@"cityName"];
    
    SelectCityViewController * vc = [[SelectCityViewController alloc] init];
    vc.city = newCityName;
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
            
            //            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            //            cityName = [userDefaults objectForKey:@"cityName"];
            //            formattedAddress = [userDefaults objectForKey:@"formattedAddress"];
            //            [_cityChangeBtn setTitle:cityName forState:UIControlStateNormal];//设置button的title
            //            logationLabel.text = formattedAddress;
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

-(void)erweimaBtnPressed:(UIButton *)sender//searchBtnBtnPressed
{
    [MobClick endEvent:STORE_QR];
    
    
    
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [[RequestManager shareRequestManager] tipAlert:@"相机权限受限，请在设置->华佗驾到里打开相机权限" viewController:self];
        NSLog(@"相机权限受限");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
    QRCodeViewController * vc = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)searchBtnPressed:(UIButton *)sender
{
    NSLog(@"跳转到搜索界面");
    [MobClick endEvent:STORE_SEARCH];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    
    StoreSearchViewController * vc = [[StoreSearchViewController alloc] init];
    vc.searchType =@"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)moreBtnPressed:(UIButton *)sender
{
    NSLog(@"显示更多");
    [MobClick endEvent:STORE_SCREEN];
    
    NSArray *menuItems =
    @[
      //      [KxMenuItem menuItem:@"默认排序"
      //                     image:nil
      //                    target:self
      //                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"离我最近"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      //      [KxMenuItem menuItem:@"订单最多"
      //                     image:nil
      //                    target:self
      //                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"评价最高"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"价格最低"
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
    NSLog(@"pushMenuItem--------------->%@", sender.title);
    //    if ([sender.title isEqualToString:@"默认排序"]) {
    //        [self.baseTableView setTableHeaderView:self.headerView];
    //
    //    }
    //    else
    if([sender.title isEqualToString:@"离我最近"]){
        [MobClick endEvent:STORE_SCREEN_NEAR];
        orderBy = @"0";
        if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"type"] ] isEqualToString:@"3"]) {
                      self.view.userInteractionEnabled = NO;
            //查询秒杀时间轴列表
            [self getTimeZoneList];
        }
        else{
            [self getNavContent];
        }
    }
    //    else if([sender.title isEqualToString:@"订单最多"]){
    //        orderBy = @"2";
    //
    //    }
    else if([sender.title isEqualToString:@"评价最高"]){
        [MobClick endEvent:STORE_SCREEN_EVALUATE];
        orderBy = @"1";
        if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"type"] ] isEqualToString:@"3"]) {
            self.view.userInteractionEnabled = NO;
            //查询秒杀时间轴列表
            [self getTimeZoneList];
        }
        else{
            [self getNavContent];
        }
    }
    else if([sender.title isEqualToString:@"价格最低"]){
        [MobClick endEvent:STORE_SCREEN_PRICE];
        orderBy = @"3";
        if ([[NSString stringWithFormat:@"%@",[[navigationListArray objectAtIndex:currentNum] objectForKey:@"type"] ] isEqualToString:@"3"]) {
            self.view.userInteractionEnabled = NO;
            //查询秒杀时间轴列表
            [self getTimeZoneList];
        }
        else{
            [self getNavContent];
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
    //    NSLog(@"value-- %f",value);
    btn.titleLabel.font = [UIFont systemFontOfSize:value];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
    
    
    if((int)xx%MENU_BUTTON_WIDTH == 0)
        return;
    
    UIButton *btn2 = (UIButton *)[self.myScrollView viewWithTag:sT + 1];
    float value2 = [QHCommonUtil lerp:percent min:MIN_MENU_FONT max:MAX_MENU_FONT];
    btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView ==self.myScrollView ||scrollView ==self.contentScrollView) {
        float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
        [self.myScrollView scrollRectToVisible:CGRectMake(xx, 0, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height) animated:YES];
        //        self.view.userInteractionEnabled = NO;
        [self requestButton];
    }
}


-(void)requestButton{
    for (int i=0; i < ButtonArray.count; i++) {
        UIButton * tempButton = (UIButton *)[ButtonArray objectAtIndex:i];
        
        if (tempButton.selected) {
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
#pragma mark 秒杀按钮代理
-(void)gotoSecKillPay:(NSDictionary *)dic
{
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        //        seckillTableView.userInteractionEnabled = NO;
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用预约功能" viewController:self];
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }
    NSLog(@"dic %@",dic);
    SeckillPayViewController * vc = [[SeckillPayViewController alloc] init];
    vc.minPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"minPrice"]];
    vc.specialID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
    if ([dic objectForKey:@"priceID"]) {
        vc.priceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"priceID"]];
    }
    else{
        vc.priceID = @"";
    }
    vc.servName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"servName"]];
    vc.storeName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"storeName"]];
    vc.servIcom = [NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"]];
    vc.activitydescArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"activitydesc"]];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
}

-(void)gotoLogVC
{
    //    seckillTableView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 跳转到项目详情
-(void)gotoServiceDetail:(NSDictionary *)dic
{
    NSString * stockStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"stock"]];
        if (!timebegin||[stockStr isEqualToString:@"0"]) {
    NSLog(@"可以跳转");
    ServiceDetailViewController * vc = [[ServiceDetailViewController alloc] init];
    vc.serviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"servID"]];
    vc.isSelfOwned = @"0";
    vc.serviceType = @"0";
    vc.isStore = YES;
    vc.haveWorker = NO;
    [self.navigationController pushViewController:vc animated:YES];
        }
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag >= 1000) {
        return 4;
    }
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag >= 1000) {
        if (section == 0) {
            return [specialList count];
            //            return [adList count];
        }else if (section == 1){
            return [activityList count];
            //            return [servList count];
        }else if (section == 2){
            return [adList count];
        }else if (section == 3){
            return [servList count];
        }
    }
    else
    {
        if (section == 0) {
            return [[adListArray objectAtIndex:currentNum]count];
        }else if (section == 1)
        {
            if (arrayGroup.count>0) {
                if ([navType isEqualToString:@"0" ]) {
                    return [[arrayGroup objectAtIndex:currentNum] count];
                }else if ([navType isEqualToString:@"1" ]){
                    return [[arrayGroup objectAtIndex:currentNum] count];
                }else{
                    return 0;
                }
            }
            return 0;
        }
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag >= 1000) {
        if (indexPath.section == 0) {
            return 322*AUTO_SIZE_SCALE_X1+7*AUTO_SIZE_SCALE_X1;
        }else if (indexPath.section == 1){
            float activitydescHeight = [[activitydesc objectAtIndex:indexPath.row] floatValue] ;
            NSLog(@"activitydescHeight %f",activitydescHeight);
            if (activityList.count > 0) {
                if ([[NSString stringWithFormat:@"%@",[[activityList objectAtIndex:indexPath.row] objectForKey:@"isLevel"] ] isEqualToString:@"0"]) {
                    return (366+(55*1))*AUTO_SIZE_SCALE_X1+activitydescHeight+7*AUTO_SIZE_SCALE_X1;
                }
                return (366+(55*[[[activityList objectAtIndex:indexPath.row] objectForKey:@"servLevelList"] count]))*AUTO_SIZE_SCALE_X1+activitydescHeight+7*AUTO_SIZE_SCALE_X1;
            }
            
         }else if (indexPath.section == 2){
            return 175*AUTO_SIZE_SCALE_X;
        }else if (indexPath.section == 3){
            return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f;
        }
        
    }
    else{
        if (indexPath.section == 0) {
            return 175*AUTO_SIZE_SCALE_X;
        }
        else if (indexPath.section == 1){
            if ([navType isEqualToString:@"0" ]) {
                return cellHeight;
            }else if ([navType isEqualToString:@"1" ]){
                //            return (108.75f+10.0f+88.0f)*AUTO_SIZE_SCALE_X;
                return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f;
                
            }else
                return 0;
        }
    }
    
    
    
    return 0;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag >= 1000) {
        if (indexPath.section == 0) {
            NSString * cellName = @"SpecialSKTableViewCell";
            SpecialSKTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                cell = [[SpecialSKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([specialList count] > 0){
                cell.dataDic = [specialList objectAtIndex:indexPath.row];
            }
            
            cell.backgroundColor = [UIColor clearColor];
            return cell;
            
        }
        else if (indexPath.section == 1){
            static NSString * cellName = @"SeckillTableViewCell";
            SeckillTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            
            if (!cell) {
                cell = [[SeckillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (activityList.count > 0 ) {
                cell.timeout = timeout;
                cell.timebegin = timebegin;
                cell.type = @"0";
                cell.dataDic = [activityList objectAtIndex:indexPath.row] ;
                cell.delegate = self;
                //                if ([[NSString stringWithFormat:@"%@",[[activityList objectAtIndex:indexPath.row] objectForKey:@"isLevel"] ] isEqualToString:@"0"]) {
                //                    cell.mycount = 0;
                //                }
                //                else{
                //                    cell.mycount = (int)[[[activityList objectAtIndex:indexPath.row] objectForKey:@"servLevelList"] count]-1;
                //                }
                
            }
            
            return cell;
        }
        else if (indexPath.section == 2){
            NSString * cellName = @"publicTableViewCell";
            publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil];
                cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([adList count] > 0){
                UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*AUTO_SIZE_SCALE_X)];
                bgView.backgroundColor = [UIColor whiteColor ];
                [cell addSubview:bgView];
                
                UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 150*AUTO_SIZE_SCALE_X)];
                ;
                [imv setImageWithURL:[NSURL URLWithString:[[adList objectAtIndex:indexPath.row] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"banner默认图2比1"]];
                [bgView addSubview:imv];
                
                UILabel * sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 48*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
                sloganLabel.text = [[adList objectAtIndex:indexPath.row] objectForKey:@"slogan"];
                sloganLabel.textColor = [UIColor whiteColor];
                sloganLabel.textAlignment = NSTextAlignmentCenter;
                sloganLabel.font = [UIFont systemFontOfSize:17];
                [imv addSubview:sloganLabel];
                
                if ([[adList objectAtIndex:indexPath.row] objectForKey:@"introduction"]) {
                    UILabel * introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X+sloganLabel.frame.origin.y+sloganLabel.frame.size.height, kScreenWidth-20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X)];
                    introductionLabel.text = [[adList objectAtIndex:indexPath.row] objectForKey:@"introduction"];
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
        else if (indexPath.section == 3){
            static NSString *identify =@"doorcell";
            CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            //            if (self.data.count>0) {
            if ([servList count]>0){
                cell.data = [servList objectAtIndex:indexPath.row];
                cell.backgroundColor = [UIColor clearColor];
            }
            //            }
            
            
            return cell;
            
        }
    }
    else{
        if (indexPath.section == 0) {
            NSString * cellName = @"publicTableViewCell";
            publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil];
                cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([[adListArray  objectAtIndex:currentNum] count] > 0){
                UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*AUTO_SIZE_SCALE_X)];
                bgView.backgroundColor = [UIColor whiteColor ];
                [cell addSubview:bgView];
                
                UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X, 150*AUTO_SIZE_SCALE_X)];
                ;
                [imv setImageWithURL:[NSURL URLWithString:[[[adListArray  objectAtIndex:currentNum]objectAtIndex:indexPath.row] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"banner默认图2比1"]];
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
            if ([navType isEqualToString:@"0" ]) {
                static NSString *identify =@"StoreListcell";
                StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[StoreListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                }
                //        if (self.data.count>0) {
                if ([[arrayGroup objectAtIndex:currentNum] count]>0){
                    cell.listArrayData = [[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row];
                    cell.backgroundColor = [UIColor clearColor];
                }
                
                //        }
                
                
                return cell;
                
            }
            else{
                static NSString *identify =@"doorcell";
                CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                }
                //            if (self.data.count>0) {
                if ([[arrayGroup objectAtIndex:currentNum] count]>0){
                    cell.data = [[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row];
                    cell.backgroundColor = [UIColor clearColor];
                }
                //            }
                
                
                return cell;
                
            }
            
            
        }
        
    }
    //
    //       else{
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
    //
    //    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag >= 1000) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
        if (indexPath.section == 0) {
            SeckillViewController * vc1 = [[SeckillViewController alloc] init];
            vc1.ID = [NSString stringWithFormat:@"%@",[[specialList objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            if (timebegin) {
                vc1.titles = @"秒杀专场";
            }
            else{
                vc1.titles = @"预告专场";
            }
            [self.navigationController pushViewController:vc1 animated:YES];
            return;
            
        }
        else if (indexPath.section == 2){
            if ([[NSString stringWithFormat:@"%@",[[adList objectAtIndex:indexPath.row] objectForKey:@"itemType"]] isEqualToString:@"0"]) {
                StoreActivityViewController * vc = [[StoreActivityViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",[[ adList  objectAtIndex:indexPath.row] objectForKey:@"ID"]];
                vc.name = [[ adList  objectAtIndex:indexPath.row] objectForKey:@"name"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([[NSString stringWithFormat:@"%@",[[adList objectAtIndex:indexPath.row] objectForKey:@"itemType"]] isEqualToString:@"1"]){
                ServiceActivityViewController * vc = [[ServiceActivityViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",[[ adList  objectAtIndex:indexPath.row] objectForKey:@"ID"]];
                vc.name = [[adList objectAtIndex:indexPath.row] objectForKey:@"name"];
                //                vc.serviceType = serviceType;
                [self.navigationController pushViewController:vc animated:YES    ];
            }
        }
    }
    else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
        navType = [navTypeArray objectAtIndex:currentNum];
        if (indexPath.section == 0) {
            NSLog(@"点击了广告栏");
            if ([navType isEqualToString:@"0" ]){
                StoreActivityViewController * vc = [[StoreActivityViewController alloc] init];
                vc.ID = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"ID"];
                vc.name = [[[adListArray  objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"name"];
                [self.navigationController pushViewController:vc animated:YES];
            }//ServiceActivityViewController
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
            
            if ([navType isEqualToString:@"0" ]){
                [MobClick event:STORE_STOREDETAIL];
                StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
                vc.storeID = [[[arrayGroup objectAtIndex:currentNum] objectAtIndex:indexPath.row] objectForKey:@"ID"];
                [self.navigationController pushViewController:vc animated:YES];
                //            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
                
            }else{
                ServiceDetailViewController * vc = [[ServiceDetailViewController alloc] init];
                vc.haveWorker = NO;
                vc.isStore = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
    
    
}

#pragma mark refreshViewStart

-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    NSLog(@"加载数据123");
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    
    BaseTableView * currentTableView = [baseTableViewArray objectAtIndex:currentNum];
    NSLog(@"currentTableView.tag  %ld",(long)currentTableView.tag);
    if (currentTableView.tag>=1000) {
        [specialList removeAllObjects];
        [activityList removeAllObjects];
        [adList removeAllObjects];
        [servList removeAllObjects];
//        NSLog(@"time id %@",[[timeZoneList objectAtIndex:(sender.view.tag-200)] objectForKey:@"ID"]);
        NSString * timeID = [NSString stringWithFormat:@"%@",[[timeZoneList objectAtIndex:currenttimeTag] objectForKey:@"ID"]];
//        currenttimeTag = (int)(sender.view.tag-200);
        timeout = NO;
        timebegin = NO;
        timeleftLabel.text = @"正在加载...";
        [refreshView endRefreshing];
        [self getTimeZoneContext:timeID];

        
    }
    
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
        //                NSLog(@"查询分类导航内容result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            
            //            navType = [NSString stringWithFormat:@"%@",[result objectForKey:@"navType"]];
            
            if ([navType isEqualToString:@"0"]) {
                NSMutableArray * currentarray = [NSMutableArray arrayWithArray:[arrayGroup objectAtIndex:currentNum]];
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"storeList"] ];
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [currentarray removeAllObjects];
                }
                [currentarray addObjectsFromArray:array];
                [arrayGroup replaceObjectAtIndex:currentNum withObject:currentarray];
                [currentTableView reloadData];
                [refreshView endRefreshing];
                NSLog(@"currentarray count -- %lu",(unsigned long)currentarray.count);
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
                if (array.count < 15 || array.count ==0 ) {
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
        //        [currentTableView.foot finishRefreshing];
        //        [currentTableView.head finishRefreshing];
        [refreshView endRefreshing];
        failView.hidden = NO;
        self.contentScrollView.hidden = YES;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        [ProgressHUD dismiss];
    }];
    
}

#pragma mark 收藏
-(void)favoritesImvTaped:(UITapGestureRecognizer *)sender
{
    //    sender.view.tag
    NSLog(@"收藏/取消收藏");
    [_baseTableView reloadData];
}

- (void)getUserInfo {
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    
    if (!([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]]||userID ==nil)) {
        NSDictionary * dic = @{
                               @"userID":userID
                               };
        [[RequestManager shareRequestManager] GetMyUserInfo:dic viewController:self successData:^(NSDictionary *result) {
            //            NSLog(@"result------------>%@",result);
            if(IsSucessCode(result)){
                
            }else{
                NDLog(@"--删除userid------");
                [userDetaults removeObjectForKey:@"userID"];
                [userDetaults removeObjectForKey:@"mobile"];
                [userDetaults removeObjectForKey:@"deposit"];
                [[RequestManager shareRequestManager] tipAlert:@"您的用户信息已过期，请重新登录" viewController:self];
            }
        } failuer:^(NSError *error) {
            
        }];
    }
}

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
