//
//  ServiceDetailViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/27.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "SDCycleScrollView.h"
#import "publicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DoorAppointmentViewController.h"
#import "DoorAppointmentFromWorkerViewController.h"
#import "DoorAppointmentFromServiceViewController.h"
#import "StoreAppointmentFromServiceViewController.h"
#import "StoreAppointmentFromWorkerViewController.h"
#import "technicianViewController.h"
#import "TechnicianMyselfViewController.h"
#import "clientCommentListViewController.h"
#import "RoutePlanViewController.h"
#import "CWStarRateView.h"
#import "LCProgressHUD.h"

#import "UMSocial.h"

#import "LoginViewController.h"

#import "noWifiView.h"
#import "AppDelegate.h"

@interface ServiceDetailViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UMSocialUIDelegate,UIAlertViewDelegate>
{
    SDCycleScrollView *cycle;
    
    UITableView * myTableView;
    UIView * headerView;
    
    UIImageView * bgYuan1;
    UIImageView * bgYuan2;
    UIImageView * bgYuan3;
    UIButton * favoritesBtn;
    UIButton * sharesBtn;
    UIButton * backsBtn;
    
    UIButton * favoriteBtn;
    UIButton * shareBtn;
    UIButton * backBtn;
    
    NSMutableArray * imageArray;
    
    UIView * btnView;
    
    UIView * serviceInfoView; //服务信息
    UIView * serviceCommentView; //服务评价
    UIView * workerInfoView; //技师信息
    UIView * serviceIntrodutionView; //服务介绍
    UIView * servicePositionView; //服务部位
    UIView * serviceSymptomView; //服务症状
    UIView * serviceNoticeView; //服务须知
    
    UIWebView * phoneCallWebView;
    
    NSDictionary * dataDic;
    NSString * isFavorite;
    
    NSMutableArray * introductionArray;
    NSMutableArray * reminderArray;
    
    CWStarRateView * startView;//评级
    
    NSString * favoriteChange;
    NSString * defaultFavorite;
    
//    UIActivityIndicatorView *activityIndicator;
    noWifiView *failView;
    
    UIImage *sharedImage;

    UIButton * yuyueBtn;
    
    UIImageView * shareImv;

}
@end

@implementation ServiceDetailViewController
@synthesize haveWorker,isStore,serviceID,isSelfOwned,serviceType,backType;

-(void)gotoLogVC
{
    favoriteBtn.userInteractionEnabled = YES;
    favoritesBtn.userInteractionEnabled = YES;
    yuyueBtn.userInteractionEnabled = YES;
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)favoriteBtnPressed:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用收藏功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }
    NSLog(@"收藏");
    //    NSDictionary * dic = @{
    //                           @"userID":userID,
    //                           @"itemType":@"1",//0 门店，1项目，2技师，3发现
    //                           @"itemId":self.serviceID,//门店ID/服务ID/技师ID/发现ID
    //                           };
    //    [[RequestManager shareRequestManager] addCollect:dic viewController:self successData:^(NSDictionary *result) {
    //        NDLog(@"项目收藏 %@",result);
    //    } failuer:^(NSError *error) {
    //
    //    }];
    //
    //0当前未收藏
    if ([isFavorite isEqualToString:@"0"]) {
        if (!isStore) {
            [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_COLLECT];
        }else if (isStore) {
            [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_COLLECT];
        }
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"1",//0 门店，1项目，2技师，3发现
                               @"itemID":self.serviceID,//门店ID/服务ID/技师ID/发现ID
                               };
        NSLog(@"dic %@",dic);
        [[RequestManager shareRequestManager] addCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"项目收藏 %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //提示 添加收藏成功
                isFavorite = @"1";
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                [LCProgressHUD showSuccess:@"收藏成功"];
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
                               @"itemType":@"1",//0 门店，1项目，2技师，3发现
                               @"itemID":self.serviceID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] cancelCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"删除项目收藏 %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //提示 取消收藏成功
                isFavorite = @"0";
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
                [LCProgressHUD showSuccess:@"收藏已取消"];
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
    if (!isStore) {
        [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_SHARE];
    }else if (isStore) {
        [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_SHARE];
    }
    NSLog(@"分享");
    NSString *url = [NSString stringWithFormat:@"http://wechat.huatuojiadao.com/weixin_user/html/wechat.html#project-detail?id=%@",self.serviceID];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.url = url;
    
    //微博 & 微信 & 朋友圈 & 复制链接
//    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon"]]];
//    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
//    UIImage *img = [UIImage imageWithData:imgData];
    NSString *str = [NSString string];
    if (introductionArray.count > 0) {
        str = [NSString stringWithFormat:@"%@、%@",[[introductionArray firstObject]objectForKey:@"tag"],[[introductionArray firstObject]objectForKey:@"content"]];
    }else {
        str = @"";
    }
    sharedImage = shareImv.image;

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:str
                                     shareImage:sharedImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform",nil]
                                       delegate:self];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [dataDic objectForKey:@"name"];
    
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [dataDic objectForKey:@"name"];
}

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

-(void)gotoStoreVC
{
    yuyueBtn.userInteractionEnabled = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
    UIButton *tempbutton =[[UIButton alloc]init];
    tempbutton.tag =0;
    [mainVC selectorAction:tempbutton];
}

-(void)serviceDownLine
{
    yuyueBtn.userInteractionEnabled = YES;
    //项目是门店的
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]){
        //从项目进的 退回首页
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
            UIButton *tempbutton =[[UIButton alloc]init];
            tempbutton.tag =0;
            [mainVC selectorAction:tempbutton];
        }
        else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }
    //项目是自营的
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
        UIButton *tempbutton =[[UIButton alloc]init];
        tempbutton.tag =1
        ;
        [mainVC selectorAction:tempbutton];
    }
}

-(void)workerDownLine
{
    yuyueBtn.userInteractionEnabled = YES;

    //项目是门店到店
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isGoHome"]] isEqualToString:@"0"]){
        StoreAppointmentFromServiceViewController * vc = [[StoreAppointmentFromServiceViewController alloc] init];
        vc.serviceID = [dataDic objectForKey:@"ID"];
        vc.serviceInfoDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isGoHome"]] isEqualToString:@"1"]) {

        //项目是门店上门
        //项目是自营上门
        DoorAppointmentFromServiceViewController * vc = [[DoorAppointmentFromServiceViewController alloc] init];
        vc.serviceID = [dataDic objectForKey:@"ID"];
        vc.serviceInfoDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
 
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(gotoStoreVC) withObject:nil afterDelay:0];

        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(serviceDownLine) withObject:nil afterDelay:0];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(workerDownLine) withObject:nil afterDelay:0];
        }
    }
}

