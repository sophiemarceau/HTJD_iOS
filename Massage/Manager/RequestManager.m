//
//  RequestManager.m
//  YouYiLian
//
//  Created by DevNiudun on 15/3/20.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "RequestManager.h"
#import "NetworkManager.h"
#import "OpenUDID.h"
#import <commoncrypto/CommonDigest.h>
#define   kNetWorkManager   [NetworkManager SharedNetworkManager]

#pragma 华佗驾到USER 接口汇总
#define HTJD_getServList @"/serv/getServList" // 查询服务列表信息
#define HTJD_getServInfo  @"/serv/getServInfo" //查询服务详细信息
#define HTJD_getCityList @"/cms/getCityList"//开通城市查询
#define HTJD_getAreaList @"/cms/getAreaList"//城市区域信息查询
#define HTJD_getVersionInfo @"/cms/getVersionInfo"//手机客户端版本信息查询
#define HTJD_sendSms @"/cms/sendSms" //支持绑定手机号码发送，和登陆发送
#define HTJD_login @"/user/login/new" //    如果是手机APP登录client=android或者client=ios，那么需要手机号和验证码进行登录
#define HTJD_addmobile  @"/user/addmobile"
#define HTJD_userInfo @"/user/info/get" //查询用户信息
#define HTJD_accountDetail @"/user/bill/get" //查询账户明细列表
#define HTJD_userAddress @"/user/address/get" //查询地址列表
#define HTJD_addressDetail @"/user/address/detail" //查询地址详情
#define HTJD_updateAddress @"/user/address/save" //新增/修改地址
#define HTJD_delAddress @"/user/address/del"// 删除地址
#define HTJD_getSkillListByServID @"/skill/getSkillListByServID" //查询技师列表
#define HTJD_getSkillList @"/skill/getSkillList"//查询技师列表-与项目评级
#define HTJD_getSkillDetailInfo @"/skill/getSkillDetailInfo" //查询技师详情
#define HTJD_getGoodsList @"/goods/getGoodsList"//查询充值卡
//#define HTJD_getServiceTime @"/order/getServiceTime" //查询预约时间


//#define HTJD_getOrderList @"/order/getOrderList"// 查询订单列表
//#define HTJD_getOrderDetail @"/order/getOrderDetail"  //查询订单详情
#define HTJD_getOrderList @"/publicorder/userOrderList"// 查询订单列表
#define HTJD_getOrderDetail @"/publicorder/userOrderDetail"  //查询订单详情
#define HTJD_getstoreOrderList @"/storeorder/storeOrderList"// 查询到店订单列表

#define HTJD_evaluateOrder @"/order/evaluateOrder" //用户订单完成订单后可以对订单进行评价
#define HTJD_getSkillEvaluateList @"/skill/getSkillEvaluateList"  //根据钟数查询可选的时间，如果已经选定了技师，则要考虑占钟的情况。
#define HTJD_CommentRemarkList @"/order/getBedCommentRemarkList" //获得差评标签列表
#define HTJD_couponList @"/coupon/couponList" //获得优惠券列表 6.4.2
//#define HTJD_addCoupon  @"/coupon/addCoupon"  //增加优惠券 6.4.1.1 ／／/market/addCoupon
#define HTJD_addCoupon  @"/market/addCoupon"  //增加优惠券 6.6.3 /market/addCoupon
#define HTJD_getGoodsList @"/goods/getGoodsList" //查询充值卡列表
#define HTJD_genRechargeCardOrder @"/order/genRechargeCardOrder" //提交充值卡订单
#define HTJD_orderPay @"/pay/orderPay" //支付请求
#define HTJD_deleteOrder @"/order/deleteOrder" //删除订单
#define HTJD_addBeltOrder @"/order/addBeltOrder" //提交加钟订单
#define HTJD_getBedCommentRemarkList @"/order/getBedCommentRemarkList" //获得差评标签列表
#define HTJD_cancelOrder @"/order/cancelOrder" //取消订单
#define HTJD_cancelSpikeOrder @"/spikeorder/cancelOrder" //取消秒杀订单


#define HTJD_getTagList @"/tag/getTag" //获得差评标签列表

