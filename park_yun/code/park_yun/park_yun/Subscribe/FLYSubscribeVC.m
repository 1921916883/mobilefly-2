//
//  FLYSubscribeVC.m
//  park_yun
//
//  Created by Allen on 15-4-1.
//  Copyright (c) 2015年 无线飞翔. All rights reserved.
//
#define SpColor Color(220, 220, 220, 1)
#import "FLYSubscribeVC.h"
#import "FLYDBUtil.h"
#import "FLYRegionModel.h"
#import "DownSheetModel.h"
#import "DownSheet.h"
#import "FLYDataService.h"

#import "FLYParkModel.h"
#import "FLYShopModel.h"
#import "FLYParkCardModel.h"
#import "DXAlertView.h"
#import "FLYParkCardDetailView.h"
//我的预约
#import "FLYMyReserveVC.h"

//地锁数据model
#import "LockListInfo.h"
#import "LockListModel.h"
#import "LockListResult.h"


@interface FLYSubscribeVC ()<UITableViewDataSource,UITableViewDelegate,DownSheetDelegate>
{
    UIView *backView;
    UILabel *provinceLab;
    UILabel *cityLab;
    UILabel *areaLab;
    UILabel *stopLab;
    
    UIButton *provinceBtn;//省份按钮
    UIButton *cityBtn;//城市按钮
    UIButton *areaBtn;//区域按钮
    UIButton *stopBtn;//停车场按钮
    NSString *lockCode;//
    NSString *appointPrice;//
    NSString *appointPretime;
    
    //下拉类型
    int _listType;
    //下拉数据
    NSArray *_listData;
    //省区域ID
    NSString *_provinceId;
    
    //市区域ID
    NSString *_cityId;
    //停车场ID
    NSString *_parkId;
    //区域ID
    NSString *_areaId;
    UIView *mainView;
    NSMutableDictionary *resultsDictionary;//停车场请求的数据
    NSMutableDictionary *lockListDataDic;//地锁列表请求的数据
    NSMutableDictionary *queryAppointmentListDataDic;//价格，时间请求数据
    UILabel *chooseLB;
    int currentMainBtn;//虚拟地锁按钮
    int currentTimeBtn;//虚拟预约时间按钮
    UILabel *moneyLB;//费用
    UILabel *numberLB;//剩余预约个数
    NSString *parkId;
    NSArray *LockListDataArr;//地锁列表请求的数据数组
}
@property(nonatomic,strong)UITableView *stopTableView;//停车场选择列表

@property (strong,nonatomic) NSMutableArray *parkList;
@property (strong,nonatomic) NSMutableArray *parkCardList;

