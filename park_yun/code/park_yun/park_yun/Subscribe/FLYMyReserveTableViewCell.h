//
//  FLYMyReserveTableViewCell.h
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLYMyReserveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *reserveTime;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
@property (weak, nonatomic) IBOutlet UILabel *residueTime;
@property (weak, nonatomic) IBOutlet UILabel *money;


@end
