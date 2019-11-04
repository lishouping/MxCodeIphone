//
//  SalesStatisticsViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "SalesStatisticsViewController.h"
#import "YLButton.h"
#import "StatisFoodTableViewCell.h"
#import "FoodStatisModel.h"

@interface SalesStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tabSalesFood;
    YLButton *btnStartTime;
    YLButton *btnEndTime;
    
    UIButton *btnMonth;
    UIButton *btnWeek;
    UIButton *btnDay;
    UIButton *btnDateTime;
    
    UIView *footView;
    UILabel *labFoodName;
    UILabel *labStaNum;
    UILabel *labTotalPrice;
    
    NSUserDefaults * userDefaults;
    
    NSString *time_flag;
    
    UIView *shopview;
    UIImageView *img1;
    UIImageView *img2;
    UILabel *shopOrderNumTitle;
    UILabel *shopOrderZeTitle;
    UILabel *shopOrderNum;
    UILabel *shopOrderZe;
    
    UIView* dataPicker;
    UIDatePicker *date;
    
    NSString *starttime;
    NSString *endtime;
    
    int timespos;
    
    int page;
    int totalnum;
    
    UIView *nodateView;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation SalesStatisticsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"销售统计";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    time_flag = @"3";
    [self makeUI];
    [self setupTableView];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    LMJTab * tab = [[LMJTab alloc] initWithFrame:CGRectMake(10, 10, kWidth-10-10, 30) lineWidth:1 lineColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1]];
    [tab setItemsWithTitle:[NSArray arrayWithObjects:@"菜品统计",@"订单统计", nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] normalTitleColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] selectTitleColor:[UIColor whiteColor] titleTextSize:12 selectItemNumber:0];
    tab.delegate = self;
    tab.layer.cornerRadius = 5.0;
    [self.view addSubview:tab];
    
    btnStartTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnStartTime setFont:[UIFont systemFontOfSize:14]];
    [btnStartTime customButtonWithFrame1:CGRectMake(10, 30+10+10,(kWidth-10-10)/2, 40) title:@"开始日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnStartTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnStartTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnStartTime.layer.borderWidth = 0.5;
    [btnStartTime setFont:[UIFont systemFontOfSize:12]];
    btnStartTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnStartTime];
    [btnStartTime addTarget:self action:@selector(selectStartTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    btnEndTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnEndTime setFont:[UIFont systemFontOfSize:14]];
    [btnEndTime customButtonWithFrame1:CGRectMake(kWidth-((kWidth-10-10)/2)-10, 30+10+10,(kWidth-10-10)/2, 40) title:@"结束日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnEndTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnEndTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnEndTime.layer.borderWidth = 0.5;
     [btnEndTime setFont:[UIFont systemFontOfSize:12]];
    btnEndTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnEndTime];
    [btnEndTime addTarget:self action:@selector(selectEndTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(10, 30+10+40+10+10, 50, 30)];
    [btnMonth setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMonth setTitle:@"月" forState:UIControlStateNormal];
    [btnMonth setFont:[UIFont systemFontOfSize:12]];
    [btnMonth addTarget:self action:@selector(monthClick) forControlEvents:UIControlEventTouchUpInside];
    btnMonth.layer.cornerRadius = 5;
    [self.view addSubview:btnMonth];
    
    btnWeek = [[UIButton alloc] initWithFrame:CGRectMake(10+50+10, 30+10+40+10+10, 50, 30)];
    [btnWeek setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnWeek setTitle:@"周" forState:UIControlStateNormal];
    [btnWeek setFont:[UIFont systemFontOfSize:12]];
    [btnWeek addTarget:self action:@selector(weekClick) forControlEvents:UIControlEventTouchUpInside];
    btnWeek.layer.cornerRadius = 5;
    [self.view addSubview:btnWeek];
    
    btnDay = [[UIButton alloc] initWithFrame:CGRectMake(10+50+10+50+10, 30+10+40+10+10, 50, 30)];
    [btnDay setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDay setTitle:@"日" forState:UIControlStateNormal];
    [btnDay setFont:[UIFont systemFontOfSize:12]];
    [btnDay addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    btnDay.layer.cornerRadius = 5;
    [self.view addSubview:btnDay];
    
    btnDateTime = [[UIButton alloc] initWithFrame:CGRectMake(10+50+10+50+10+50+10, 30+10+40+10+10, 60, 30)];
    [btnDateTime setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnDateTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDateTime setTitle:@"按日期" forState:UIControlStateNormal];
     [btnDateTime setFont:[UIFont systemFontOfSize:12]];
    [btnDateTime addTarget:self action:@selector(dateTimeClick) forControlEvents:UIControlEventTouchUpInside];
    btnDateTime.layer.cornerRadius = 5;
    [self.view addSubview:btnDateTime];
    
    
    shopview = [[UIView alloc] initWithFrame:CGRectMake(10, 30+10+40+10+10+10+20+10, kWidth-10-10, 120)];
    [shopview setBackgroundColor:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1]];
    shopview.layer.cornerRadius = 10;
    [self.view addSubview:shopview];
    shopview.hidden = YES;
    
    
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+5, 20, 20)];
    [img1 setImage:[UIImage imageNamed:@"num"]];
    [shopview addSubview:img1];
    
    shopOrderNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10, 20, 120, 30)];
    [shopOrderNumTitle setText:@"定单数:"];
    [shopOrderNumTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderNumTitle];
    
    shopOrderNum = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+120, 20, 100, 30)];
    [shopOrderNum setText:@"100"];
    [shopOrderNum setFont:[UIFont systemFontOfSize:12]];
    shopOrderNum.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderNum];
    
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+30+20+5, 20, 20)];
    [img2 setImage:[UIImage imageNamed:@"price"]];
    [shopview addSubview:img2];
    
    shopOrderZeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10, 20+30+20, 120, 30)];
    [shopOrderZeTitle setText:@"店铺总销售额:"];
    [shopOrderZeTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderZeTitle];
    
    shopOrderZe = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+120, 20+30+20, 100, 30)];
    [shopOrderZe setText:@"100"];
    [shopOrderZe setFont:[UIFont systemFontOfSize:12]];
    shopOrderZe.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderZe];
    
    
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+10+40+10+10+10+20+10, kWidth, 30)];
    [footView setBackgroundColor:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1]];
    [self.view addSubview:footView];
    
    labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth/2-20, 30)];
    [labFoodName setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labFoodName setText:@"菜品名称"];
    [labFoodName setFont:[UIFont systemFontOfSize:12]];
    [footView addSubview:labFoodName];
    
    
    labStaNum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-20, 0, kWidth/2/2, 30)];
    [labStaNum setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labStaNum setText:@"销售数量"];
       [labStaNum setFont:[UIFont systemFontOfSize:12]];
     //[footView addSubview:labStaNum];
 
    
    labTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-(kWidth/2/2), 0, kWidth/2/2, 30)];
    [labTotalPrice setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labTotalPrice setText:@"销售额排行"];
     [labTotalPrice setFont:[UIFont systemFontOfSize:12]];
     [footView addSubview:labTotalPrice];
    
    
    tabSalesFood = [[UITableView alloc] initWithFrame:CGRectMake(0, 30+10+40+10+10+10+20+10+30+10, kWidth, kHeight-(30+10+40+10+10+10+20+10+30+10+50+10)) style:UITableViewStylePlain];
    tabSalesFood.delegate = self;
    tabSalesFood.dataSource = self;
    [self.view addSubview:tabSalesFood];
    
    nodateView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+10+40+10+10+10+20+10+30+10, kWidth, kHeight-(30+10+40+10+10+10+20+10+30+10+50+10))];
    [nodateView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgNodate = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-(196/2), 80, 196, 128)];
    [imgNodate setImage:[UIImage imageNamed:@"common_nodata"]];
    [nodateView addSubview:imgNodate];
    [self.view addSubview:nodateView];
    
}
-(void)selectStartTimeClick{
    if (timespos ==1) {
        [self dismiss];
    }
    timespos = 0;
    dataPicker = nil;
    [self dataChoose];
}
-(void)selectEndTimeClick{
    if (timespos ==0) {
        [self dismiss];
    }
    timespos = 1;
    dataPicker = nil;
    [self dataChoose];
}

