//
//  TableStatisticsViewController.m
//  MXrestaurant
//
//  Created by MX on 2019/10/24.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "TableStatisticsViewController.h"
#import "YLButton.h"
#import "TableStaticsTableViewCell.h"
#import "TableInfoModel.h"
@interface TableStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tabSalesFood;
    YLButton *btnStartTime;
    YLButton *btnEndTime;
    
    UIButton *btnMonth;
    UIButton *btnWeek;
    UIButton *btnDay;
    UIButton *btnDateTime;
    
    UIView *footView;
    UILabel *labFoodName;
    UILabel *labOrderNumber;
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

@implementation TableStatisticsViewController

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
    self.navigationItem.title = @"桌台统计";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self setupTableView];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        UIBarButtonItem * negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width=-15;
        self.navigationItem.rightBarButtonItems=@[negativeSpacer,rightBtnItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightBtnItem;
    }
    
    
    btnStartTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnStartTime setFont:[UIFont systemFontOfSize:14]];
    [btnStartTime customButtonWithFrame1:CGRectMake(10, 10,(kWidth-10-10)/2, 40) title:@"开始日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnStartTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnStartTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnStartTime.layer.borderWidth = 0.5;
    btnStartTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnStartTime];
    [btnStartTime addTarget:self action:@selector(selectStartTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    btnEndTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnEndTime setFont:[UIFont systemFontOfSize:14]];
    [btnEndTime customButtonWithFrame1:CGRectMake(kWidth-((kWidth-10-10)/2)-10, 10,(kWidth-10-10)/2, 40) title:@"结束日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnEndTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnEndTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnEndTime.layer.borderWidth = 0.5;
    btnEndTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnEndTime];
    [btnEndTime addTarget:self action:@selector(selectEndTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+10+10, kWidth, 30)];
    [footView setBackgroundColor:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1]];
    [self.view addSubview:footView];
    
    labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth/4-20, 30)];
    [labFoodName setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labFoodName setText:@"餐桌号"];
    [labFoodName setFont:[UIFont systemFontOfSize:12]];
    [footView addSubview:labFoodName];
    
    labOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/4, 0, kWidth/4-20, 30)];
    [labOrderNumber setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labOrderNumber setText:@"订单数量"];
    [labOrderNumber setFont:[UIFont systemFontOfSize:12]];
    [footView addSubview:labOrderNumber];
    
    
    labStaNum = [[UILabel alloc] initWithFrame:CGRectMake((kWidth/4)*2, 0, kWidth/4, 30)];
    [labStaNum setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labStaNum setText:@"销售数量"];
    [labStaNum setFont:[UIFont systemFontOfSize:12]];
    [footView addSubview:labStaNum];
    
    
    labTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-(kWidth/4), 0, kWidth/4, 30)];
    [labTotalPrice setTextColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [labTotalPrice setText:@"销售金额"];
    [labTotalPrice setFont:[UIFont systemFontOfSize:12]];
    [footView addSubview:labTotalPrice];
    
    
    tabSalesFood = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+10+30+10, kWidth, kHeight-( 40+10+30)) style:UITableViewStylePlain];
    tabSalesFood.delegate = self;
    tabSalesFood.dataSource = self;
    [self.view addSubview:tabSalesFood];
    
    nodateView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+10+30+10, kWidth, kHeight-( 40+10+30))];
    [nodateView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgNodate = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-(196/2), 80, 196, 128)];
    [imgNodate setImage:[UIImage imageNamed:@"common_nodata"]];
    [nodateView addSubview:imgNodate];
    [self.view addSubview:nodateView];
}

-(void)rightBtnButtonClick{
    if (starttime==nil) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (endtime==nil){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }else{
        [self headerRereshing];
    }
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

-(void)dismiss{
    [dataPicker removeFromSuperview];
    dataPicker = nil;
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

-(void)dateTimeClick{
    if (starttime==nil) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (endtime==nil){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }else{
        [self selectgoodstatic];
    }
    
}


// 查询桌台统计信息
- (void)selectgoodstatic{
    if (starttime==nil) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (endtime==nil){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETTABLESST];
    NSDictionary *parameters;
    
    parameters = @{@"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                   @"start_date":starttime,
                   @"end_date": endtime,
                   @"page_no":[NSString stringWithFormat:@"%d",page]
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
                NSString *table_name = [dic objectForKey:@"table_name"];
                NSNumber *sacon =[dic objectForKey:@"sales_count"];
                NSString *sales_count = [sacon stringValue];
                NSNumber *order_num = [dic objectForKey:@"order_count"];
                NSString *order_count = [order_num stringValue];

                TableInfoModel *model = [[TableInfoModel alloc] init];
                model.table_name = table_name;
                model.sales_count =sales_count;
                model.order_count = order_count;
                model.sales_payment = [NSString stringWithFormat:@"%2f",[[dic objectForKey:@"sales_payment"] doubleValue]];
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
    TableStaticsTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
    if (tabcell==nil) {
        tabcell = [[TableStaticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    TableInfoModel *model = self.dateArray[indexPath.section];
    tabcell.labFoodName.text = model.table_name;
    tabcell.labOrderNumber.text = model.order_count;
    tabcell.labStaNum.text = model.sales_count;
    tabcell.labTotalPrice.text = model.sales_payment;
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

@end