//到店
#define HTJD_storeExchangeCodeList @"/storeorder/storeExchangeCodeList" //消费码列表
#define HTJD_checkStoreList @"/store/storeList" //查询店铺列表
#define HTJD_checkBrandList @"/brand/brandList" //查询品牌列表
#define HTJD_checkbrandStoreList @"/brand/brandStoreList" //查询品牌店铺列表
#define HTJD_checkstoreDetail @"/store/storeDetail" //查询店铺详情
#define HTJD_checkstoreServiceDetail @"/store/storeServiceDetail" //查询店铺服务详情
#define HTJD_getStoreServiceTime @"/store/getStoreServiceTime" //到店预约选择时间
//#define HTJD_getstoreSkillListByServID @"/store/getStoreSkillListByServID" //预约选择技师列表
#define HTJD_genStoreOrder @"/storeorder/genStoreOrder" //提交店铺订单
#define HTJD_checkstoreEvaluateList @"/store/storeEvaluateList" //查询评价列表
#define HTJD_searchSkillList @"/store/searchSkillList" //搜索技师列表（到店和上门的一起）
#define HTJD_checkstoreSkillDetailInfo @"/store/storeSkillDetailInfo" //查询技师详情（到店）
#define HTJD_getAreaDistrictList @"/cms/getAreaDistrictList" //查询技师详情（到店）
#define HTJD_getstoreList @"/store/storeList" //查询店铺列表
#define HTJD_searchNearSkillList @"/store/searchNearSkillList" //附近技师列表（只是到店的技师）
#define HTJD_getstoreOrderDetail @"/storeorder/storeOrderDetail" //店铺订单详情
#define HTJD_getBannerList @"/cms/getBannerList" //查询banner信息
#define HTJD_AddevalStoreOrder @"/storeorder/evalStoreOrder" //评价到店订单
#define HTJD_getServiceListByPosition @"/store/getServiceListByPosition" //查询分类服务列表(新增)(项目模块详细信息)
#define HTJD_getProjectSortList @"/store/getProjectSortList" //查询身体部位列表(新增)(项目模块分类与排序)
#define HTJD_genQuickPayOrder @"/storeorder/genQuickPayOrder" //提交闪付订单

//3.0新
#define HTJD_getSysServiceDetail @"/serv/getSysServiceDetail" //项目详情
#define HTJD_getNavigationList @"/navigation/navigationList" //查询分类导航
#define HTJD_getNavContent @"/publicorder/getNavContent" //查询分类导航
#define HTJD_getUserCouponList @"/market/userCouponList" //查询卡券列表
#define HTJD_getSysSkillDetailInfo @"/skill/getSysSkillDetailInfo" //查询技师详情
#define HTJD_getServiceTime @"/publicorder/getServiceTime" //查询预约时间
#define HTJD_getstoreSkillListByServID @"/publicorder/storeSkillListByServID" //查询预约技师
#define HTJD_genServiceOrder @"/publicorder/genServiceOrder" //预约下单
#define HTJD_getSysStoreDetail @"/store/getSysStoreDetail" //查询门店详情
#define HTJD_CommentOrder @"/evaluate/userEvaluate" //评价订单（3.0版)
#define HTJD_getadList @"/commercial/adList" //查询广告列表
#define HTJD_getFastPayActivity @"/activity/getFastPayActivity" //查询闪付优惠
#define HTJD_getConsumptionList @"/storeorder/ecode/get" //查询消费码列表
#define HTJD_getDiscoverList @"/discover/list" //发现列表
#define HTJD_getDiscoverItem @"/discover/item" //发现内容列表
#define HTJD_addCollect @"/collect/addCollect" //更新收藏
#define HTJD_getUserCollections @"/collect/userCollections" //查询收藏
#define HTJD_cancelCollect @"/collect/cancelCollect" //删除收藏
#define HTJD_CommentList @"/evaluate/evaluateList" //查询评价列表
#define HTJD_getMakeExtention @"/publicorder/extention" //加钟预约信息
#define HTJD_genQuickOrder @"/quickorder/genQuickOrder" //闪付下单
#define HTJD_addFeedBack @"/user/feedback/add" //提交用户反馈
#define HTJD_userGetCoupon @"/market/userGetCoupon" //领取卡券
#define HTJD_getfirstFigure @"/prop/firstFigure" //客户端首图
#define HTJD_getBusiness @"/cityarea/business" //客户端首图

#define HTJD_genSpikeOrder @"/spikeorder/genSpikeOrder" //秒杀下单
#define HTJD_queryTimeZoneList @"/spike/queryTimeZoneList" //查询秒杀时间轴列表
#define HTJD_queryTimeZoneContext @"/spike/queryTimeZoneContext" //查询秒杀活动列表
#define HTJD_spikeOrderDetail @"/spikeorder/spikeOrderDetail" //秒杀订单详情
#define HTJD_querySpecialContext @"/spike/querySpecialContext" //查询秒杀专题内容





