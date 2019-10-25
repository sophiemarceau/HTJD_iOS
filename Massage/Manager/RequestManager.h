//
//  RequestManager.h
//
//
//
//
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef void(^SuccessData)(NSDictionary *result);
typedef void(^ErrorData)( NSError *error);

@interface RequestManager : NSObject

+(RequestManager *)shareRequestManager;

@property (nonatomic,strong) NSArray *friendArray; //好友数组

@property (nonatomic,copy)NSString *token; //token
@property (nonatomic,strong)UserModel *userModel;
@property (nonatomic,assign) BOOL hasNetWork;
@property (nonatomic,strong)NSString * curentlatitude;
@property (nonatomic,strong)NSString * curentlongitude;
@property (nonatomic,copy) NSString *cityname;
@property (nonatomic,assign)NSInteger heartbeat;  //轮询定位提交时间 (分钟)
@property (nonatomic,assign)NSInteger userPageCount;  //用户搜索的默认分页数量
@property (nonatomic,assign)NSInteger firendPageCount;//好友列表的默认分页数量
@property (nonatomic,assign)NSInteger eventPageCount; //活动搜索的默认分页数量
@property (nonatomic,assign)NSInteger topicPageCount; //活动评论搜索的默认分页数量
@property (nonatomic,copy) NSString *appUsl;//应用的链接地址
@property (nonatomic,copy) NSString *beforeAppVersion_;
@property (nonatomic,copy) NSString *nowVersions_;
@property (nonatomic,assign) BOOL canuUMPush;

@property (nonatomic,strong) UIViewController *CurrMainController;

@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *longti;
//取消请求
- (void)cancelAllRequest;

#pragma mark - 看技师
- (void)SelectTechican:(NSDictionary *)dataDic
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 选服务
- (void)SelectService:(NSDictionary *)dataDic
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 看服务详情
- (void)GetServiceDetail:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 	查询技师列表
- (void)GetSkillListByServID:(NSDictionary *)dataDic
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 看技师详情
- (void)GetTechnicianDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 预约时间
- (void)BookTime:(NSDictionary *)dataDic
  viewController:(UIViewController *)controller
     successData:(SuccessData)success
         failuer:(ErrorData)errors;

#pragma mark - 用户信息
- (void)GetUserInfo:(NSDictionary *)dataDic
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 获取验证码
- (void)GetVerifyCodeRusult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 获取我的华佗信息
- (void)GetMyUserInfo:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 获取我的地址信息
- (void)GetMyAddressInfo:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 查询地址详情
- (void)CheckAddressDetail:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 删除地址详情
- (void)DeleteAddressDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 查询账户明细列表
- (void)CheckaccountDetail:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 查询优惠券列表
- (void)CheckcouponDetail:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 添加优惠券
- (void)AddcouponDetail:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 获得城市区域信息
- (void)GetMyCityAndAreaInfo:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 查询城市列表
- (void)GetMyCityInfo:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 查询充值卡列表
- (void)getGoodsList:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark - 提交充值卡订单
- (void)genRechargeCardOrder:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 添加新的地址信息
- (void)AddNewAddressInfo:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 用户点评
- (void)AddCommentInfo:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 登录
- (void)LoginUserRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 查询订单列表
- (void)getOrderList:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark - 查询到店订单列表
- (void)getstoreOrderList:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 查询订单详情
- (void)getOrderDetail:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 查询评论列表
- (void)getSkillEvaluateList:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 支付请求
- (void)getOrderPay:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 删除订单
- (void)deleteOrder:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 提交加钟订单
- (void)addBeltOrder:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;


#pragma mark - 取消订单
- (void)cancelOrder:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 取消秒杀订单
- (void)cancelSpikeOrder:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 获得差评标签列表
- (void)getBedCommentRemarkList:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

- (void)getTagList:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors;



