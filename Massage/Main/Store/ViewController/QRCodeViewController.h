//
//  QRCodeViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController : BaseViewController
{
    //二维码
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    //手电筒
    BOOL isLightOn;
}
//二维码
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

//手电筒
@property BOOL isLightOn;
@end