//用户相关
#define    kYYL_Regist               @"Account/regist2"              //注册
#define    kYYL_CreateVerifyCode     @"Account/createVerifyCode"    //获取验证码
#define    kYYL_Logonuser            @"Account/logonuser"           //登录
#define    kYYL_ForgetPWd            @"Account/forgetPassword"      //忘记密码
#define    kYYL_UpdateUserInfo       @"Account/updateUserInfo"      //用户资料更新
#define    kYYL_GetUserInfo          @"Account/GetUserInfoByID"     //获取目标用户资料 - 根据系统UID
#define    kYYL_GetUserInfoByHxUser  @"Account/GetUserInfoByHXUser" //获取目标用户资料 - 根据环信用户名
#define    kYYL_SearchUsers          @"Account/SearchUsers"         //用户搜索
#define    kYYL_isYYLUser            @"Account/IsYYLUser"           //查询是否是本应用的用户
#define    kYYL_LocatedUser          @"Account/LocatedUser"         //定时更新用户位置
#define    kYYL_NearUserList         @"Account/NearUserList"        //附近的人列表

//资源相关
#define    kYYL_AreaList             @"Resource/AreaList"           //获取地区列表
#define    kYYL_JobList              @"Resource/JobList"            //获取职业列表
#define    kYYL_Configure            @"Resource/Configure"          //服务器配置信息


//活动相关
#define    kYYL_CreateEvent              @"Events/CreateEvent"      //创建活动
#define    kYYL_JoinEvent                @"Events/JoinEvent"        //参加活动
#define    kYYL_ReportEvent              @"Events/ReportEvent"      //举报活动
#define    kYYL_ViewEvent                @"Events/ViewEvent"        //查看活动
#define    kYYL_EventInfo                @"Events/EventInfo"        //查看活动
#define    kYYL_SignInEvent              @"Events/SignInEvent"      //签到活动
#define    kYYL_EventList                @"Events/EventList"        //活动列表
#define    kYYL_EventListByUID           @"Events/EventListByUID"   //活动列表
#define    kYYL_EventMemberList          @"Events/EventMemberList"  //活动成员列表
#define    kYYL_EventSearch              @"Events/EventSearch"      //活动搜索
#define    kYYL_AddEventTopic            @"Events/AddEventTopic"    //添加活动评论
#define    kYYL_EventTopicList           @"Events/EventTopicList"   //活动评论列表
#define    kYYL_EventTopList             @"Events/EventTopList"     //当前活动排行 用于计算我发起的活动预计排行数


//通讯录/好友
#define    kYYL_SyncContactUsers    @"Contact/SyncContactUsers"  //同步手机通讯录的用户
#define    kYYL_BuddyList           @"Contact/BuddyList"         //获取好友列表
#define    kYYL_AddBuddy            @"Contact/AddBuddy"          //添加好友
#define    kYYL_RemoveBuddy         @"Contact/RemoveBuddy"       //移除好友
#define    kYYL_AllowAddBuddy       @"Contact/AllowAddBuddy"     //通过添加好友请求
#define    kYYL_RejectAddBuddy      @"Contact/RejectAddBuddy"    //拒绝添加好友请求
#define    kYYL_BuddyRequestList    @"Contact/BuddyRequestList"  //获取请求加入好友列表

#define    kYYL_UserListFromChatGroup    @"Contact/UserListFromChatGroup"  //根据环信聊天组ID获取用户列表

//用户设置
#define    kYYL_BuddyVerify         @"UserSetting/BuddyVerify"     //好友验证设定
#define    kYYL_SignInDay           @"UserSetting/SignInDay"       //每日签到
#define    kYYL_MyCode              @"UserSetting/MyCode"          //获取二维码字符串





static RequestManager *shareRusult;

@interface RequestManager ()

@property(nonatomic ,strong) AFHTTPRequestOperationManager *requestManager;


@end

@implementation RequestManager
-(id) init
{
    self = [super init];
    
    //            _locService = [[BMKLocationService alloc]init];
    //            _locService.delegate =self;
    //            [_locService startUserLocationService];
    //    [self startUpdatingLocation];
    self.lat = @"";
    self.longti =  @"";
    self.eventPageCount = 50;
    self.cityname =@"";
    return self;
}