#pragma mark - 消费码列表
- (void)storeExchangeCodeList:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark - 查询店铺列表
- (void)checkStoreList:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 查询品牌列表
- (void)checkBrandList:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 查询品牌店铺列表
- (void)checkbrandStoreList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 查询品牌店铺详情
- (void)checkstoreDetail:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 查询店铺服务详情
- (void)checkstoreServiceDetail:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

#pragma mark - 到店预约选择时间
- (void)getStoreServiceTime:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 预约选择技师列表
- (void)getstoreSkillListByServID:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark - 提交店铺订单
- (void)genStoreOrder:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 查询评价列表
- (void)checkstoreEvaluateList:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark - 搜索技师列表（到店和上门的一起）
- (void)searchSkillList:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 查询技师详情（到店）
- (void)checkstoreSkillDetailInfo:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark - 城市商圈信息查询
- (void)getAreaDistrictList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 查询店铺列表
- (void)getstoreList:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark - 附近技师列表（只是到店的技师）
- (void)searchNearSkillList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 店铺订单详情
- (void)getstoreOrderDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 查询banner信息
- (void)getBannerList:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 评价到店订单
- (void)AddevalStoreOrder:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;
- (void)CommentOrder:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;//3.0版


#pragma mark - 查询分类服务列表(新增)(项目模块详细信息)
- (void)getServiceListByPosition:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;

#pragma mark - 查询身体部位列表(新增)(项目模块分类与排序)
- (void)getProjectSortList:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 提交闪付订单
- (void)genQuickPayOrder:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;





#pragma mark - 3.0新

#pragma mark - 项目详情
- (void)getSysServiceDetail:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;


#pragma mark - 查询分类导航
- (void)getNavigationList:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 查询分类导航内容 获取导航的详细内容 ,包括门店，项目， 技师的信息
- (void)getNavContent:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 查询卡券列表
- (void)getUserCouponList:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 查询技师详情
- (void)getSysSkillDetailInfo:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark - 搜索 ,包括门店，项目， 技师的信息
- (void)SearchContent:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
       SearchFlagType:(NSString *)flag
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 查询预约时间
- (void)getServiceTime:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;


#pragma mark - 预约下单
- (void)genServiceOrder:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;


#pragma mark - 查询门店详情
- (void)getSysStoreDetail:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 查询消费码列表
- (void)getConsumptionList:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 查询广告列表
- (void)getadList:(NSDictionary *)dataDic
   viewController:(UIViewController *)controller
      successData:(SuccessData)success
          failuer:(ErrorData)errors;


#pragma mark - 查询闪付优惠
- (void)getFastPayActivity:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 发现列表
- (void)getDiscoverList:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 发现内容列表
- (void)getDiscoverItem:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 更新收藏
- (void)addCollect:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors;



#pragma mark - 查询收藏
- (void)getUserCollections:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;


#pragma mark - 删除收藏
- (void)cancelCollect:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 加钟预约
- (void)getMakeExtention:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 查询预约时间
- (void)getCommenList:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;


//#pragma mark - 加钟下单
//- (void)addBeltOrder:(NSDictionary *)dataDic
//       viewController:(UIViewController *)controller
//          successData:(SuccessData)success
//              failuer:(ErrorData)errors;

#pragma mark - 闪付下单
- (void)genQuickOrder:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 提交用户反馈
- (void)addFeedBack:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;


#pragma mark - 领取卡券
- (void)userGetCoupon:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 客户端首图
- (void)getfirstFigure:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;


#pragma mark - 城市热门商圈
- (void)getBusiness:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;


#pragma mark - 查询当前版本
- (void)getVersionInfo:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;


#pragma mark - 秒杀下单
- (void)genSpikeOrder:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 秒杀订单详情
- (void)spikeOrderDetail:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 查询秒杀时间轴列表
- (void)getQueryTimeZoneList:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;


#pragma mark - 查询秒杀活动列表
- (void)getQueryTimeZoneContext:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

#pragma mark - 查询秒杀专题内容
- (void)getQuerySpecialContext:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;
























































