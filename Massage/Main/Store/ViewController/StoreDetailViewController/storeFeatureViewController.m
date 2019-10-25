//
//  storeFeatureViewController.m
//  Massage
//
//  Created by htjd_IOS on 16/1/12.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "storeFeatureViewController.h"
#import "noWifiView.h"
@interface storeFeatureViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UITableView * myTableView;
    UIWebView * serviceFeatureWebView;
    
    UIImageView * bgYuan1;
    UIButton * backsBtn;
    
    noWifiView * failView;
}
@end

@implementation storeFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"门店特色";
    [self showHudInView:self.view hint:@"正在加载"];
    
    myTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    serviceFeatureWebView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    serviceFeatureWebView.delegate = self;
    [serviceFeatureWebView loadHTMLString:self.storeFeature baseURL:nil];
    
    bgYuan1 = [[UIImageView alloc] init];
    bgYuan1.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan1.alpha = 0.5;
    bgYuan1.frame = CGRectMake(5 , 22*AUTO_SIZE_SCALE_X+(44-28*AUTO_SIZE_SCALE_X)/2, 28*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    
    backsBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backsBtn.frame = CGRectMake(0, 22*AUTO_SIZE_SCALE_X,35*AUTO_SIZE_SCALE_X, 44);
    [backsBtn setImage:[UIImage imageNamed:@"icon_sd_back"] forState:UIControlStateNormal];
    [backsBtn addTarget:self action:@selector(backsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backsBtn setBackgroundColor:[UIColor clearColor]];
    
    //数据加载失败
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)reloadButtonClick:(UIButton *)sender {
    [self showHudInView:self.view hint:@"正在加载"];
    [serviceFeatureWebView loadHTMLString:self.storeFeature baseURL:nil];
}

-(void)backsBtnPressed:(UIButton *)sender
{
    [self hideHud];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    [failView removeFromSuperview];
    
    NSString  *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    float webViewheight = [htmlHeight floatValue];

    webView.frame = CGRectMake(0, webView.frame.origin.y, self.view.frame.size.width, webViewheight);
    
//    self.navView.hidden = YES;
    self.navView.alpha = 0;
    [self.view addSubview:myTableView];
    [webView addSubview:bgYuan1];
    [webView addSubview:backsBtn];
    [webView sizeToFit];
    [myTableView setTableHeaderView:webView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view addSubview:failView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.tag != 100001) {
        if (scrollView.contentOffset.y>=0) {
            [self.view bringSubviewToFront:self.navView];
            self.navView.alpha = scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X);
        }
    
        if (scrollView.contentOffset.y <= 0)
        {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            scrollView.contentOffset = offset;
        }
        
//    }
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
    return nil;
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
