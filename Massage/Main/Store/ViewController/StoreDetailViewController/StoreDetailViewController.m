//
//  StoreDetailViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "SDCycleScrollView.h"



#import "CCLocationManager.h"
#import "UIImageView+WebCache.h"
#import "publicTableViewCell.h"
#import "ServiceDetailViewController.h"
#import "UMSocial.h"
#import "BaseTableView.h"
#import "RoutePlanViewController.h"
#import "CustomCellTableViewCell.h"
#import "TechicianListCell.h"
#import "technicianViewController.h"
#import "MyworkerTableViewCell.h"
#import "MyServiceTableViewCell.h"
#import "UIWindow+YzdHUD.h"
#import "clientCommentListViewController.h"
#import "FlashDetailViewController.h"

#import "LCProgressHUD.h"

#import "LoginViewController.h"

#import "noWifiView.h"
#import "AppDelegate.h"

#import "storeFeatureViewController.h"
//#import "FVCustomAlertView.h"
//#import "KxMenu.h"
@interface StoreDetailViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,UMSocialUIDelegate>
{
    SDCycleScrollView *cycle;
    
    UIView * headerView;
    UIImageView * imv;
    BaseTableView * myTableView;
    
    UIView * backView;
    UIImageView * bgYuan1;
    UIImageView * bgYuan2;
    UIImageView * bgYuan3;
    UIButton * favoritesBtn;
    UIButton * sharesBtn;
    UIButton * backsBtn;
    UIButton * favoriteBtn;
    UIButton * shareBtn;
    UIButton * backBtn;
    NSMutableArray * couponArray;
    NSMutableArray * coupontitleArray;
    NSMutableArray * couponnameArray;
    UIImageView * coupon_posImv;
    
    UILabel * serviceLabel;
    UILabel * workerLabel;
    
    UIWebView * phoneCallWebView;
    
    int ListType; //0服务 1技师
    
    NSArray *listViewData;
    
    NSMutableArray * workerArray;
    NSDictionary * storeData;
    NSMutableArray * serviceArray;
    
    int _pageForHot;
    
    NSString * serviceType; //0到店，1上门
    
    NSString * isFavorite;//类型 0：否，1：是，
    
    NSMutableArray * imageArray;
    
    
    NSString *Storelatitude;
    NSString *Storelongitude;
    
    NSString * isFlashPay; //类型 0：否，1：是，
    NSString * isReservable;//类型 0：否（仅展示），1：是，
    
    NSString * favoriteChange;
    NSString * defaultFavorite;
    
    UIActivityIndicatorView *activityIndicator;
    noWifiView *failView;
    UIImage *sharedImage;
    
    int currentCoupon;
    
    UIButton * flashBtn;

    UIImageView * shareImv;
    
    NSString * storeFeature;
}



@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) NSMutableArray *ALLData;
@property (nonatomic , strong) NSMutableArray *ALLData1;
@property (nonatomic , strong) NSMutableArray *data1;

@end

@implementation StoreDetailViewController
@synthesize storeID;

-(void)gotoLogVC
{
    flashBtn.userInteractionEnabled = YES;
    favoriteBtn.userInteractionEnabled = YES;
    favoritesBtn.userInteractionEnabled = YES;
    
    if (couponArray.count > 0) {
        for (UIImageView * couimv in couponArray) {
            couimv.userInteractionEnabled = YES;
        }
    }
   
    
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 收藏按钮点击事件
-(void)favoriteBtnPressed:(UIButton *)sender
{
    NSLog(@"收藏");
    sender.userInteractionEnabled = NO;
    //    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    
    //    [self performSelector:@selector(success:) withObject:nil afterDelay:2.0];
    
    
    //    完成模式：
    //    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:@"Done"];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用收藏功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        
        return;
    }
    
    //0当前未收藏
    if ([isFavorite isEqualToString:@"0"]) {
        [MobClick event:STORE_STOREDETAIL_COLLECT];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"0",//0 门店，1项目，2技师，3发现
                               @"itemID":self.storeID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] addCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"门店收藏 %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //提示 添加收藏成功
                isFavorite = @"1";
                [LCProgressHUD showSuccess:@"收藏成功"];
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                if ([isFavorite isEqualToString:defaultFavorite]) {
                    favoriteChange = @"0";
                }else{
                    favoriteChange = @"1";
                }
            }
            else
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        } failuer:^(NSError *error) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
        }];
        
    }
    //1当前已收藏
    else if ([isFavorite isEqualToString:@"1"]){
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"0",//0 门店，1项目，2技师，3发现
                               @"itemID":self.storeID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] cancelCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"删除门店收藏 %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //提示 取消收藏成功
                isFavorite = @"0";
                [LCProgressHUD showSuccess:@"收藏已取消"];
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];

                if ([isFavorite isEqualToString:defaultFavorite]) {
                    favoriteChange = @"0";
                }else{
                    favoriteChange = @"1";
                }
            }
            else
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        } failuer:^(NSError *error) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
        }];
    }
    
    
    
}

//-(void)success:(id)sender
//{
//    [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
////        [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
//        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
//}

#pragma mark 分享按钮点击事件
-(void)shareBtnPressed:(UIButton *)sender
{
    [MobClick event:STORE_STOREDETAIL_SHARE];
    NSLog(@"分享");
    NSString *url = [NSString stringWithFormat:@"http://wechat.huatuojiadao.com/weixin_user/html/wechat.html#shop-detail?id=%@",self.storeID];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.url = url;
    
    //微博 & 微信 & 朋友圈 & 复制链接
//    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageArray firstObject]]];
//    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
//    UIImage *img = [UIImage imageWithData:imgData];
    
    sharedImage = shareImv.image;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:[NSString stringWithFormat:@"%@",[storeData objectForKey:@"introduction"]]
                                     shareImage:sharedImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform",nil]
                                       delegate:self];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [storeData objectForKey:@"name"];
    
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [storeData objectForKey:@"name"];
}

