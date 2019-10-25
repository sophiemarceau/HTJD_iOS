//
//  ServiceFoundViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "ServiceFoundViewController.h"
 #import "UIImageView+WebCache.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "UMSocial.h"

#import "KxMenu.h"
#import "CustomCellTableViewCell.h"
#import "QHCommonUtil.h"
#import "ServiceDetailViewController.h"

#import "LCProgressHUD.h"

#import "LoginViewController.h"
#import "noWifiView.h"
#import "AppDelegate.h"

@interface ServiceFoundViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,UMSocialUIDelegate>
{
    UIView * headerView;
    BaseTableView * myTableView;
    UIImageView * imv;
    UIView * headView;
    
    UIImageView * bgYuan1;
    UIImageView * bgYuan2;
    UIImageView * bgYuan3;
    UIButton * favoritesBtn;
    UIButton * sharesBtn;
    UIButton * backsBtn;
    NSArray *listViewData;
    
    UIButton * favoriteBtn;
    UIButton * shareBtn;
    UIButton * backBtn;
    
    NSDictionary * dataDic;
    NSMutableArray * serviceArray;

    NSString * isFavorite;

    int _pageForHot;
    
    NSString * favoriteChange;
    NSString * defaultFavorite;
    
//    UIActivityIndicatorView *activityIndicator;
    noWifiView * failView;

}

@property (nonatomic , strong) NSMutableArray *data;

@property (nonatomic , strong) NSMutableArray *ALLData;
@end

@implementation ServiceFoundViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    if (self.returnServiceFoundFavoriteChangeBlock != nil) {
        self.returnServiceFoundFavoriteChangeBlock(favoriteChange);
    }
}

-(void)returnText:(ReturnServiceFoundFavoriteChangeBlock)block
{
    self.returnServiceFoundFavoriteChangeBlock = block;
}
#pragma mark 接收广播
-(void)gotoServiceDetailController:(NSNotification *)notification
{
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:notification.object];
    ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
    vc.haveWorker = NO;
    vc.serviceType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"] ];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navView.alpha = 1;
//    self.titles = @"发现－项目详情页";
    serviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    [self showHudInView:self.view hint:@"正在加载"];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    [self loadData];
    
}

- (void)reloadButtonClick:(UIButton *)sender {
    [serviceArray removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载"];
    [self loadData];
}

-(void)gotoLogVC
{
    favoriteBtn.userInteractionEnabled = YES;
    favoritesBtn.userInteractionEnabled = YES;
    
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)favoriteBtnPressed:(UIButton *)sender
{
    NSLog(@"收藏");
    sender.userInteractionEnabled = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用收藏功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }
    if ([isFavorite isEqualToString:@"0"]) {
        [MobClick event:DISCOVER_DETAIL_COLLECT];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"3",//0 门店，1项目，2技师，3发现
                               @"itemID":self.ID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] addCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"发现项目收藏 %@",result);
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
    else if ([isFavorite isEqualToString:@"1"]){
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"3",//0 门店，1项目，2技师，3发现
                               @"itemID":self.ID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] cancelCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"删除发现项目收藏 %@",result);
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

-(void)shareBtnPressed:(UIButton *)sender
{
    [RequestManager shareRequestManager].CurrMainController = self;
    NSLog(@"分享");
    [MobClick event:DISCOVER_DETAIL_SHARE];
    NSString *url = [NSString stringWithFormat:@"http://wechat.huatuojiadao.com/weixin_user/html/wechat.html#discover-detail?id=%@",self.ID];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.url = url;
    
    //微博 & 微信 & 朋友圈 & 复制链接
//    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]]];
//    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
//    UIImage *img = [UIImage imageWithData:imgData];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"description"]]
                                     shareImage:imv.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform",nil]
                                       delegate:self];
 
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [dataDic objectForKey:@"title"];
    
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [dataDic objectForKey:@"title"];
}

