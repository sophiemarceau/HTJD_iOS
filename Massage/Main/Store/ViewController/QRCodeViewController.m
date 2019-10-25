//
//  QRCodeViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "QRCodeViewController.h"
#import "StoreDetailViewController.h"
#import "ServiceDetailViewController.h"
#import "TechnicianMyselfViewController.h"
#import "technicianViewController.h"

#import "StoreActivityViewController.h"
#import "ServiceActivityViewController.h"
#import "WorkerActivityViewController.h"

#import "AppDelegate.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    NSDictionary * resultDic;
}
@end

@implementation QRCodeViewController
@synthesize isLightOn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"二维码";
    
    UIView * view1 = [[UIView alloc] init];
    view1.frame = CGRectMake(0, kNavHeight, self.view.frame.size.width,(100*AUTO_SIZE_SCALE_Y -kNavHeight+5));
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.5;
    [self.view addSubview:view1];


    
    UIView * view3 = [[UIView alloc] init ];
    view3.frame = CGRectMake(0 ,view1.frame.origin.y+view1.frame.size.height, 55*AUTO_SIZE_SCALE_X, 220*AUTO_SIZE_SCALE_X-10);
    view3.backgroundColor = [UIColor blackColor];
    view3.alpha = 0.5;
    [self.view addSubview:view3];
    
    UIView * view4 = [[UIView alloc] init ];
    view4.frame = CGRectMake(self.view.frame.size.width-55*AUTO_SIZE_SCALE_X , view1.frame.origin.y+view1.frame.size.height, 55*AUTO_SIZE_SCALE_X, 220*AUTO_SIZE_SCALE_X-10);
    view4.backgroundColor = [UIColor blackColor];
    view4.alpha = 0.5;
    [self.view addSubview:view4];
    
    UIView * view2 = [[UIView alloc] init];
    view2.frame = CGRectMake(0, view4.frame.origin.y+view4.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(view4.frame.origin.y+view4.frame.size.height));
    view2.backgroundColor = [UIColor blackColor];
    view2.alpha = 0.5;
    [self.view addSubview:view2];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, 85*AUTO_SIZE_SCALE_Y, self.view.frame.size.width, 13*AUTO_SIZE_SCALE_X)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    //    labIntroudction.numberOfLines=2;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"对准二维码/条形码到框内即可扫描";
    labIntroudction.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_Y, 220*AUTO_SIZE_SCALE_X, 220*AUTO_SIZE_SCALE_X)];
    imageView.image = [UIImage imageNamed:@"icon_code"];
    [self.view addSubview:imageView];
    
    UIButton *lightbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lightbtn setFrame:CGRectMake(130*AUTO_SIZE_SCALE_X,  imageView.frame.origin.y+imageView.frame.size.height+45*AUTO_SIZE_SCALE_Y, 65*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X)];
    //    [lightbtn setTitle:@"开关灯" forState:UIControlStateNormal];
    [lightbtn setBackgroundImage:[UIImage imageNamed:@"but_light_off"] forState:UIControlStateNormal];
    [lightbtn addTarget:self action:@selector(lightbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightbtn];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(60*AUTO_SIZE_SCALE_X, 110*AUTO_SIZE_SCALE_Y, 220*AUTO_SIZE_SCALE_X, 2)];
    _line.image = [UIImage imageNamed:@"greenline.png"];
    [self.view addSubview:_line];
    
    
    
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(60*AUTO_SIZE_SCALE_X, 110*AUTO_SIZE_SCALE_Y+2*num, 200*AUTO_SIZE_SCALE_X, 2);
        if (2*num >= 200*AUTO_SIZE_SCALE_Y-10) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(60*AUTO_SIZE_SCALE_X, 110*AUTO_SIZE_SCALE_Y+2*num, 200*AUTO_SIZE_SCALE_X, 2);
        if (num <= 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)backAction
{
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        [timer invalidate];
    //    }];
    [self.navigationController popViewControllerAnimated:YES];
    [timer invalidate];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self setupCamera];
    NSLog(@"启动照相机");
    self.navView.backgroundColor = [UIColor blackColor];
    self.navView.alpha = 0.5;
    
}
- (void)setupCamera
{
    [_preview removeFromSuperlayer];
//    upOrdown = NO;
//    num =0;
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    NSLog(@"初始化参数");
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (![_device hasTorch]) {//判断是否有闪光灯
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alter show];
    }
    
    isLightOn = NO;
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _preview.frame =CGRectMake(55,105,210,210);
    _preview.frame =CGRectMake(0,0 ,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
//    [ _output setRectOfInterest : CGRectMake ( 0.21f,0.17f,0.43f,0.65f )];
    
    [ _output setRectOfInterest : CGRectMake (( 100*AUTO_SIZE_SCALE_Y )/ kScreenHeight ,(( kScreenWidth - 220*AUTO_SIZE_SCALE_X-kNavHeight )/ 2 )/ kScreenWidth , 220*AUTO_SIZE_SCALE_X / kScreenHeight , 220*AUTO_SIZE_SCALE_X / kScreenWidth )];
    
    //    [self.view addSubview:bgView];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"stringValue %@",stringValue);
        
        NSData *jsonData = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        NSLog(@"err %@",err);
            NSLog(@"解析字典 dic %@",dic);
//        二维码样式  {"type":"store","id":"xxxxxxxxxxxxxx"}
        
        if (dic) {
            NSString * needID = [dic  objectForKey:@"id"];
            NSString * type = [dic objectForKey:@"type"];
            if ([type isEqualToString:@"store"]) {
                [_session stopRunning];
                [timer invalidate];
                [_preview removeFromSuperlayer];
                //门店详情接口
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                NSString * userID = [userDefaults objectForKey:@"userID"];
                NSString * longitude = [userDefaults objectForKey:@"longitude"];
                NSString * latitude = [userDefaults objectForKey:@"latitude"];
                if (!userID) {
                    userID = @"";
                }
                NSDictionary * dic = @{
                                       @"ID":needID,
                                       @"userID":userID,
                                       @"longitude":longitude,
                                       @"latitude":latitude,
                                       };
                NSLog(@"dic %@",dic);
                [[RequestManager shareRequestManager] getSysStoreDetail:dic viewController:self successData:^(NSDictionary *result) {
                    NDLog(@"门店详情--%@",result);
                    if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                        StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
                        vc.storeID = needID;
                        vc.backType = @"1";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                    else{
                        [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                        [_session stopRunning];
                        [timer invalidate];
                        
                        [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                    }
                } failuer:^(NSError *error) {
                    [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                    [_session stopRunning];
                    [timer invalidate];
                    
                    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                }];
                return;
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:@"您扫描的二维码不支持本软件" viewController:self];
                [_session stopRunning];
                [timer invalidate];
                
                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                return;

            }
        }
        
        //http://wechat.huatuojiadao.cn/weixin_user/html/wechat.html#shop-detail?id=1234567890
        //        1. 门店详情
        //#shop-detail?id=id
        //        2. 项目详情
        //#project-detail?id=id
        //        3. 门店技师 - 主题技师
        //#pt-detail?id=id
        //        4. 门店广告 - 主题门店
        //#shop-topic?id=id
        //        5. 项目广告 - 主题项目
        //#project-topic?id=id
        //        6. 技师广告 - 主题技师
        //#pt-topic?id=id
        
//        NSString *srcStr = @"http://wechat.huatuojiadao.cn/weixin_user/html/wechat.html#shop-detail?id=521fd3a9-ff07-42de-a113-d5b598662d5f";
        
        NSArray *strarray = [stringValue componentsSeparatedByString:@"#"];
        NSString * type = @"";
        NSString * needID = @"";
//        NSLog(@"%@",strarray[0]);
        if (strarray.count>1) {
            NSString *str1 = [strarray objectAtIndex:1];
            NSArray * finalstrArray = [str1 componentsSeparatedByString:@"?id="];
            if (finalstrArray.count>1){
                type = [finalstrArray objectAtIndex:0];
                needID = [finalstrArray objectAtIndex:1];
                NSLog(@"type  %@  needID  %@",type,needID);
            }else{
                [[RequestManager shareRequestManager] tipAlert:@"您扫描的二维码不支持本软件" viewController:self];
                [_session stopRunning];
                [timer invalidate];
                
                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
        }else{
            [[RequestManager shareRequestManager] tipAlert:@"您扫描的二维码不支持本软件" viewController:self];
            [_session stopRunning];
            [timer invalidate];
            
            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            return;
        }


        //门店
        if ([type isEqualToString:@"shop-detail"]) {
            [_session stopRunning];
            [timer invalidate];
            [_preview removeFromSuperlayer];
            //门店详情接口
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * userID = [userDefaults objectForKey:@"userID"];
            NSString * longitude = [userDefaults objectForKey:@"longitude"];
            NSString * latitude = [userDefaults objectForKey:@"latitude"];
            if (!userID) {
                userID = @"";
            }
            NSDictionary * dic = @{
                                   @"ID":needID,
                                   @"userID":userID,
                                   @"longitude":longitude,
                                   @"latitude":latitude,
                                   };
            NSLog(@"dic %@",dic);
            [[RequestManager shareRequestManager] getSysStoreDetail:dic viewController:self successData:^(NSDictionary *result) {
                NDLog(@"门店详情--%@",result);
                if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                    if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"state"]] isEqualToString:@"9"]) {
                        [[RequestManager shareRequestManager] tipAlert:@"该门店暂时无法为您服务" viewController:self];
                        [self performSelector:@selector(popVc) withObject:nil afterDelay:2.0];
                        return ;
                    }
                    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
                    vc.storeID = needID;
                    vc.backType = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                else{
                    [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                    [_session stopRunning];
                    [timer invalidate];
                    
                    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                }
            } failuer:^(NSError *error) {
                [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                [_session stopRunning];
                [timer invalidate];
                
                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }];
        }
        //项目
        else if ([type isEqualToString:@"project-detail"]){
            [_session stopRunning];
            [timer invalidate];
            [_preview removeFromSuperlayer];
            //项目详情接口
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * userID = [userDefaults objectForKey:@"userID"];
            NSString * longitude = [userDefaults objectForKey:@"longitude"];
            NSString * latitude = [userDefaults objectForKey:@"latitude"];
            if (!userID) {
                userID = @"";
            }
            NSDictionary * dic = @{
                                   @"ID":needID,
                                   @"userID":userID,
                                   @"longitude":longitude,
                                   @"latitude":latitude,
                                   @"skillWorkerID":@"",
                                   };
            [[RequestManager shareRequestManager] getSysServiceDetail:dic viewController:self successData:^(NSDictionary *result) {
                NDLog(@"项目详情result-->%@",result);
                if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                    resultDic = [NSDictionary dictionaryWithDictionary:result];
                    if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"state"]] isEqualToString:@"9"]) {
                        [[RequestManager shareRequestManager] tipAlert:@"项目已下线" viewController:self];
                        [self performSelector:@selector(serviceDownLine) withObject:nil afterDelay:2.0];
                        return ;
                    }

                    ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
                    vc.haveWorker = NO;
//                    vc.serviceType = serviceType;
                    if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
                        vc.isStore = YES;
                        vc.isSelfOwned = @"0";
                    }else if([[NSString stringWithFormat:@"%@",[result objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
                        vc.isStore = NO;
                        vc.isSelfOwned = @"1";
                    }
                    vc.serviceID = [NSString stringWithFormat:@"%@",[result objectForKey:@"ID"]];
                    vc.backType = @"1";
                    [self.navigationController pushViewController:vc animated:YES];

                }
                else{
                    [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                    [_session stopRunning];
                    [timer invalidate];
                    
                    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                }
                
                
            } failuer:^(NSError *error) {
                [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                [_session stopRunning];
                [timer invalidate];
                
                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }];

        }
        //技师
        else if ([type isEqualToString:@"pt-detail"]){
            [_session stopRunning];
            [timer invalidate];
            [_preview removeFromSuperlayer];
            //技师详情接口
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * userID = [userDefaults objectForKey:@"userID"];
            NSString * longitude = [userDefaults objectForKey:@"longitude"];
            NSString * latitude = [userDefaults objectForKey:@"latitude"];
            if (!userID) {
                userID = @"";
            }
            NSDictionary * dic = @{
                                   @"ID":needID,
                                   @"userID":userID,
                                   @"longitude":longitude,
                                   @"latitude":latitude,
                                   };
            [[RequestManager shareRequestManager] getSysSkillDetailInfo:dic viewController:self successData:^(NSDictionary *result) {
                NDLog(@" %@",result);
                if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                    resultDic = [NSDictionary dictionaryWithDictionary:result];

                    if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"state"]] isEqualToString:@"9"]) {
                        [[RequestManager shareRequestManager] tipAlert:@"技师已下线" viewController:self];
                        [self performSelector:@selector(workerDownLine) withObject:nil afterDelay:2.0];
                        return ;
                    }
                    
                    if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isSelfOwned"] ] isEqualToString:@"1"]) {
                        TechnicianMyselfViewController * vc = [[TechnicianMyselfViewController alloc] init];
                        vc.workerID = needID;
                        vc.backType = @"1";
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        technicianViewController *VC =[[technicianViewController alloc] init];
                        VC.flag = @"0";
                        VC.workerID = needID;
                        VC.backType = @"1";
                        [self.navigationController pushViewController:VC animated:YES];

                    }
                }
                else{
                    [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                    [_session stopRunning];
                    [timer invalidate];
                    
                    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                }
                
            } failuer:^(NSError *error) {
                [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                [_session stopRunning];
                [timer invalidate];
                
                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }];

        }
        //门店广告
        else if ([type isEqualToString:@"shop-topic"]){
            [_session stopRunning];
            [timer invalidate];
            [_preview removeFromSuperlayer];
            //门店广告接口
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * longitude = [userDefaults objectForKey:@"longitude"];
            NSString * latitude = [userDefaults objectForKey:@"latitude"];
             NSDictionary * dic = @{
                                   @"ID":needID,
                                   @"latitude":latitude,
                                   @"longitude":longitude,
                                   @"pageStart":@"1",
                                   @"pageOffset":@"1",
                                   @"orderBy":@"1",
                                   };
            NSLog(@"dic --%@",dic);
            [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
                NSLog(@"msg--%@",[result objectForKey:@"msg"]);
                if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                    StoreActivityViewController * vc = [[StoreActivityViewController alloc] init];
                    vc.ID = needID;
                    vc.name = [result objectForKey:@"adName"];
                    vc.backType = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }     else{
                    [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                    [_session stopRunning];
                    [timer invalidate];
                    
                    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                }
            } failuer:^(NSError *error) {
                [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                [_session stopRunning];
                [timer invalidate];
                
                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }];

        }
        //项目广告
        else if ([type isEqualToString:@"project-topic"]){
            [_session stopRunning];
            [timer invalidate];
            [_preview removeFromSuperlayer];
            //项目广告接口
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * longitude = [userDefaults objectForKey:@"longitude"];
            NSString * latitude = [userDefaults objectForKey:@"latitude"];
            NSDictionary * dic = @{
                                   @"ID":needID,
                                   @"latitude":latitude,
                                   @"longitude":longitude,
                                   @"pageStart":@"1",
                                   @"pageOffset":@"1",
                                   @"orderBy":@"1",
                                   };
            NSLog(@"dic --%@",dic);
            [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
                NSLog(@"msg--%@",[result objectForKey:@"msg"]);
                 if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                     ServiceActivityViewController * vc = [[ServiceActivityViewController alloc] init];
                     vc.ID = needID;
                     vc.name = [result objectForKey:@"adName"];
                     vc.backType = @"1";
                     [self.navigationController pushViewController:vc animated:YES];
                    
                 }     else{
                     [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                     [_session stopRunning];
                     [timer invalidate];
                     
                     [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                 }
             } failuer:^(NSError *error) {
                 [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                 [_session stopRunning];
                 [timer invalidate];
                 
                 [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }];

        }
        //技师广告
        else if ([type isEqualToString:@"pt-topic"]){
            [_session stopRunning];
            [timer invalidate];
            [_preview removeFromSuperlayer];
            //技师广告接口
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * longitude = [userDefaults objectForKey:@"longitude"];
            NSString * latitude = [userDefaults objectForKey:@"latitude"];
            NSDictionary * dic = @{
                                   @"ID":needID,
                                   @"latitude":latitude,
                                   @"longitude":longitude,
                                   @"pageStart":@"1",
                                   @"pageOffset":@"1",
                                   @"orderBy":@"1",
                                   };
            NSLog(@"dic --%@",dic);
            [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
                NSLog(@"msg--%@",[result objectForKey:@"msg"]);
                if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                    WorkerActivityViewController * vc = [[WorkerActivityViewController alloc] init];
                    vc.ID = needID;
                    vc.name = [result objectForKey:@"adName"];
                    vc.backType = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                }     else{
                    [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                    [_session stopRunning];
                    [timer invalidate];
                    
                    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
                }
             } failuer:^(NSError *error) {
                 [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
                 [_session stopRunning];
                 [timer invalidate];
                 
                 [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }];

        }
        else{
            NSLog(@"您扫描的二维码不支持本软件使用");
            [[RequestManager shareRequestManager] tipAlert:@"您扫描的二维码不支持本软件使用,请尝试扫描其他二维码" viewController:self];
            [_session stopRunning];
            [timer invalidate];
            
            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            
            //            [self setupCamera];
            
        }
        
    }
    
    
    
}

#pragma mark 回到上一级界面
-(void)popVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  项目下线
-(void)serviceDownLine
{
    //门店 跳转到门店详情，如果门店也下线，跳转到到店首页
    if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
        if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"storeState"]] isEqualToString:@"9"]) {
            [self popVc];
        }
        else{
            StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
            vc.storeID = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"storeID"]];
            vc.backType = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    //上门 跳转到上门首页
    else if([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
        UIButton *tempbutton =[[UIButton alloc]init];
        tempbutton.tag =1;
        [mainVC selectorAction:tempbutton];

    }
}

#pragma mark  技师下线
-(void)workerDownLine
{
    //门店 跳转到门店详情，如果门店也下线，跳转到到店首页
    if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
        if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"storeState"]] isEqualToString:@"9"]) {
            [self popVc];
        }
        else{
            StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
            vc.storeID = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"storeID"]];
            vc.backType = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    //上门 跳转到上门首页
    else if([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainViewController  *mainVC= (MainViewController *)   appDelegate.mainController ;
        UIButton *tempbutton =[[UIButton alloc]init];
        tempbutton.tag =1;
        [mainVC selectorAction:tempbutton];

    }
}

#pragma mark 手电筒
-(void)lightbtnClicked:(UIButton *)sender
{
    isLightOn = 1-isLightOn;
    if (isLightOn) {
        [self turnOnLed:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"but_light_on"] forState:UIControlStateNormal];
    }else{
        [self turnOffLed:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"but_light_off"] forState:UIControlStateNormal];
    }
}

//打开手电筒
-(void) turnOnLed:(bool)update
{
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOn];
    [_device unlockForConfiguration];
}

//关闭手电筒
-(void) turnOffLed:(bool)update
{
    [_device lockForConfiguration:nil];
    [_device setTorchMode: AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
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