#pragma mark 返回按钮点击事件
-(void)backsBtnPressed:(UIButton *)sender
{
    if ([self.backType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backAction
{
    if ([self.backType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

//-(void)loadData
//{
//    
//    listViewData = [NSArray arrayWithArray:[storeData objectForKey:@"serviceList"]];
//    
//    _data =[NSMutableArray array];
//    if (listViewData.count > 0) {
//        NSMutableArray *cellArray = [_data lastObject];
//        for (int i = 0; i < listViewData.count; i++) {
//            if (cellArray.count == 2 || cellArray == nil) {
//                cellArray = [NSMutableArray arrayWithCapacity:2];
//                [_data addObject:cellArray];
//                
//            }
//            NSDictionary *dic = listViewData[i];
//            
//            [cellArray addObject:dic];
//        }
//    }
//    
//    [serviceArray addObjectsFromArray:_data];
//}

#pragma mark 加载技师列表数据
-(void)loadWorkerData
{
    _pageForHot = 1;

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    NSDictionary * dic = @{
                           @"storeID":self.storeID,
                           @"pageStart":@"1",
                           @"pageOffset":@"15",
                           @"longitude":longitude,
                           @"latitude":latitude,
                           };
    [[RequestManager shareRequestManager] SearchContent:dic viewController:self SearchFlagType:@"1" successData:^(NSDictionary *result) {
        NDLog(@"loadWorkerData-->%@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            [activityIndicator stopAnimating];
//            activityIndicator.hidden = YES;
            
            NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"skillList"] ];
            
            [workerArray addObjectsFromArray:array];
            
            [self inittableView];
            [self.view addSubview:self.navView];
            
            
            // 1.根据数量判断是否需要隐藏上拉控件
            if (array.count < 15 || array.count ==0 ) {
                [myTableView.foot finishRefreshing];
            }else
            {
                [myTableView.foot endRefreshing];
            }
            
            //加载 店铺详情页面
            [self loadStoreData];
            
            
        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
    } failuer:^(NSError *error) {
        [self hideHud];
        failView.hidden = NO;
        myTableView.hidden = YES;
    }];
}

#pragma mark 加载门店数据
-(void)loadStoreData
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    if (!userID) {
        userID = @"";
    }
    NSDictionary * dic = @{
                           @"ID":self.storeID,
                           @"userID":userID,
                           @"longitude":longitude,
                           @"latitude":latitude,
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] getSysStoreDetail:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"门店详情--%@",result);
        [self hideHud];
        failView.hidden = YES;

        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            self.navView.alpha = 0;
            storeData = [NSDictionary dictionaryWithDictionary:result];
            
            //门店特色
            if ([result objectForKey:@"storeFeature"]) {
                storeFeature = [NSString stringWithFormat:@"%@",[result objectForKey:@"storeFeature"]];
            }
            //            [self loadData];
            NSArray * imgArray = [NSArray arrayWithArray: [result objectForKey:@"imageList"]];
            isFlashPay = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFlashPay"]];
            for (NSDictionary * dic in imgArray) {
                [imageArray addObject:[dic objectForKey:@"url"]];
            }
            NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageArray firstObject]]];
//            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
//            sharedImage = [UIImage imageWithData:imgData];//icon_touxiang
            
            shareImv = [[UIImageView alloc] init];
            [shareImv setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            
            self.titles =[storeData objectForKey:@"name"];
            
            Storelatitude=[NSString stringWithFormat:@"%@",[result objectForKey:@"latitude"]];
            Storelongitude=[NSString stringWithFormat:@"%@",[result objectForKey:@"longitude"]];
            
            isFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
            defaultFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
            isReservable = [NSString stringWithFormat:@"%@",[result objectForKey:@"isReservable"]];
            if ([isFavorite isEqualToString:@"1"]) {
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
            }else
            {
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
            }

            
            NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"serviceList"] ];
            
            //            NSMutableArray * array0 =[[NSMutableArray alloc] initWithCapacity:0];
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
            if (serviceArray.count <=0) {
                myTableView.bounces = NO;
            }
            //            NSLog(@"serviceArray  -- %@",serviceArray);
            
            
            //            if (ListType == 0) {
            //                myTableView.foot.hidden = YES;
            
            //            }
            [myTableView reloadData];
            [self initheaderView];
            myTableView.hidden = NO;
            bgYuan1.hidden = NO;
            bgYuan2.hidden = NO;
            bgYuan3.hidden = NO;
            favoritesBtn.hidden = NO;
            sharesBtn.hidden = NO;
            backsBtn.hidden = NO;
            
        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        [self hideHud];
        failView.hidden = NO;
        myTableView.hidden = YES;
        bgYuan1.hidden = YES;
        bgYuan2.hidden = YES;
        bgYuan3.hidden = YES;
        favoritesBtn.hidden = YES;
        sharesBtn.hidden = YES;
        backsBtn.hidden = YES;
    }];
}

#pragma mark 添加进入服务详情广播
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
    
}


#pragma mark 删除进入服务详情广播
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    if (self.returnStoreFavoriteChangeBlock != nil) {
        self.returnStoreFavoriteChangeBlock(favoriteChange);
    }
}

-(void)returnText:(ReturnStoreFavoriteChangeBlock)block
{
    self.returnStoreFavoriteChangeBlock = block;
}

