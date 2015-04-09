//
//  FLYMyReserveVC.m
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import "FLYMyReserveVC.h"

#import "FLYDataService.h"
#import "FLYMyReserveTableViewCell.h"
#import "FLYBaseUtil.h"



@interface FLYMyReserveVC ()
{
    NSMutableDictionary *resultsDictionary;//请求的预约数据
}

@end

@implementation FLYMyReserveVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"我的预约";
    //表
    self.tableView =[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44) pullingDelegate:self];
    self.tableView.pullingDelegate=self;
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    static NSString *cellIndifier = @"cell";
    FLYMyReserveTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FLYMyReserveTableViewCell" owner:self options:nil] lastObject];
    }
    [cell.mainBtn addTarget:self action:@selector(mainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.mainBtn.tag=indexPath.row+100;
    
    
    FLYLockFixModel *lockFixModel =[self.datas objectAtIndex:indexPath.row];
    cell.fixModel = lockFixModel;
    
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
    _isMore =NO;
    _dataIndex=0;
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
        resultsDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
        NSLog(@"成功%@",resultsDictionary);
        [ref loadSubscribeData:result];
        
    } errorBolck:^(){
        [ref loadSubscribeError:YES];
        
        
    }];


}
//加载更多
-(void)requestMoreSubscribeData
{
    if (_isMore)
    {
        _isMore =NO;
        int start =_dataIndex;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults stringForKey:@"token"];
        NSString *userid = [defaults stringForKey:@"memberId"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       token,
                                       @"token",
                                       userid,
                                       @"userid",
                                       [NSString stringWithFormat:@"%d",start],
                                       @"start",
                                            nil];
        //防止循环引用
        __weak FLYMyReserveVC *ref = self;
        [FLYDataService requestWithURL:queryAppoinInfo_API params:params httpMethod:@"POST" completeBolck:^(id result)
        {
            [ref loadSubscribeData:result];
            
        } errorBolck:^(){
            [ref loadSubscribeError:NO];
        }];
    }else
    {
        [self.tableView tableViewDidFinishedLoadingWithMessage:nil];
    }
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
    _dataIndex=_dataIndex+20;
    [self hideHUD];
    [self.tableView setReachedTheEnd:NO];
    NSString *flag =[resultsDictionary objectForKey:@"flag"];
    if ([flag isEqualToString:kFlagYes]){
        NSLog(@"请求成功");
        NSDictionary *result =[resultsDictionary objectForKey:@"result"];
        if (result !=nil)
        {
            NSArray *lockFixList =[result objectForKey:@"lockFixList"];
            if ([lockFixList count]>=20)
            {
                _isMore =YES;
            }
            
            NSMutableArray *lockListMutableArray = [NSMutableArray arrayWithCapacity:lockFixList.count];
            
            for (NSDictionary *fixDic in lockFixList) {
                //NSDictionary 转 Model
                FLYLockFixModel *fixModel = [[FLYLockFixModel alloc] initWithDataDic:fixDic];
                [lockListMutableArray addObject:fixModel];
            }
            
            if (self.datas==nil)
            {
                self.datas =lockListMutableArray;
            }else
            {
                [self.datas addObjectsFromArray:lockListMutableArray];
            }
            
            if (self.datas != nil && [self.datas count] > 0) {
                self.tableView.hidden = NO;
                [self showNoDataView:NO];
            }else{
                self.tableView.hidden = YES;
                [self showNoDataView:YES];
            }
            [self.tableView reloadData ];
        }
          
        
    }else
    {
        NSLog(@"请求失败");
        NSString *msg = [data objectForKey:@"msg"];
        [self showAlert:msg];

    }
    [self.tableView tableViewDidFinishedLoading];
    if (!_isMore && self.datas != nil && [self.datas count] > 0) {
        [self.tableView setReachedTheEnd:YES];
        [super showMessage:@"加载完成"];
    }
}
#pragma mark - PullingRefreshTableViewDelegate
//下拉开始
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(RequestSubscribeData) withObject:nil afterDelay:1.f];
}

//上拉加载数据
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(requestMoreSubscribeData) withObject:nil afterDelay:1.f];
}

//滑动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
}
//结束滑动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
//关闭地锁请求
-(void)switchLock:(NSString *)lockCode lockFlag:(NSString *)lockFlag
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];

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
         NSString *str=[result JSONString];
         NSMutableDictionary *switchLockDic = [NSMutableDictionary dictionaryWithDictionary:result];
         NSString *statusStr = [switchLockDic objectForKey:@"flag"] ;
         if ([statusStr isEqualToString:@"0"])
         {
             NSLog(@"请求成功");
             [self showToast:@"开关地锁成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
              [self showToast:@"开关地锁失败"];
             //[self showToast:[switchLockDic objectForKey:@"msg"]];
         }

     } errorBolck:^()
     {
         NSLog(@"请求失败");

     }];
}

-(void)mainBtnClick:(UIButton *)sender
{
    static BOOL isChage;
    if (!isChage)
    {
        [sender setTitle:@"车走了" forState:UIControlStateNormal];
        [self switchLock:[[self.datas objectAtIndex:sender.tag-100]objectForKey:@"fixLockcode"]lockFlag:@"1"];
    }else
    {
        [sender setTitle:@"车到了" forState:UIControlStateNormal];
        [self switchLock:[[self.datas objectAtIndex:sender.tag-100]objectForKey:@"fixLockcode"]lockFlag:@"0"];
    }
    isChage=!isChage;
    
    
    
    
    
    
}

@end
