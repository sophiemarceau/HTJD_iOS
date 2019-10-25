//
//  Comment.h
//  Massage
//
//  Created by sophiemarceau_qu on 15/5/26.
//  Copyright (c) 2015年 sophiemarceau_qu. All rights reserved.
//

#ifndef Massage_Comment_h
#define Massage_Comment_h

//#define ServerWechatURL @"http://wechat.huatuojiadao.com"// 生产环境
#define ServerWechatURL @"http://wechat.huatuojiadao.cn"// 测试环境

//#define POST_key @"1234567890" //正式环境
#define POST_key @"594f803b380a41396ed63dca39503542"//测试环境

//#define BaseURLString  @"http://server.huatuojiadao.com/huatuo_server"//生产环境 .com
#define BaseURLString  @"http://server.huatuojiadao.cn/huatuo_server"//测试环境 .cn

#define BURL(Value) [NSString stringWithFormat:@"%@%@",ServerWechatURL,Value]

#define ProtocolString @"/weixin_user/html/wechat.html#user-protocol"//用户协议

#define ApplyString @"/weixin_user/html/wechat.html#user-apply"//门店入驻

#define disclaimerString @"/weixin_user/html/wechat.html#user-disclaimer"//免责声明

#define helpString @"/weixin_user/html/wechat.html#user-help"//常见问题

#define IS_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromFindRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.6]

#define APPNAME @"华佗驾到"

#define SENDPASSWORD  @"huatuozx"

#define UIColorBlackString UIColorFromRGB(0x282828)

#define UIColorGrayString UIColorFromRGB(0x808080)

#define UIColorBlueString UIColorFromRGB(0x006BD1)

#define RedUIColorC1 UIColorFromRGB(0xc03230)

#define C2UIColorGray UIColorFromRGB(0xededed)

#define RedUIColorC3 UIColorFromRGB(0xd83219)

#define OrangeUIColorC4 UIColorFromRGB(0xf39517)

#define BlackUIColorC5 UIColorFromRGB(0x1d1d1d)

#define C5UIColorGray UIColorFromRGB(0xbfc4ca)

#define C6UIColorGray UIColorFromRGB(0x747474)

#define C7UIColorGray UIColorFromRGB(0xc8c8c8)

#define C8UIColorGray UIColorFromRGB(0xebebeb)

#define VIewBackGroundColor UIColorFromRGB(0xebebe5)

#define UIColorBrownString UIColorFromRGB(0xC64300)

#define UIColorfontString UIColorFromRGB(0xCA5D00)

#define UIColorTextfieldString UIColorFromRGB(0xCC6D41)

#define UIColorShihuangseString UIColorFromRGB(0xFCF7EF)

#define UIColorSelected UIColorFromRGB(0x9c4e1f)

#define UIColorNormal UIColorFromRGB(0xab9283)

#define BAIDUKEY @"GlS1YY7nU4Fu86rg2NBj3wYD"

#define UMENG_APPKEY @"54b764fbfd98c5b550000f9a"

#define kTabHeight  49

#define kNavHeight  64

#define kHeightFor5s     568

#define kWidthFor5s     320
#define   kHeightFor6s     668
#define   kWidthFor6s     375

#define TAB_BAR_HEIGHT 49

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width

//#define   kHeight  ((IS_3_5_INCH_SCREEN)? 568:kScreenHeight)

#define AUTO_SIZE_SCALE_X (kScreenHeight != kHeightFor5s ? (kScreenWidth/kWidthFor5s) : 1.0)

#define AUTO_SIZE_SCALE_Y (kScreenHeight != kHeightFor5s ? ((kScreenHeight-kNavHeight)/(kHeightFor5s-kNavHeight)) : 1.0)

#define AUTO_SIZE_SCALE_X1 (kScreenHeight != kHeightFor6s ? (kScreenWidth/kWidthFor6s) : 1.0)
#define   AUTO_SIZE_SCALE_Y1 (kScreenHeight != kHeightFor6s ? ((kScreenHeight-kNavHeight)/(kHeightFor6s-kNavHeight)) : 1.0)

#define k_UIFont(font)  [UIFont systemFontOfSize:font]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define GDMapKey @"bb0c2474f9e9c49266448989da2c1caf"

#define IsSucess(result) [[result objectForKey:@"Result"] boolValue]

#define IsSucessCode(result)  [[result objectForKey:@"code"] isEqualToString:@"0000"]?TRUE:FALSE

#define noIsKindOfNusll(result,key)   ![[(result) objectForKey:(key)] isKindOfClass:[NSNull class]]

//判断字符串是否为nil,如果是nil则设置为空字符串
#define CHECK_STRING_IS_NULL(txt) txt = !txt ? @"" : txt

#define kDateFormatTime @"yyyy-MM-dd hh:mm:ss"

#define kDateFormatDay @"yyyy-MM-dd"