+(RequestManager *)shareRequestManager
{
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareRusult = [[self alloc]init];
        
    });
    return shareRusult;
}

#pragma 1.0版本 接口请求方法
-(NSString *)getPathWithServiceName:(NSString *)serviceName WithBody:(NSDictionary *)BodyDic{
    
    NSString *requestPath =nil;
    
    NSDictionary *content =@{
                             @"head":[self getHeadDictionaryWithServicesName:serviceName],
                             @"body":BodyDic,
                             };
    
    NSString *contentString = [self jsonStringWithDictionary:content];//转为json string
    
    NSData *contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding];//转为NSData
    /*
     String content=injs.toString();//转成 string
     String contentbase64 = Base64.String2Base64(content);//把content base64
     String key =MD5v2.md532(contentbase64+"huatuozx");key是 content和 huotuozx拼接而成的key md5编码后
     
     String urlString = "http://182.92.223.9:8080/huatuo/servlet/getdata?sid=1&content="+StringUtil.urlEncoder(contentbase64)+"&key="+key;
     */
    NSString *after_contentStrBase64 = [self Base64Encode:contentData];//base64编码
    //    NSLog(@"after----------->%@",after_contentStrBase64);
    //    NSString *contentStr = [after_contentStrBase64 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *contentStr =[self URLEncodedString:after_contentStrBase64];//urlEncode
    
    NSString *keystr =[NSString stringWithFormat:@"%@%@",after_contentStrBase64 ,SENDPASSWORD];
    NSLog(@"%@",keystr);
    NSString *key = [self md5:keystr];
    NSLog(@"%@",key);
    NSDictionary *postdata =@{
                              @"sid":@"1",
                              @"content":contentStr,
                              @"key":key
                              };
    
    requestPath =[NSString stringWithFormat:@"?sid=%@&content=%@&key=%@",[postdata objectForKey:@"sid"],[postdata objectForKey:@"content"],[postdata objectForKey:@"key"]];
    NSLog(@"requestPath------%@",requestPath);
    return requestPath;
}


#pragma md5 加密
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}


- (NSString *)URLEncodedString:(NSString *)beforeString
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)beforeString,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8));
    return outputStr;
}

#pragma BASE 64编码
-(NSString *) Base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B','C', 'D', 'E','F', 'G', 'H','I', 'J', 'K','L', 'M', 'N','O', 'P',
        'Q', 'R','S', 'T', 'U','V', 'W', 'X','Y', 'Z', 'a','b', 'c', 'd','e', 'f',
        'g', 'h','i', 'j', 'k','l', 'm', 'n','o', 'p', 'q','r', 's', 't','u', 'v',
        'w', 'x','y', 'z', '0','1', '2', '3','4', '5', '6','7', '8', '9','+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i <3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] &0xFC) >> 2;
        output[1] = ((input[0] &0x03) << 4) | ((input[1] &0xF0) >> 4);
        output[2] = ((input[1] &0x0F) << 2) | ((input[2] &0xC0) >> 6);
        output[3] = input[2] &0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
    
}

#pragma  从NSDictionary中获取json 串 封装
-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

