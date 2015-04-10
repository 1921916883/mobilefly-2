//
//  FLYMyReserveTableViewCell.m
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import "FLYMyReserveTableViewCell.h"
#import "UIButton+Bootstrap.h"

@implementation FLYMyReserveTableViewCell

//初始化
- (void)awakeFromNib {
    // Initialization code
    
}

//布局
- (void)layoutSubviews{
    self.titleLab.text = [NSString stringWithFormat:@"%@",self.fixModel.parkName];
    self.lockCode .text =[NSString stringWithFormat:@"车位：%@",self.fixModel.fixLockcode];
    self.reserveTime.text = [NSString stringWithFormat:@"预约时长：%@分钟",[self.fixModel.fixPretime stringValue]];
    self.residueTime.text = [NSString stringWithFormat:@"剩余时长：%@分钟",self.fixModel.fixRemainingtime];
    self.money.text = [NSString stringWithFormat:@"¥%d.00",([self.fixModel.fixPreamt intValue])/100 ];
    
    if([self.fixModel.lockFlag isEqualToString:@"0"]){
        [self.mainBtn setTitle:@"我到了" forState:UIControlStateNormal];
    }else{
        [self.mainBtn setTitle:@"我走了" forState:UIControlStateNormal];
    }
    
    [self.mainBtn primaryStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//按钮点击事件
- (IBAction)lockBtnClick:(id)sender {
    
    if ([self.lockDelegate respondsToSelector:@selector(optLock:)]) {
        [self.lockDelegate optLock:self.fixModel];
    }
    
    }

@end