#pragma mark 接收广播
-(void)gotoServiceDetailController:(NSNotification *)notification
{
    [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL];
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

#pragma mark 网络失败 刷新
- (void)reloadButtonClick:(UIButton *)sender {
    //先调技师列表 在调服务列表
    [self loadWorkerData];
    [self showHudInView:self.view hint:@"正在加载"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    favoriteChange = @"0";
    ListType = 0;
    workerArray = [[NSMutableArray alloc] initWithCapacity:0];
    serviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    couponArray = [[NSMutableArray alloc] initWithCapacity:0];
    imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    couponnameArray = [[NSMutableArray alloc] initWithCapacity:0];
    coupontitleArray = [[NSMutableArray alloc] initWithCapacity:0];
    serviceType = @"0";
    storeFeature = @"";
    
    currentCoupon = 9999;
    
    
    self.view.backgroundColor = C2UIColorGray;
    
    self.navView.alpha = 1;
    
    [self showHudInView:self.view hint:@"正在加载"];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];

    
    favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 20, 28*AUTO_SIZE_SCALE_X, 44);
        [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:favoriteBtn];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kScreenWidth - 28*AUTO_SIZE_SCALE_X-5, 20, 28*AUTO_SIZE_SCALE_X, 44);
    [shareBtn setImage:[UIImage imageNamed:@"icon_sd_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:shareBtn];
    
    
//    activityIndicator = [[UIActivityIndicatorView alloc]
//                         initWithActivityIndicatorStyle:
//                         UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicator.color = [UIColor blackColor];
//    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y);;
//    [activityIndicator startAnimating]; // 开始旋转
//    [self.view addSubview:activityIndicator];
    
    //先调技师列表 在调服务列表
    [self loadWorkerData];
}

//#pragma mark - scrollView相关操作 高度55*bili
//-(void)showcycle
//{
//    //    UIView *pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight  , kScreenWidth, 100*bili)];
//    //    pictureView.backgroundColor = [UIColor clearColor];
//    //
//    //
//    ////    // 情景二：采用网络图片实现
//    ////    NSArray *imagesURLStrings = @[
//    ////                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//    ////                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//    ////                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//    ////                                  ];
//    
//    //         --- 轮播时间间隔，默认1.0秒，可自定义
//    //cycleScrollView.autoScrollTimeInterval = 4.0;
//    
//    
//    //网络加载 --- 创建带标题的图片轮播器
//    cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 100*AUTO_SIZE_SCALE_X) imageURLStringsGroup:nil]; // 模拟网络延时情景
//    cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    cycle.backgroundColor =[UIColor whiteColor];
//    cycle.delegate = self;
//    cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
//    cycle.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    cycle.placeholderImage = [UIImage imageNamed:@"placeholder"];
//    //        [self.view addSubview:cycle];
//    [self.view addSubview:cycle];
//    
//    
//}

-(void)initheaderView
{
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = C2UIColorGray;
#pragma mark 店铺大图
    //店铺大图
    //网络加载 --- 创建带标题的图片轮播器

    if(imageArray !=nil && imageArray.count !=0){
      cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 240*AUTO_SIZE_SCALE_X) imageURLStringsGroup:nil];
    // 模拟网络延时情景
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            cycle.imageURLStringsGroup = imageArray;
            
        });
    }else{
        [imageArray addObjectsFromArray:@[[UIImage imageNamed:@"店铺、项目大图默认图"],
                                         
                                          ]];
        cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 240*AUTO_SIZE_SCALE_X) imagesGroup:imageArray];
    }
   
    cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycle.backgroundColor =[UIColor whiteColor];
    cycle.delegate = self;
    cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycle.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycle.placeholderImage = [UIImage imageNamed:@"店铺、项目大图默认图"];
    //        [self.view addSubview:cycle];
    cycle.autoScroll = NO;
    [headerView addSubview:cycle];
   
   
    if ([isReservable isEqualToString:@"1"]) {
        UIView * priceBgView = [[UIView alloc] initWithFrame:CGRectMake(8, 240*AUTO_SIZE_SCALE_X - 43*AUTO_SIZE_SCALE_X, 87*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_X)];
        priceBgView.backgroundColor = [UIColor blackColor];
        priceBgView.alpha = 0.3;
        [headerView  addSubview:priceBgView];
        
        //        float monetFloat = [[NSString stringWithFormat:@"%@",[storeData objectForKey:@"minPrice"]] floatValue]/100;
        
        NSString * moneyStr = @"";
        int monetInt = [[storeData objectForKey:@"minPrice"] intValue];
        if (monetInt%100 == 0) {
            monetInt = monetInt/100;
            moneyStr = [NSString stringWithFormat:@"¥%d起",monetInt];
        }else{
            float money = [[storeData objectForKey:@"minPrice"] floatValue];
            money = money/100.0;
            moneyStr = [NSString stringWithFormat:@"¥%0.2f起",money];
        }
        
        //        NSString * moneyStr = [NSString stringWithFormat:@"¥%0.2f起",monetFloat];
        NSMutableAttributedString * attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attMoneyStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:13.0 ]
                            range:NSMakeRange(0, 1)];
        [attMoneyStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:13.0 ]
                            range:NSMakeRange(moneyStr.length-1, 1)];
        [attMoneyStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:24.0 ]
                            range:NSMakeRange( 1,moneyStr.length-2)];
        [attMoneyStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor whiteColor]
                            range:NSMakeRange(0, moneyStr.length)];
        UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, cycle.frame.size.height - 43*AUTO_SIZE_SCALE_X, 87*AUTO_SIZE_SCALE_X, 43*AUTO_SIZE_SCALE_X)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.attributedText = attMoneyStr;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        CGSize priceLabelSize = [priceLabel intrinsicContentSize];
        priceLabel.frame = CGRectMake(8+8, cycle.frame.size.height - 43*AUTO_SIZE_SCALE_X, priceLabelSize.width+8, 43*AUTO_SIZE_SCALE_X);
        [headerView  addSubview:priceLabel];
        
        priceBgView.frame = CGRectMake(8, 240*AUTO_SIZE_SCALE_X - 43*AUTO_SIZE_SCALE_X,priceLabel.frame.origin.x+priceLabel.frame.size.width, 43*AUTO_SIZE_SCALE_X);
        
        if (monetInt == 0) {
            priceLabel.hidden = YES;
            priceBgView.hidden = YES;
        }
    }

    
#pragma mark headView
    UIView * headView = [[UIView alloc] init];
    headView.backgroundColor = C2UIColorGray;
    [headerView addSubview:headView];
    
