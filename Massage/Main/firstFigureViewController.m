//
//  firstFigureViewController.m
//  Massage
//
//  Created by htjd_IOS on 16/1/7.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "firstFigureViewController.h"
#import "UIImageView+WebCache.h"
@interface firstFigureViewController ()

@end

@implementation firstFigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[RequestManager shareRequestManager] getfirstFigure:nil viewController:nil successData:^(NSDictionary *result) {
        NSLog(@"客户端首图result  %@",result);
//                            NSURL * url = [NSURL URLWithString:[result objectForKey:@"firstFigureUrl"]];
////                    NSURL * url = [NSURL URLWithString:  @"http://www.jerehedu.com/images/temp/logo.gif"];
//        
//                    SDWebImageDownloader * downloader = [SDWebImageDownloader sharedDownloader];
//                    [downloader downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:@"aaa"];
//                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
        
//                    }];

        
    } failuer:^(NSError *error) {
        NSLog(@"加载失败");
    }];

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
