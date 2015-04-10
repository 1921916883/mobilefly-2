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
#import "FLYMyReserveTableViewCell.h"


@interface FLYMyReserveVC : FLYBaseViewController<UITableViewDelegate,UITableViewDataSource,ReserveDelegate>
{

}

@property (nonatomic,strong) UITableView *tableView;
//table数据
@property (nonatomic,strong) NSMutableArray *datas;

@end