#pragma mark firstView
    UIView * firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 72*AUTO_SIZE_SCALE_X)];
    firstView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:firstView];
    
    UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10*AUTO_SIZE_SCALE_X, 250*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X)];
    storeNameLabel.text = [NSString stringWithFormat:@"%@",[storeData objectForKey:@"name"]];;
    storeNameLabel.textColor = [UIColor blackColor];
    storeNameLabel.font = [UIFont systemFontOfSize:17];
    [firstView addSubview:storeNameLabel];
    
    if ([isReservable isEqualToString:@"1"]) {
        NSString * storeScore = [NSString stringWithFormat:@"%@分",[storeData objectForKey:@"score"]];
        NSMutableAttributedString * attstoreScore = [[NSMutableAttributedString alloc] initWithString:storeScore];
        [attstoreScore addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:13.0 ]
                              range:NSMakeRange(storeScore.length-1, 1)];
        [attstoreScore addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:16.0 ]
                              range:NSMakeRange( 0,storeScore.length-1)];
        [attstoreScore addAttribute:NSForegroundColorAttributeName
                              value:OrangeUIColorC4
                              range:NSMakeRange(0, storeScore.length)];
        UILabel * storeScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X-10, 16*AUTO_SIZE_SCALE_X)];
        storeScoreLabel.textColor = OrangeUIColorC4;
        storeScoreLabel.textAlignment = NSTextAlignmentRight;
        storeScoreLabel.attributedText = attstoreScore;
        [firstView addSubview:storeScoreLabel];

    }
    
    UILabel * worktimeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(10, firstView.frame.size.height-30*AUTO_SIZE_SCALE_X, 250*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
//    worktimeLabel.text =[NSString stringWithFormat:@"营业 %@ | 已成交%@单",[storeData objectForKey:@"openTime"],[storeData objectForKey:@"orderCount"]];
    if ([storeData objectForKey:@"openTime"]) {
        worktimeLabel.text =[NSString stringWithFormat:@"营业: %@",[storeData objectForKey:@"openTime"]];
    }else{
        worktimeLabel.text =[NSString stringWithFormat:@"%@",@"营业"];
    }
    worktimeLabel.textColor = C6UIColorGray;
    worktimeLabel.font = [UIFont systemFontOfSize:13];
    [firstView addSubview:worktimeLabel];
    
#pragma mark secView
    UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 130*AUTO_SIZE_SCALE_X)];
    secView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:secView];
    
    UIImageView * huiImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    huiImv.image = [UIImage imageNamed:@"icon_sd_coupon"];
    [secView addSubview:huiImv];
    
    UILabel * flashPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(13+huiImv.frame.origin.x+huiImv.frame.size.width, 0, 165*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X)];
    flashPayLabel.text = @"闪付买单,快捷更实惠";
    flashPayLabel.textColor = [UIColor blackColor];
    flashPayLabel.font = [UIFont systemFontOfSize:15];
    [secView addSubview:flashPayLabel];
    
    flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(kScreenWidth-10-95*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 95*AUTO_SIZE_SCALE_X, 36*AUTO_SIZE_SCALE_X);
    [flashBtn setTitle:@"闪付" forState:UIControlStateNormal];
    [flashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashBtn setTitle:@"闪付" forState:UIControlStateHighlighted];
    [flashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [flashBtn setBackgroundColor:OrangeUIColorC4];
    [flashBtn addTarget:self action:@selector(flashBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    flashBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15*AUTO_SIZE_SCALE_X];
    flashBtn.layer.cornerRadius = 5.0;
    [secView addSubview:flashBtn];
    
    if ([isFlashPay isEqualToString:@"0"]) {
        huiImv.hidden = YES;
        flashBtn.hidden = YES;
        flashPayLabel.frame = CGRectMake(13+huiImv.frame.origin.x+huiImv.frame.size.width, 0, 165*AUTO_SIZE_SCALE_X, 0);
    }
    
    if ([[storeData objectForKey:@"activityList"] count]>0) {
        UIImageView * zhixian1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, flashPayLabel.frame.origin.y+flashPayLabel.frame.size.height, kScreenWidth-10, 0.5)];
        zhixian1.image = [UIImage imageNamed:@"icon_zhixian"];
        [secView addSubview:zhixian1];
        
        UIScrollView * scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, flashPayLabel.frame.origin.y+flashPayLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
        scrView.delegate = self;
        scrView.tag = 100001;
        scrView.backgroundColor = [UIColor whiteColor];
        scrView.showsVerticalScrollIndicator = NO;
        scrView.showsHorizontalScrollIndicator = NO;
        scrView.contentSize = CGSizeMake(10+(99*AUTO_SIZE_SCALE_X+10)*[[storeData objectForKey:@"activityList"] count], 45*AUTO_SIZE_SCALE_X);
        [secView addSubview:scrView];
        
        for (int i = 0; i<[[storeData objectForKey:@"activityList"] count]; i++) {
            UIImageView * couponimv = [[UIImageView alloc] initWithFrame:CGRectMake(10+(99*AUTO_SIZE_SCALE_X+10)*i, 0, 99*AUTO_SIZE_SCALE_X, scrView.frame.size.height)];
            couponimv.userInteractionEnabled = YES;
            NSString * isReceiveable = [NSString stringWithFormat:@"%@",[[[storeData objectForKey:@"activityList"] objectAtIndex:i] objectForKey:@"isReceiveable"]];//isReceiveable
            //1为可以点击
            if ([isReceiveable isEqualToString:@"1"]) {
                couponimv.image = [UIImage imageNamed:@"bg_coupon_get"];
            }
            else{
                couponimv.image = [UIImage imageNamed:@"bg_coupon_getgary"];
                couponimv.userInteractionEnabled = NO;
            }
            couponimv.tag = i;
            [scrView addSubview:couponimv];
            UITapGestureRecognizer * couponimvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponimvTaped:)];
            [couponimv addGestureRecognizer:couponimvTap];
            
            [couponArray addObject:couponimv];
            
            UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(5*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, (99-10)*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X)];
            titlelabel.text = [NSString stringWithFormat:@"%@",@"优惠券"];
            if ([isReceiveable isEqualToString:@"1"]) {
                titlelabel.textColor = UIColorFromRGB(0xc59358);
            }
            else{
                titlelabel.textColor = UIColorFromRGB(0xbfc4ca);
            }
            titlelabel.font = [UIFont systemFontOfSize:11];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            [couponimv addSubview:titlelabel];
            [coupontitleArray addObject:titlelabel];
            
            UILabel * namelabel = [[UILabel alloc] initWithFrame:CGRectMake(5*AUTO_SIZE_SCALE_X, titlelabel.frame.origin.y+titlelabel.frame.size.height+5*AUTO_SIZE_SCALE_X, (99-10)*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
            namelabel.text = [NSString stringWithFormat:@"%@",[[[storeData objectForKey:@"activityList"] objectAtIndex:i] objectForKey:@"name"]];
            if ([isReceiveable isEqualToString:@"1"]) {
                namelabel.textColor = UIColorFromRGB(0xc59358);
            }
            else{
                namelabel.textColor = UIColorFromRGB(0xbfc4ca);
            }
            namelabel.font = [UIFont systemFontOfSize:13];
            namelabel.textAlignment = NSTextAlignmentCenter;
            [couponimv addSubview:namelabel];
            [couponnameArray addObject:namelabel];
            
            if ([isReceiveable isEqualToString:@"1"]) {
                
            }
            else{
                UIImageView * posGrayImv = [[UIImageView alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X, 5, 37*AUTO_SIZE_SCALE_X, 37*AUTO_SIZE_SCALE_X)];
                posGrayImv.image = [UIImage imageNamed:@"bg_coupon_posgary"];
                [couponimv addSubview:posGrayImv];
            }

        }
        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 130*AUTO_SIZE_SCALE_X);
    }
//    else if([isFlashPay isEqualToString:@"1"]){
//        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 65*AUTO_SIZE_SCALE_X);
//    }else if([isFlashPay isEqualToString:@"0"]){
//        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 0*AUTO_SIZE_SCALE_X);
//    }
    
    if([isFlashPay isEqualToString:@"1"]&&[[storeData objectForKey:@"activityList"] count] == 0){
        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 65*AUTO_SIZE_SCALE_X);
    }