//首页列表数据
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation FLYSubscribeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   //[self creatSubscribeParkView];
    
    // Do any additional setup after loading the view.
    
    //self.view .backgroundColor =[UIColor redColor];
   self.title=@"停车预约";
    //导航右按钮
    UIButton *myReserveBtn = [UIFactory createButton:@"mfpparking_user_all_up@2x" hightlight:@"mfpparking_user_all_down@2x"];
    myReserveBtn.showsTouchWhenHighlighted = YES;
    myReserveBtn.frame = CGRectMake(0, 0, 30, 30);
    //settingBtn.backgroundColor =[UIColor redColor];
    [myReserveBtn addTarget:self action:@selector(myReserveBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:myReserveBtn];
    self.navigationItem.rightBarButtonItem = settingItem;

    
    
    //省份
    provinceLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, ((ScreenWidth-20)/2)/2, 40)];
    provinceLab.text =@"请选择省份";
    provinceLab.font =[UIFont systemFontOfSize:14];
    provinceLab.textAlignment =NSTextAlignmentLeft;
    provinceLab.userInteractionEnabled =YES;
    [self.view addSubview:provinceLab];
    
    
    UIImageView *provinceView =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-25, 33, 15, 10)];
    provinceView .image =[UIImage imageNamed:@"mfpparking_xzcsxia_all_0"];
    provinceView.userInteractionEnabled =YES;
    [self.view addSubview:provinceView];
    
    provinceBtn =[[UIButton alloc]initWithFrame:CGRectMake(provinceLab.frame.origin.x-10, provinceLab.frame.origin.y, ScreenWidth-10, 40)];
    provinceBtn.layer.borderWidth =1;
    provinceBtn.layer.borderColor=[UIColor colorWithRed:93/255.0 green:109/255.0 blue:113/255.0 alpha:1].CGColor;
    provinceBtn.layer.cornerRadius=5;
    [provinceBtn addTarget:self action:@selector(provinceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:provinceBtn];
    
    
    //城市
    cityLab =[[UILabel alloc]initWithFrame:CGRectMake(15, provinceLab.frame.origin.y+provinceLab.frame.size.height+15, ((ScreenWidth-20)/2)/2,40)];
    cityLab.text =@"请选择城市";
    cityLab.font =[UIFont systemFontOfSize:14];
    cityLab.textAlignment =NSTextAlignmentLeft;
    cityLab.userInteractionEnabled =YES;
    [self.view addSubview:cityLab];
    
    
    UIImageView *cityView =[[UIImageView alloc]initWithFrame:CGRectMake(cityLab.frame.origin.x+cityLab.frame.size.width, provinceLab.frame.origin.y+provinceLab.frame.size.height+33, 15, 10)];
    cityView .image =[UIImage imageNamed:@"mfpparking_xzcsxia_all_0"];
    cityView.userInteractionEnabled =YES;
    [self.view addSubview:cityView];
    
    cityBtn =[[UIButton alloc]initWithFrame:CGRectMake(cityLab.frame.origin.x-10, cityLab.frame.origin.y, cityLab.frame.size.width+cityView.frame.size.width+20, 40)];
    cityBtn.layer.borderWidth =1;
    cityBtn.layer.borderColor=[UIColor colorWithRed:93/255.0 green:109/255.0 blue:113/255.0 alpha:1].CGColor;
    cityBtn.layer.cornerRadius=5;
    [cityBtn addTarget:self action:@selector(cityBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cityBtn];

    
    //请选择区域
    areaLab =[[UILabel alloc]initWithFrame:CGRectMake(cityBtn.frame.origin.x+cityBtn.frame.size.width+20, cityBtn.frame.origin.y, ((ScreenWidth-20)/2)/2+10, 40)];
    areaLab.text =@"请选择区域";
    areaLab.font =[UIFont systemFontOfSize:14];
    areaLab.textAlignment =NSTextAlignmentLeft;
    areaLab.userInteractionEnabled =YES;
    [self.view addSubview:areaLab];
    
    
    UIImageView *areaView =[[UIImageView alloc]initWithFrame:CGRectMake(provinceView.frame.origin.x, cityView.frame.origin.y, 15, 10)];
    areaView .image =[UIImage imageNamed:@"mfpparking_xzcsxia_all_0"];
    areaView.userInteractionEnabled =YES;
    [self.view addSubview:areaView];
    
    areaBtn =[[UIButton alloc]initWithFrame:CGRectMake(areaLab.frame.origin.x-10, cityBtn.frame.origin.y, ScreenWidth-10-cityBtn.frame.size.width-10, 40)];
    areaBtn.layer.borderWidth =1;
    areaBtn.layer.borderColor=[UIColor colorWithRed:93/255.0 green:109/255.0 blue:113/255.0 alpha:1].CGColor;
    areaBtn.layer.cornerRadius=5;
    //areaBtn.backgroundColor =[UIColor redColor];
    [areaBtn addTarget:self action:@selector(areaBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:areaBtn];
    

    //请选择停车场
    stopLab =[[UILabel alloc]initWithFrame:CGRectMake(15, cityBtn.frame.origin.y+cityBtn.frame.size.height+15, ((ScreenWidth-20)/2)/2+100, 40)];
    stopLab.text =@"请选择停车场";
    stopLab.font =[UIFont systemFontOfSize:14];
    stopLab.textAlignment =NSTextAlignmentLeft;
    stopLab.userInteractionEnabled =YES;
    [self.view addSubview:stopLab];
    
    
    UIImageView *stopView =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-25, stopLab.frame.origin.y+20, 15, 10)];
    stopView .image =[UIImage imageNamed:@"mfpparking_xzcsxia_all_0"];
    stopView.userInteractionEnabled =YES;
    [self.view addSubview:stopView];
    
    stopBtn =[[UIButton alloc]initWithFrame:CGRectMake(stopLab.frame.origin.x-10, stopLab.frame.origin.y, ScreenWidth-10, 40)];
    stopBtn.layer.borderWidth =1;
    stopBtn.layer.borderColor=[UIColor colorWithRed:93/255.0 green:109/255.0 blue:113/255.0 alpha:1].CGColor;
    stopBtn.layer.cornerRadius=5;
    [stopBtn addTarget:self action:@selector(stopBtn:) forControlEvents:UIControlEventTouchUpInside];
    //stopBtn.backgroundColor =[UIColor redColor];
    [self.view addSubview:stopBtn];

    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)provinceBtnClick:(UIButton *)sender
{
    [mainView removeFromSuperview];
    _listType = 0;
    
    NSMutableArray *provinceList = [FLYDBUtil queryRegionOfProvice];
    [self showPicker:provinceList];

    NSLog(@"点击选择省份");
}
-(void)cityBtn:(UIButton *)sender
{
    [mainView removeFromSuperview];
    _listType = 1;
    
    if([FLYBaseUtil isNotEmpty:_provinceId]){
        NSMutableArray *list = [FLYDBUtil queryRegionOfCity:_provinceId];
        [self showPicker:list];
    }
    NSLog(@"点击选择城市");
    
}
-(void)areaBtn:(UIButton *)sender
{
    [mainView removeFromSuperview];
    _listType = 2;
    
    if([FLYBaseUtil isNotEmpty:_cityId]){
        NSMutableArray *list = [FLYDBUtil queryRegionOfArea:_cityId];
        [self showPicker:list];
    }

    NSLog(@"点击选择区域");
}
-(void)stopBtn:(UIButton *)sender
{
    [mainView removeFromSuperview];
    _listType = 3;
    
    if([FLYBaseUtil isNotEmpty:_areaId]){
        if(self.parkList == nil)
        {
            [self prepareRequestParkListData];
        }else
        {
            if([self.parkList count] == 0)
            {
                [self showToast:@"该区域暂无停车场"];
            }else
            {
                [self showParkPicker:self.parkList];
                
            }
        }
    }

    NSLog(@"点击选择停车场");
    
}
-(void)myReserveBtn:(UIButton *)sender
{
    NSLog(@"导航右按钮");
    FLYMyReserveVC *myReserveVC =[FLYMyReserveVC new];
    [self.navigationController pushViewController:myReserveVC animated:NO];
    
}
#pragma mark--StopTableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr=[[resultsDictionary objectForKey:@"result"]objectForKey:@"parkList"];

    return [arr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.text=[[[resultsDictionary objectForKey:@"result"]objectForKey:@"parkList"][indexPath.row] objectForKey:@"parkName"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
   
       stopLab.text=cell.textLabel.text;
       [_stopTableView removeFromSuperview];
       [backView removeFromSuperview];
    
     parkId =[[[resultsDictionary objectForKey:@"result"]objectForKey:@"parkList"][indexPath.row]objectForKey:@"parkId"];
    
    [self LockListData];
}
- (void)showPicker:(NSMutableArray *)list{
    
    NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:list.count];
    for (FLYRegionModel *region in list) {
        DownSheetModel *model = [[DownSheetModel alloc] init];
        model.title = region.regionName;
        model.value = region.regionId;
        
        [modelList addObject:model];
    }
    _listData = [NSArray arrayWithArray:modelList];
    
    
    
    
    
    DownSheet *sheet;
    if (_listType == 0) {
        sheet = [[DownSheet alloc]initWithlist:_listData height:44 * 7 original:_provinceId];
    }else if(_listType == 1){
        sheet = [[DownSheet alloc]initWithlist:_listData height:44 * 7 original:_cityId];
    }else if(_listType == 2){
        sheet = [[DownSheet alloc]initWithlist:_listData height:44 * 7 original:_areaId];
    }
    sheet.delegate = self;
    [sheet showInView:nil];
}
- (void)showParkPicker:(NSMutableArray *)list{
    NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:list.count];
    for (FLYParkModel *park in list) {
        DownSheetModel *model = [[DownSheetModel alloc] init];
        model.title = park.parkName;
        model.value = park.parkId;
        [modelList addObject:model];
    }
    _listData = [NSArray arrayWithArray:modelList];
    
    DownSheet *sheet = [[DownSheet alloc]initWithlist:_listData height:44 * 7 original:_parkId];
    sheet.delegate = self;
    [sheet showInView:nil];
}