#pragma  从NSObject中获取json 串 封装
-(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

#pragma  从NSString中获取json 串 封装
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

#pragma  从NSArray中获取json 串 封装
-(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}


#pragma 1.0 请求 数据报文头 封装
-(NSDictionary *)getHeadDictionaryWithServicesName:(NSString*)servicename{
    NSDictionary *head =@{
                          @"client":@"ios",
                          @"deviceID":[self opendUDID],
                          @"screenPixel":@"320*480",
                          @"longitude":self.longti,
                          @"latitude":self.lat,
                          @"version"
                          @"servicesName":servicename,
                          @"messageID":@"",
                          @"channelCode":@"",
                          
                          
                          };
    
    return head;
}

-(NSString *)opendUDID{
    return  [OpenUDID value];
}



//取消请求
- (void)cancelAllRequest
{
    [kNetWorkManager cancelAllRequest];
}

#pragma mark -2.0 接口 封装Content
-(NSDictionary *)translateParams:(NSDictionary *)params{
    //    NSLog(@"version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    //    //公共交互报文
    NSDictionary *PublicDictionary =@{
                                      @"client":@"ios",
                                      @"deviceID":[self opendUDID],
                                      @"screenPixel":@"320*480",
                                      @"longitude":self.longti,
                                      @"latitude":self.lat,
                                      
                                      //                                      @"version":@"3.0.1",
                                      @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                      //                          @"messageID":@"",
                                      @"channelCode":@"",
                                      //sign 也是必填的需要添加的 一项
                                      };
    
    //    NSDictionary *PublicDictionary =@{@"a":@"1"};
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    [beforeDic addEntriesFromDictionary:params];
    
    NSMutableDictionary *mutableDic =   [self filterParamters:beforeDic];// 过滤掉 空参数 和 参数名为 sign signtype的 键值对
    
    NSString  *translateString=[self createSign:mutableDic];
    //         NSLog(@"sign------->%@",translateString);
    translateString =[translateString stringByAppendingString:POST_key];
    //        NSLog(@"transl------->%@",translateString);
    NSString *sign =[self md5:translateString];
    
    [mutableDic setObject:[sign lowercaseString] forKey:@"sign"];
    //     NSLog(@"mutableDic------->%@",mutableDic);
    NSString *contentString =    [self jsonStringWithDictionary:mutableDic];
    
    //    NSLog(@"contentString------->%@",contentString);
    
    NSData *contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding];//转为NSData
    
    NSString *after_contentStrBase64String = [contentData base64EncodedStringWithOptions:0];
    //        NSLog(@"Base64String------->%@",after_contentStrBase64String);
    //			Map<String, Object> paramsMap = new HashMap<String, Object>();
    //			paramsMap.put("content", content);
    //			String result = httpClient.post(serverUrl + params.getUrl(), paramsMap);
    //    String result = httpClient.get(serverUrl + params.getUrl() + "?content=" + content);
    NSString *after_contentStrBase64 = [self Base64Encode:contentData];//base64编码
    //    NSLog(@"after_contentStrBase64------->%@",after_contentStrBase64String);
    
    //    NSString *contentStr =[self URLEncodedString:after_contentStrBase64];//urlEncode
    NSDictionary *content =@{
                             @"content":after_contentStrBase64
                             };
    //     NSLog(@"content------->%@",content);
    
    return content;
}

-(NSMutableDictionary *)filterParamters:(NSMutableDictionary *)params{
    
    NSMutableDictionary *filterDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (params ==NULL ||params.count<=0) {
        return filterDictionary;
    }
    for (NSString *keyString in params.allKeys) {
        NSString *value =[params objectForKey:keyString];
        if (value ==NULL ||[value isEqualToString:@""] || [[keyString lowercaseString] isEqualToString:@"sign"]|| [[keyString lowercaseString ]isEqualToString:@"sign_type"]) {
            continue;
        }
        [filterDictionary setObject:value forKey:keyString];
    }
    
    return filterDictionary;
}

-(NSString *)createSign:(NSMutableDictionary *)params{
    
    
    
    NSArray *keys = [params allKeys];
    
    //    NSLog(@"keys :%@", keys);
    
    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:sort];
    //    NSLog(@"字符串数组排序结果%@",sortedKeys);//所有的键集合的排序
    
    NSString *strstring = @"";
    //    //所有值集合
    //    NSArray *values = [params allValues];
    //    NSLog(@"values :%@", values);
    for (int i =0; i<sortedKeys.count; i++) {
        NSString *key =sortedKeys[i];
        NSString *key_value = [params objectForKey:key];
        if (i == sortedKeys.count - 1) {     //拼接时，不包括最后一个&字符
            strstring =[NSString stringWithFormat:@"%@%@=%@",strstring,key,key_value];
        } else {
            strstring =[NSString stringWithFormat:@"%@%@=%@&",strstring,key,key_value];
        }
    }
    //    NSLog(@"%@",strstring);
    return strstring;
}


#pragma mark - 看技师
- (void)SelectTechican:(NSDictionary *)dataDic
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    
    NSDictionary *postdic = [self translateParams:dataDic];
    
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:HTJD_getSkillList
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           
                                           success(result);
                                           
                                           
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
    
}


