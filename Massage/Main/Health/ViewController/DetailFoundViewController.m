//
//  DetailFoundViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "DetailFoundViewController.h"
#import "UIImageView+WebCache.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"

#import "UMSocial.h"
#import "LCProgressHUD.h"
//#import "ProgressHUD.h"

#import "LoginViewController.h"
#import "noWifiView.h"

#import "AppDelegate.h"
@interface DetailFoundViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,UIWebViewDelegate>
{
    UIView * headerView;
    UITableView * myTableView;
    UIImageView * imv;
    UIView * headView;
    
    UIImageView * bgYuan1;
    UIImageView * bgYuan2;
    UIImageView * bgYuan3;
    UIButton * favoritesBtn;
    UIButton * sharesBtn;
    UIButton * backsBtn;

    UIButton * favoriteBtn;
    UIButton * shareBtn;
    UIButton * backBtn;
    
    NSString * isFavorite;
    int _pageForHot;
    
    NSDictionary * dataDic;
    UIWebView * servicePositionWebView;
    
    NSString * favoriteChange;
    NSString * defaultFavorite;
    
//    UIActivityIndicatorView *activityIndicator;
    noWifiView * failView;

}
@end

@implementation DetailFoundViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    if (self.returnDetailFoundFavoriteChangeBlock != nil) {
        self.returnDetailFoundFavoriteChangeBlock(favoriteChange);
    }
}

-(void)returnText:(ReturnDetailFoundFavoriteChangeBlock)block
{
    self.returnDetailFoundFavoriteChangeBlock = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = C2UIColorGray;
    
    self.navView.alpha = 1;
//    self.titles = @"发现详情页";
    
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
    
    //    /** 滚动scrollView */
    //    [self showcycle];
//    [self showHintNoHide:@"正在加载..."];
    [self showHudInView:self.view hint:@"正在加载"];//可点击
//        [LCProgressHUD showLoading:@"正在加载"];//不可点击
    
//    activityIndicator = [[UIActivityIndicatorView alloc]
//                         initWithActivityIndicatorStyle:
//                         UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicator.color = [UIColor blackColor];
//    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y);;
//    [activityIndicator startAnimating]; // 开始旋转
//    [self.view addSubview:activityIndicator];

    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];

    [self loadData];

    

}

- (void)reloadButtonClick:(UIButton *)sender {
     [self showHudInView:self.view hint:@"正在加载"];
    [self loadData];
}

-(void)loadData
{
    
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
                           @"pageOffset":@"15",
                           };
    [[RequestManager shareRequestManager] getDiscoverItem:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"发现图文详情 %@",result);
        
      
        
        isFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
        defaultFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
        
               NDLog(@"msg-->%@",[result objectForKey:@"msg"]);
        dataDic = [NSDictionary dictionaryWithDictionary:result];
        
        self.titles = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"] ];
        
        [self inittableView];
        [self initheaderView];
        [self.view addSubview:self.navView];
        
//        servicePositionWebView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 200)];
//        servicePositionWebView.delegate = self;
//        //    servicePositionWebView.scrollView.bounces = NO;
////            servicePositionWebView.scrollView.showsHorizontalScrollIndicator = NO;
//        servicePositionWebView.scrollView.scrollEnabled = YES;
//        servicePositionWebView.userInteractionEnabled = NO;
////            [servicePositionWebView sizeToFit];
////        servicePositionWebView.scrollView.clipsToBounds = NO; //这样超出范围scrollView.frame 也会显示，即整个webView还是会正常显示
//        NSString * htmlcontent = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content" ]];
//        [servicePositionWebView loadHTMLString:htmlcontent baseURL:nil];
//        [self.view addSubview:servicePositionWebView];
        
    } failuer:^(NSError *error) {
        [self hideHud];
        failView.hidden = NO;
    }];
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
    sender.userInteractionEnabled = NO;
    NSLog(@"收藏");
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
        NDLog(@"发现图文收藏 %@",result);
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
            NDLog(@"删除发现图文收藏 %@",result);
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
    [imv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
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
//    [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
    if ([isFavorite isEqualToString:@"1"]) {
        [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
        [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
    }else
    {
        [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
        [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
    }

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
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, imv.frame.origin.y+imv.frame.size.height , kScreenWidth, 0)];
    headView.backgroundColor = [UIColor whiteColor];;
    [headerView addSubview:headView];
    
    CGSize descriptionSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X, 2000);
    UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, kScreenWidth-20, 125*AUTO_SIZE_SCALE_X)];
    storeNameLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"description"]];
    storeNameLabel.numberOfLines = 0;
    storeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    storeNameLabel.textColor = [UIColor blackColor];
    storeNameLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    CGSize storeNameLabelSize = [storeNameLabel.text sizeWithFont:storeNameLabel.font constrainedToSize:descriptionSize lineBreakMode:NSLineBreakByWordWrapping];
    storeNameLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, kScreenWidth-20, storeNameLabelSize.height);
    [headView addSubview:storeNameLabel];
    
    servicePositionWebView = [[UIWebView alloc] initWithFrame: CGRectMake(0, storeNameLabel.frame.origin.y+storeNameLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, kScreenWidth, 200)];
    servicePositionWebView.delegate = self;
    //    servicePositionWebView.scrollView.bounces = NO;
    //    servicePositionWebView.scrollView.showsHorizontalScrollIndicator = NO;