#pragma mark - DownSheetDelegate
- (void)didSelectIndex:(NSInteger)index{
    
    DownSheetModel *model = [_listData objectAtIndex:index];
    if(_listType == 0){
        
        _provinceId = model.value;
        provinceLab.text= model.title;
        _cityId = nil;
        cityLab.text = @"请选择城市";
        _areaId = nil;
        areaLab.text = @"请选择区域";
        _parkId = nil;
        stopLab.text = @"请选择停车场";
        
        self.parkList = nil;
        
    }else if(_listType == 1){
        
        _cityId = model.value;
        cityLab.text = model.title;
        _areaId = nil;
        areaLab.text = @"请选择区域";
        _parkId = nil;
        stopLab.text = @"请选择停车场";
        
        self.parkList = nil;
        
    }else if(_listType == 2){
        
        _areaId = model.value;
        areaLab.text = model.title;
        _parkId = nil;
        stopLab.text = @"请选择停车场";
        
        self.parkList = nil;
        
    }else if(_listType == 3){
        
        _parkId = model.value;
        stopLab.text = model.title;
        
    }
    
}
//创建停车场列表
-(void)creatParkView
{
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backView.backgroundColor=[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:0.5];
    
    [self.view addSubview:backView];
    
    _stopTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height/2-70, backView.frame.size.width, backView.frame.size.height/2+70) style:UITableViewStylePlain];
    _stopTableView.delegate=self;
    _stopTableView.dataSource=self;
    [self.view addSubview:_stopTableView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    [backView addGestureRecognizer:singleTap];
    
    
}