-(void)yuyueBtnPressed:(UIButton *)sender
{
    NSLog(@"预约");
    sender.userInteractionEnabled = NO;
    //    NSLog(@"serviceInfoDic %@",dataDic);
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用预约功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }
    
    //店铺下线
    if ([dataDic objectForKey:@"storeState"]&&![[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"storeState"]] isEqualToString:@""]) {
        NSString * storeState = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"storeState"]];
        if ([storeState isEqualToString:@"9"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该门店已下线暂不可约,欢迎点选其他门店" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 1;
            [alert show];
            return;
        }
    }
    //项目下线
    if ([dataDic objectForKey:@"state"]&&![[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"state"]] isEqualToString:@""]) {
        NSString * state = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"state"]];
        if ([state isEqualToString:@"9"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该项目已下线暂不可约,欢迎点选其他服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
            return;
        }
    }
    //技师下线
    if ([dataDic objectForKey:@"workerState"]&&![[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"workerState"]] isEqualToString:@""]) {
        NSString * workerState = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"workerState"]];
        if ([workerState isEqualToString:@"9"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该技师已下线暂不可约,欢迎点选本店其他技师" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 3;
            [alert show];
            return;
        }
    }
    yuyueBtn.userInteractionEnabled = YES;

    //1为上门
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isGoHome"]] isEqualToString:@"1"]) {
        [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER];
        //有技师
        if (haveWorker) {
            DoorAppointmentFromWorkerViewController * vc = [[DoorAppointmentFromWorkerViewController alloc] init];
            vc.serviceID = [dataDic objectForKey:@"ID"];
            vc.serviceInfoDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //无技师
        else{
            DoorAppointmentFromServiceViewController * vc = [[DoorAppointmentFromServiceViewController alloc] init];
            vc.serviceID = [dataDic objectForKey:@"ID"];
            vc.serviceInfoDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    //0为为到店
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isGoHome"]] isEqualToString:@"0"]){
        [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER];
        //有技师
        if (haveWorker) {
            StoreAppointmentFromWorkerViewController * vc = [[StoreAppointmentFromWorkerViewController alloc] init];
            vc.serviceID = [dataDic objectForKey:@"ID"];
            vc.serviceInfoDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        //无技师
        else{
            StoreAppointmentFromServiceViewController * vc = [[StoreAppointmentFromServiceViewController alloc] init];
            vc.serviceID = [dataDic objectForKey:@"ID"];
            vc.serviceInfoDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

-(void)downloadDate
{
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * skillWorkerID ;
    
    if (![self.workerInfoDic objectForKey:@"ID"]) {
        skillWorkerID = @"";
    }else{
        skillWorkerID = [self.workerInfoDic objectForKey:@"ID"];
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    if (!userID) {
        userID = @"";
    }
    NSDictionary * dic = @{
                           @"ID":self.serviceID,
                           @"userID":userID,
                           @"longitude":longitude,
                           @"latitude":latitude,
                           @"skillWorkerID":skillWorkerID,
                           };
    NDLog(@"项目详情dic-->%@",dic);

    [[RequestManager shareRequestManager] getSysServiceDetail:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"项目详情result-->%@",result);
        self.navView.alpha = 0.0;
        [self hideHud];
        failView.hidden = YES;
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            [activityIndicator stopAnimating];
//            activityIndicator.hidden = YES;
            
            dataDic = [NSDictionary dictionaryWithDictionary:result];
            self.titles = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
            isFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
            defaultFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFlashPay"]];
            
            if ([isFavorite isEqualToString:@"1"]) {
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
            }else
            {
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
                [favoritesBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
            }
            
            [introductionArray addObjectsFromArray:[dataDic objectForKey:@"introduction"]];
            [reminderArray addObjectsFromArray:[dataDic objectForKey:@"reminder"]];
            //            NSLog(@"服务介绍introduction-%@",[result objectForKey:@"introduction"]);
            //            NSLog(@"针对部位forBodyPart-%@",[result objectForKey:@"forBodyPart"]);
            //            NSLog(@"适用症状forSymptom-%@",[result objectForKey:@"forSymptom"]);
            //            NSLog(@"购买须知reminder-%@",[result objectForKey:@"reminder"]);
            NSArray * imgArray = [NSArray arrayWithArray: [dataDic objectForKey:@"imageList"]];
            
            for (NSDictionary * dic in imgArray) {
                [imageArray addObject:[dic objectForKey:@"url"]];
            }
            //            imageArray = [NSMutableArray arrayWithArray: [dataDic objectForKey:@"imageList"]];
            NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon"]]];
//            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
//            sharedImage = [UIImage imageWithData:imgData];
            shareImv = [[UIImageView alloc] init];
            [shareImv setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            
            [self initView];
        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
        
    } failuer:^(NSError *error) {
        [self hideHud];
        failView.hidden = NO;
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.returnServiceFavoriteChangeBlock != nil) {
        self.returnServiceFavoriteChangeBlock(favoriteChange);
    }
}

-(void)returnText:(ReturnServiceFavoriteChangeBlock)block
{
    self.returnServiceFavoriteChangeBlock = block;
}
#pragma mark 网络失败 刷新
- (void)reloadButtonClick:(UIButton *)sender {
    [self downloadDate];
    [self showHudInView:self.view hint:@"正在加载"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    isStore = NO;
    //    haveWorker = YES;
//    self.navView.alpha = 0.0;
    self.navView.alpha = 1;
    
    [self showHudInView:self.view hint:@"正在加载"];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    introductionArray = [[NSMutableArray alloc] initWithCapacity:0];
    reminderArray = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    
    [self downloadDate];
    
    
    
}

-(void)initView
{
    
    [self initheaderView];
    [self inittableView];
    [self.view addSubview:self.navView];
    
}

-(void)initheaderView
{
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = C2UIColorGray;
#pragma mark 项目大图
    //项目大图
    //网络加载 --- 创建带标题的图片轮播器
    cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 240*AUTO_SIZE_SCALE_X) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycle.backgroundColor =[UIColor whiteColor];
    cycle.delegate = self;
    cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycle.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycle.placeholderImage = [UIImage imageNamed:@"placeholder"];
    //    cycle.imageURLStringsGroup = imageArray;
    //        [self.view addSubview:cycle];
    cycle.autoScroll = NO;
    [headerView addSubview:cycle];
    
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycle.imageURLStringsGroup = imageArray;
    });
#pragma mark headView
    UIView * headView = [[UIView alloc] init ];
    headView.backgroundColor = C2UIColorGray;
    [headerView addSubview:headView];
#pragma mark serviceInfoView
    if (isStore) {
        serviceInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73*AUTO_SIZE_SCALE_X)];
    }else{
        serviceInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 94*AUTO_SIZE_SCALE_X)];
    }
    serviceInfoView.backgroundColor = [UIColor whiteColor];
    
    NSString * sitType = @"";
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"sitType"]] isEqualToString:@"0"]) {
        sitType = @"坐";
    }else if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"sitType"]] isEqualToString:@"1"]){
        sitType = @"卧";
    }
    UILabel * serviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 38*AUTO_SIZE_SCALE_X)];
    serviceNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[dataDic objectForKey:@"name"],sitType];
    serviceNameLabel.font = [UIFont systemFontOfSize:18];
    [serviceInfoView addSubview:serviceNameLabel];
    
    //    float moneyFloat = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"minPrice"]] floatValue]/100.0;
    //    NSString * moneyStr = [NSString stringWithFormat:@"¥%0.2f起",moneyFloat];
    
    NSString * moneyStr = @"";
    int monetInt = [[dataDic objectForKey:@"minPrice"] intValue];
    if (monetInt%100 == 0) {
        monetInt = monetInt/100;
        NSString * isLevel = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isLevel"]];
        if ([isLevel isEqualToString:@"0"]||haveWorker) {
            moneyStr = [NSString stringWithFormat:@"¥%d",monetInt];
        }else if([isLevel isEqualToString:@"1"]){
            moneyStr = [NSString stringWithFormat:@"¥%d起",monetInt];
        }
    }else{
        float money = [[dataDic objectForKey:@"minPrice"] floatValue];
        money = money/100.0;
        NSString * isLevel = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isLevel"]];
        if ([isLevel isEqualToString:@"0"]||haveWorker) {
            moneyStr = [NSString stringWithFormat:@"¥%0.2f",money];
        }else if([isLevel isEqualToString:@"1"]){
            moneyStr = [NSString stringWithFormat:@"¥%0.2f起",money];
        }
    }
    
    NSMutableAttributedString * attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attMoneyStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:10]
                        range:NSMakeRange(0, 1)];
    NSString * isLevel = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isLevel"]];
    if ([isLevel isEqualToString:@"0"]||haveWorker) {
        [attMoneyStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16.0]
                            range:NSMakeRange( 1,moneyStr.length-1)];
    }
    else if([isLevel isEqualToString:@"1"]){
        [attMoneyStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:10.0]
                            range:NSMakeRange(moneyStr.length-1, 1)];
        [attMoneyStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16.0]
                            range:NSMakeRange( 1,moneyStr.length-2)];
    }
    [attMoneyStr addAttribute:NSForegroundColorAttributeName
                        value:RedUIColorC1
                        range:NSMakeRange(0, moneyStr.length)];
    UILabel * servicePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height, kScreenWidth/2-10, 16*AUTO_SIZE_SCALE_X)];
    servicePriceLabel.attributedText = attMoneyStr;
    CGSize servicePriceLabelSize = [servicePriceLabel intrinsicContentSize];
    servicePriceLabel.frame = CGRectMake(10, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height, servicePriceLabelSize.width, 16*AUTO_SIZE_SCALE_X);
    //    servicePriceLabel.backgroundColor = [UIColor yellowColor];
    [serviceInfoView addSubview:servicePriceLabel];
    //    NSLog(@"宽度 %f",servicePriceLabelSize.width);
    
    //    float temoneyFloat = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"maxPrice"]] floatValue]/100.0;
    //    NSString * temoneyStr = [NSString stringWithFormat:@"特价 ¥%0.2f",temoneyFloat];
    
    NSString * temoneyStr = @"";
    int temonetInt = [[dataDic objectForKey:@"maxPrice"] intValue];
    if (temonetInt%100 == 0) {
        temonetInt = temonetInt/100;
        temoneyStr = [NSString stringWithFormat:@"市场价 ¥%d",temonetInt];
    }else{
        float temoney = [[dataDic objectForKey:@"maxPrice"] floatValue];
        temoney = temoney/100.0;
        temoneyStr = [NSString stringWithFormat:@"市场价  ¥%0.2f",temoney];
    }
    
    NSMutableAttributedString * attTemoneyStr  = [[NSMutableAttributedString alloc] initWithString:temoneyStr];
    [attTemoneyStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(0, 3)];
    [attTemoneyStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:10.0]
                          range:NSMakeRange(4, temoneyStr.length-4)];
    [attTemoneyStr addAttribute:NSStrikethroughStyleAttributeName
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                          range:NSMakeRange( 4, temoneyStr.length-4)];
    [attTemoneyStr addAttribute:NSForegroundColorAttributeName
                          value:C6UIColorGray
                          range:NSMakeRange(0, temoneyStr.length)];
    UILabel * serviceTePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(servicePriceLabel.frame.origin.x+servicePriceLabel.frame.size.width, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height, kScreenWidth/2-10, 16*AUTO_SIZE_SCALE_X)];
    serviceTePriceLabel.attributedText = attTemoneyStr;
    CGSize serviceTePriceLabelSize = [serviceTePriceLabel intrinsicContentSize];
    serviceTePriceLabel.frame = CGRectMake(servicePriceLabel.frame.origin.x+servicePriceLabel.frame.size.width+12*AUTO_SIZE_SCALE_X, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height, serviceTePriceLabelSize.width, 16*AUTO_SIZE_SCALE_X);
    //    serviceTePriceLabel.backgroundColor = [UIColor blueColor];
    [serviceInfoView addSubview:serviceTePriceLabel];
    
    NSString * timeStr = [NSString stringWithFormat:@"单钟时长: %@分钟",[dataDic objectForKey:@"duration"]];
    NSMutableAttributedString * attTimeStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [attTimeStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:12.0]
                       range:NSMakeRange(0, timeStr.length)];
    [attTimeStr addAttribute:NSForegroundColorAttributeName
                       value:C6UIColorGray
                       range:NSMakeRange(0, 5)];
    [attTimeStr addAttribute:NSForegroundColorAttributeName
                       value:OrangeUIColorC4
                       range:NSMakeRange(5, timeStr.length-5)];
    UILabel * serviceTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 42*AUTO_SIZE_SCALE_X, kScreenWidth/2-10, 12*AUTO_SIZE_SCALE_X)];
    serviceTimeLabel.attributedText = attTimeStr;
    serviceTimeLabel.textAlignment = NSTextAlignmentRight;
    [serviceInfoView addSubview:serviceTimeLabel];
    
    if (isStore) {
        
    }else{
        UILabel * notStoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10*AUTO_SIZE_SCALE_X+servicePriceLabel.frame.origin.y+servicePriceLabel.frame.size.height, kScreenWidth-20, 13*AUTO_SIZE_SCALE_X)];
        notStoreLabel.text = @"[自营]华佗驾到";
        notStoreLabel.textColor = C6UIColorGray;
        notStoreLabel.font = [UIFont systemFontOfSize:13];
        [serviceInfoView addSubview:notStoreLabel];
    }
    
    [headView addSubview:serviceInfoView];
