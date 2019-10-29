//
//  ChangePassViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ChangePassViewController.h"
#import "LoginViewController.h"

@interface ChangePassViewController ()<UITextFieldDelegate>{
    UITextField *tfoldpass;
    UITextField *tfnewpass;
    UITextField *tfsubnewpass;
      MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
     UIButton *btnLogin;
}

@end

@implementation ChangePassViewController
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
    self.navigationItem.title = @"密码修改";
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    tfoldpass = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kWidth-20-20, 40)];
    tfoldpass.placeholder = @"请输入原密码";
    tfoldpass.delegate = self;
    [tfoldpass setTextColor:[UIColor blackColor]];
    tfoldpass.font = [UIFont systemFontOfSize:13];
    tfoldpass.layer.cornerRadius = 3.0;
    tfoldpass.layer.borderWidth = 0.5;
    tfoldpass.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:tfoldpass];
    
    tfnewpass = [[UITextField alloc] initWithFrame:CGRectMake(20, 10+40+10, kWidth-20-20, 40)];
    tfnewpass.placeholder = @"请输入新密码";
    tfnewpass.delegate = self;
    [tfnewpass setTextColor:[UIColor blackColor]];
    tfnewpass.font = [UIFont systemFontOfSize:13];
    tfnewpass.layer.cornerRadius = 3.0;
    tfnewpass.layer.borderWidth = 0.5;
    tfnewpass.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:tfnewpass];
    
    tfsubnewpass = [[UITextField alloc] initWithFrame:CGRectMake(20, 10+10+40+10+40+10, kWidth-20-20, 40)];
    tfsubnewpass.placeholder = @"请确认新密码";
    tfsubnewpass.delegate = self;
    [tfsubnewpass setTextColor:[UIColor blackColor]];
    tfsubnewpass.font = [UIFont systemFontOfSize:13];
    tfsubnewpass.layer.cornerRadius = 3.0;
    tfsubnewpass.layer.borderWidth = 0.5;
    tfsubnewpass.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [self.view addSubview:tfsubnewpass];
    
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(30,  10+10+40+10+40+10+40+20+20, kWidth-30-30, 30)];
    [btnLogin setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnLogin.layer.cornerRadius = 3.0;
    [btnLogin setTitle:@"修改" forState:UIControlStateNormal];
    [btnLogin setFont:[UIFont systemFontOfSize:14]];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];

}
-(void)changeClick{
 
    if (tfoldpass.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入原密码" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (tfnewpass.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入新密码" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (tfnewpass.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请确认新密码" preferredStyle:  UIAlertControllerStyleAlert];
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
        
        userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL ,UPDATEPASSWORD];
        NSDictionary *parameters = @{@"oldpassword": tfoldpass.text,
                                     @"password": tfnewpass.text,
                                     @"passwordnew":tfsubnewpass.text,
                                     @"waiter_id":[userDefaults objectForKey:@"business_id_MX"]
                                     };
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                LoginViewController *logv = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:logv animated:YES];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfsubnewpass resignFirstResponder];
    [tfnewpass resignFirstResponder];
    [tfoldpass resignFirstResponder];
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