//加上刷新控件
-(void)setupTableView
{
    //下拉刷新
    [tabSalesFood addHeaderWithTarget:self action:@selector(headerRereshing)];
    //上拉加载
    [tabSalesFood addFooterWithTarget:self action:@selector(footerRereshing)];
}


//下拉
- (void)headerRereshing
{
    [self.dateArray removeAllObjects];
    [tabSalesFood reloadData];
    page=1;
    [self selectgoodstatic];
}
//上拉
-(void)footerRereshing
{
    page++;
    [self selectgoodstatic];
}

- (void)dataChoose{
    dataPicker= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 216+44)];
    [dataPicker setBackgroundColor:[UIColor whiteColor]];
    date=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 216)];
    [date setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    date.datePickerMode=UIDatePickerModeDateAndTime;
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    toolbar.barTintColor=[UIColor whiteColor];
    toolbar.frame=CGRectMake(0, 0, kWidth, 44);
    UIBarButtonItem *item0=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss) ];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    toolbar.items = @[item0, item2, item3];
    [dataPicker addSubview:date];
    [dataPicker addSubview:toolbar];
    [self.view addSubview:dataPicker];
}
- (void)done
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date.date];
    
    if (timespos ==0) {
        starttime = destDateString;
        [btnStartTime setTitle:starttime forState:UIControlStateNormal];
    }else{
        endtime = destDateString;
        [btnEndTime setTitle:endtime forState:UIControlStateNormal];
    }
    
    [dataPicker removeFromSuperview];
    dataPicker = nil;
}
-(void)dismiss{
    [dataPicker removeFromSuperview];
    dataPicker = nil;
}