#pragma mark serviceCommentView
    if (isStore) {
        serviceCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceInfoView.frame.origin.y+serviceInfoView.frame.size.height+10, kScreenWidth, 160*AUTO_SIZE_SCALE_X)];
        //        serviceCommentView.userInteractionEnabled = YES;
        UIView * storeNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
        [serviceCommentView addSubview:storeNameView];
        storeNameView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * storeNameViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeNameViewTaped:)];
        //        storeNameView.userInteractionEnabled = YES;
        [storeNameView addGestureRecognizer:storeNameViewTap];
        
        UIImageView * phoneImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
        phoneImv.image = [UIImage imageNamed:@"icon_sd_tel"];
        [storeNameView addSubview:phoneImv];
        
        UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+phoneImv.frame.origin.x+phoneImv.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5)];
        phoneLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"storeName"]];
        phoneLabel.font = [UIFont systemFontOfSize:15];
        [storeNameView addSubview:phoneLabel];
        
        UIImageView * nextImv2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        nextImv2.image = [UIImage imageNamed:@"icon_sd_next"];
        [storeNameView addSubview:nextImv2];
        
        UIImageView * zhixian2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, phoneLabel.frame.origin.y+phoneLabel.frame.size.height-0.5, kScreenWidth-10, 0.5)];
        zhixian2.image = [UIImage imageNamed:@"icon_zhixian"];
        [storeNameView addSubview:zhixian2];
        
        UIView * storePlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, storeNameView.frame.origin.y+storeNameView.frame.size.height, kScreenWidth, 70*AUTO_SIZE_SCALE_X)];
        [serviceCommentView addSubview:storePlaceView];
        UITapGestureRecognizer * storePlaceViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storePlaceViewTaped:)];
        [storePlaceView addGestureRecognizer:storePlaceViewTap];
        
        UIImageView * addressImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        addressImv.image = [UIImage imageNamed:@"icon_sd_awayfrom"];
        [storePlaceView addSubview:addressImv];
        
        UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+addressImv.frame.origin.x+addressImv.frame.size.width, 0, 185*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X-0.5)];
        addressLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"storeAddress"]];
        addressLabel.font = [UIFont systemFontOfSize:15];
        addressLabel.numberOfLines = 0;
        [storePlaceView addSubview:addressLabel];
        
        UIImageView * nextImv3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        nextImv3.image = [UIImage imageNamed:@"icon_sd_next"];
        [storePlaceView addSubview:nextImv3];
        
        UILabel * distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-nextImv3.frame.size.width-10-60*AUTO_SIZE_SCALE_X, 0, 60*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X-0.5)];
