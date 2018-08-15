//
//  ManagerPrintAddViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/15.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerPrintAddViewController.h"

@interface ManagerPrintAddViewController()<UITextFieldDelegate,UIScrollViewDelegate> 
{
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
    
    UIScrollView *_scrollView;
    UITextField *_tfShopName;
    UITextField *_tfShopPersonName;
    UITextField *_tfShopPersonPhone;
    UITextField *_tfShopAddress;
    UIButton *btnSelect;
    
        UIButton *btnSubmit;
    NSString *printType;
}
@end

@implementation ManagerPrintAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加打印机";
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
    [self makeUI];
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
    [labShopA setText:@"打印机名称"];
    labShopA.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopA];
    
    _tfShopName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10, kWidth-15-80-10-15, 40)];
    _tfShopName.placeholder = @"请输入打印机名称";
    _tfShopName.delegate = self;
    [_tfShopName setTextColor:[UIColor blackColor]];
    _tfShopName.font = [UIFont systemFontOfSize:13];
    _tfShopName.layer.cornerRadius = 3.0;
    _tfShopName.layer.borderWidth = 0.5;
    _tfShopName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopName];
    
    
    UILabel *labShopB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
    [labShopB setText:@"打印机编号"];
    labShopB.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopB];
    
    _tfShopPersonName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonName.placeholder = @"请输入打印机编号";
    _tfShopPersonName.delegate = self;
    [_tfShopPersonName setTextColor:[UIColor blackColor]];
    _tfShopPersonName.font = [UIFont systemFontOfSize:13];
    _tfShopPersonName.layer.cornerRadius = 3.0;
    _tfShopPersonName.layer.borderWidth = 0.5;
    _tfShopPersonName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonName];
    
    UILabel *labShopC = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
    [labShopC setText:@"打印机KEY"];
    labShopC.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopC];
    
    _tfShopPersonPhone = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonPhone.placeholder = @"请输入打印机KEY";
    _tfShopPersonPhone.delegate = self;
    [_tfShopPersonPhone setTextColor:[UIColor blackColor]];
    _tfShopPersonPhone.font = [UIFont systemFontOfSize:13];
    _tfShopPersonPhone.layer.cornerRadius = 3.0;
    _tfShopPersonPhone.layer.borderWidth = 0.5;
    _tfShopPersonPhone.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonPhone];
    
    UILabel *labShopE = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50, 80, 40)];
    [labShopE setText:@"打印份数"];
    labShopE.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopE];
    
    printType = @"0";
    _tfShopAddress = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50, kWidth-15-80-10-15, 40)];
    _tfShopAddress.placeholder = @"请输入打印份数";
    _tfShopAddress.delegate = self;
    [_tfShopAddress setTextColor:[UIColor blackColor]];
    _tfShopAddress.font = [UIFont systemFontOfSize:13];
    _tfShopAddress.layer.cornerRadius = 3.0;
    _tfShopAddress.layer.borderWidth = 0.5;
    _tfShopAddress.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopAddress];
    
    UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50+50, 80, 40)];
    [labShopF setText:@"打印类型"];
    labShopF.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopF];
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50+50, kWidth-15-80-10-15, 40)];
    [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSelect setTitle:@"请选择打印类型" forState:UIControlStateNormal];
    btnSelect.font = [UIFont systemFontOfSize:13];
    btnSelect.layer.cornerRadius = 3.0;
    btnSelect.layer.borderWidth = 0.5;
    btnSelect.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scrollView addSubview:btnSelect];
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30,  kHeight-30-44-20-10, kWidth-30-30, 30)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 3.0;
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSubmit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
}

-(void)selectOnclick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择打印类型" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"后厨" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printType = @"1";
        [btnSelect setTitle:@"后厨" forState:UIControlStateNormal];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"结账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printType = @"2";
        [btnSelect setTitle:@"结账" forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)sumbitClick{
    
    if (_tfShopName.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机名称" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonName.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机编号" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonPhone.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机KEY" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopAddress.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印份数" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if ([printType isEqualToString:@"0"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择打印机类型" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
    else{
        //开始显示HUD
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,PRINTADD];
        NSDictionary *parameters = @{@"printer_name": _tfShopName.text,
                                     @"printer_no": _tfShopPersonName.text,
                                     @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                     @"key":_tfShopPersonPhone.text,
                                     @"print_num":_tfShopAddress.text,
                                     @"type_print":printType
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
                hud.labelText = @"成功";
                [hud hide:YES afterDelay:0.5];
                //说明不是跟视图
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                hud.labelText = @"失败";
                [hud hide:YES afterDelay:0.5];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.labelText = @"网络连接异常";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"Error: ==============%@", error);
        }];
        
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