#pragma mark - 看服务
- (void)SelectService:(NSDictionary *)dataDic
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    //    NSDictionary *userdic = @{
    //                              @"userID":@"14302744382404816"
    //
    //                              };
    
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getServList
     //     HTJD_userInfo
     
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------获取目标用户资料 - 根据系统UID ------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           success(result);
                                           
                                           
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
    //    [kNetWorkManager requestGetWithParameters:postdic
    //                                      ApiPath:HTJD_getServList
    //                                   WithHeader:nil
    //                                     onTarget:nil
    //                                      success:^(NSDictionary *result, NSDictionary *headers) {
    ////                                          if (IsSucess(result)) {
    ////                                              success(result);
    ////                                          }else
    ////                                          {
    ////                                              NDLog(@"-------选服务 列表成功 - 根据系统UID ------");
    ////                                              [self resultFail:result];
    ////                                          }
    //
    ////                                          if(IsSucessCode(result)){
    ////
    ////                                          }else{
    ////                                              NDLog(@"-------获取目标用户资料 - 根据系统UID ------");
    ////                                              [self resultFail:result];
    ////                                          }
    //                                           success(result);
    //                                      } failure:^(NSError *error) {
    //                                          errors(error);
    //                                      }];
    
}


#pragma mark - 服务详情
- (void)GetServiceDetail:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getServInfo
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------获取我的地址信息------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}



#pragma mark - 服务详情
- (void)GetTechnicianDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSkillDetailInfo
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           success(result);
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------获取我的地址信息------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}



#pragma mark - 获取预约时间
- (void)BookTime:(NSDictionary *)dicData
  viewController:(UIViewController *)controller
     successData:(SuccessData)success
         failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dicData];
    
    [kNetWorkManager requestPostWithParameters:postdic ApiPath:HTJD_getServiceTime WithHeader:nil onTarget:controller success:^(NSDictionary *result, NSDictionary *headers) {
        success(result);
    } failure:^(NSError *error) {
        errors(error);
    }];
}


#pragma mark - 查询技师列表
- (void)GetSkillListByServID:(NSDictionary *)dataDic
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    
    NSDictionary *postdic = [self translateParams:dataDic];
    
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:HTJD_getSkillListByServID
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                            if(IsSucessCode(result)){
                                           //                                                  success(result);
                                           //                                            }else{
                                           //                                                            NDLog(@"-------获取目标用户资料 - 根据系统UID ------");
                                           //                                                            [self resultFail:result];
                                           //                                            }
                                           success(result);
                                           
                                           
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    //
    //    [kNetWorkManager requestGetWithParameters:postdic
    //                                      ApiPath:HTJD_getSkillList
    //                                   WithHeader:nil
    //                                     onTarget:nil
    //                                      success:^(NSDictionary *result, NSDictionary *headers) {
    ////                                          if(IsSucessCode(result)){
    ////
    ////                                          }else{
    ////                                              NDLog(@"-------获取目标用户资料 - 根据系统UID ------");
    ////                                              [self resultFail:result];
    ////                                          }
    //
    ////                                          if (IsSucess(result)) {
    //                                              success(result);
    ////                                          }else
    ////                                          {
    ////                                              NDLog(@"-------获取目标用户资料 - 根据系统UID ------");
    ////                                              [self resultFail:result];
    ////                                          }
    //
    //
    //                                      } failure:^(NSError *error) {
    //                                          errors(error);
    //                                      }];
    
}




#pragma mark - 获取我的华佗信息
- (void)GetMyUserInfo:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_userInfo
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------获取我的华佗信息------");
                                           //                                               [self resultFail:result];
                                           //
                                           //
                                           //
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}



#pragma mark - 用户信息
- (void)GetServiceDetail:(NSDictionary *)dataDic
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getServInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------获取目标用户资料 - 根据系统UID ------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                           
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}



#pragma mark - 获取验证码
- (void)GetVerifyCodeRusult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_sendSms
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           NDLog(@"-------获取验证码 ------%@",[result objectForKey:@"msg"]);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------获取验证码 ------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                           
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 登录2.0
- (void)LoginUserRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_login
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------登录2.0------");
                                               //                                               [self resultFail:result];
                                               [[RequestManager shareRequestManager] tipAlert:@"手机号或验证码错误，请重新输入"];
                                           }
                                           
                                           
                                           
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取我的地址信息
- (void)GetMyAddressInfo:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_userAddress
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           success(result);
                                           //                                                                                      if(IsSucessCode(result)){
                                           //                                                                                          success(result);
                                           //                                                                                      }else{
                                           //                                                                                          NDLog(@"-------获取我的地址信息------");
                                           //                                                                                          [self resultFail:result];
                                           //                                                                                      }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 添加新的地址信息