//        distanceLabel.text = [NSString stringWithFormat:@"%@km",[dataDic objectForKey:@"distance"]];
        CGFloat dist = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"distance"]] floatValue];
        if (dist >= 1) {
            distanceLabel.text = [NSString stringWithFormat:@"%0.1fkm",dist];
        }else{
            int dista = dist*1000;
            distanceLabel.text = [NSString stringWithFormat:@"%dm",dista];
        }
        distanceLabel.textColor = C6UIColorGray;
        distanceLabel.textAlignment = NSTextAlignmentRight;
        distanceLabel.font = [UIFont systemFontOfSize:14];
        [storePlaceView addSubview:distanceLabel];
        
        UIImageView * zhixian3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, addressLabel.frame.origin.y+addressLabel.frame.size.height-0.5, kScreenWidth-10, 0.5)];
        zhixian3.image = [UIImage imageNamed:@"icon_zhixian"];
        [storePlaceView addSubview:zhixian3];
        
        UIView * storeCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, storePlaceView.frame.origin.y+storePlaceView.frame.size.height, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
        [serviceCommentView addSubview:storeCommentView];
        UITapGestureRecognizer * storeCommentViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeCommentViewTaped:)];
        [storeCommentView addGestureRecognizer:storeCommentViewTap];
        
        UIImageView * storeCommentImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
        storeCommentImv.image = [UIImage imageNamed:@"icon_sd_comment"];
        [storeCommentView addSubview:storeCommentImv];
        
        UILabel * commentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X+addressImv.frame.origin.x+addressImv.frame.size.width, 0, 90*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
        commentNameLabel.text = [NSString stringWithFormat:@"%@",@"用户评论"];
        commentNameLabel.font = [UIFont systemFontOfSize:15];
        commentNameLabel.numberOfLines = 0;
        [storeCommentView addSubview:commentNameLabel];
        
        UIImageView * nextImv4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        nextImv4.image = [UIImage imageNamed:@"icon_sd_next"];
        [storeCommentView addSubview:nextImv4];
        
        UILabel * commentnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-nextImv3.frame.size.width-10-130*AUTO_SIZE_SCALE_X, 0, 130*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
        if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentCount"]] isEqualToString:@"0"]) {
            commentnumLabel.text = [NSString stringWithFormat:@"暂无评论"];
            storeCommentView.userInteractionEnabled = NO;
        }else{
            commentnumLabel.text = [NSString stringWithFormat:@"%@评",[dataDic objectForKey:@"commentCount"]];
        }
        commentnumLabel.textColor = C6UIColorGray;
        commentnumLabel.textAlignment = NSTextAlignmentRight;
        commentnumLabel.font = [UIFont systemFontOfSize:14];
        [storeCommentView addSubview:commentnumLabel];
        
    }else{
        serviceCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceInfoView.frame.origin.y+serviceInfoView.frame.size.height+10, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        UIView * storeCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        [serviceCommentView addSubview:storeCommentView];
        UITapGestureRecognizer * storeCommentViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeCommentViewTaped:)];
        [storeCommentView addGestureRecognizer:storeCommentViewTap];
        
        UILabel * commentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5)];
        commentNameLabel.text = [NSString stringWithFormat:@"%@",@"用户评论"];
        commentNameLabel.font = [UIFont systemFontOfSize:15];
        commentNameLabel.numberOfLines = 0;
        [storeCommentView addSubview:commentNameLabel];
        
        UIImageView * nextImv4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        nextImv4.image = [UIImage imageNamed:@"icon_sd_next"];
        [storeCommentView addSubview:nextImv4];
        
        UILabel * commentnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-nextImv4.frame.size.width-10-130*AUTO_SIZE_SCALE_X, 0, 130*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X-0.5)];
        if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentCount"]] isEqualToString:@"0"]) {
            commentnumLabel.text = [NSString stringWithFormat:@"暂无评论"];
            serviceCommentView.userInteractionEnabled = NO;
        }else{
            commentnumLabel.text = [NSString stringWithFormat:@"%@评",[dataDic objectForKey:@"commentCount"]];
        }
        commentnumLabel.textColor = C6UIColorGray;
        commentnumLabel.textAlignment = NSTextAlignmentRight;
        commentnumLabel.font = [UIFont systemFontOfSize:14];
        [storeCommentView addSubview:commentnumLabel];
        
    }
    serviceCommentView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:serviceCommentView];
    
    
