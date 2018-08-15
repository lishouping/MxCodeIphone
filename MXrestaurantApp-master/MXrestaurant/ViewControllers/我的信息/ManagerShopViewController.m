	//
//  ManagerShopViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/14.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerShopViewController.h"
#import "YLButton.h"

@interface ManagerShopViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UITextField *_tfShopName;
    UITextField *_tfShopPersonName;
    UITextField *_tfShopPersonPhone;
    UITextField *_tfShopAddress;
    UITextField *_tfShopIntroduction;
    UITextField *_tfShopNotice;
    
    YLButton *btnStartTime;
    YLButton *btnEndTime;
    
    UIButton *btnSubmit;
    
    UIView* dataPicker;
    UIDatePicker *date;
    
    NSString *starttime;
    NSString *endtime;
        int timespos;
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
    NSString *shop_id;
    
    UIImageView *imgLogo;
    UIImageView *wxLogo;
    UIImageView *alpayLogo;
}

@end

@implementation ManagerShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [self getShopInfo];
    // Do any additional setup after loading the view.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)makeUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-30-10-44-20)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kWidth, kHeight+100);//滚动范围的大小
    
    
    UILabel *labShopA = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 40)];
    [labShopA setText:@"店铺名称"];
     labShopA.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopA];
    
    _tfShopName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10, kWidth-15-80-10-15, 40)];
    _tfShopName.placeholder = @"请输入店铺名称";
    _tfShopName.delegate = self;
    [_tfShopName setTextColor:[UIColor blackColor]];
    _tfShopName.font = [UIFont systemFontOfSize:13];
    _tfShopName.layer.cornerRadius = 3.0;
    _tfShopName.layer.borderWidth = 0.5;
    _tfShopName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopName];
    
    
    UILabel *labShopB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
    [labShopB setText:@"负责人员"];
    labShopB.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopB];
    
    _tfShopPersonName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonName.placeholder = @"请输入负责人员";
    _tfShopPersonName.delegate = self;
    [_tfShopPersonName setTextColor:[UIColor blackColor]];
    _tfShopPersonName.font = [UIFont systemFontOfSize:13];
    _tfShopPersonName.layer.cornerRadius = 3.0;
    _tfShopPersonName.layer.borderWidth = 0.5;
    _tfShopPersonName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonName];
    
    UILabel *labShopC = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
    [labShopC setText:@"联系电话"];
    labShopC.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopC];
    
    _tfShopPersonPhone = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonPhone.placeholder = @"请输入联系电话";
    _tfShopPersonPhone.delegate = self;
    [_tfShopPersonPhone setTextColor:[UIColor blackColor]];
    _tfShopPersonPhone.font = [UIFont systemFontOfSize:13];
    _tfShopPersonPhone.layer.cornerRadius = 3.0;
    _tfShopPersonPhone.layer.borderWidth = 0.5;
    _tfShopPersonPhone.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonPhone];
    
    
    UILabel *labShopD = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50, 80, 40)];
    [labShopD setText:@"营业时间"];
    labShopD.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopD];
    
    btnStartTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnStartTime setFont:[UIFont systemFontOfSize:14]];
    [btnStartTime customButtonWithFrame1:CGRectMake(15+80+10, 10+40+10+50+50,(kWidth-15-80-10-15)/2, 40) title:@"开始时间" rightImage:[UIImage imageNamed:@""]];
    [btnStartTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnStartTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnStartTime.layer.borderWidth = 0.5;
    btnStartTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:btnStartTime];
    [btnStartTime addTarget:self action:@selector(selectStartTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    btnEndTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnEndTime setFont:[UIFont systemFontOfSize:14]];
    [btnEndTime customButtonWithFrame1:CGRectMake(15+10+80+10+((kWidth-15-80-10-15)/2), 10+40+10+50+50,(kWidth-15-80-10-15)/2, 40) title:@"结束时间" rightImage:[UIImage imageNamed:@""]];
    [btnEndTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnEndTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnEndTime.layer.borderWidth = 0.5;
    btnEndTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:btnEndTime];
    [btnEndTime addTarget:self action:@selector(selectEndTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel *labShopE = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50, 80, 40)];
    [labShopE setText:@"店铺地址"];
    labShopE.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopE];
    
    _tfShopAddress = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50, kWidth-15-80-10-15, 40)];
    _tfShopAddress.placeholder = @"请输入店铺地址";
    _tfShopAddress.delegate = self;
    [_tfShopAddress setTextColor:[UIColor blackColor]];
    _tfShopAddress.font = [UIFont systemFontOfSize:13];
    _tfShopAddress.layer.cornerRadius = 3.0;
    _tfShopAddress.layer.borderWidth = 0.5;
    _tfShopAddress.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopAddress];
    
    UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50, 80, 40)];
    [labShopF setText:@"店铺简介"];
    labShopF.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopF];
    
    _tfShopIntroduction = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50, kWidth-15-80-10-15, 40)];
    _tfShopIntroduction.placeholder = @"请输入店铺简介";
    _tfShopIntroduction.delegate = self;
    [_tfShopIntroduction setTextColor:[UIColor blackColor]];
    _tfShopIntroduction.font = [UIFont systemFontOfSize:13];
    _tfShopIntroduction.layer.cornerRadius = 3.0;
    _tfShopIntroduction.layer.borderWidth = 0.5;
    _tfShopIntroduction.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopIntroduction];
    
    UILabel *labShopG = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50, 80, 40)];
    [labShopG setText:@"店铺公告"];
    labShopG.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopG];
    
    _tfShopNotice = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50, kWidth-15-80-10-15, 40)];
    _tfShopNotice.placeholder = @"请输入店铺公告";
    _tfShopNotice.delegate = self;
    [_tfShopNotice setTextColor:[UIColor blackColor]];
    _tfShopNotice.font = [UIFont systemFontOfSize:13];
    _tfShopNotice.layer.cornerRadius = 3.0;
    _tfShopNotice.layer.borderWidth = 0.5;
    _tfShopNotice.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopNotice];
    
    UILabel *labShopH = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50, 80, 60)];
    [labShopH setText:@"店铺图片"];
    labShopH.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopH];
    
    imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50, 60, 60)];
    [_scrollView addSubview:imgLogo];
    
    UILabel *labShopI = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+10+60, 80, 60)];
    [labShopI setText:@"微信支付图片"];
    labShopI.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopI];
    
    wxLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+10+60, 60, 60)];
    [_scrollView addSubview:wxLogo];
    
    UILabel *labShopJ = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+10+60+10+60, 90, 60)];
    [labShopJ setText:@"支付宝支付"];
    labShopJ.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopJ];
    
    alpayLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+10+60+10+60, 60, 60)];
    [_scrollView addSubview:alpayLogo];
    
    
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30,  kHeight-30-44-20-10, kWidth-30-30, 30)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 3.0;
    [btnSubmit setTitle:@"修改" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSubmit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
}