-(void)clickView
{
    [_stopTableView removeFromSuperview];
    [backView removeFromSuperview];
    [mainView removeFromSuperview];
}


//请求停车场数据
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
                                   _areaId,
                                   @"regionId",
                                   nil];
    //防止循环引用
    __weak FLYSubscribeVC *ref = self;
    [FLYDataService requestWithURL:kHttpQueryParkLockListByRegion params:dict httpMethod:@"POST" completeBolck:^(id result)
    {
     
       resultsDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
        NSLog(@"成功%@",resultsDictionary);
        NSString *statusStr = [resultsDictionary objectForKey:@"flag"] ;
        if ([statusStr isEqualToString:@"0"])
        {
           
            NSLog(@"请求成功");
            [self creatParkView];//调用--创建停车场列表
            
          }
        
    } errorBolck:^()
    {
       NSLog(@"请求失败");
        
    }];
}

#pragma mark ----停车场数据列表请求
-(void)creatSubscribeParkView
{
    mainView =[[UIView alloc]init];
    if (ScreenHeight<=480)
    {
        mainView.frame=CGRectMake(0, ScreenHeight/2-104, ScreenWidth, ScreenHeight/2+64);
    }else
    {
        mainView.frame=CGRectMake(0, ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
    }
    mainView.layer.borderColor=Color(237, 237, 237, 1).CGColor;
    mainView.layer.borderWidth=0.5;
    mainView.backgroundColor=[UIColor whiteColor];
    [self .view addSubview:mainView];
    //
    UILabel *headerLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 29)];
    headerLab.text=stopLab.text;
    headerLab.font=[UIFont systemFontOfSize:15];
    headerLab.textAlignment =NSTextAlignmentLeft;
    [mainView addSubview:headerLab];
    //分隔线
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 29, ScreenWidth, 1)];
    lineView.backgroundColor =Color(237, 237, 237, 1);
    [mainView addSubview:lineView];
    
  chooseLB =[[UILabel alloc]initWithFrame:CGRectMake(10, headerLab.frame.size.height+lineView.frame.size.height, ScreenWidth-20, 30)];
    chooseLB.font=[UIFont systemFontOfSize:15];
    chooseLB.textAlignment =NSTextAlignmentLeft;
    [mainView addSubview:chooseLB];
    
    //横向滑动视图--地锁
    UIScrollView *scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0,60, ScreenWidth, 60)];
    scroller.contentSize=CGSizeMake(5 *90+10, 60);
    scroller .showsHorizontalScrollIndicator=NO;
    [mainView addSubview:scroller];
    
    
    for (int i=0; i<LockListDataArr.count; i++)
    {
        UIButton *mainBtn =[[UIButton alloc]initWithFrame:CGRectMake(10+i%5*90, 0, 80, 60)];
        mainBtn.layer.borderWidth=1;
        mainBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        mainBtn.layer.cornerRadius =8;
        [mainBtn addTarget:self action:@selector(mainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        mainBtn.tag=i+300;
        [scroller addSubview:mainBtn];
        currentMainBtn=300;
        
        UILabel *textLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 80, 10)];
        textLab.textAlignment =NSTextAlignmentCenter;
        textLab.font =[UIFont systemFontOfSize:15];
        [mainBtn addSubview:textLab];
        if ([[[LockListDataArr objectAtIndex:i]objectForKey:@"lockStatus"] isEqualToString:@"0"]) {
            textLab.text=@"可预约";
            textLab.textColor =Color(63, 110, 117, 1);
        }else if ([[[LockListDataArr objectAtIndex:i]objectForKey:@"lockStatus"] isEqualToString:@"1"])
        {
            textLab.text=@"占用";
            textLab.textColor =Color(196, 26, 22, 1);
            UIButton *btn= (UIButton *)[textLab superview];
            btn.enabled=NO;
        }else if([[[LockListDataArr objectAtIndex:i]objectForKey:@"lockStatus"] isEqualToString:@"2"]){
             textLab.text=@"维修中";
            textLab.textColor =Color(242, 241, 118, 1);
            UIButton *btn= (UIButton *)[textLab superview];
            btn.enabled=NO;

        }
        
         [mainBtn addSubview:textLab];
        UILabel *numerLab =[[UILabel alloc]initWithFrame:CGRectMake(0, textLab.frame.origin.y+textLab.frame.size.height+15, 80, 12)];
        numerLab.text=[[LockListDataArr objectAtIndex:i]objectForKey:@"lockCode"];
        numerLab.textAlignment =NSTextAlignmentCenter;
        numerLab.font =[UIFont systemFontOfSize:12];
        numerLab.textColor=[UIColor orangeColor];
        numerLab.tag=i+400;
        [mainBtn addSubview:numerLab];
    }
    
    //默认--选择预约车位--第一个地锁编码
    UILabel *lab=(UILabel *)[self.view viewWithTag:400];
    chooseLB.text=[NSString stringWithFormat:@"选择预约车位：%@",lab.text];
    
    //分隔线
    UIView * secondLineView=[[UIView alloc]initWithFrame:CGRectMake(0, scroller.frame.origin.y+scroller.frame.size.height+8, ScreenWidth, 1)];
    secondLineView.backgroundColor =Color(237, 237, 237, 1);
    [mainView addSubview:secondLineView];
    
   
    //横向滑动视图--时间
    UIScrollView *timeScroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0,secondLineView.frame.origin.y+9, ScreenWidth, 35)];
    timeScroller.contentSize=CGSizeMake(2*90+10, 35);
    timeScroller .showsHorizontalScrollIndicator=NO;
    [mainView addSubview:timeScroller];
    
    NSArray *arr=[[queryAppointmentListDataDic objectForKey:@"result"]objectForKey:@"appointList"];
    for (int i=0; i<arr.count; i++)
    {
        UIButton *timeBtn =[[UIButton alloc]initWithFrame:CGRectMake(10+i%5*90, 5, 80, 25)];
        timeBtn.layer.borderWidth=1;
        
        //默认第一个边框为红色
        if (i==0)
        {
             timeBtn.layer.borderColor=Color(196, 26, 22, 1).CGColor;
        }else
        {
             timeBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        }
       
        timeBtn.layer.cornerRadius =3;
        
         [timeBtn setTitle:[NSString stringWithFormat:@"预约%@分钟",[[[queryAppointmentListDataDic objectForKey:@"result"]objectForKey:@"appointList"][i] objectForKey:@"appointTime"]] forState:UIControlStateNormal];
        timeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [timeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [timeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        timeBtn.tag=i+100;
        [timeScroller addSubview:timeBtn];
        
        
        currentTimeBtn=100;
    }
    appointPretime=[[[queryAppointmentListDataDic objectForKey:@"result"]objectForKey:@"appointList"][0] objectForKey:@"appointTime"];
    
    UILabel *priceLB=[[UILabel alloc]initWithFrame:CGRectMake(10, timeScroller.frame.size.height+timeScroller.frame.origin.y, 100, 20)];
    priceLB.text=@"预约价格：";
    priceLB.font=[UIFont systemFontOfSize:14];
    [mainView addSubview:priceLB];
    
    moneyLB=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-120, priceLB.frame.origin.y, 110, 20)];
    moneyLB.text=[NSString stringWithFormat:@"¥%d",[[[[queryAppointmentListDataDic objectForKey:@"result"]objectForKey:@"appointList"][0]objectForKey:@"appointPrice"] intValue]/100];
    moneyLB.textColor=[UIColor orangeColor];
    moneyLB.textAlignment=NSTextAlignmentRight;
    moneyLB.font=[UIFont systemFontOfSize:13];
    [mainView addSubview:moneyLB];
    
    appointPrice=[[[queryAppointmentListDataDic objectForKey:@"result"]objectForKey:@"appointList"][0]objectForKey:@"appointPrice"];
    
    //分隔线
    UIView * thirdlyLineView=[[UIView alloc]initWithFrame:CGRectMake(0, priceLB.frame.origin.y+priceLB.frame.size.height+3, ScreenWidth, 1)];
    thirdlyLineView.backgroundColor =Color(237, 237, 237, 1);
    [mainView addSubview:thirdlyLineView];
    
    numberLB=[[UILabel alloc]initWithFrame:CGRectMake(10, thirdlyLineView.frame.origin.y+6, 200, 20)];
    numberLB.text=[NSString stringWithFormat:@"剩余车位：%@",[[lockListDataDic objectForKey:@"result"]objectForKey:@"count"]];
    numberLB.font=[UIFont systemFontOfSize:14];
    [mainView addSubview:numberLB];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, numberLB.frame.origin.y+numberLB.frame.size.height+5, ScreenWidth-20, 35)];
    saveBtn.backgroundColor=[UIColor orangeColor];
    [saveBtn setTitle:@"立即预定" forState:UIControlStateNormal];
    saveBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    saveBtn.layer.cornerRadius=3;
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:saveBtn];
    
}