//        servicePositionWebView.scrollView.scrollEnabled = NO;
    servicePositionWebView.userInteractionEnabled = NO;
//        [servicePositionWebView sizeToFit];
//    servicePositionWebView.scrollView.clipsToBounds = NO; //这样超出范围scrollView.frame 也会显示，即整个webView还是会正常显示
    NSString * htmlcontent = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content" ]];
    [servicePositionWebView loadHTMLString:htmlcontent baseURL:nil];
    servicePositionWebView.hidden = YES;
    myTableView.hidden = YES;
#pragma mark headView.frame&&headerView.frame
//    headView.frame = CGRectMake(0, imv.frame.origin.y+imv.frame.size.height, kScreenWidth,servicePositionWebView.frame.origin.y+servicePositionWebView.frame.size.height );
//    headerView.frame = CGRectMake(0, 0, kScreenWidth, headView.frame.origin.y+headView.frame.size.height);
}

#pragma mark WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [self hideHud];
    failView.hidden = YES;

    NSString  *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    float webViewheight = [htmlHeight floatValue];
    webView.frame = CGRectMake(0, webView.frame.origin.y, self.view.frame.size.width, webViewheight);
    
//    headView.frame = CGRectMake(0, imv.frame.origin.y+imv.frame.size.height , kScreenWidth, servicePositionWebView.frame.origin.y+webViewheight+500);
//    headView.frame = CGRectMake(0, imv.frame.origin.y+imv.frame.size.height, kScreenWidth,servicePositionWebView.frame.origin.y+servicePositionWebView.frame.size.height );
//    headerView.frame = CGRectMake(0, 0, kScreenWidth, headView.frame.origin.y+headView.frame.size.height+500);
//    headerView.frame = CGRectMake(0, 0, kScreenWidth,servicePositionWebView.frame.origin.y+webViewheight);
//    NSLog(@"imv.frame.origin.y==%f",imv.frame.origin.y);
//    NSLog(@"imv.frame.size.height==%f",imv.frame.size.height);
//    NSLog(@"servicePositionWebView.frame.origin.y==%f",servicePositionWebView.frame.origin.y);
    NSLog(@"webViewheight==%f",webViewheight);
//    NSLog(@"self.view.frame.size.height==%f",self.view.frame.size.height);
//    servicePositionWebView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    [headView addSubview:servicePositionWebView];
    headView.frame = CGRectMake(0, imv.frame.origin.y+imv.frame.size.height, kScreenWidth, servicePositionWebView.frame.origin.y+webViewheight);
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headView.frame.origin.y+headView.frame.size.height);
    [myTableView setTableHeaderView:headerView];
    [myTableView reloadData];
    //    [LCProgressHUD hide];
//    [activityIndicator stopAnimating];
//    activityIndicator.hidden = YES;
    self.navView.alpha = 0.0;
    servicePositionWebView.hidden = NO;
    myTableView.hidden = NO;
}

-(void)inittableView
{
    //加载数据后判断，如果技师数组为空，style:UITableViewStyleGrouped;技师数组不为空，style:UITableViewStylePlain
    //   myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStyleGrouped];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStylePlain];
//    [myTableView setTableHeaderView:headerView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
//    myTableView.delegates = self;
//    myTableView.bounces = NO;
//    myTableView.rowHeight = 300;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}

#pragma mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0*AUTO_SIZE_SCALE_X;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * publicCell = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:publicCell];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:nil options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    [imgV setImageWithURL:[NSURL URLWithString:@"http://image.huatuojiadao.cn/2015/09/14/895b34a1-6642-4844-9b6d-1fd94983059d.jpg"] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
    [cell addSubview:imgV];
    
    cell.backgroundColor = [UIColor  whiteColor];
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
            imv.center = CGPointMake(kScreenWidth/2, (240*AUTO_SIZE_SCALE_X+scrollView.contentOffset.y)/2);
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
//            [bgYuan1 removeFromSuperview];
//            [favoritesBtn removeFromSuperview];
//            [bgYuan2 removeFromSuperview];
//            [sharesBtn removeFromSuperview];
//            [bgYuan3 removeFromSuperview];
//            [backsBtn removeFromSuperview];
            bgYuan1.hidden = YES;
            bgYuan2.hidden = YES;
            bgYuan3.hidden = YES;
            favoritesBtn.hidden = YES;
            sharesBtn.hidden = YES;
            backsBtn.hidden = YES;
        }
        if (self.navView.alpha == 0) {
//            [imv addSubview:bgYuan1];
//            [imv addSubview:favoritesBtn];
//            [imv addSubview:bgYuan2];
//            [imv addSubview:sharesBtn];
//            [imv addSubview:bgYuan3];
//            [imv addSubview:backsBtn];
            bgYuan1.hidden = NO;
            bgYuan2.hidden = NO;
            bgYuan3.hidden = NO;
            favoritesBtn.hidden = NO;
            sharesBtn.hidden = NO;
            backsBtn.hidden = NO;
        }
        
    }
    
}

#pragma mark 上下来刷新
//-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
//{
//    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//        _pageForHot = 1;
//    }
//    else
//    {
//        _pageForHot++;
//    }
//    NSString *page = [NSString stringWithFormat:@"%d",_pageForHot];
//    NSString * pageOffset = @"10";
//
//}

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