-(void)backsBtnPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initheaderView
{
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = C2UIColorGray;
#pragma mark 店铺大图
    //店铺大图
    imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240*AUTO_SIZE_SCALE_X)];
    [imv setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
    [headerView addSubview:imv];
    imv.userInteractionEnabled = YES;
    
    UIImageView * maskImv = [[UIImageView alloc] initWithFrame:CGRectMake(imv.frame.origin.x, imv.frame.origin.y, imv.frame.size.width, imv.frame.size.height)];
    maskImv.image = [UIImage imageNamed:@"img_mask"];
    [imv addSubview:maskImv];

    CGSize titlesize = CGSizeMake(235*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X);
    UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-235*AUTO_SIZE_SCALE_X)/2, 170*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 0)];
    titlelabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.numberOfLines = 0;
    titlelabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlelabel.font = [UIFont systemFontOfSize:17];
    CGSize titlelabelsize = [titlelabel.text sizeWithFont:titlelabel.font constrainedToSize:titlesize lineBreakMode:NSLineBreakByWordWrapping];
    titlelabel.frame = CGRectMake((kScreenWidth-235*AUTO_SIZE_SCALE_X)/2, (240-20)*AUTO_SIZE_SCALE_X-titlelabelsize.height, 235*AUTO_SIZE_SCALE_X, titlelabelsize.height);
    [imv addSubview:titlelabel];

    
    bgYuan1 = [[UIImageView alloc] init];
    bgYuan1.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan1.alpha = 0.5;
    [imv addSubview:bgYuan1];
    bgYuan2 = [[UIImageView alloc] init  ];
    bgYuan2.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan2.alpha = 0.5;
    [imv addSubview:bgYuan2];
    bgYuan3 = [[UIImageView alloc] init ];
    bgYuan3.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan3.alpha = 0.5;
    [imv addSubview:bgYuan3];
    
    favoritesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoritesBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 22*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X, 44);
    [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
    [favoritesBtn addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [favoritesBtn setBackgroundColor:[UIColor clearColor]];
    [imv addSubview:favoritesBtn];
    
    bgYuan1.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    sharesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharesBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5), 22*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X, 44);
    [sharesBtn setImage:[UIImage imageNamed:@"icon_sd_share"] forState:UIControlStateNormal];
    [sharesBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sharesBtn setBackgroundColor:[UIColor clearColor]];
    [imv addSubview:sharesBtn];
    bgYuan2.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5) , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    
    backsBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backsBtn.frame = CGRectMake(0, 22*AUTO_SIZE_SCALE_X,35*AUTO_SIZE_SCALE_X, 44);
    [backsBtn setImage:[UIImage imageNamed:@"icon_sd_back"] forState:UIControlStateNormal];
    [backsBtn addTarget:self action:@selector(backsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backsBtn setBackgroundColor:[UIColor clearColor]];
    [imv addSubview:backsBtn];
    bgYuan3.frame = CGRectMake(5 , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
#pragma mark headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:headView];
    
    CGSize descriptionSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X, 2000);
    UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 125*AUTO_SIZE_SCALE_X)];
    storeNameLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"description"]];
    storeNameLabel.numberOfLines = 0;
    storeNameLabel.textColor = [UIColor blackColor];
    storeNameLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    CGSize storeNameLabelSize = [storeNameLabel.text sizeWithFont:storeNameLabel.font constrainedToSize:descriptionSize lineBreakMode:NSLineBreakByWordWrapping];
    storeNameLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, kScreenWidth-20, storeNameLabelSize.height);
    [headView addSubview:storeNameLabel];
    