//    else
        if([isFlashPay isEqualToString:@"0"]&&[[storeData objectForKey:@"activityList"] count] == 0){
        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 0*AUTO_SIZE_SCALE_X);
    }
    
    if([isFlashPay isEqualToString:@"0"]&&[[storeData objectForKey:@"activityList"] count] != 0){
        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, kScreenWidth, 65*AUTO_SIZE_SCALE_X);
    }
    
    if ([isReservable isEqualToString:@"0"]) {
        secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height, kScreenWidth, 0*AUTO_SIZE_SCALE_X);
    }
    
    NSLog(@"isReservable-->%@",isReservable);
#pragma mark thirdView
    UIView * thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, kScreenWidth, 157*AUTO_SIZE_SCALE_X)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:thirdView];
    
    UIView * thirdOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    [thirdView addSubview:thirdOneView];
    UITapGestureRecognizer * thirdOneViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdOneViewTaped:)];
    [thirdOneView addGestureRecognizer:thirdOneViewTap];
    
    UIImageView * phoneImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    phoneImv.image = [UIImage imageNamed:@"icon_sd_tel"];
    [thirdOneView addSubview:phoneImv];
    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+phoneImv.frame.origin.x+phoneImv.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5)];
    phoneLabel.text = [NSString stringWithFormat:@"%@",[storeData objectForKey:@"tel"]];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    [thirdOneView addSubview:phoneLabel];
    
    UIImageView * nextImv2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    nextImv2.image = [UIImage imageNamed:@"icon_sd_next"];
    [thirdOneView addSubview:nextImv2];
    
    UIImageView * zhixian2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, phoneLabel.frame.origin.y+phoneLabel.frame.size.height-0.5, kScreenWidth-10, 0.5)];
    zhixian2.image = [UIImage imageNamed:@"icon_zhixian"];
    [thirdOneView addSubview:zhixian2];
    
    UIView * thirdTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, thirdOneView.frame.origin.y+thirdOneView.frame.size.height, kScreenWidth, 65*AUTO_SIZE_SCALE_X)];
    [thirdView addSubview:thirdTwoView];
    UITapGestureRecognizer * thirdTwoViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdTwoViewTaped:)];
    [thirdTwoView addGestureRecognizer:thirdTwoViewTap];
    
    UIImageView * addressImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
    addressImv.image = [UIImage imageNamed:@"icon_sd_awayfrom"];
    [thirdTwoView addSubview:addressImv];
    
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+addressImv.frame.origin.x+addressImv.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X-0.5)];
    addressLabel.text = [NSString stringWithFormat:@"%@",[storeData objectForKey:@"address"]];
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.numberOfLines = 0;
    [thirdTwoView addSubview:addressLabel];
    
    UIImageView * nextImv3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    nextImv3.image = [UIImage imageNamed:@"icon_sd_next"];
    [thirdTwoView addSubview:nextImv3];
    
    UILabel * distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-nextImv3.frame.size.width-10-60*AUTO_SIZE_SCALE_X, 0, 60*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X-0.5)];
    CGFloat dist = [[NSString stringWithFormat:@"%@",[storeData objectForKey:@"distance"]] floatValue];
    if (dist >= 1) {
        distanceLabel.text = [NSString stringWithFormat:@"%0.1fkm",dist];
    }else{
        int dista = dist*1000;
        distanceLabel.text = [NSString stringWithFormat:@"%dm",dista];
    }
    distanceLabel.textColor = C6UIColorGray;
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont systemFontOfSize:14];
    [thirdTwoView addSubview:distanceLabel];
    
    
    
    if ([isReservable isEqualToString:@"1"]) {
        UIImageView * zhixian3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, addressLabel.frame.origin.y+addressLabel.frame.size.height-0.5, kScreenWidth-10, 0.5)];
        zhixian3.image = [UIImage imageNamed:@"icon_zhixian"];
        [thirdTwoView addSubview:zhixian3];
        
        UIView * thirdThreeView = [[UIView alloc] initWithFrame:CGRectMake(0, thirdTwoView.frame.origin.y+thirdTwoView.frame.size.height, kScreenWidth, 47*AUTO_SIZE_SCALE_X)];
        [thirdView addSubview:thirdThreeView];
        UITapGestureRecognizer * thirdThreeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdThreeViewTaped:)];
        [thirdThreeView addGestureRecognizer:thirdThreeViewTap];
        
        UIImageView * storeCommentImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
        storeCommentImv.image = [UIImage imageNamed:@"icon_sd_comment"];
        [thirdThreeView addSubview:storeCommentImv];
        
        UILabel * commentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+addressImv.frame.origin.x+addressImv.frame.size.width, 0, 90*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
        commentNameLabel.text = [NSString stringWithFormat:@"%@",@"用户评论"];
         commentNameLabel.font = [UIFont systemFontOfSize:15];
        commentNameLabel.numberOfLines = 0;
        [thirdThreeView addSubview:commentNameLabel];
        
        UIImageView * nextImv4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
        nextImv4.image = [UIImage imageNamed:@"icon_sd_next"];
        [thirdThreeView addSubview:nextImv4];
        
        UILabel * commentnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-nextImv3.frame.size.width-10-130*AUTO_SIZE_SCALE_X, 0, 130*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
        commentnumLabel.text = [NSString stringWithFormat:@"%@评",[storeData objectForKey:@"commentCount"]];
        if ([[NSString stringWithFormat:@"%@",[storeData objectForKey:@"commentCount"]] isEqualToString:@"0"]) {
            commentnumLabel.text = [NSString stringWithFormat:@"暂无评论"];
            thirdThreeView.userInteractionEnabled = NO;
        }else{
            commentnumLabel.text = [NSString stringWithFormat:@"%@评",[storeData objectForKey:@"commentCount"]];
        }
        
        commentnumLabel.textColor = C6UIColorGray;
        commentnumLabel.textAlignment = NSTextAlignmentRight;
        commentnumLabel.font = [UIFont systemFontOfSize:14];
        [thirdThreeView addSubview:commentnumLabel];
        //门店特色
        if (![storeFeature isEqualToString:@""]) {
            UIImageView * zhixian4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, commentnumLabel.frame.origin.y+commentnumLabel.frame.size.height-0.5, kScreenWidth-10, 0.5)];
            zhixian4.image = [UIImage imageNamed:@"icon_zhixian"];
            [thirdThreeView addSubview:zhixian4];

            UIView * thirdFourView = [[UIView alloc] initWithFrame:CGRectMake(0, thirdThreeView.frame.origin.y+thirdThreeView.frame.size.height, kScreenWidth, 47*AUTO_SIZE_SCALE_X)];
            [thirdView addSubview:thirdFourView];
            UITapGestureRecognizer * thirdFourViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdFourViewTaped:)];
            [thirdFourView addGestureRecognizer:thirdFourViewTap];
            
            UIImageView * characteristicImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
            characteristicImv.image = [UIImage imageNamed:@"characteristic"];
            [thirdFourView addSubview:characteristicImv];
            
            UILabel * characteristicLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+addressImv.frame.origin.x+addressImv.frame.size.width, 0, 90*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
            characteristicLabel.text = [NSString stringWithFormat:@"%@",@"门店特色"];
            characteristicLabel.font = [UIFont systemFontOfSize:15];
            characteristicLabel.numberOfLines = 0;
            [thirdFourView addSubview:characteristicLabel];
            
            UIImageView * nextImv5 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
            nextImv5.image = [UIImage imageNamed:@"icon_sd_next"];
            [thirdFourView addSubview:nextImv5];
            
            thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, kScreenWidth, thirdFourView.frame.origin.y+thirdFourView.frame.size.height);
        }
        else{
            
            thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, kScreenWidth, thirdThreeView.frame.origin.y+thirdThreeView.frame.size.height);

        }
    }else{
        //门店特色
        if (![storeFeature isEqualToString:@""]) {
            UIImageView * zhixian4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, addressLabel.frame.origin.y+addressLabel.frame.size.height-0.5, kScreenWidth-10, 0.5)];
            zhixian4.image = [UIImage imageNamed:@"icon_zhixian"];
            [thirdTwoView addSubview:zhixian4];
            
            UIView * thirdFourView = [[UIView alloc] initWithFrame:CGRectMake(0, thirdTwoView.frame.origin.y+thirdTwoView.frame.size.height, kScreenWidth, 47*AUTO_SIZE_SCALE_X)];
            [thirdView addSubview:thirdFourView];
            UITapGestureRecognizer * thirdFourViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdFourViewTaped:)];
            [thirdFourView addGestureRecognizer:thirdFourViewTap];
            
            UIImageView * characteristicImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
            characteristicImv.image = [UIImage imageNamed:@"characteristic"];
            [thirdFourView addSubview:characteristicImv];
            
            UILabel * characteristicLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+addressImv.frame.origin.x+addressImv.frame.size.width, 0, 90*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
            characteristicLabel.text = [NSString stringWithFormat:@"%@",@"门店特色"];
            characteristicLabel.font = [UIFont systemFontOfSize:15];
            characteristicLabel.numberOfLines = 0;
            [thirdFourView addSubview:characteristicLabel];
            
            UIImageView * nextImv5 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
            nextImv5.image = [UIImage imageNamed:@"icon_sd_next"];
            [thirdFourView addSubview:nextImv5];
            
            thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, kScreenWidth, thirdFourView.frame.origin.y+thirdFourView.frame.size.height);
        }
        else{
            thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, kScreenWidth, thirdTwoView.frame.origin.y+thirdTwoView.frame.size.height);
            
        }