- (void)AddNewAddressInfo:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateAddress
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           //                                              success(result);
                                           //
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------添加新的地址信息------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           //
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询账户明细列表
- (void)CheckaccountDetail:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_accountDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------查询账户明细列表------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询优惠券列表
- (void)CheckcouponDetail:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_couponList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------查询优惠券列表------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 获得城市区域信息
- (void)GetMyCityAndAreaInfo:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getAreaList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------获得城市区域信息------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询城市列表
- (void)GetMyCityInfo:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getCityList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------查询城市列表------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询地址详情
- (void)CheckAddressDetail:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addressDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------查询地址详情------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 删除地址详情
- (void)DeleteAddressDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_delAddress
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------删除地址详情------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询订单列表
- (void)getOrderList:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getOrderList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------删除地址详情------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询到店订单列表
- (void)getstoreOrderList:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getstoreOrderList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------删除地址详情------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 用户点评
- (void)AddCommentInfo:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_evaluateOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------用户点评------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 添加优惠券
- (void)AddcouponDetail:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addCoupon
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           
                                           //                                           NDLog(@"-------添加优惠券------%@",result);
                                           //                                              success(result);
                                           success(result);
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------添加优惠券------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询充值卡列表
- (void)getGoodsList:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getGoodsList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------查询充值卡列表------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 提交充值卡订单
- (void)genRechargeCardOrder:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_genRechargeCardOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------提交充值卡订单------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询评论列表
- (void)getSkillEvaluateList:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSkillEvaluateList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                              success(result);
                                           
                                           if(IsSucessCode(result)){
                                               success(result);
                                           }else{
                                               NDLog(@"-------查询评论列表------");
                                               [self resultFail:result];
                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 支付请求
- (void)getOrderPay:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_orderPay
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------支付请求------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 删除订单
- (void)deleteOrder:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_deleteOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------删除订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询订单详情
- (void)getOrderDetail:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getOrderDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------查询订单详情------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 提交加钟订单
- (void)addBeltOrder:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addBeltOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 提交订单
- (void)genServiceOrder:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors
{
    
    //    NSLog(@"dataDic--------->%@",dataDic);
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_genServiceOrder
     
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获得差评标签列表
- (void)getBedCommentRemarkList:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getBedCommentRemarkList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

- (void)getTagList:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getTagList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 取消订单
- (void)cancelOrder:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 取消秒杀订单
- (void)cancelSpikeOrder:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelSpikeOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 消费码列表
- (void)storeExchangeCodeList:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_storeExchangeCodeList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------提交加钟订单------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 查询店铺列表
- (void)checkStoreList:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkStoreList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 查询品牌列表
- (void)checkBrandList:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkBrandList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 查询品牌店铺列表
- (void)checkbrandStoreList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkbrandStoreList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询品牌店铺详情
- (void)checkstoreDetail:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkstoreDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询店铺服务详情
- (void)checkstoreServiceDetail:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkstoreServiceDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                                NSLog(@"postdic-------－－－－－－－－-->%@",result);
                                           
                                           
                                           
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 到店预约选择时间
- (void)getStoreServiceTime:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getStoreServiceTime
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 提交店铺订单
- (void)genStoreOrder:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_genStoreOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询评价列表
- (void)checkstoreEvaluateList:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkstoreEvaluateList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 搜索技师列表（到店和上门的一起）
- (void)searchSkillList:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchSkillList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询技师详情（到店）
- (void)checkstoreSkillDetailInfo:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_checkstoreSkillDetailInfo
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 城市商圈信息查询
- (void)getAreaDistrictList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getAreaDistrictList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询店铺列表
- (void)getstoreList:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getstoreList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 附近技师列表（只是到店的技师）
- (void)searchNearSkillList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchNearSkillList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 店铺订单详情
- (void)getstoreOrderDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getstoreOrderDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询banner信息
- (void)getBannerList:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getBannerList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 评价到店订单
- (void)AddevalStoreOrder:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_AddevalStoreOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
//3.0版
- (void)CommentOrder:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_CommentOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询分类服务列表(新增)(项目模块详细信息)
- (void)getServiceListByPosition:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getServiceListByPosition
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询身体部位列表(新增)(项目模块分类与排序)
- (void)getProjectSortList:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getProjectSortList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 提交闪付订单
- (void)genQuickPayOrder:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_genQuickPayOrder
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 项目详情
- (void)getSysServiceDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSysServiceDetail
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}


#pragma mark - 查询分类导航
- (void)getNavigationList:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getNavigationList
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询分类导航内容 获取导航的详细内容 ,包括门店，项目， 技师的信息
- (void)getNavContent:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getNavContent
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 查询卡券列表
- (void)getUserCouponList:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserCouponList
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 查询技师详情
- (void)getSysSkillDetailInfo:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSysSkillDetailInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 搜索 ,包括门店，项目， 技师的信息
- (void)SearchContent:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
       SearchFlagType:(NSString *)flag
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    
    NSDictionary *postdic = [self translateParams:dataDic];
    
    NSString *search =@"";
    if ([flag isEqualToString:@"0"]) {
        search = @"/search/searchStoreList";
    }else if(([flag isEqualToString:@"1"]) ){
        search = @"/search/searchSkillerList";
    }else if(([flag isEqualToString:@"2"]) ){
        search =  @"/search/searchServiceList";
        
    }
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     search
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 查询预约时间
- (void)getServiceTime:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getServiceTime
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询预约技师
- (void)getstoreSkillListByServID:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getstoreSkillListByServID
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 查询门店详情
- (void)getSysStoreDetail:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSysStoreDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 查询广告列表
- (void)getadList:(NSDictionary *)dataDic
   viewController:(UIViewController *)controller
      successData:(SuccessData)success
          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getadList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}


