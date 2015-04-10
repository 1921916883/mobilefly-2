//
//  FLYMyReserveTableViewCell.h
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLYLockFixModel.h"
//自定义代理
@protocol ReserveDelegate <NSObject>
@optional
//操作地锁
- (void)optLock:(FLYLockFixModel *)fixModel;
@end

@interface FLYMyReserveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *reserveTime;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
@property (weak, nonatomic) IBOutlet UILabel *residueTime;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *lockCode;

@property(nonatomic,strong) FLYLockFixModel *fixModel;

@property(assign,nonatomic)id<ReserveDelegate> lockDelegate;

- (IBAction)lockBtnClick:(id)sender;

@end