#pragma  mark---btnClick
-(void)saveBtnClick:(UIButton *)sender
{
    NSLog(@"立即预定");
    if (lockCode==nil)
    {
        [self showToast:@"请选择地锁"];
    }else
    {
        [self appointLockByAp];
    }
    
   
}
-(void)timeBtnClick:(UIButton *)sender
{
    NSLog(@"选择预约时间");
    UIButton *btn=(UIButton *)[self.view viewWithTag:currentTimeBtn];
    btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    sender.layer.borderColor=Color(196, 26, 22, 1).CGColor;
    currentTimeBtn=sender.tag;
    appointPretime=[[[queryAppointmentListDataDic objectForKey:@"result"]objectForKey:@"appointList"][sender.tag-100] objectForKey:@"appointTime"];
    
    
}
-(void)mainBtnClick:(UIButton *)sender
{
    NSLog(@"选择预约地锁");
    UIButton *btn=(UIButton *)[self.view viewWithTag:currentMainBtn];
    btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    sender.layer.borderColor=Color(196, 26, 22, 1).CGColor;
    
    currentMainBtn=sender.tag;
    
    UILabel *lab=(UILabel *)[self.view viewWithTag:sender.tag+100];
    chooseLB.text=[NSString stringWithFormat:@"选择预约车位：%@",lab.text];
    
    lockCode=lab.text;
}

