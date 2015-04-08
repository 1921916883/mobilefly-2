//
//  FLYMyReserveVC.h
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import "FLYBaseViewController.h"
#import "PullingRefreshTableView.h"
#import "FLYLockFixModel.h"


@interface FLYMyReserveVC : FLYBaseViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
{
    //最后一次数据加载索引
    int _dataIndex;
    //数据是否全部加载完
    BOOL _isMore;
}
@property (nonatomic ,strong)PullingRefreshTableView *tableView;
//table数据
@property (strong,nonatomic) NSMutableArray *datas;
//下拉刷新
@property (nonatomic) BOOL refreshing;

@end