-(void)getShopInfo{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@/%@",API_URL,GETSHOPINFO,[userDefaults objectForKey:@"shop_id_MX"]];
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
    
    [manager GET:postUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            NSDictionary *dics =[responseObject objectForKey:@"DATA"];
            
            shop_id = [NSString stringWithFormat:@"%@",[dics objectForKey:@"shop_id"]];
            NSString *shop_name = [NSString stringWithFormat:@"%@",[dics objectForKey:@"shop_name"]];
            NSString *address = [NSString stringWithFormat:@"%@",[dics objectForKey:@"address"]];
            NSString *shop_owner_name = [NSString stringWithFormat:@"%@",[dics objectForKey:@"shop_owner_name"]];
            NSString *shop_owner_phone = [NSString stringWithFormat:@"%@",[dics objectForKey:@"shop_owner_phone"]];
            NSString *introduction = [NSString stringWithFormat:@"%@",[dics objectForKey:@"introduction"]];
            NSString *notice = [NSString stringWithFormat:@"%@",[dics objectForKey:@"notice"]];
            NSString *begin_time = [NSString stringWithFormat:@"%@",[dics objectForKey:@"begin_time"]];
            starttime = begin_time;
            NSString *end_time = [NSString stringWithFormat:@"%@",[dics objectForKey:@"end_time"]];
            endtime = end_time;
            NSString *wechat_img = [NSString stringWithFormat:@"%@/%@",RESOURCE_URL,[dics objectForKey:@"wechat_img"]];
            NSString *alipay_img = [NSString stringWithFormat:@"%@/%@",RESOURCE_URL,[dics objectForKey:@"alipay_img"]];
            NSString *icon = [NSString stringWithFormat:@"%@/%@",RESOURCE_URL,[dics objectForKey:@"icon"]];
            
            NSURL *icon_img = [[NSURL alloc] initWithString:icon];
            [imgLogo sd_setImageWithURL:icon_img placeholderImage:[UIImage imageNamed:@"icon"]];
            
            NSURL *wx_img = [[NSURL alloc] initWithString:wechat_img];
            [wxLogo sd_setImageWithURL:wx_img placeholderImage:[UIImage imageNamed:@"icon"]];
            
            NSURL *alp_img = [[NSURL alloc] initWithString:alipay_img];
            [alpayLogo sd_setImageWithURL:alp_img placeholderImage:[UIImage imageNamed:@"icon"]];
            
            [_tfShopName setText:shop_name];
            [_tfShopAddress setText:address];
            [_tfShopPersonName setText:shop_owner_name];
            [btnStartTime setTitle:begin_time forState:UIControlStateNormal];
            [btnEndTime setTitle:end_time forState:UIControlStateNormal];
            [_tfShopPersonPhone setText:shop_owner_phone];
            [_tfShopIntroduction setText:introduction];
            [_tfShopNotice setText:notice];
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}


-(void)sumbitClick{
    
    if (_tfShopName.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入店铺名" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonName.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入负责人" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonPhone.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入电话" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else{
        //开始显示HUD
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"修改中";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,UPDATESHOP];
        NSDictionary *parameters = @{@"shop_name": _tfShopName.text,
                                     @"address": _tfShopAddress.text,
                                     @"shop_owner_name":_tfShopPersonName.text,
                                     @"shop_owner_phone":_tfShopPersonPhone.text,
                                     @"introduction":_tfShopIntroduction.text,
                                     @"notice":_tfShopNotice.text,
                                     @"begin_time":starttime,
                                     @"end_time":endtime,
                                     @"shop_id":shop_id
                                     };
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        NSString *key =[userDefaults objectForKey:@"login_key_MX"];
        NSString *longbusid = [[userDefaults objectForKey:@"business_id_MX"] stringValue];
        
        [manager.requestSerializer setValue:key forHTTPHeaderField:@"key"];
        [manager.requestSerializer setValue:longbusid forHTTPHeaderField:@"id"];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                hud.labelText = @"修改成功";
                [hud hide:YES afterDelay:0.5];
            }
            else
            {
                hud.labelText = @"修改失败";
                [hud hide:YES afterDelay:0.5];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.labelText = @"网络连接异常";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"Error: ==============%@", error);
        }];
        
    }
    
    
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

- (void)dataChoose{
    dataPicker= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 216+44)];
    [dataPicker setBackgroundColor:[UIColor whiteColor]];
    date=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 216)];
    [date setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    date.datePickerMode=UIDatePickerModeTime;
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
    [dateFormatter setDateFormat:@"hh:mm"];
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfShopNotice resignFirstResponder];
    [_tfShopName resignFirstResponder];
    [_tfShopPersonName resignFirstResponder];
    [_tfShopPersonPhone resignFirstResponder];
    [_tfShopAddress resignFirstResponder];
    [_tfShopIntroduction resignFirstResponder];
    [_tfShopNotice resignFirstResponder];
    return YES;
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