//        thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, kScreenWidth, 113*AUTO_SIZE_SCALE_X);
    }
    
    //    UIImageView * zhixian4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, thirdThreeView.frame.size.height-0.5, kScreenWidth-10, 0.5)];
    //    zhixian4.image = [UIImage imageNamed:@"icon_zhixian"];
    //    [thirdThreeView addSubview:zhixian4];
    //
    //#pragma mark fourView
    //    UIView * fourView = [[UIView alloc] initWithFrame:CGRectMake(0, thirdView.frame.origin.y+thirdView.frame.size.height+10, kScreenWidth, 40*AUTO_SIZE_SCALE_X)];
    //    fourView.backgroundColor = [UIColor whiteColor];
    //    [headView addSubview:fourView];
    
#pragma mark headView.frame&&headerView.frame
    headView.frame = CGRectMake(0, cycle.frame.origin.y+cycle.frame.size.height, kScreenWidth,thirdView.frame.origin.y+thirdView.frame.size.height );
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headView.frame.origin.y+headView.frame.size.height+10);
    [myTableView setTableHeaderView:headerView];
    
}

-(void)inittableView
{
    //加载数据后判断，如果技师数组为空，style:UITableViewStyleGrouped;技师数组不为空，style:UITableViewStylePlain
    if (workerArray.count == 0) {
        myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStyleGrouped];
    }else
    {
        myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStylePlain];
    }
    
//    myTableView.style = ;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.delegates = self;
    myTableView.bounces = YES;
    myTableView.backgroundColor = UIColorFromRGB(0xebebeb);
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    myTableView.foot.hidden = YES;

    bgYuan1 = [[UIImageView alloc] init];
    bgYuan1.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan1.alpha = 0.5;
    [self.view addSubview:bgYuan1];
    bgYuan2 = [[UIImageView alloc] init  ];
    bgYuan2.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan2.alpha = 0.5;
    [self.view addSubview:bgYuan2];
    bgYuan3 = [[UIImageView alloc] init ];
    bgYuan3.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan3.alpha = 0.5;
    [self.view addSubview:bgYuan3];
    
    favoritesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoritesBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 22*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X, 44);
    [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
    [favoritesBtn addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [favoritesBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:favoritesBtn];
    
    bgYuan1.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    sharesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharesBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5), 22*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X, 44);
    [sharesBtn setImage:[UIImage imageNamed:@"icon_sd_share"] forState:UIControlStateNormal];
    [sharesBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sharesBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sharesBtn];
    bgYuan2.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5) , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    
    backsBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backsBtn.frame = CGRectMake(0, 22*AUTO_SIZE_SCALE_X,35*AUTO_SIZE_SCALE_X, 44);
    [backsBtn setImage:[UIImage imageNamed:@"icon_sd_back"] forState:UIControlStateNormal];
    [backsBtn addTarget:self action:@selector(backsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backsBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backsBtn];
    bgYuan3.frame = CGRectMake(5 , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    myTableView.hidden = YES;
    bgYuan1.hidden = YES;
    bgYuan2.hidden = YES;
    bgYuan3.hidden = YES;
    favoritesBtn.hidden = YES;
    sharesBtn.hidden = YES;
    backsBtn.hidden = YES;
}

#pragma mark 闪付按钮点击
-(void)flashBtnPressed:(UIButton *)sender
{
    [MobClick event:STORE_STOREDETAIL_PAY];
    NSLog(@"闪付闪付");
    flashBtn.userInteractionEnabled = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用闪付功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }
    flashBtn.userInteractionEnabled = YES;

    FlashDetailViewController * vc = [[FlashDetailViewController alloc] init];
    vc.storeID = self.storeID;
    vc.titles = [NSString stringWithFormat:@"%@",[storeData objectForKey:@"name"]];;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 拨打电话手势
-(void)thirdOneViewTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:STORE_STOREDETAIL_PHONE];
    NSLog(@"拨打电话");
    
    //    NSString * tel =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"tel"]];
    NSString * tel =[NSString stringWithFormat:@"%@",[storeData objectForKey:@"tel"]];
    tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"－" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"（" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"）" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@":" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"：" withString:@""];
    
    NSLog(@"%@",tel);
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}

