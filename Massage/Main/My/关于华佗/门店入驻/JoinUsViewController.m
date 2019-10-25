//
//  JoinUsViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/30.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "JoinUsViewController.h"

@interface JoinUsViewController () <UIWebViewDelegate>

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"门店入驻";
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    [self showHudInView:webView hint:@"加载中"];
//    NSString *path = @"http://www.mikecrm.com/f.php?t=HmqkNZ";
    NSURL *url = [NSURL URLWithString:BURL(ApplyString)];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            //右侧的滚动条
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            
            //下侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            
            //上下滚动出边界时的黑色的图片
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;
                }
            }
        }
    }
    [self.view addSubview:webView];
    [webView sizeToFit];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideHud];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

@end
