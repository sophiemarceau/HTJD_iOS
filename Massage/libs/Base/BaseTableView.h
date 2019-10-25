
//  WXMovie
//
//  Created by 牛顿、 on 13-8-31.
//  Copyright (c) 2013年 www.736014814@qq.com牛顿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshBaseView.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"

@protocol BaseTableViewDelegate <NSObject>
@optional
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView;
@end
@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *data;

//当前选中得单元格indexPath
@property(nonatomic,retain)NSIndexPath *selectIndexPath;

@property (nonatomic,assign)id<BaseTableViewDelegate>delegates;

@property (nonatomic,strong)MJRefreshHeaderView *head;
@property (nonatomic,strong)MJRefreshFooterView *foot;

@end