#pragma mark 导航手势
-(void)thirdTwoViewTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:STORE_STOREDETAIL_ADRESS];
    NSLog(@"去导航");
    
    RoutePlanViewController * vc = [[RoutePlanViewController alloc] init];
    
    vc.latitude =    [Storelatitude doubleValue];
    
    vc.longitude =   [Storelongitude doubleValue];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    //    //高德三方导航
    //    //    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=com.sophiemarceauqu.Massage&sid=BGVIS1&slat=39.92848272&slon=116.39560823&sname=我的位置&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&m=0&t=0",currentLat, currentLon,_shopLat,_shopLon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    //    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    //    {
    //
    //        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    //
    //            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=com.sophiemarceauqu.Massage&sid=BGVIS1&slat=%f&slon=%f&sname=我的位置&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&m=0&t=2",locationCorrrdinate.latitude,locationCorrrdinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    //        }];
    //
    //    }
    //    else{
    //
    //    }
    //
    //    //    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=36.547901&lon=104.258354&dev=1&style=2"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    //
}

#pragma mark 评论手势
-(void)thirdThreeViewTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:STORE_STOREDETAIL_COMMENT];
    clientCommentListViewController *vc = [[clientCommentListViewController alloc] init];
    vc.ID = self.storeID;
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 特色手势
-(void)thirdFourViewTaped:(UITapGestureRecognizer *)sender
{
//    NSLog(@"特色服务～～～大保健～～～～");
    //storeFeature
    storeFeatureViewController * vc = [[storeFeatureViewController alloc] init];
    vc.storeFeature = storeFeature;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 店铺优惠券手势
-(void)couponimvTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:STORE_STOREDETAIL_COUPON];
    sender.view.userInteractionEnabled = NO;
    currentCoupon = (int)sender.view.tag;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能领取优惠券" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
//        sender.view.userInteractionEnabled = YES;
        return;
    }
    NSString * activityID = [NSString stringWithFormat:@"%@",[[[storeData objectForKey:@"activityList"] objectAtIndex:sender.view.tag] objectForKey:@"ID"]];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"activityID":activityID,
                           };
    
    [[RequestManager shareRequestManager] userGetCoupon:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"result %@",result);
        NSLog(@"result msg %@",[result objectForKey:@"msg"]);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            sender.view.userInteractionEnabled = YES;

            [[RequestManager shareRequestManager] tipAlert:@"成功领取优惠券" viewController:self];
            
            if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isReceiveable"]] isEqualToString:@"1"]) {
        
 
            }else{
                //需要先判断 是否可以使用，可以使用添加如下代码
                UIImageView * imgV = [couponArray objectAtIndex:sender.view.tag];
                imgV.image = [UIImage imageNamed:@"bg_coupon_getgary"];
                UILabel * titleLabel = [coupontitleArray objectAtIndex:sender.view.tag];
                titleLabel.textColor = UIColorFromRGB(0xbfc4ca);
                UILabel * nameLabel = [couponnameArray objectAtIndex:sender.view.tag];
                nameLabel.textColor = UIColorFromRGB(0xbfc4ca);
                
                coupon_posImv = [[UIImageView alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X, 5, 37*AUTO_SIZE_SCALE_X, 37*AUTO_SIZE_SCALE_X)];
                coupon_posImv.image = [UIImage imageNamed:@"bg_coupon_posgary"];
                [imgV addSubview:coupon_posImv];
                imgV.userInteractionEnabled = NO;
                sender.view.userInteractionEnabled = NO;
            }
            
        }else
        [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
//        sender.view.userInteractionEnabled = YES;

    } failuer:^(NSError *error) {
        sender.view.userInteractionEnabled = YES;

    }];
}

#pragma mark 展示服务列表手势
-(void)serviceLabelTaped:(UITapGestureRecognizer *)sender
{
    //刷新tableView 展示服务列表
    NSLog(@"刷新tableView 展示服务列表");
    ListType = 0;
    myTableView.foot.hidden = YES;
    [myTableView reloadData];
}

