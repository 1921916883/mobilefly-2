//
//  FLYMyReserveTableViewCell.m
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import "FLYMyReserveTableViewCell.h"

@implementation FLYMyReserveTableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *reserveTime;
//@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
//@property (weak, nonatomic) IBOutlet UILabel *residueTime;
//@property (weak, nonatomic) IBOutlet UILabel *money;

//返回值字段	字段类型	字段说明
//fixPretime	int	预约时长(分钟)
//fixPreamt	int	预约价格(分)
//parkName	string	停车场名称
//fixLockcode	string	地锁AP编号
//fixOpttime	string	操作时间
//lockSeatcode	string	车位编码
//fixRemainingtime	int	剩余时长(小于0说明已经过时了)
//lockFlag	string	0空闲1占用 未知表示地磁状态有错误
//flag	string	成功标示（0成功1失败）

//初始化
- (void)awakeFromNib {
    // Initialization code
    
}

//布局
- (void)layoutSubviews{
    [self.titleLab sizeToFit];
    self.titleLab.text = self.fixModel.parkName;
    self.reserveTime.text = (NSString *)(self.fixModel.fixPretime);
    self.residueTime.text = self.fixModel.fixOpttime;
    self.money.text = (NSString *)(self.fixModel.fixPreamt);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
