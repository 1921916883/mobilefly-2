//
//  FLYMyReserveVC.m
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import "FLYMyReserveVC.h"

#import "FLYDataService.h"
#import "FLYBaseUtil.h"



@interface FLYMyReserveVC ()
{

}

@end

@implementation FLYMyReserveVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的预约";
    //表
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];

    [self prepareRequestSubscribeData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datas == nil || [self.datas count] == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [self.datas count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndifier = @"ReserveCell";
    FLYMyReserveTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FLYMyReserveTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    [cell.mainBtn addTarget:self action:@selector(mainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.mainBtn.tag = indexPath.row+100;
    
    
    FLYLockFixModel *lockFixModel =[self.datas objectAtIndex:indexPath.row];
    cell.fixModel = lockFixModel;
    cell.lockDelegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

#pragma mark - 数据请求
//判断是否有网
-(void)prepareRequestSubscribeData{
    if ([FLYBaseUtil isEnableInternate]) {
        [self showHUD:@"加载中" isDim:NO];
        [self RequestSubscribeData];
    }else{
        [self showTimeoutView:YES];
        [self showToast:@"请打开网络"];
    }
}

//发送请求
-(void)RequestSubscribeData
{
    [self showTimeoutView:NO];
    self.datas=nil;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   token,
                                   @"token",
                                   userid,
                                   @"userid",
                                   nil];
    //防止循环引用
    __weak FLYMyReserveVC *ref = self;
    [FLYDataService requestWithURL:queryAppoinInfo_API params:params httpMethod:@"POST" completeBolck:^(id result){
        [ref loadSubscribeData:result];
    } errorBolck:^(){
        [ref loadSubscribeError:YES];
    }];


}


//加载错误
-(void)loadSubscribeError:(BOOL)isFirst{
    if (isFirst) {
        [self showTimeoutView:YES];
    }
    [self hideHUD];
    [FLYBaseUtil networkError];
}

//加载成功，处理数据
- (void)loadSubscribeData:(id)data
{
    [self hideHUD];
    NSString *flag =[data objectForKey:@"flag"];
    if ([flag isEqualToString:kFlagYes]){
        NSLog(@"请求成功");
        NSDictionary *result =[data objectForKey:@"result"];
        if (result !=nil)
        {
            NSArray *lockFixList =[result objectForKey:@"lockFixList"];
            NSMutableArray *lockListMutableArray = [NSMutableArray arrayWithCapacity:lockFixList.count];
            
            for (NSDictionary *fixDic in lockFixList) {
                FLYLockFixModel *fixModel = [[FLYLockFixModel alloc] initWithDataDic:fixDic];
                [lockListMutableArray addObject:fixModel];
                
            }
            
            self.datas = lockListMutableArray;
            
            if (self.datas != nil && [self.datas count] > 0) {
                self.tableView.hidden = NO;
                [self showNoDataView:NO];
            }else{
                self.tableView.hidden = YES;
                [self showNoDataView:YES];
            }
            [self.tableView reloadData];
        }
          
        
    }else
    {
        NSLog(@"请求失败");
        NSString *msg = [data objectForKey:@"msg"];
        [self showAlert:msg];

    }
}


//关闭地锁请求
-(void)switchLock:(NSString *)lockCode lockFlag:(NSString *)lockFlag
{
    //lockFlag 0空闲1占用
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];
    
    //如果当前地锁空闲 我到了 下降地锁
    if([lockFlag isEqualToString:@"0"]){
        lockFlag = @"1";
    }
    //如果当前地锁占用 我走了 上升地锁
    else{
        lockFlag = @"0";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token,
                                 @"token",
                                 userid,
                                 @"userid",
                                 lockFlag,
                                 @"lockFlag",
                                 lockCode,
                                 @"lockCode",
                                 nil];
    //防止循环引用
    __weak FLYMyReserveVC *ref = self;
    [FLYDataService requestWithURL:switchLock_API params:dict httpMethod:@"POST" completeBolck:^(id result)
     {
         NSMutableDictionary *switchLockDic = [NSMutableDictionary dictionaryWithDictionary:result];
         NSString *statusStr = [switchLockDic objectForKey:@"flag"] ;
         if ([statusStr isEqualToString:@"0"])
         {
             [self prepareRequestSubscribeData];
             NSLog(@"请求成功");
         }else
         {
            [self showToast:@"开关地锁失败"];
         }

     } errorBolck:^()
     {
         [self showToast:@"请求失败"];
     }];
}

#pragma mark - ReserveDelegate
- (void)optLock:(FLYLockFixModel *)fixModel{
    [self switchLock:fixModel.fixLockcode lockFlag:fixModel.lockFlag];
    [self showHUD:@"切换中" isDim:NO];
}


@end
