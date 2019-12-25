//
//  MemberStatisticsViewController.m
//  MXrestaurant
//
//  Created by MX on 2019/10/24.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "MemberStatisticsViewController.h"
#import "YLButton.h"
#import "MemberTableViewCell.h"
#import "TableInfoModel.h"

@interface MemberStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>{
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

@implementation MemberStatisticsViewController

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
    self.navigationItem.title = @"会员统计";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    
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
      [btnStartTime setFont:[UIFont systemFontOfSize:12]];
    [btnStartTime addTarget:self action:@selector(selectStartTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    btnEndTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnEndTime setFont:[UIFont systemFontOfSize:12]];
    [btnEndTime customButtonWithFrame1:CGRectMake(kWidth-((kWidth-10-10)/2)-10, 10,(kWidth-10-10)/2, 40) title:@"结束日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnEndTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnEndTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnEndTime.layer.borderWidth = 0.5;
    btnEndTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnEndTime];
    [btnEndTime addTarget:self action:@selector(selectEndTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    shopview = [[UIView alloc] initWithFrame:CGRectMake(10, 40+10+10, kWidth-10-10, 120)];
    [shopview setBackgroundColor:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1]];
    shopview.layer.cornerRadius = 10;
    [self.view addSubview:shopview];
    
    
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+5, 20, 20)];
    [img1 setImage:[UIImage imageNamed:@"num"]];
    [shopview addSubview:img1];
    
    shopOrderNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10, 20, 120, 30)];
    [shopOrderNumTitle setText:@"会员充值金额:"];
    [shopOrderNumTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderNumTitle];
    
    shopOrderNum = [[UILabel alloc] initWithFrame:CGRectMake(10+120, 20, 100, 30)];
  
    [shopOrderNum setFont:[UIFont systemFontOfSize:12]];
    shopOrderNum.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderNum];
    
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+30+20+5, 20, 20)];
    [img2 setImage:[UIImage imageNamed:@"price"]];
    [shopview addSubview:img2];
    
    shopOrderZeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10, 20+30+20, 120, 30)];
    [shopOrderZeTitle setText:@"会员新开数量:"];
    [shopOrderZeTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderZeTitle];
    
    shopOrderZe = [[UILabel alloc] initWithFrame:CGRectMake(10+120, 20+30+20, 100, 30)];
    [shopOrderZe setFont:[UIFont systemFontOfSize:12]];
    shopOrderZe.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderZe];
    
    
    
    
    tabSalesFood = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+10+10+120+10, kWidth, kHeight-( 40+10+10+120+10)) style:UITableViewStylePlain];
    tabSalesFood.delegate = self;
    tabSalesFood.dataSource = self;
    [self.view addSubview:tabSalesFood];
    
    nodateView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+10+10+120+10, kWidth, kHeight-(40+10+10+120+10))];
    [nodateView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgNodate = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-(196/2/2), 80, 196/2, 128/2)];
    [imgNodate setImage:[UIImage imageNamed:@"common_nodata"]];
    [nodateView addSubview:imgNodate];
    UILabel *labNodata = [[UILabel alloc] initWithFrame:CGRectMake(0, 80+(128/2)+20, kWidth, 20)];
    [labNodata setText:@"暂无数据"];
    labNodata.textAlignment = NSTextAlignmentCenter;
    [labNodata setFont:[UIFont systemFontOfSize:12]];
    [nodateView addSubview:labNodata];
    
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

-(void)dismiss{
    [dataPicker removeFromSuperview];
    dataPicker = nil;
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

-(void)rightBtnButtonClick{
    if (starttime==nil) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (endtime==nil){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }else{
        [self selectgoodstatic1];
        [self selectgoodstatic2];
        [self selectgoodstatic3];
    }
}

//  根据日期段查询会员充值金额
- (void)selectgoodstatic1{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL_MEMBER,SUMBYDATE];
    NSDictionary *parameters;
    
    parameters = @{@"shopId":[userDefaults objectForKey:@"menmbers_shop_id"],
                   @"startDate":starttime,
                   @"endDate": endtime
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
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
            //NSNumber *num = [responseObject objectForKey:@"data"];
            //NSString *money = [num stringValue];
            
            NSString *money = [NSString stringWithFormat:@"￥%.2f",[[responseObject objectForKey:@"data"]doubleValue]];
            [shopOrderNum setText:money];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"MESSAGE"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}
//根据日期查询会员新开数量
- (void)selectgoodstatic2{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL_MEMBER,GETUSERCOUNT];
    NSDictionary *parameters;
    
    parameters = @{@"shopId":[userDefaults objectForKey:@"menmbers_shop_id"],
                   @"startDate":starttime,
                   @"endDate": endtime
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
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
            NSNumber *num = [responseObject objectForKey:@"data"];
            NSString *number = [num stringValue];
            [shopOrderZe setText:number];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"MESSAGE"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}

// 查询会员列表
- (void)selectgoodstatic3{
    if (self.dateArray.count>0) {
        [self.dateArray removeAllObjects];
        [tabSalesFood reloadData];
    }
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL_MEMBER,GETUSERCHARTS];
    NSDictionary *parameters;
    
    parameters = @{@"shopId":[userDefaults objectForKey:@"menmbers_shop_id"],
                   @"startDate":starttime,
                   @"endDate": endtime
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
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
            NSArray *dateArray = [responseObject objectForKey:@"data"];
            
            if (dateArray.count==0) {
                nodateView.hidden = NO;
                [self.dateArray removeAllObjects];
                return ;
            }
            
            for (NSDictionary * dic in dateArray)
            {

                NSNumber *sacon =[dic objectForKey:@"user_count"];
                NSString *user_count = [sacon stringValue];
                NSString *create_date = [dic objectForKey:@"create_date"];
                
                TableInfoModel *model = [[TableInfoModel alloc] init];
                model.sales_count =user_count;
                model.order_count = create_date;
                [self.dateArray addObject:model];
            }
            
            nodateView.hidden = YES;
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
    MemberTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
    if (tabcell==nil) {
        tabcell = [[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    TableInfoModel *model = self.dateArray[indexPath.section];
    NSString *cont = [NSString stringWithFormat:@"会员数量：%@",model.sales_count];
    tabcell.memberNum.text = cont;
    tabcell.memberNewNum.text = model.order_count;
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