-(void)monthClick{
    time_flag = @"3";
    [self getMonthBeginAndEndWith];
    [self selectgoodstatic];
    [self selecShopSt];
}

-(void)weekClick{
     time_flag = @"2";
    [self getWeekBeginAndEndWith];
    [self selectgoodstatic];
    [self selecShopSt];
}

-(void)dateClick{
     time_flag = @"1";
    [self getNowDate];
    [self selectgoodstatic];
    [self selecShopSt];
}
-(void)dateTimeClick{
    if (starttime==nil) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (endtime==nil){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }else{
        time_flag = @"-1";
        [self selectgoodstatic];
        [self selecShopSt];
    }
   
}



-(void)tab:(LMJTab *)tab didSelectedItemNumber:(NSInteger)number{
    NSLog(@"CLICKED:%ld",number);
    if (number==0) {
        footView.hidden = NO;
        tabSalesFood.hidden = NO;
        shopview.hidden = YES;
        if(self.dateArray.count==0){
            nodateView.hidden = NO;
        }else{
            nodateView.hidden = YES;
        }
    }else if (number==1){
        footView.hidden = YES;
        tabSalesFood.hidden = YES;
        shopview.hidden = NO;
        nodateView.hidden = YES;
    }
}

// 查询菜品统计信息
- (void)selectgoodstatic{
    if (starttime==nil) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (endtime==nil){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }
    if (self.dateArray.count>0) {
        [self.dateArray removeAllObjects];
        [tabSalesFood reloadData];
    }
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETFOODSSTATICS];
    NSDictionary *parameters;
    
    parameters = @{@"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                   @"start_date":starttime,
                   @"end_date": endtime,
                   @"page_no":@"1"
                   };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *key =[userDefaults objectForKey:@"login_key_MX"];
    NSString *longbusid = [[userDefaults objectForKey:@"business_id_MX"] stringValue];
    
    [manager.requestSerializer setValue:key forHTTPHeaderField:@"key"];
    [manager.requestSerializer setValue:longbusid forHTTPHeaderField:@"id"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            NSDictionary *myDic = [responseObject objectForKey:@"DATA"];
            NSArray *dateArray = [myDic objectForKey:@"list"];
            
            if (dateArray.count==0) {
                nodateView.hidden = NO;
                [tabSalesFood footerEndRefreshing];
                [tabSalesFood headerEndRefreshing];
                [tabSalesFood reloadData];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"无更多数据" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                return ;
            }
            
            for (NSDictionary * dic in dateArray)
            {
                NSString *GOOD_NAME = [dic objectForKey:@"GOOD_NAME"];
                NSString *good_ze = [dic objectForKey:@"total_sales_count"];
                
                FoodStatisModel *model = [[FoodStatisModel alloc] init];
                model.food_name = GOOD_NAME;
                model.food_price = good_ze;
                [self.dateArray addObject:model];
            }
            
             nodateView.hidden = YES;
   
            [tabSalesFood headerEndRefreshing];
            [tabSalesFood footerEndRefreshing];
            
            [tabSalesFood reloadData];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"MESSAGE"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}