#pragma mark ----地锁列表数据请求
-(void)LockListData
{
   
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token,
                                 @"token",
                                 userid,
                                 @"userid",
                                 parkId,
                                 @"parkId",
                                 nil];
    //防止循环引用
    __weak FLYSubscribeVC *ref = self;
    [FLYDataService requestWithURL:getLockList_API params:dict httpMethod:@"POST" completeBolck:^(id result)
     {
         NSString *str=[result JSONString];
         lockListDataDic = [NSMutableDictionary dictionaryWithDictionary:result];
         LockListDataArr =(NSArray *)[[lockListDataDic objectForKey:@"result"]objectForKey:@"lockList"];
         NSString *statusStr = [lockListDataDic objectForKey:@"flag"] ;
         if ([statusStr isEqualToString:@"0"])
         {
             NSLog(@"请求成功");
             
             [self queryAppointmentListData];
             
         }
         
     } errorBolck:^()
     {
         NSLog(@"请求失败");
         
     }];
}

#pragma mark ----价格 时间数据请求
-(void)queryAppointmentListData
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token,
                                 @"token",
                                 userid,
                                 @"userid",
                                 parkId,
                                 @"parkId",
                                 nil,
                                 @"count",
                                 nil,
                                 @"start",
                                 nil];
    //防止循环引用
    __weak FLYSubscribeVC *ref = self;
    [FLYDataService requestWithURL:queryAppointmentList_API params:dict httpMethod:@"POST" completeBolck:^(id result)
     {
         NSString *str=[result JSONString];
         queryAppointmentListDataDic = [NSMutableDictionary dictionaryWithDictionary:result];
         NSString *statusStr = [queryAppointmentListDataDic objectForKey:@"flag"] ;
         if ([statusStr isEqualToString:@"0"])
         {
             NSLog(@"请求成功");
             [self creatSubscribeParkView];//调用--停车预约视图
          }
         
     } errorBolck:^()
     {
         NSLog(@"请求失败");
         
     }];
}
#pragma mark ----立即预约
-(void)appointLockByAp
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    NSString *userid = [defaults stringForKey:@"memberId"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token,
                                 @"token",
                                 userid,
                                 @"userid",
                                 lockCode,
                                 @"lockAp",
                                 appointPrice,
                                 @"appointPrice",
                                 appointPretime,
                                 @"appointPretime",
                                 nil];
    //防止循环引用
    __weak FLYSubscribeVC *ref = self;
    [FLYDataService requestWithURL:appointLockByAp_API params:dict httpMethod:@"POST" completeBolck:^(id result)
     {
         NSString *str=[result JSONString];
         NSMutableDictionary *appointLockByApDic = [NSMutableDictionary dictionaryWithDictionary:result];
         NSString *statusStr = [appointLockByApDic objectForKey:@"flag"] ;
         if ([statusStr isEqualToString:@"0"])
         {
             NSLog(@"请求成功");
              [self showToast:@"立即预定成功"];
             [self.navigationController popViewControllerAnimated:YES];
//             [self switchLock];
         }else
         {
             
         }
         
     } errorBolck:^()
     {
         NSLog(@"请求失败");
         
     }];
}

@end
