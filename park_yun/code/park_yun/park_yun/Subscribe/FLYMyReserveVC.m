//
//  FLYMyReserveVC.m
//  park_yun
//
//  Created by Allen on 15-4-2.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//

#import "FLYMyReserveVC.h"
#import "FLYMyReserveTableViewCell.h"
#import "FLYDataService.h"


@interface FLYMyReserveVC ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
{
    UIScrollView *scrollView;
    UITableView *mainTabView ;
    NSMutableDictionary *infoResults;//请求结果
    NSMutableArray *dataArr;

}

@end

@implementation FLYMyReserveVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"我的预约";
    scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    scrollView .contentSize =CGSizeMake(ScreenWidth, 1000);
    [self.view addSubview:scrollView];
    [self creatTableView];
       [self prepareRequestParkListData];
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
-(void)creatTableView
{
    mainTabView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    mainTabView .delegate =self;
    mainTabView.dataSource =self;
    
    [scrollView addSubview:mainTabView];

}
#pragma mark --taleView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr =[[infoResults objectForKey:@"result"]objectForKey:@"lockFixList"];
    return arr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellInditifier =@"cell";
    FLYMyReserveTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellInditifier];
    if (!cell)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"FLYMyReserveTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
    }
    cell.titleLab.text =[[dataArr objectAtIndex:indexPath.row] objectForKey:@"parkName"];
    cell.reserveTime .text=[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fixPretime"];
    cell.residueTime.text =[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fixRemainingtime"];
    cell.money.text =[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fixPreamt"];

    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma  mark--请求停车场数据
-(void)prepareRequestParkListData
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token,
                                 @"token",
                                 userid,
                                 @"userid",
                                 nil];
    //防止循环引用
    __weak FLYMyReserveVC *ref = self;
    [FLYDataService requestWithURL:kHttpQueryAppoinInfo params:dict httpMethod:@"post" completeBolck:^(id result)
     {
         [ref requestSucceed:result];
        // NSLog(@"%@",result);
     } errorBolck:^()
     {
         NSLog(@"请求失败");
         [self loadDataError];
     }];
}
-(void)requestSucceed:(id)result
{
    infoResults = [NSMutableDictionary dictionaryWithDictionary:result];
    NSString *statusStr = [infoResults objectForKey:@"flag"] ;
    if ([statusStr isEqualToString:@"0"])
    {
        NSLog(@"请求成功");
        dataArr =[[infoResults objectForKey:@"result"]objectForKey:@"lockFixList"];
        [mainTabView reloadData];
        [super showMessage:@"加载完成"];
}
}
-(void)loadDataError{
    
            [self showTimeoutView:YES];//超时，显示图片
            [self hideHUD];
        [FLYBaseUtil networkError];
    }
#pragma mark ---上下拉动，加载数据
//下拉开始
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(prepareRequestParkListData) withObject:nil afterDelay:1.f];
}
//上拉加载数据
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(prepareRequestParkListData) withObject:nil afterDelay:1.f];
}

@end