#pragma mark workerInfoView
    NDLog(@"name%@",[self.workerInfoDic objectForKey:@"name"]);
    NDLog(@"score%@",[NSString stringWithFormat:@"%@分",[self.workerInfoDic objectForKey:@"score"]]);
    NDLog(@"orderCount%@",[NSString stringWithFormat:@"接单数: %@",[self.workerInfoDic objectForKey:@"orderCount"]]);
    NDLog(@"commentCount%@",[NSString stringWithFormat:@"评论数: %@",[self.workerInfoDic objectForKey:@"commentCount"]]);
    
    if (haveWorker) {
        workerInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceCommentView.frame.origin.y+serviceCommentView.frame.size.height+10, kScreenWidth, 100*AUTO_SIZE_SCALE_X)];
        UITapGestureRecognizer * workerInfoViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workerInfoViewTaped:)];
        [workerInfoView addGestureRecognizer:workerInfoViewTap];
        
        UIImageView * touxiangImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15*AUTO_SIZE_SCALE_X , 65*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X)];
        [touxiangImv setImageWithURL:[NSURL URLWithString:[self.workerInfoDic objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        touxiangImv.layer.borderColor = C2UIColorGray.CGColor;
        touxiangImv.layer.borderWidth = 1.0;
        touxiangImv.layer.cornerRadius = 5.0;
        [workerInfoView addSubview:touxiangImv];
        
        UILabel * workerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(touxiangImv.frame.origin.x+touxiangImv.frame.size.width+10, 15*AUTO_SIZE_SCALE_X, 200*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        workerNameLabel.text = [NSString stringWithFormat:@"%@",[self.workerInfoDic objectForKey:@"name"]];
        workerNameLabel.font = [UIFont systemFontOfSize:16];
        [workerInfoView addSubview:workerNameLabel];
        
        //        int s = [[NSString stringWithFormat:@"%@分",[self.workerInfoDic objectForKey:@"score"]] ];
        
        
        startView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10+10*AUTO_SIZE_SCALE_X+66*AUTO_SIZE_SCALE_X, (15+16+10)*AUTO_SIZE_SCALE_X, 106*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X) numberOfStars:5];
        startView.backgroundColor =[UIColor clearColor];
        
        startView.allowIncompleteStar = YES;
        startView.hasAnimation = YES;
        [workerInfoView addSubview:startView];
        startView.scorePercent = [[self.workerInfoDic objectForKey:@"score"] floatValue]/5.0f;
        
        UILabel * scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(200*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        scoreLabel.text = [NSString stringWithFormat:@"%@分",[self.workerInfoDic objectForKey:@"score"]];
        scoreLabel.textColor = C6UIColorGray;
        scoreLabel.font = [UIFont systemFontOfSize:13];
        [workerInfoView addSubview:scoreLabel];
        
        UIImageView * nextImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-10*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        nextImv.image = [UIImage imageNamed:@"icon_sd_next"];
        [workerInfoView addSubview:nextImv];
        
        UILabel * ordernumLabel = [[UILabel alloc] initWithFrame:CGRectMake(touxiangImv.frame.origin.x+touxiangImv.frame.size.width+10, 70*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
        ordernumLabel.text = [NSString stringWithFormat:@"接单数: %@",[self.workerInfoDic objectForKey:@"orderCount"]];
        ordernumLabel.textColor = C6UIColorGray;
        ordernumLabel.font = [UIFont systemFontOfSize:13];
        CGSize ordernumLabelSize = [ordernumLabel intrinsicContentSize];
        ordernumLabel.frame = CGRectMake(touxiangImv.frame.origin.x+touxiangImv.frame.size.width+10, 70*AUTO_SIZE_SCALE_X, ordernumLabelSize.width, 13*AUTO_SIZE_SCALE_X);
        [workerInfoView addSubview:ordernumLabel];
        
        UILabel * commentnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ordernumLabel.frame.origin.x+ordernumLabel.frame.size.width+12*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
        commentnumLabel.text = [NSString stringWithFormat:@"评论数: %@",[self.workerInfoDic objectForKey:@"commentCount"]];
        commentnumLabel.textColor = C6UIColorGray;
        commentnumLabel.font = [UIFont systemFontOfSize:13];
        CGSize commentnumLabelSize = [commentnumLabel intrinsicContentSize];
        commentnumLabel.frame = CGRectMake(ordernumLabel.frame.origin.x+ordernumLabel.frame.size.width+12*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, commentnumLabelSize.width, 13*AUTO_SIZE_SCALE_X);
        [workerInfoView addSubview:commentnumLabel];
        
    }else
    {
        workerInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceCommentView.frame.origin.y+serviceCommentView.frame.size.height, 0, 0)];
    }
    workerInfoView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:workerInfoView];
    
#pragma mark serviceIntrodutionView
    serviceIntrodutionView = [[UIView alloc] init];
    serviceIntrodutionView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:serviceIntrodutionView];
    
    
    
    
    //    UILabel * introductionLabel = [[UILabel alloc] init];
    //    //    introductionLabel.text = [dataDic objectForKey:@"introduction"];
    //    introductionLabel.textColor = C6UIColorGray;
    //    introductionLabel.font = [UIFont systemFontOfSize:14];
    //    introductionLabel.numberOfLines = 0;
    //    introductionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    CGSize size = CGSizeMake(kScreenWidth-10*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,2000);
    //    //    CGSize labelsize = [[dataDic objectForKey:@"introduction"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //    //    introductionLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X,serviceIntrodutionImv.frame.origin.y+serviceIntrodutionImv.frame.size.height+12*AUTO_SIZE_SCALE_X, labelsize.width, labelsize.height);
    //    [serviceIntrodutionView addSubview:introductionLabel];
    if (introductionArray.count>0) {
        UILabel * serviceIntrodutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*AUTO_SIZE_SCALE_X, 0, 100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X)];
        serviceIntrodutionLabel.text = @"服务介绍";
        serviceIntrodutionLabel.textColor = [UIColor blackColor];
        serviceIntrodutionLabel.font = [UIFont systemFontOfSize:14];
        [serviceIntrodutionView addSubview:serviceIntrodutionLabel];
        UIImageView * serviceIntrodutionImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, serviceIntrodutionLabel.frame.origin.y+serviceIntrodutionLabel.frame.size.height, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
        serviceIntrodutionImv.image = [UIImage imageNamed:@"icon_zhixian"];
        [serviceIntrodutionView addSubview:serviceIntrodutionImv];
        
        int i = 0;
        CGFloat height = 35*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X;
        for (NSDictionary * dic in introductionArray) {
            //            NSLog(@"dic objectForKey:content %@",[dic objectForKey:@"content"]);
            
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = @"· ";
            label1.textColor = C6UIColorGray;
            label1.font = [UIFont systemFontOfSize:12];
            CGSize labelSize1 = [label1 intrinsicContentSize];
            label1.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, height, labelSize1.width, 12*AUTO_SIZE_SCALE_X);
            [serviceIntrodutionView addSubview:label1];

            UILabel * label2 = [[UILabel alloc] init];
            label2.text = [NSString stringWithFormat:@"%@:",[dic objectForKey:@"tag"]];
            label2.textColor = C6UIColorGray;
            label2.font = [UIFont systemFontOfSize:12];
            CGSize labelSize2 = [label2 intrinsicContentSize];
            label2.frame = CGRectMake(label1.frame.origin.x+label1.frame.size.width, height, labelSize2.width, 12*AUTO_SIZE_SCALE_X);
            [serviceIntrodutionView addSubview:label2];
            
            CGSize contentSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X-labelSize1.width, 2000);
            UILabel * contentLabel = [[UILabel alloc] init];
            contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textColor = C6UIColorGray;
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize contentLabelSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
            contentLabel.frame = CGRectMake(label1.frame.origin.x+label1.frame.size.width, height+15*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X-labelSize1.width, contentLabelSize.height);
            
            [serviceIntrodutionView addSubview:contentLabel];
            
