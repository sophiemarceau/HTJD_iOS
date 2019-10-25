//
//  LoveHealthyViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/14.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "LoveHealthyViewController.h"
#import "BaseTableView.h"
#import "publicTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "WorkerFoundViewController.h"
#import "StoreFoundViewController.h"
#import "ServiceFoundViewController.h"
#import "DetailFoundViewController.h"

#import "noWifiView.h"

@interface LoveHealthyViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>
{
    BaseTableView * myTableView;
    noWifiView * failView;
    NSMutableArray * discoverListArray;
    
//    UIActivityIndicatorView *activityIndicator;
    
    int _pageForHot;
}
@end

@implementation LoveHealthyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"发现";
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = C2UIColorGray;
    
//    activityIndicator = [[UIActivityIndicatorView alloc]
//                         initWithActivityIndicatorStyle:
//                         UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicator.color = [UIColor blackColor];
//    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y);;
//    [activityIndicator startAnimating]; // 开始旋转
//    [self.view addSubview:activityIndicator];

    discoverListArray = [[NSMutableArray alloc] initWithCapacity:0 ];
    [self initTableView];
    
    [self loadData];
    [self showHudInView:self.view hint:@"正在加载"];

}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-49)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 225*AUTO_SIZE_SCALE_X+1;
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}
- (void)reloadButtonClick:(UIButton *)sender {
    [discoverListArray removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载"];
    [self loadData];
}
-(void)loadData
{
//    [myTableView removeFromSuperview];
//    [failView.activityIndicatorView startAnimating];
//    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSDictionary * dic = @{
                           @"cityCode":cityCode,
                           @"pageStart":@"1",
                           @"pageOffset":@"15",
                           };
    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        NDLog(@"发现首页数据 -- %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            [activityIndicator stopAnimating];
//            activityIndicator.hidden = YES;
            
//            failView.hidden = YES;
//            [failView.activityIndicatorView stopAnimating];
//            failView.activityIndicatorView.hidden = YES;
            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
            [discoverListArray addObjectsFromArray:array];
            [myTableView reloadData];
            if (array.count<15 || array.count == 0) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
//        [myTableView.foot finishRefreshing];
//        [myTableView.head finishRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
//        [failView.activityIndicatorView stopAnimating];
//        failView.activityIndicatorView.hidden = YES;
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
//    [failView.activityIndicatorView startAnimating];
//    failView.activityIndicatorView.hidden = NO;
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else{
        _pageForHot ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"15";
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSDictionary * dic = @{
                           @"cityCode":cityCode,
                           @"pageStart":page,
                           @"pageOffset":pageOffset,
                           };
    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            failView.hidden = YES;
//            [failView.activityIndicatorView stopAnimating];
//            failView.activityIndicatorView.hidden = YES;
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [discoverListArray removeAllObjects];
            }
            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
            [discoverListArray addObjectsFromArray:array];
            [myTableView reloadData];
            [refreshView endRefreshing];
            if (array.count<15 || array.count == 0) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
//        [myTableView.foot finishRefreshing];
//        [myTableView.head finishRefreshing];

//        failView.hidden = NO;
//        [failView.activityIndicatorView stopAnimating];
//        failView.activityIndicatorView.hidden = YES;
        [refreshView endRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
    }];

}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return discoverListArray.count;
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
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 225*AUTO_SIZE_SCALE_X)];
    [imgV setImageWithURL:[NSURL URLWithString:[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
    [cell addSubview:imgV];
    
    UIImageView * maskImv = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, kScreenWidth, 225*AUTO_SIZE_SCALE_X)];
    maskImv.image = [UIImage imageNamed:@"img_mask"];
    [imgV addSubview:maskImv];
    
//    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175*AUTO_SIZE_SCALE_X, 190*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
    CGSize maxInfoSize = CGSizeMake(190*AUTO_SIZE_SCALE_X, 200*AUTO_SIZE_SCALE_X);
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 175*AUTO_SIZE_SCALE_X, 190*AUTO_SIZE_SCALE_X, 36*AUTO_SIZE_SCALE_X)];
     infoLabel.text = [NSString stringWithFormat:@"%@",[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    infoLabel.textColor = [UIColor  whiteColor];
    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont systemFontOfSize:15];
    CGSize currentInfoLabelSize = [infoLabel.text sizeWithFont:infoLabel.font constrainedToSize:maxInfoSize lineBreakMode:NSLineBreakByWordWrapping];
    infoLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, (225-15)*AUTO_SIZE_SCALE_X-currentInfoLabelSize.height, 190*AUTO_SIZE_SCALE_X, currentInfoLabelSize.height);
//    [cell addSubview:infoLabel];
    [maskImv addSubview:infoLabel];
    
//    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-100*AUTO_SIZE_SCALE_X, 195*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15*AUTO_SIZE_SCALE_X-90*AUTO_SIZE_SCALE_X, (225-15)*AUTO_SIZE_SCALE_X-12 *AUTO_SIZE_SCALE_X, 90*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X)];
    timeLabel.text = [NSString stringWithFormat:@"%@发布",[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"publishDate"]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = UIColorFromFindRGB(0xffffff);
    //    timeLabel.numberOfLines = 0;
    timeLabel.font = [UIFont systemFontOfSize:11];
//    [cell addSubview:timeLabel];
    [maskImv addSubview:timeLabel];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:DISCOVER_DETAIL];
    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
    NSString * type = [NSString stringWithFormat:@"%@",[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    //0 门店 1服务 2 技师 3图文
    if ([type isEqualToString:@"3"]) {
        //发现详情页
        DetailFoundViewController * vc = [[DetailFoundViewController alloc] init];
        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:@"0"]) {
        //发现店铺详情页
        StoreFoundViewController * vc = [[StoreFoundViewController alloc] init];
        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:@"1"]) {
        //发现服务详情页
        ServiceFoundViewController * vc = [[ServiceFoundViewController alloc] init];
        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:@"2"]) {
        //发现技师详情页
        WorkerFoundViewController * vc = [[WorkerFoundViewController alloc] init];
        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
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