#pragma mark - 查询闪付优惠
- (void)getFastPayActivity:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getFastPayActivity
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

- (void)getConsumptionList:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getConsumptionList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}



#pragma mark - 发现列表
- (void)getDiscoverList:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getDiscoverList
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 更新收藏
- (void)addCollect:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addCollect
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}



#pragma mark - 查询收藏
- (void)getUserCollections:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserCollections
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 发现内容列表
- (void)getDiscoverItem:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getDiscoverItem
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 删除收藏
- (void)cancelCollect:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelCollect
     
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 加钟预约信息
- (void)getMakeExtention:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getMakeExtention
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 查询预约时间
- (void)getCommenList:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_CommentList
     
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


//#pragma mark - 加钟下单
//- (void)addBeltOrder:(NSDictionary *)dataDic
//      viewController:(UIViewController *)controller
//         successData:(SuccessData)success
//             failuer:(ErrorData)errors
//{
//
//}

#pragma mark - 闪付下单
- (void)genQuickOrder:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_genQuickOrder
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 提交用户反馈
- (void)addFeedBack:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addFeedBack
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 领取卡券
- (void)userGetCoupon:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_userGetCoupon
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 客户端首图
- (void)getfirstFigure:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getfirstFigure
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}


#pragma mark - 城市热门商圈
- (void)getBusiness:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getBusiness
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 查询当前版本
- (void)getVersionInfo:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getVersionInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 秒杀下单
- (void)genSpikeOrder:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_genSpikeOrder
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}


#pragma mark - 查询秒杀时间轴列表
- (void)getQueryTimeZoneList:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_queryTimeZoneList
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 秒杀订单详情
- (void)spikeOrderDetail:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_spikeOrderDetail
     //     HTJD_userInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                           //                                           if(IsSucessCode(result)){
                                           //                                               success(result);
                                           //                                           }else{
                                           //                                               NDLog(@"-------查询订单详情------");
                                           //                                               [self resultFail:result];
                                           //                                           }
                                           
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
    

#pragma mark - 查询秒杀活动列表
- (void)getQueryTimeZoneContext:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_queryTimeZoneContext
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 查询秒杀专题内容
- (void)getQuerySpecialContext:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self translateParams:dataDic];
    //    NSLog(@"postdic--------->%@",postdic);
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_querySpecialContext
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];

}




















#pragma mark -
#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller
{
    if ([results isKindOfClass:[NSNull class]]) {
        return;
    }
    //    [controller.view makeToast:results duration:2.0 position:@"bottom"];
    [controller.view makeToast:results duration:1.0 position:@"center"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    return;
}

- (void)tipAlert:(NSString *)results
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:results
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}

//弹出错误提示
- (void)resultFail:(NSDictionary *)result
{
    //    if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
    NSString *info =  [result objectForKey:@"msg"];
    [self tipAlert:info];
    //    }
}

//弹出错误提示
- (void)resultFail:(NSDictionary *)result  viewController:(UIViewController *)controller
{
    if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
        NSString *info =  [result objectForKey:@"Infomation"];
        [self tipAlert:info viewController:controller];
    }
}




@end