//            CGSize contentSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X, 2000);
//            UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, height, kScreenWidth-20*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X)];
//            contentLabel.text = [NSString stringWithFormat:@"· %@、%@",[dic objectForKey:@"tag"],[dic objectForKey:@"content"]];
//            contentLabel.font = [UIFont systemFontOfSize:12];
//            contentLabel.textColor = C6UIColorGray;
//            contentLabel.numberOfLines = 0;
//            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            CGSize contentLabelSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
//            contentLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, height, kScreenWidth-20, contentLabelSize.height);
//            
//            [serviceIntrodutionView addSubview:contentLabel];
            i++;
            height = height + contentLabel.frame.size.height+20*AUTO_SIZE_SCALE_X;
        }
        
        serviceIntrodutionView.frame = CGRectMake(0, workerInfoView.frame.origin.y+workerInfoView.frame.size.height+10, kScreenWidth, height);
        
        
    }
    else{
        serviceIntrodutionView.frame = CGRectMake(0, workerInfoView.frame.origin.y+workerInfoView.frame.size.height, kScreenWidth, 0*AUTO_SIZE_SCALE_X);
    }
    
    
#pragma mark servicePositionView
    servicePositionView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceIntrodutionView.frame.origin.y+serviceIntrodutionView.frame.size.height+10, kScreenWidth, 0)];
    servicePositionView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:servicePositionView];
    
    UILabel * servicePositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*AUTO_SIZE_SCALE_X, 0, 100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X)];
    servicePositionLabel.text = @"针对部位";
    servicePositionLabel.textColor = [UIColor blackColor];
    servicePositionLabel.font = [UIFont systemFontOfSize:14];
    [servicePositionView addSubview:servicePositionLabel];
    
    UIImageView * servicePositionImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, servicePositionLabel.frame.origin.y+servicePositionLabel.frame.size.height, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    servicePositionImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [servicePositionView addSubview:servicePositionImv];
    
    UILabel * servicePositionInfoLabel1 = [[UILabel alloc] init];
    servicePositionInfoLabel1.text = @"· ";
    servicePositionInfoLabel1.font = [UIFont systemFontOfSize:12];
    servicePositionInfoLabel1.textColor = C6UIColorGray;
    CGSize servicePositionInfoLabelSize1 = [servicePositionInfoLabel1 intrinsicContentSize];
    servicePositionInfoLabel1.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, servicePositionImv.frame.origin.y+servicePositionImv.frame.size.height, servicePositionInfoLabelSize1.width, 34*AUTO_SIZE_SCALE_X);
    [servicePositionView addSubview:servicePositionInfoLabel1];

    UILabel * servicePositionInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, servicePositionImv.frame.origin.y+servicePositionImv.frame.size.height, kScreenWidth-20*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    servicePositionInfoLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"forBodyPart"]];
    CGSize contentSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X-servicePositionInfoLabelSize1.width, 2000);
    servicePositionInfoLabel.font = [UIFont systemFontOfSize:12];
    servicePositionInfoLabel.textColor = C6UIColorGray;
    servicePositionInfoLabel.numberOfLines = 0;
    servicePositionInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize contentLabelSize = [servicePositionInfoLabel.text sizeWithFont:servicePositionInfoLabel.font constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
    servicePositionInfoLabel.frame = CGRectMake(servicePositionInfoLabel1.frame.origin.x+servicePositionInfoLabel1.frame.size.width, 10*AUTO_SIZE_SCALE_X+servicePositionInfoLabel.frame.origin.y, kScreenWidth-20*AUTO_SIZE_SCALE_X-servicePositionInfoLabelSize1.width, contentLabelSize.height);
    [servicePositionView addSubview:servicePositionInfoLabel];
    servicePositionView.frame = CGRectMake(0,serviceIntrodutionView.frame.origin.y+serviceIntrodutionView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, servicePositionInfoLabel.frame.origin.y+servicePositionInfoLabel.frame.size.height+10*AUTO_SIZE_SCALE_X);
    
    
#pragma mark serviceSymptomView
    serviceSymptomView = [[UIView alloc] initWithFrame:CGRectMake(0, servicePositionView.frame.origin.y+servicePositionView.frame.size.height+10, kScreenWidth, 0)];
    serviceSymptomView.backgroundColor = [UIColor  whiteColor];
    [headView addSubview:serviceSymptomView];
    
    UILabel * serviceSymptomLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*AUTO_SIZE_SCALE_X, 0, 100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X)];
    serviceSymptomLabel.text = @"适应症状";
    serviceSymptomLabel.textColor = [UIColor blackColor];
    serviceSymptomLabel.font = [UIFont systemFontOfSize:14];
    [serviceSymptomView addSubview:serviceSymptomLabel];
    
    UIImageView * serviceSymptomImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, serviceSymptomLabel.frame.origin.y+serviceSymptomLabel.frame.size.height, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    serviceSymptomImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [serviceSymptomView addSubview:serviceSymptomImv];
    
    UILabel * serviceSymptomInfoLabel1 = [[UILabel alloc] init];
    serviceSymptomInfoLabel1.text = @"· ";
    serviceSymptomInfoLabel1.font = [UIFont systemFontOfSize:12];
    serviceSymptomInfoLabel1.textColor = C6UIColorGray;
    CGSize serviceSymptomInfoLabelSize1 = [serviceSymptomInfoLabel1 intrinsicContentSize];
    serviceSymptomInfoLabel1.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, servicePositionImv.frame.origin.y+servicePositionImv.frame.size.height, serviceSymptomInfoLabelSize1.width, 34*AUTO_SIZE_SCALE_X);
    [serviceSymptomView addSubview:serviceSymptomInfoLabel1];

    NSLog(@"forSymptom %@",[dataDic objectForKey:@"forSymptom"]);
    
    UILabel * serviceSymptomInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, serviceSymptomImv.frame.origin.y+serviceSymptomImv.frame.size.height, kScreenWidth-20*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    serviceSymptomInfoLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"forSymptom"]];
    CGSize forSymptomSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X-serviceSymptomInfoLabelSize1.width, 2000);
    serviceSymptomInfoLabel.font = [UIFont systemFontOfSize:12];
    serviceSymptomInfoLabel.textColor = C6UIColorGray;
    serviceSymptomInfoLabel.numberOfLines = 0;
    serviceSymptomInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize serviceSymptomInfoLabelSize = [serviceSymptomInfoLabel.text sizeWithFont:serviceSymptomInfoLabel.font constrainedToSize:forSymptomSize lineBreakMode:NSLineBreakByWordWrapping];
    serviceSymptomInfoLabel.frame = CGRectMake(serviceSymptomInfoLabel1.frame.origin.x + serviceSymptomInfoLabel1.frame.size.width, 10*AUTO_SIZE_SCALE_X+serviceSymptomInfoLabel.frame.origin.y, kScreenWidth-20*AUTO_SIZE_SCALE_X-serviceSymptomInfoLabelSize1.width, serviceSymptomInfoLabelSize.height);
    [serviceSymptomView addSubview:serviceSymptomInfoLabel];
    serviceSymptomView.frame = CGRectMake(0,servicePositionView.frame.origin.y+servicePositionView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, serviceSymptomInfoLabel.frame.origin.y+serviceSymptomInfoLabel.frame.size.height+10*AUTO_SIZE_SCALE_X);
    
    
