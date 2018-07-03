//
//  ServiceStatisticsViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ServiceStatisticsViewController.h"
#import "YLButton.h"

@interface ServiceStatisticsViewController (){
    YLButton *btnStartTime;
    YLButton *btnEndTime;
    
    UIButton *btnMonth;
    UIButton *btnWeek;
    UIButton *btnDay;
    UIButton *btnDateTime;
    NSUserDefaults * userDefaults;
    
    NSString *time_flag;
    
    UIView *shopview;
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;
    UILabel *shopOrderNumTitle;
    UILabel *shopOrderZeTitle;
    UILabel *shopOrderjzNumTitle;
    UILabel *shopOrderNum;
    UILabel *shopOrderZe;
    UILabel *shopOrderjzNum;
    
    UIView* dataPicker;
    UIDatePicker *date;
    
    NSString *starttime;
    NSString *endtime;
    
    int timespos;
}

@end

@implementation ServiceStatisticsViewController
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
    self.navigationItem.title = @"服务统计";
    // Do any additional setup after loading the view.
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    time_flag = @"3";
    [self makeUI];
    [self servicetais];
}
- (void)makeUI{
    btnStartTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnStartTime setFont:[UIFont systemFontOfSize:15]];
    [btnStartTime customButtonWithFrame1:CGRectMake(10, 10,(kWidth-10-10)/2, 40) title:@"开始日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnStartTime setFont:[UIFont systemFontOfSize:12]];
    [btnStartTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnStartTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnStartTime.layer.borderWidth = 0.5;
    btnStartTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnStartTime];
    [btnStartTime addTarget:self action:@selector(selectStartTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    btnEndTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnEndTime setFont:[UIFont systemFontOfSize:15]];
    [btnEndTime customButtonWithFrame1:CGRectMake(kWidth-((kWidth-10-10)/2)-10, 10,(kWidth-10-10)/2, 40) title:@"结束日期" rightImage:[UIImage imageNamed:@"canlo"]];
    [btnEndTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btnEndTime setFont:[UIFont systemFontOfSize:12]];
    btnEndTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnEndTime.layer.borderWidth = 0.5;
    btnEndTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:btnEndTime];
    [btnEndTime addTarget:self action:@selector(selectEndTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(10, 40+10+10, 50, 30)];
    [btnMonth setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMonth setTitle:@"月" forState:UIControlStateNormal];
    [btnMonth setFont:[UIFont systemFontOfSize:12]];
    [btnMonth addTarget:self action:@selector(monthClick) forControlEvents:UIControlEventTouchUpInside];
    btnMonth.layer.cornerRadius = 5;
    [self.view addSubview:btnMonth];
    
    btnWeek = [[UIButton alloc] initWithFrame:CGRectMake(10+50+10,40+10+10, 50, 30)];
    [btnWeek setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnWeek setTitle:@"周" forState:UIControlStateNormal];
     [btnWeek setFont:[UIFont systemFontOfSize:12]];
    [btnWeek addTarget:self action:@selector(weekClick) forControlEvents:UIControlEventTouchUpInside];
    btnWeek.layer.cornerRadius = 5;
    [self.view addSubview:btnWeek];
    
    btnDay = [[UIButton alloc] initWithFrame:CGRectMake(10+50+10+50+10, 40+10+10, 50, 30)];
    [btnDay setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDay setTitle:@"日" forState:UIControlStateNormal];
    [btnDay addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    btnDay.layer.cornerRadius = 5;
      [btnDay setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:btnDay];
    
    btnDateTime = [[UIButton alloc] initWithFrame:CGRectMake(10+50+10+50+10+50+10, 40+10+10, 60, 30)];
    [btnDateTime setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnDateTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDateTime setTitle:@"按日期" forState:UIControlStateNormal];
    [btnDateTime setFont:[UIFont systemFontOfSize:12]];
    [btnDateTime addTarget:self action:@selector(dateTimeClick) forControlEvents:UIControlEventTouchUpInside];
    btnDateTime.layer.cornerRadius = 5;
    [self.view addSubview:btnDateTime];
    
    
    shopview = [[UIView alloc] initWithFrame:CGRectMake(10, 40+10+10+10+20+10, kWidth-10-10, 170)];
    [shopview setBackgroundColor:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1]];
    shopview.layer.cornerRadius = 10;
    [self.view addSubview:shopview];
    
    
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    [img1 setImage:[UIImage imageNamed:@"num"]];
    [shopview addSubview:img1];
    
    shopOrderNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+10, 20, 120, 30)];
    [shopOrderNumTitle setText:@"服务数量:"];
    [shopOrderNumTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderNumTitle];
    
    shopOrderNum = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+120, 20, 100, 30)];
    [shopOrderNum setText:@"100"];
    [shopOrderNum setFont:[UIFont systemFontOfSize:12]];
    shopOrderNum.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderNum];
    
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+30+20, 20, 20)];
    [img2 setImage:[UIImage imageNamed:@"price"]];
    [shopview addSubview:img2];
    
    shopOrderZeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+10, 20+30+20, 120, 30)];
    [shopOrderZeTitle setText:@"订单数量:"];
     [shopOrderZeTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderZeTitle];
    
    shopOrderZe = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+120, 20+30+20, 100, 30)];
    [shopOrderZe setText:@"100"];
    [shopOrderZe setFont:[UIFont systemFontOfSize:12]];
    shopOrderZe.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderZe];
    
    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+30+20+30+20, 20, 20)];
    [img3 setImage:[UIImage imageNamed:@"orderprice"]];
    [shopview addSubview:img3];
    
    shopOrderjzNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+10, 20+30+20+30+20, 120, 30)];
    [shopOrderjzNumTitle setText:@"结账订单数量:"];
    [shopOrderjzNumTitle setFont:[UIFont systemFontOfSize:12]];
    [shopview addSubview:shopOrderjzNumTitle];
    
    shopOrderjzNum = [[UILabel alloc] initWithFrame:CGRectMake(20+20+10+120, 20+30+20+30+20, 100, 30)];
    [shopOrderjzNum setText:@"100"];
    [shopOrderjzNum setFont:[UIFont systemFontOfSize:12]];
    shopOrderjzNum.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [shopview addSubview:shopOrderjzNum];
    
    
    
    
}
-(void)selectStartTimeClick{
    timespos = 0;
    dataPicker = nil;
    [self dataChoose];
}
-(void)selectEndTimeClick{
    timespos = 1;
    dataPicker = nil;
    [self dataChoose];
}
-(void)servicetais{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,SERVICESTSTICS];
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
            
            NSDictionary *dic1 = dateArray[0];
            NSNumber *zs = [dic1 objectForKey:@"SERVICE_COUNT"];
            NSString *SERVICE_COUNT = [zs stringValue];
            NSDictionary *dic2 = dateArray[1];
            NSNumber *ze = [dic2 objectForKey:@"ORDER_COUNT"];
            NSString *ORDER_COUNT = [ze stringValue];
             NSDictionary *dic3 = dateArray[2];
            NSNumber *co = [dic3 objectForKey:@"ORDER_CHECK_COUNT"];
            NSString *ORDER_CHECK_COUNT = [co stringValue];
            
            
            
            shopOrderZe.text = SERVICE_COUNT;
            
            shopOrderNum.text = ORDER_COUNT;
            
            shopOrderjzNum.text = ORDER_CHECK_COUNT;
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
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
    [self servicetais];
}

-(void)weekClick{
    time_flag = @"2";
    [self servicetais];
}

-(void)dateClick{
    time_flag = @"1";
    [self servicetais];
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
       [self servicetais];
    }
    
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
