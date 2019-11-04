//
//  OrderUpdateViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/24.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "OrderUpdateViewController.h"

@interface OrderUpdateViewController ()<UIAlertViewDelegate,UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource>{
    UILabel *labOrderNumber;
    UILabel *labTableNumber;
    UILabel *labPersonNumber;
    UILabel *labSubOrderTime;
    
    NSUserDefaults * userDefaults;
    
    MBProgressHUD *hud;
    
    UIButton *btnFoodType;
    UIButton *btnSangcaiTime;
    UITextField *tfFoodNumber;
    UITextField *tfFoodResen;
    
    UIView *pickV;
    UIPickerView *pickerView;
    NSArray *dateArray;
    
    
    NSString *way;
    NSString *go_goods_way;
    
    UIButton *btnAdd;
    UIButton *btnSubmit;
    
    UILabel *labTotalPrice;
    
    NSString *order_num;
}


@end

@implementation OrderUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.navigationItem.title = @"订单详情";
    [self makeUI];
    [self loadDate];
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90)];
    headView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:headView];
    
    labTableNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    labTableNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labTableNumber];
    
    labOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(10,30, kWidth-10-10, 20)];
    labOrderNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labOrderNumber];
    
    labSubOrderTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kWidth-10-10, 20)];
    labSubOrderTime.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labSubOrderTime];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kWidth, 200)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIView *jcview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    [jcview setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:jcview];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab1.text = @"就餐方式:";
    [lab1 setFont:[UIFont systemFontOfSize:12]];
    [jcview addSubview:lab1];
    
    btnFoodType = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2, 10, kWidth/2-20, 20)];
    [btnFoodType setTitle:@"堂食" forState:UIControlStateNormal];
    [btnFoodType setFont:[UIFont systemFontOfSize:12]];
    [btnFoodType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFoodType setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [jcview addSubview:btnFoodType];
    btnFoodType.tag = 0;
    [btnFoodType addTarget:self action:@selector(btnFoodTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    way = @"1";
    
    
    UIView *shview = [[UIView alloc] initWithFrame:CGRectMake(0, 40+1, kWidth, 40)];
    [shview setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:shview];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab2.text = @"上菜方式:";
    [lab2 setFont:[UIFont systemFontOfSize:12]];
    [shview addSubview:lab2];
    
    
    btnSangcaiTime = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2, 10, kWidth/2-20, 20)];
    [btnSangcaiTime setTitle:@"做好即上" forState:UIControlStateNormal];
    [btnSangcaiTime setFont:[UIFont systemFontOfSize:12]];
    [btnSangcaiTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSangcaiTime setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [shview addSubview:btnSangcaiTime];
    btnSangcaiTime.tag = 1;
    [btnSangcaiTime addTarget:self action:@selector(btnFoodTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    go_goods_way = @"1";
    
    
    UIView *jcnuview = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40+2, kWidth, 40)];
    [jcnuview setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:jcnuview];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab3.text = @"就餐人数:";
    [lab3 setFont:[UIFont systemFontOfSize:12]];
    [jcnuview addSubview:lab3];
    
    tfFoodNumber = [[UITextField alloc] initWithFrame:CGRectMake(kWidth/2, 10,  kWidth/2-20, 20)];
    tfFoodNumber.placeholder = @"请输入就餐人数";
    tfFoodNumber.delegate = self;
    [tfFoodNumber setFont:[UIFont systemFontOfSize:12]];
    [jcnuview addSubview:tfFoodNumber];
    
    
    UIView *review = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40+40+3, kWidth, 40)];
    [review setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:review];
    
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab4.text = @"菜品备注:";
    [lab4 setFont:[UIFont systemFontOfSize:12]];
    [review addSubview:lab4];
    
    tfFoodResen = [[UITextField alloc] initWithFrame:CGRectMake(kWidth/2, 10,  kWidth/2-20, 20)];
    tfFoodResen.placeholder = @"请输入菜品备注";
    [tfFoodResen setFont:[UIFont systemFontOfSize:12]];
    tfFoodResen.delegate = self;
    [review addSubview:tfFoodResen];
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-TabBarHeight-TabbarSafeBottomMargin-80, kWidth, 80)];
    footV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footV];
    
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kWidth-10-10, 30)];
    [btnSubmit setTitle:@"修改订单" forState:UIControlStateNormal];
    [btnSubmit setFont:[UIFont systemFontOfSize:14]];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 5.0;
    [footV addSubview:btnSubmit];
    [btnSubmit addTarget:self action:@selector(subOrder) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfFoodNumber resignFirstResponder];
    [tfFoodResen resignFirstResponder];
    return YES;
}
-(void)loadDate{
    order_num = [self.mydic objectForKey:@"order_num"];
    [labOrderNumber setText:[NSString stringWithFormat:@"订单编号:%@",order_num]];
    
    NSDictionary *tableDic = [self.mydic objectForKey:@"table"];
    
    NSString *table_name = [tableDic objectForKey:@"table_name"];
    [labTableNumber setText:[NSString stringWithFormat:@"桌号:%@",table_name]];
    
    NSString *way = [[NSNumber numberWithLong:[[self.mydic objectForKey:@"way"]longValue]] stringValue];
    if ([way isEqualToString:@"1"]) {
        [btnFoodType setTitle:@"堂食" forState:UIControlStateNormal];
    }else{
        [btnFoodType setTitle:@"打包" forState:UIControlStateNormal];
    }
    NSString *go_goods_way = [[NSNumber numberWithLong:[[self.mydic objectForKey:@"go_goods_way"]longValue]] stringValue];
    
    if ([go_goods_way isEqualToString:@"1"]) {
        [btnSangcaiTime setTitle:@"做好即上" forState:UIControlStateNormal];
    }else{
        [btnSangcaiTime setTitle:@"等待叫起" forState:UIControlStateNormal];
    }
    
    NSString *order_time = [self.mydic objectForKey:@"create_time"];
    
    [labSubOrderTime setText:[NSString stringWithFormat:@"下单时间:%@",[self timeWithTimeIntervalString:order_time]]];
    
    NSString *comments = [self.mydic objectForKey:@"comments"];
    if ([comments isEqual:[NSNull null]]) {
        tfFoodResen.text = [NSString stringWithFormat:@"无"];
    }else{
        tfFoodResen.text = [NSString stringWithFormat:@"%@",comments];
    }
    
    NSString *people_count = [[NSNumber numberWithLong:[[self.mydic objectForKey:@"people_count"]longValue]] stringValue];
    tfFoodNumber.text = people_count;
}
-(void)subOrder{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,UPDATEORDERINFO];
    
    NSString *reseon;
    if (tfFoodResen.text.length == 0) {
        reseon = @"0";
    }else{
        reseon = tfFoodResen.text;
    }
    NSString *peopocont;
    if (tfFoodNumber.text.length == 0) {
        peopocont = @"0";
    }else{
        peopocont = tfFoodNumber.text;
    }
    NSDictionary *parameters = @{@"order_num": order_num,
                                 @"comments":reseon,
                                 @"people_count":peopocont,
                                 @"way":way,
                                 @"go_goods_way":go_goods_way
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
            NSLog(@"成功");
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text{
    [btnFoodType setTitle:text forState:UIControlStateNormal];
}
-(void)btnFoodTypeClick:(UIButton*)btn{
    
    pickV = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-300, kWidth, 300)];
    [self.view addSubview:pickV];
    
    if (btn.tag==0) {
        dateArray = [NSArray arrayWithObjects:@"堂食",@"打包",nil];
    }else{
        dateArray = [NSArray arrayWithObjects:@"做好即上",@"等待叫起",nil];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    [view setBackgroundColor:[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1]];
    [pickerView addSubview:view];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickV addSubview:pickerView];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-50-20, 5, 50, 50)];
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [pickV addSubview: btnClose];
    
    pickV.hidden = NO;
}
-(void)closeBtnClick{
    pickV.hidden = YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return dateArray.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    
    return [dateArray objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    if ([[dateArray objectAtIndex:row] isEqualToString:@"堂食"]) {
        [btnFoodType setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        way = @"1";
    }else if ([[dateArray objectAtIndex:row] isEqualToString:@"打包"]){
        [btnFoodType setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        way = @"2";
    }else if ([[dateArray objectAtIndex:row] isEqualToString:@"做好即上"]){
        [btnSangcaiTime setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        go_goods_way = @"1";
    }else if ([[dateArray objectAtIndex:row] isEqualToString:@"等待叫起"]){
        [btnSangcaiTime setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        go_goods_way = @"2";
    }
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
