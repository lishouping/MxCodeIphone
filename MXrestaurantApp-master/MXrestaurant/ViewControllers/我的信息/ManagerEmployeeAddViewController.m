//
//  ManagerEmployeeAddViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/16.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerEmployeeAddViewController.h"

@interface ManagerEmployeeAddViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
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

@implementation ManagerEmployeeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加员工";
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
    [labShopA setText:@"员工姓名"];
    labShopA.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopA];
    
    _tfShopName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10, kWidth-15-80-10-15, 40)];
    _tfShopName.placeholder = @"请输入员工姓名";
    _tfShopName.delegate = self;
    [_tfShopName setTextColor:[UIColor blackColor]];
    _tfShopName.font = [UIFont systemFontOfSize:13];
    _tfShopName.layer.cornerRadius = 3.0;
    _tfShopName.layer.borderWidth = 0.5;
    _tfShopName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopName];
    
    
    UILabel *labShopB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
    [labShopB setText:@"登录账号"];
    labShopB.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopB];
    
    _tfShopPersonName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonName.placeholder = @"请输入登录账号";
    _tfShopPersonName.delegate = self;
    [_tfShopPersonName setTextColor:[UIColor blackColor]];
    _tfShopPersonName.font = [UIFont systemFontOfSize:13];
    _tfShopPersonName.layer.cornerRadius = 3.0;
    _tfShopPersonName.layer.borderWidth = 0.5;
    _tfShopPersonName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonName];
    
    UILabel *labShopC = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
    [labShopC setText:@"手机号码"];
    labShopC.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopC];
    
    _tfShopPersonPhone = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonPhone.placeholder = @"请输入手机号码  ";
    _tfShopPersonPhone.delegate = self;
    [_tfShopPersonPhone setTextColor:[UIColor blackColor]];
    _tfShopPersonPhone.font = [UIFont systemFontOfSize:13];
    _tfShopPersonPhone.layer.cornerRadius = 3.0;
    _tfShopPersonPhone.layer.borderWidth = 0.5;
    _tfShopPersonPhone.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonPhone];
    
    
    UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50, 80, 40)];
    [labShopF setText:@"账号类型"];
    labShopF.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopF];
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50, kWidth-15-80-10-15, 40)];
    [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSelect setTitle:@"请选择账号类型" forState:UIControlStateNormal];
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
    
    [alert addAction:[UIAlertAction actionWithTitle:@"服务员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printType = @"1";
        [btnSelect setTitle:@"服务员" forState:UIControlStateNormal];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"店长" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printType = @"2";
        [btnSelect setTitle:@"店长" forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)sumbitClick{
    
    if (_tfShopName.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入员工姓名" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonName.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入登录账号" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonPhone.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入手机号码" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if ([printType isEqualToString:@"0"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择账号类型" preferredStyle:  UIAlertControllerStyleAlert];
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
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDWAITER];
        NSDictionary *parameters = @{@"name": _tfShopName.text,
                                     @"username": _tfShopPersonName.text,
                                     @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                     @"user_status":@"1",
                                     @"phonenum":_tfShopPersonPhone.text,
                                     @"type":printType
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