//引入头文件
//#import "CommentMethod.h"
#import "UIViewExt.h"
#import "ZCControl.h"
#import "Toast+UIView.h"
#import "RequestManager.h"
#import "TTGlobalUICommon.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIViewController+HUD.h"
#import "WCAlertView.h"
#import "UIView+ViewController.h"
#import "Toast+UIView.h"
#import "UIImage+fixOrientation.h"
//#import "SDWebImageManager.h"
#import "UILabel+StringFrame.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//设置是否调试模式
#define NDDEBUG 1

#if NDDEBUG
#define NDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLog(xx, ...)  ((void)0)
#endif

#define IS_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//#define UMOnlineConfigDidFinishedNotification @"OnlineConfigDidFinishedNotification"
//
//#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define kPersonalServiceCellHeight 108

#define APPScheme @"huatuojiadaoiOS"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define navBtnHeight 44

#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

#define LAST_RUN_VERSION_KEY @"first_run_version_of_application"

#define NOTIFICATION_NAME_USER_LOGOUT       @"userLogout" //退出登录

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif



#pragma mark 友盟点击事件名称-----------------------------

#define VISITOR_LOGIN               @"VISITOR_LOGIN"                //登录事件
#define VISITOR_GETCODE             @"VISITOR_GETCODE"              //获取验证码事件
#define VISITOR_PROTOCOL            @"VISITOR_PROTOCOL"             //华佗驾到免责声明事件
#define TAB_STORE                   @"TAB_STORE"                    //TAB到店事件
#define TAB_DOOR                    @"TAB_DOOR"                     //TAB上门事件
#define TAB_DISCOVER                @"TAB_DISCOVER"                 //TAB发现事件
#define TAB_ORDER                   @"TAB_ORDER"                    //TAB订单事件
#define TAB_MY                      @"TAB_MY"                       //TAB我的事件
#define STORE_CITY                  @"STORE_CITY"                   //到店页选择城市事件
#define STORE_QR                    @"STORE_QR"                     //二维码扫描事件
#define STORE_SEARCH                @"STORE_SEARCH"                 //到店页搜索事件
#define STORE_SCREEN                @"STORE_SCREEN"                 //到店页排序事件
#define STORE_SCREEN_NEAR           @"STORE_SCREEN_NEAR"            //到店页离我最近事件
#define STORE_SCREEN_EVALUATE       @"STORE_SCREEN_EVALUATE"        //到店页评价最高事件
#define STORE_SCREEN_PRICE          @"STORE_SCREEN_PRICE"           //到店页价格最低事件
#define STORE_POSITION              @"STORE_POSITION"               //到店页定位事件
#define STORE_SEARCH_CHOOSE         @"STORE_SEARCH_CHOOSE"
#define STORE_SEARCH_SEARCH         @"STORE_SEARCH_SEARCH"
#define STORE_SEARCH_DELETE         @"STORE_SEARCH_DELETE"
#define STORE_SEARCH_CHOOSE_STORE   @"STORE_SEARCH_CHOOSE_STORE"
#define STORE_SEARCH_CHOOSE_TICHNICIAN      @"STORE_SEARCH_CHOOSE_TICHNICIAN"
#define STORE_SEARCH_CHOOSE_PROJECT         @"STORE_SEARCH_CHOOSE_PROJECT"
#define STORE_STOREDETAIL           @"STORE_STOREDETAIL"
#define STORE_STOREDETAIL_COLLECT   @"STORE_STOREDETAIL_COLLECT"
#define STORE_STOREDETAIL_SHARE     @"STORE_STOREDETAIL_SHARE"
#define STORE_STOREDETAIL_PAY       @"STORE_STOREDETAIL_PAY"
#define STORE_STOREDETAIL_COUPON    @"STORE_STOREDETAIL_COUPON"
#define STORE_STOREDETAIL_PHONE     @"STORE_STOREDETAIL_PHONE"
#define STORE_STOREDETAIL_ADRESS    @"STORE_STOREDETAIL_ADRESS"
#define STORE_STOREDETAIL_COMMENT   @"STORE_STOREDETAIL_COMMENT"
#define STORE_STOREDETAIL_PROJECTDETAIL     @"STORE_STOREDETAIL_PROJECTDETAIL"
#define STORE_STOREDETAIL_PROJECTDETAIL_COLLECT     @"STORE_STOREDETAIL_PROJECTDETAIL_COLLECT"
#define STORE_STOREDETAIL_PROJECTDETAIL_SHARE       @"STORE_STOREDETAIL_PROJECTDETAIL_SHARE"
#define STORE_STOREDETAIL_PROJECTDETAIL_STOREDETAIL @"STORE_STOREDETAIL_PROJECTDETAIL_STOREDETAIL"
#define STORE_STOREDETAIL_PROJECTDETAIL_ADRESS      @"STORE_STOREDETAIL_PROJECTDETAIL_ADRESS"
#define STORE_STOREDETAIL_PROJECTDETAIL_COMMENT     @"STORE_STOREDETAIL_PROJECTDETAIL_COMMENT"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ADDTIME  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ADDTIME"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_REDUCETIME  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_REDUCETIME"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_TIME  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_TIME"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_COUPON  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_COUPON"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_PAY  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_PAY"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ACCOUNT  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ACCOUNT"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ZHIFUBAO  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ZHIFUBAO"
#define STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_WEIXIN  @"STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_WEIXIN"
#define DOOR_CITY  @"DOOR_CITY"
#define DOOR_SEARCH  @"DOOR_SEARCH"
//#define DOOR_BOOK  @"DOOR_BOOK"
//#define DOOR_PROJECT  @"DOOR_PROJECT"
//#define DOOR_COMPANY  @"DOOR_COMPANY"
#define DOOR_SCREEN  @"DOOR_SCREEN"
#define DOOR_PHOTO  @"DOOR_PHOTO"
#define DOOR_TICHNICIANDETAIL  @"DOOR_TICHNICIANDETAIL"
#define DOOR_POSITION  @"DOOR_POSITION"
#define DOOR_SCREEN_NEAR  @"DOOR_SCREEN_NEAR"
#define DOOR_SCREEN_EVALUATE  @"DOOR_SCREEN_EVALUATE"
#define DOOR_SCREEN_ORDER  @"DOOR_SCREEN_ORDER"
#define DOOR_SEARCH_CHOOSE  @"DOOR_SEARCH_CHOOSE"
#define DOOR_SEARCH_CHOOSE_STORE  @"DOOR_SEARCH_CHOOSE_STORE"
#define DOOR_SEARCH_CHOOSE_TICHNICIAN  @"DOOR_SEARCH_CHOOSE_TICHNICIAN"
#define DOOR_SEARCH_CHOOSE_PROJECT  @"DOOR_SEARCH_CHOOSE_PROJECT"
#define DOOR_SEARCH_SEARCH  @"DOOR_SEARCH_SEARCH"
#define DOOR_SEARCH_DELETE  @"DOOR_SEARCH_DELETE"
#define DOOR_TICHNICIANDETAIL_COLLECT  @"DOOR_TICHNICIANDETAIL_COLLECT"
#define DOOR_TICHNICIANDETAIL_SHARE  @"DOOR_TICHNICIANDETAIL_SHARE"
#define DOOR_TICHNICIANDETAIL_MORE  @"DOOR_TICHNICIANDETAIL_MORE"
#define DOOR_TICHNICIANDETAIL_COMMENT  @"DOOR_TICHNICIANDETAIL_COMMENT"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_COLLECT  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_COLLECT"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_SHARE  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_SHARE"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_COMMENT  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_COMMENT"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_TICHNICIANDETAIL  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_TICHNICIANDETAIL"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_REDUCETIME  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_REDUCETIME"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ADDTIME  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ADDTIME"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_TIME  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_TIME"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ADRESS  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ADRESS"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_COUPON  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_COUPON"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_PAY  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_PAY"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ACCOUNT  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ACCOUNT"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ZHIFUBAO  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ZHIFUBAO"
#define DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_WEIXIN  @"DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_WEIXIN"
#define DISCOVER_DETAIL  @"DISCOVER_DETAIL"
#define DISCOVER_DETAIL_COLLECT  @"DISCOVER_DETAIL_COLLECT"
#define DISCOVER_DETAIL_SHARE  @"DISCOVER_DETAIL_SHARE"
#define ORDER_NOPAY  @"ORDER_NOPAY"
#define ORDER_WAITSERVE  @"ORDER_WAITSERVE"
#define ORDER_WAITCOMMET  @"ORDER_WAITCOMMET"
#define ORDER_ALL  @"ORDER_ALL"
#define ORDER_PAY  @"ORDER_PAY"
#define ORDER_DELETEORDER  @"ORDER_DELETEORDER"
#define ORDER_STOREDETAIL  @"ORDER_STOREDETAIL"
#define ORDER_ORDERDETAIL  @"ORDER_ORDERDETAIL"
#define ORDER_COMMENT  @"ORDER_COMMENT"
#define ORDER_ORDERDETAIL_AGAIN  @"ORDER_ORDERDETAIL_AGAIN"
#define MY_LOGOUT  @"MY_LOGOUT"
#define MY_ADRESS  @"MY_ADRESS"
#define MY_COLLECT  @"MY_COLLECT"
#define MY_COUPON  @"MY_COUPON"
#define MY_CODE  @"MY_CODE"
#define MY_QA  @"MY_QA"
#define MY_ABOUTUS  @"MY_ABOUTUS"
#define STORE_HORIZONTAL_TAB  @"STORE_HORIZONTAL_TAB"
#define DOOR_HORIZONTAL_TAB  @"DOOR_HORIZONTAL_TAB"


#pragma mark -----------------------------