#pragma mark ----------无关-------------
#pragma mark ----------用户相关-------------

#pragma mark - 注册
- (void)registRusult:(NSDictionary *)dicData
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark - 获取验证码
- (void)createVerifyCodeRusult:(NSDictionary *)dicData
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark - 登录
- (void)logonUseRequest:(NSDictionary *)dicData
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 忘记密码
- (void)forgetPassWord:(NSString *)telPhone
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 用户资料更新
- (void)updateUserInfo:(NSDictionary *)dicData
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 获取目标用户资料 - 根据系统UID
- (void)getUserInfoById:(NSString *)uid
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 获取目标用户资料 - 根据环信用户名
- (void)getUserInfoByHxUser:(NSString *)hxUser
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 用户搜索
- (void)searchUser:(NSDictionary *)dicData
       successData:(SuccessData)success
           failuer:(ErrorData)errors;

#pragma mark - 查询是否是本应用的用户
- (void)isYYLuser:(NSString *)userPhone
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark - 定时更新用户位置
- (void)locatedUser:(NSDictionary *)dicData
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 附近的人
- (void)nearUserList:(NSDictionary *)dicData
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark ----------资源相关-------------

#pragma mark - 地区列表
- (void)areaListRequest:(SuccessData)success
                failuer:(ErrorData)errors;
#pragma mark - 职业列表
- (void)jobListListRequest:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 服务器配置信息
- (void)configureRequest:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark ----------活动相关-------------

#pragma mark - 创建活动
- (void)createEvent:(NSDictionary *)dataDic
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 参见活动
- (void)joinEvent:(NSString *)eid
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark -获取活动信息
- (void)eventInfo:(NSString *)eid
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark - 举报活动
- (void)reportEvent:(NSString *)eid
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 查看活动
- (void)viewEvent:(NSString *)eid
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark - 签到活动
- (void)signInEvent:(NSString *)eid
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 活动成员列表
- (void)eventMemberList:(NSDictionary *)memberDic
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 活动列表
- (void)eventList:(NSDictionary *)dataDic
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark - 发起的、参加的活动
- (void)eventListByUID:(NSDictionary *)dataDic
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 活动搜索
- (void)eventSearch:(NSDictionary *)dataDic
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 添加活动评论
- (void)addEventTopic:(NSDictionary *)contentDic
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 活动评论列表
- (void)eventTopicList:(NSDictionary *)topicData
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 当前活动排行 用于计算我发起的活动预计排行数
- (void)eventTopList:(SuccessData)success
             failuer:(ErrorData)errors;



#pragma mark -----------通讯录/好友--------

#pragma mark - 同步手机通讯录的用户
- (void)syncContactUsers:(NSDictionary *)dicData
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 获取好友列表
- (void)buddyList:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark - 添加好友
- (void)addBuddy:(NSDictionary *)dicData
     successData:(SuccessData)success
         failuer:(ErrorData)errors;

#pragma mark - 获取请求加入好友列表
- (void)buddyRequestList:(NSString *)page
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 通过添加好友请求
- (void)allowAddBuddy:(NSString *)br_id
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark - 拒绝好友请求
- (void)rejectAddBuddy:(NSString *)br_id
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 移除好友
- (void)removeBuddy:(NSDictionary *)dicDta
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 根据环信聊天组ID获取用户列表
- (void)userListFromChatGroup:(NSString *)groupId
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark ----------用户设置-------------
#pragma mark - 好友验证
- (void)buddyVerify:(NSString *)verify
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 用户每日签到
- (void)signInDay:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark - 获取二维码字符串
- (void)myCode:(SuccessData)success
       failuer:(ErrorData)errors;

#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller;
- (void)tipAlert:(NSString *)results;
- (void)resultFail:(NSDictionary *)result;
- (void)resultFail:(NSDictionary *)result  viewController:(UIViewController *)controller;

@end
