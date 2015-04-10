//
//  FLYQueryAppoinInfoModel.h
//  park_yun
//
//  Created by Allen on 15-4-8.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

//返回值字段	字段类型	字段说明
//fixPretime	int	预约时长(分钟)
//fixPreamt	int	预约价格(分)
//parkName	string	停车场名称
//fixLockcode	string	地锁AP编号
//fixOpttime	string	操作时间
//lockSeatcode	string	车位编码
//fixRemainingtime	int	剩余时长(小于0说明已经过时了)
//lockFlag	string	0空闲1占用 未知表示地磁状态有错误

//查询预约信息
#import "FLYBaseModel.h"

@interface FLYLockFixModel : FLYBaseModel

@property(nonatomic,strong) NSNumber *fixPretime;
@property(nonatomic,strong) NSNumber *fixPreamt;
@property(nonatomic,copy) NSString *parkName;
@property(nonatomic,copy) NSString *fixLockcode;
@property(nonatomic,copy) NSString *fixOpttime;
@property(nonatomic,copy) NSString *lockSeatcode;
@property(nonatomic,strong) NSNumber *fixRemainingtime;
@property(nonatomic,copy) NSString *lockFlag;

@end