#pragma mark headView.frame&&headerView.frame
    headView.frame = CGRectMake(0, imv.frame.origin.y+imv.frame.size.height, kScreenWidth,storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+15*AUTO_SIZE_SCALE_X );
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headView.frame.origin.y+headView.frame.size.height);
}
-(void)inittableView
{
//    [activityIndicator stopAnimating];
//    activityIndicator.hidden = YES;
    //加载数据后判断，如果技师数组为空，style:UITableViewStyleGrouped;技师数组不为空，style:UITableViewStylePlain
    //   myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStyleGrouped];
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStylePlain];
    [myTableView setTableHeaderView:headerView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.delegates = self;
    //    myTableView.bounces = NO;
    //    myTableView.rowHeight = 300;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
}

-(void)loadData
{
    [myTableView removeFromSuperview];

    _pageForHot = 1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    if (!userID) {
        userID = @"";
    }
    NSDictionary * dic = @{
                           @"ID":self.ID,
                           @"userID":userID,
                           @"latitude":latitude,
                           @"longitude":longitude,
                           @"pageStart":@"1",
                           @"pageOffset":@"30",
                           };
    [[RequestManager shareRequestManager] getDiscoverItem:dic viewController:self successData:^(NSDictionary *result) {
        self.navView.alpha = 0.0;
        [self hideHud];
        failView.hidden = YES;
        myTableView.hidden = NO;

        dataDic = [NSDictionary dictionaryWithDictionary:result];
        self.titles = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"] ];

        NDLog(@"发现服务详情 %@",result);
        [self initheaderView];
        [self inittableView];
        [self.view addSubview:self.navView];
        
        isFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
        defaultFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
        
        if ([isFavorite isEqualToString:@"1"]) {
            [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
            [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
        }else
        {
            [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
            [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
        }

        NSArray * array = [NSArray arrayWithArray:[result objectForKey:@"serviceList"]];
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
        if (array.count < 30 || array.count == 0) {
            [myTableView.foot finishRefreshing];
        }else{
            [myTableView.foot endRefreshing];
        }
        NDLog(@"msg-->%@",[result objectForKey:@"msg"]);
    } failuer:^(NSError *error) {
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }else{
        _pageForHot ++;
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    if (!userID) {
        userID = @"";
    }
    NSString * page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSDictionary * dic = @{
                           @"ID":self.ID,
                           @"userID":userID,
                           @"latitude":latitude,
                           @"longitude":longitude,
                           @"pageStart":page,
                           @"pageOffset":@"30",
                           };
    
    [[RequestManager shareRequestManager] getDiscoverItem:dic viewController:self successData:^(NSDictionary *result) {
//        NDLog(@"发现服务详情 %@",result);
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
            [serviceArray removeAllObjects];
        }
        isFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
        NSArray * array = [NSArray arrayWithArray:[result objectForKey:@"serviceList"]];
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
        if (array.count < 30 || array.count == 0) {
            [myTableView.foot finishRefreshing];
        }else{
            [myTableView.foot endRefreshing];
        }
        
        NDLog(@"msg-->%@",[result objectForKey:@"msg"]);
    } failuer:^(NSError *error) {
        [refreshView endRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
    }];
    
}

#pragma mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return serviceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return (108.75f+10.0f+88.0f)*AUTO_SIZE_SCALE_X;
    return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    static NSString *identify =@"doorcell";
    CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (serviceArray.count>0) {
        cell.data = serviceArray[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.contentOffset.y %f",scrollView.contentOffset.y);
    if (scrollView.tag != 100001) {
        if (scrollView.contentOffset.y>=0) {
//            imv.center = CGPointMake(kScreenWidth/2, (240*AUTO_SIZE_SCALE_X+scrollView.contentOffset.y)/2);
            self.navView.alpha = scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X);
        }
        //        CGFloat xx = 0.0; //0-1
        //        xx = (-scrollView.contentOffset.y)/(65.0);
        //        myTableView.frame = CGRectMake(0, 20*(xx), kScreenWidth, kScreenHeight-20*(xx));
        
        if (scrollView.contentOffset.y <= 0)
        {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            scrollView.contentOffset = offset;
        }
        
        if (scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X) >1) {
            imv.hidden = YES;
        }else{
            imv.hidden = NO;
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