// 查询订单统计接口
- (void)selecShopSt{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,SHOPSTATIS];
    NSDictionary *parameters;
    
    if ([time_flag isEqualToString:@"-1"]) {
        parameters = @{@"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                       @"start_time":starttime,
                       @"end_time": endtime
                       };
    }else{
        parameters = @{@"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                       @"time_flag": time_flag
                       };
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *key =[userDefaults objectForKey:@"login_key_MX"];
    NSString *longbusid = [[userDefaults objectForKey:@"business_id_MX"] stringValue];
    
    [manager.requestSerializer setValue:key forHTTPHeaderField:@"key"];
    [manager.requestSerializer setValue:longbusid forHTTPHeaderField:@"id"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            NSArray *dateArray = [responseObject objectForKey:@"DATA"];
            for (NSDictionary * dic in dateArray)
            {

                NSNumber *zs = [dic objectForKey:@"zs"];
                NSString *good_zs = [zs stringValue];
                
                if ([[dic objectForKey:@"ze"] isEqual:[NSNull null]]) {
                     shopOrderZe.text = @"0";
                }else{
                    NSNumber *ze = [dic objectForKey:@"ze"];
                    NSString *good_ze = [ze stringValue];
                    shopOrderZe.text = good_ze;
                }
                
                
                
                shopOrderNum.text = good_zs;
                
                
            }
            [tabSalesFood reloadData];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"MESSAGE"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 30.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatisFoodTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
    if (tabcell==nil) {
        tabcell = [[StatisFoodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    FoodStatisModel *model = self.dateArray[indexPath.section];
    
    tabcell.labNum.text = [NSString stringWithFormat:@"%ld",indexPath.section+1];
    tabcell.labFoodName.text = model.food_name;
    
    tabcell.labStatisNum.text = @"";
    tabcell.labTotalPrice.text = [NSString stringWithFormat:@"%@",model.food_price];
    
    return tabcell;
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




// 获取当前时间
- (void)getNowDate{
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:ss"];
    
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *newDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    newDate = [newDate dateByAddingTimeInterval:interval];
    
    NSString *nowDateString = [dateFormatter stringFromDate:newDate];
    
    starttime = nowDateString;
    endtime = nowDateString;

}

// 获取周
- (void)getWeekBeginAndEndWith{
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
    
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    /**获取当几个月*/
    NSInteger monthDay = [comp month];
    NSLog(@"%ld",monthDay);
    // 获取几天是几号
    NSInteger day = [comp day];
    
    NSLog(@"%ld----%ld",weekDay,day);
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    // 在当前日期(去掉时分秒)基础上加上差的天数
    
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:nowDate];
    
    [firstDayComp setDay:day + firstDiff];
    
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay   fromDate:nowDate];
    
    [lastDayComp setDay:day + lastDiff];
    
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:ss"];
    
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    
    starttime = firstDay;
    endtime = lastDay;
}

- (void)getMonthBeginAndEndWith{
    NSDate *nowDate = [NSDate date];
    if (nowDate == nil) {
        nowDate = [NSDate date];
    }
    
    double interval = 0;
    
    NSDate *beginDate = nil;
    
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];
    
    //设定周一为周首日
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:nowDate]; //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    
    if (ok) {
        
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        
    }else {
        
        return;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd hh:ss"];
    
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    starttime = beginString;
    endtime = endString;
    
    
    
}

@end