#pragma mark serviceNoticeView
    serviceNoticeView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceSymptomView.frame.origin.y+serviceSymptomView.frame.size.height+10, kScreenWidth, 0)];
    serviceNoticeView.backgroundColor = [UIColor  whiteColor];
    [headView addSubview:serviceNoticeView];
    
    if (reminderArray.count>0) {
        UILabel * serviceIntrodutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*AUTO_SIZE_SCALE_X, 0, 100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X)];
        serviceIntrodutionLabel.text = @"服务须知";
        serviceIntrodutionLabel.textColor = [UIColor blackColor];
        serviceIntrodutionLabel.font = [UIFont systemFontOfSize:14];
        [serviceNoticeView addSubview:serviceIntrodutionLabel];
        UIImageView * serviceIntrodutionImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, serviceIntrodutionLabel.frame.origin.y+serviceIntrodutionLabel.frame.size.height, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
        serviceIntrodutionImv.image = [UIImage imageNamed:@"icon_zhixian"];
        [serviceNoticeView addSubview:serviceIntrodutionImv];
        
        int i = 0;
        CGFloat height = 35*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X;
        for (NSDictionary * dic in reminderArray) {
            //            NSLog(@"dic objectForKey:content %@",[dic objectForKey:@"content"]);
            
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = @"· ";
            label1.textColor = C6UIColorGray;
            label1.font = [UIFont systemFontOfSize:12];
            CGSize labelSize1 = [label1 intrinsicContentSize];
            label1.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, height, labelSize1.width, 12*AUTO_SIZE_SCALE_X);
            [serviceNoticeView addSubview:label1];
            
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = [NSString stringWithFormat:@"%@:",[dic objectForKey:@"tag"]];
            label2.textColor = C6UIColorGray;
            label2.font = [UIFont systemFontOfSize:12];
            CGSize labelSize2 = [label2 intrinsicContentSize];
            label2.frame = CGRectMake(label1.frame.origin.x+label1.frame.size.width, height, labelSize2.width, 12*AUTO_SIZE_SCALE_X);
            [serviceNoticeView addSubview:label2];
            
            CGSize contentSize = CGSizeMake(kScreenWidth-20*AUTO_SIZE_SCALE_X-labelSize1.width, 2000);
            UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, height, kScreenWidth-20*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X)];
            contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textColor = C6UIColorGray;
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize contentLabelSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
            contentLabel.frame = CGRectMake(label1.frame.origin.x+label1.frame.size.width, height+15*AUTO_SIZE_SCALE_X, kScreenWidth-20*AUTO_SIZE_SCALE_X-labelSize1.width, contentLabelSize.height);
            
            [serviceNoticeView addSubview:contentLabel];
            i++;
            height = height + contentLabel.frame.size.height+20*AUTO_SIZE_SCALE_X;
        }
        
        serviceNoticeView.frame = CGRectMake(0, serviceSymptomView.frame.origin.y+serviceSymptomView.frame.size.height+20, kScreenWidth, height);
        
        
    }
    else{
        serviceNoticeView.frame = CGRectMake(0, serviceSymptomView.frame.origin.y+serviceSymptomView.frame.size.height, kScreenWidth, 0*AUTO_SIZE_SCALE_X);
    }
    
    