#pragma mark 展示技师列表手势
-(void)workerLabelTaped:(UITapGestureRecognizer *)sender
{
    //刷新tableView 展示技师列表
    NSLog(@"刷新tableView 展示技师列表");
    ListType = 1;
    myTableView.foot.hidden = NO;
    [myTableView reloadData];
    
    //    ServiceDetailViewController * vc = [[ServiceDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark TableView代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([isReservable isEqualToString:@"1"]){
        if (storeData) {
            UIView * fourView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X)];
            fourView.backgroundColor = [UIColor whiteColor];
            
            UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40*AUTO_SIZE_SCALE_X-0.5, kScreenWidth, 0.5)];
            zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
            [fourView addSubview:zhixianImv];
            
            //技师数组为空，只有服务列表
            if (workerArray.count == 0) {
                serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X)];
                serviceLabel.text = @"服务列表";
                serviceLabel.textColor = RedUIColorC1;
                serviceLabel.textAlignment = NSTextAlignmentCenter;
                serviceLabel.font = [UIFont systemFontOfSize:15];
                [fourView addSubview:serviceLabel];
                serviceLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer * serviceLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceLabelTaped:)];
                [serviceLabel addGestureRecognizer:serviceLabelTap];
            }
            else{
                //技师数组不为空，有服务列表和技师列表
                serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 40*AUTO_SIZE_SCALE_X)];
                serviceLabel.text = @"服务列表";
                serviceLabel.textColor = RedUIColorC1;
                serviceLabel.textAlignment = NSTextAlignmentCenter;
                serviceLabel.font = [UIFont systemFontOfSize:15];
                [fourView addSubview:serviceLabel];
                serviceLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer * serviceLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceLabelTaped:)];
                [serviceLabel addGestureRecognizer:serviceLabelTap];
                workerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 40*AUTO_SIZE_SCALE_X)];
                workerLabel.text = @"技师列表";
                workerLabel.textColor = [UIColor blackColor];
                workerLabel.textAlignment = NSTextAlignmentCenter;
                workerLabel.font = [UIFont systemFontOfSize:15];
                [fourView addSubview:workerLabel];
                workerLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer * workerLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workerLabelTaped:)];
                [workerLabel addGestureRecognizer:workerLabelTap];
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/2-55*AUTO_SIZE_SCALE_X)/2, 40*AUTO_SIZE_SCALE_X-3, 55*AUTO_SIZE_SCALE_X, 3)];
                lineView.backgroundColor = RedUIColorC1;
                lineView.hidden = YES;
                [fourView addSubview:lineView];
                
                UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2+(kScreenWidth/2-55*AUTO_SIZE_SCALE_X)/2, 40*AUTO_SIZE_SCALE_X-3, 55*AUTO_SIZE_SCALE_X, 3)];
                lineView1.backgroundColor = RedUIColorC1;
                lineView1.hidden = YES;
                [fourView addSubview:lineView1];
                
                if (ListType == 0) {
                    serviceLabel.textColor = RedUIColorC1;
                    workerLabel.textColor = [UIColor blackColor];
                    lineView.hidden = NO;
                    lineView1.hidden = YES;
                    
                }else if (ListType == 1){
                    serviceLabel.textColor = [UIColor blackColor];
                    workerLabel.textColor = RedUIColorC1;
                    lineView.hidden = YES;
                    lineView1.hidden = NO;
                }
                
            }
            
            return fourView;
            
        }

    }
        return NULL;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([isReservable isEqualToString:@"0"]) {
        return 0;
    }else{
        return 40*AUTO_SIZE_SCALE_X;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if ([isReservable isEqualToString:@"0"]) {
        return 0;
    }
    else{
        if (ListType == 0) {
            return serviceArray.count;
        }else if (ListType == 1){
            return workerArray.count;
        }
        return 0;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ListType == 0) {
//        return (108.75f+10.0f+88.0f)*AUTO_SIZE_SCALE_X;
        return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f-20;

        
    }else if (ListType == 1){
        return 380.0f*AUTO_SIZE_SCALE_X-30*AUTO_SIZE_SCALE_X;
        
    }
    return 0*AUTO_SIZE_SCALE_X;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ListType == 0) {
        static NSString *identify =@"MyServiceTableViewCell";
        MyServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[MyServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        if (serviceArray.count>0) {
            cell.data = serviceArray[indexPath.row];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }else if (ListType == 1){
        static NSString *identify =@"MyworkerTableViewCell";
        MyworkerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[MyworkerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.backgroundColor = [UIColor clearColor];
        if (workerArray.count>0) {
            cell.data = workerArray[indexPath.row];
        }
        
        return cell;
    }
    NSString * publicCell = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:publicCell];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:nil options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = C2UIColorGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    if (ListType == 1){
        technicianViewController * vc = [[technicianViewController alloc] init];
        vc.flag = @"0";
        vc.workerID = [[workerArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag != 100001) {
        cycle.center = CGPointMake(kScreenWidth/2, (240*AUTO_SIZE_SCALE_X+scrollView.contentOffset.y)/2);
        self.navView.alpha = scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X);
//        NSLog(@"xx --  %f",scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X));

        CGFloat xx = 0.0; //0-1
        xx = (scrollView.contentOffset.y-240*AUTO_SIZE_SCALE_X+kNavHeight)/(headerView.frame.size.height-240*AUTO_SIZE_SCALE_X);
        //        NSLog(@"xx --  %f",xx);
        
        if ( 0< xx && xx<=1 ) {
            //            NSLog(@"xx1 --  %f",xx);
            myTableView.frame = CGRectMake(0, kNavHeight*(xx) , kScreenWidth, kScreenHeight-kNavHeight*(xx) );
        }
        else if (xx <= 0)
        {
            myTableView.frame = CGRectMake(0, 0 , kScreenWidth, kScreenHeight  );
        }
        if (scrollView.contentOffset.y <= 0)
        {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            scrollView.contentOffset = offset;
        }
        
        if (self.navView.alpha != 0) {
            bgYuan1.hidden = YES;
            bgYuan2.hidden = YES;
            bgYuan3.hidden = YES;
            favoritesBtn.hidden = YES;
            sharesBtn.hidden = YES;
            backsBtn.hidden = YES;
        }
        if (self.navView.alpha == 0) {
            bgYuan1.hidden = NO;
            bgYuan2.hidden = NO;
            bgYuan3.hidden = NO;
            favoritesBtn.hidden = NO;
            sharesBtn.hidden = NO;
            backsBtn.hidden = NO;
        }
        
    }
    
}

#pragma mark 上拉下拉刷新
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    //门店详情 不需要上拉加载
    if (ListType == 0) {
        
    }
    
    else{
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            _pageForHot = 1;
        }
        else
        {
            _pageForHot++;
        }
        NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
        NSString * pageOffset = @"15";
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        
        NSDictionary * dic = @{
                               @"storeID":self.storeID,
                               @"pageStart":page,
                               @"pageOffset":pageOffset,
                               @"longitude":longitude,
                               @"latitude":latitude,
                               };
        [[RequestManager shareRequestManager] SearchContent:dic viewController:self SearchFlagType:@"1" successData:^(NSDictionary *result) {
            //                    NSLog(@"技师列表-->%@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                    [workerArray removeAllObjects];
                }
                NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"skillList"] ];
                
                [workerArray addObjectsFromArray:array];
                
                //                [workerArray addObjectsFromArray:[result objectForKey:@"skillList"]];
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
            
        } failuer:^(NSError *error) {
            
        }];
        
    }
}



//#pragma mark 初始化导航管理对象
//- (void)initNaviManager
//{
//    if (_naviManager == nil)
//    {
//        _naviManager = [[AMapNaviManager alloc] init];
//        [_naviManager setDelegate:self];
//    }
//}
//
//- (void)routeCal
//{
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.989614 longitude:116.481763];
//    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.983456 longitude:116.315495];
//
//    NSArray *startPoints = @[startPoint];
//    NSArray *endPoints   = @[endPoint];
//
//    //驾车路径规划（未设置途经点、导航策略为速度优先）
//    [_naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
//
//    //步行路径规划
//    [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
//}
//#pragma mark  导航视图初始化
//- (void)initNaviViewController
//{
//    if (_naviViewController == nil)
//    {
////        _naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mapView delegate:self];
//    }
//}
//
////路径规划成功的回调函数
//- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
//{
//
//    //导航视图展示
//    [_naviManager presentNaviViewController:_naviViewController animated:YES];
//}
//
////导航视图被展示出来的回调函数
//- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
//{
////    [super naviManager:naviManager didPresentNaviViewController:self.naviViewController];
//
//    //调用startGPSNavi方法进行实时导航，调用startEmulatorNavi方法进行模拟导航
//    [_naviManager startGPSNavi];
//}

#pragma mark -------------------------------------------------------
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