#pragma mark headView.frame&&headerView.frame
    headView.frame = CGRectMake(0, cycle.frame.origin.y+cycle.frame.size.height, kScreenWidth,serviceNoticeView.frame.origin.y+serviceNoticeView.frame.size.height );
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headView.frame.origin.y+headView.frame.size.height+10);
    
}


-(void)inittableView
{
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * zhixian = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    zhixian.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:zhixian];
    
    yuyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yuyueBtn.frame = CGRectMake(10, 5, kScreenWidth-20, 50*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X);
    [yuyueBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    //    [yuyueBtn setBackgroundColor:[UIColor redColor]];
    [yuyueBtn setTitle:@"预约" forState:UIControlStateNormal];
    [yuyueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yuyueBtn addTarget:self action:@selector(yuyueBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:yuyueBtn];
    
    [self.view addSubview:btnView];
    
    //加载数据后判断，如果技师数组为空，style:UITableViewStyleGrouped;技师数组不为空，style:UITableViewStylePlain
    //   myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStyleGrouped];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-btnView.frame.size.height)style:UITableViewStylePlain];
    [myTableView setTableHeaderView:headerView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    //    myTableView.rowHeight = 300;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    
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
    [self.view  addSubview:favoritesBtn];
    
    bgYuan1.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    sharesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharesBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5), 22*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X, 44);
    [sharesBtn setImage:[UIImage imageNamed:@"icon_sd_share"] forState:UIControlStateNormal];
    [sharesBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sharesBtn setBackgroundColor:[UIColor clearColor]];
    [self.view  addSubview:sharesBtn];
    bgYuan2.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5) , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    
    backsBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backsBtn.frame = CGRectMake(0, 22*AUTO_SIZE_SCALE_X,35*AUTO_SIZE_SCALE_X, 44);
    [backsBtn setImage:[UIImage imageNamed:@"icon_sd_back"] forState:UIControlStateNormal];
    [backsBtn addTarget:self action:@selector(backsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backsBtn setBackgroundColor:[UIColor clearColor]];
    [self.view  addSubview:backsBtn];
    bgYuan3.frame = CGRectMake(5 , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
}

//#pragma mark WebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSString  *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//    float webViewheight = [htmlHeight floatValue];
//    //    NSLog(@"webViewheight==%f",webViewheight);
//    webView.frame = CGRectMake(0, webView.frame.origin.y, self.view.frame.size.width, webViewheight);
//
//    servicePositionView.frame = CGRectMake(0, serviceIntrodutionView.frame.origin.y+serviceIntrodutionView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, webView.frame.origin.y+webView.frame.size.height);
//}

#pragma mark 所有手势
-(void)storeNameViewTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_STOREDETAIL];
    NSLog(@"拨打电话");
    NSString * tel =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"storeTel"]];
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
-(void)storePlaceViewTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_ADRESS];
    NSLog(@"导航");
    RoutePlanViewController *vc = [[RoutePlanViewController alloc]init];
    vc.latitude = [[dataDic objectForKey:@"latitude"]doubleValue];
    vc.longitude = [[dataDic objectForKey:@"longitude"]doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)storeCommentViewTaped:(UITapGestureRecognizer *)sender
{
    if (!isStore) {
        [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_COMMENT];
    }else if (isStore) {
        [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_COMMENT];
    }
    NDLog(@"onClickView---serviceID--------tag-->%@",self.serviceID);
    clientCommentListViewController *vc = [[clientCommentListViewController alloc] init];
    vc.ID = self.serviceID;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)workerInfoViewTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_TICHNICIANDETAIL];
    //    NSLog(@"返回");
    //    [self.navigationController popViewControllerAnimated:YES];
    //1是上门的
    if ([self.serviceType isEqualToString:@"1"]) {
        TechnicianMyselfViewController * vc = [[TechnicianMyselfViewController alloc] init];
        vc.workerID = [self.workerInfoDic objectForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //0是到店的
    if ([self.serviceType isEqualToString:@"0"]){
        technicianViewController * vc = [[technicianViewController alloc] init];
        vc.flag = @"0";
        vc.workerID = [self.workerInfoDic objectForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark TableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*AUTO_SIZE_SCALE_X;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

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
    return 300;
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
    cell.backgroundColor = C2UIColorGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag != 100001) {
        cycle.center = CGPointMake(kScreenWidth/2, (240*AUTO_SIZE_SCALE_X+scrollView.contentOffset.y)/2);
        self.navView.alpha = scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X);
        
        CGFloat xx = 0.0; //0-1
        xx = (scrollView.contentOffset.y-240*AUTO_SIZE_SCALE_X+kNavHeight)/(headerView.frame.size.height-240*AUTO_SIZE_SCALE_X);
        //        NSLog(@"xx --  %f",xx);
        
        if ( 0< xx && xx<=1 ) {
            //            NSLog(@"xx1 --  %f",xx);
            myTableView.frame = CGRectMake(0, kNavHeight*(xx) , kScreenWidth, kScreenHeight-kNavHeight*(xx)-btnView.frame.size.height );
        }
        else if (xx <= 0)
        {
            myTableView.frame = CGRectMake(0, 0 , kScreenWidth, kScreenHeight-btnView.frame.size.height  );
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
    
    //            NSLog(@"(scrollView.contentOffset.y-240.0*AUTO_SIZE_SCALE_X)/(headerView.frame.size.height-240*AUTO_SIZE_SCALE_X-kNavHeight) %f",(scrollView.contentOffset.y-240.0*AUTO_SIZE_SCALE_X)/(headerView.frame.size.height-240*AUTO_SIZE_SCALE_X-kNavHeight));
    //            NSLog(@"(scrollView.contentOffset.y-240.0*AUTO_SIZE_SCALE_X)  %f",(scrollView.contentOffset.y-240.0*AUTO_SIZE_SCALE_X) );
    //            NSLog(@"(headerView.frame.size.height-240*AUTO_SIZE_SCALE_X-kNavHeight) %f", (headerView.frame.size.height-240*AUTO_SIZE_SCALE_X-kNavHeight));
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
