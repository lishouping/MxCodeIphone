//
//  LoginViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "LoginViewController.h"
#import "JPUSHService.h"
@interface LoginViewController ()<UITextFieldDelegate>{
    UITextField *tfuserName;
    UITextField *tfpassWord;
    UIButton *btnLogin;
   
    MBProgressHUD *hud;
}

@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏导航栏
    //    [self.navigationItem setHidesBackButton:YES];   // 隐藏返回按钮
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    // Do any additional setup after loading the view.
}

- (void)makeUI{
    UIView *backgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHeight, kHeight)];
    [backgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backgView];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth/2)-(100/2), 100, 100, 120)];
    [titleImg setImage:[UIImage imageNamed:@"ic_login"]];
    [backgView addSubview:titleImg];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(30, 100+120+20, kWidth-30-30, 40)];
    userView.layer.cornerRadius = 3.0;
    userView.layer.borderWidth = 0.5;
    userView.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [backgView addSubview:userView];
    
    UILabel *userImg = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 60, 40)];
    [userImg setText:@"用户名"];
    [userImg setFont:[UIFont systemFontOfSize:13]];
    [userView addSubview:userImg];
    
    tfuserName = [[UITextField alloc] initWithFrame:CGRectMake(60+5, 0, kWidth-(30+60+30), 40)];
      tfuserName.delegate = self;
    tfuserName.placeholder = @"用户名";
    [tfuserName setTextColor:[UIColor blackColor]];
    tfuserName.font = [UIFont systemFontOfSize:13];
       tfuserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userView addSubview:tfuserName];
    //关闭键盘输入第一个字母大写的问题
    [tfuserName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(30, 100+120+20+40+10, kWidth-30-30, 40)];
    passView.layer.cornerRadius = 3.0;
    passView.layer.borderWidth = 0.5;
    passView.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [backgView addSubview:passView];
    
    UILabel *passImg = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 60, 40)];
    [passImg setText:@"密   码"];
    [passImg setFont:[UIFont systemFontOfSize:13]];
    
    [passView addSubview:passImg];
    
    tfpassWord = [[UITextField alloc] initWithFrame:CGRectMake(60+5, 0, kWidth-(30+60+30), 40)];
    tfpassWord.placeholder = @"密   码";
    tfpassWord.delegate = self;
    [tfpassWord setTextColor:[UIColor blackColor]];
    tfpassWord.secureTextEntry = YES;
    tfpassWord.font = [UIFont systemFontOfSize:13];
    [passView addSubview:tfpassWord];
    
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(30, 100+45+30+45+2+30+30+40+30, kWidth-30-30, 30)];
    [btnLogin setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnLogin.layer.cornerRadius = 3.0;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin setFont:[UIFont systemFontOfSize:14]];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [backgView addSubview:btnLogin];
    
    
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName_MX"];
    NSString *passWord = [userDefaults objectForKey:@"passWord_MX"];
    tfuserName.text = userName;
    tfpassWord.text = passWord;

}

-(void)LoginClick{
    if (tfuserName.text.length == 0) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (tfpassWord.text.length == 0){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }else{
        //开始显示HUD
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"正在登录";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];

        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL ,USERLOGIN_URL];
        NSDictionary *parameters = @{@"user_name": tfuserName.text,
                                     @"password": tfpassWord.text,
                                     @"type":@"2",
                                     @"from":@"3"
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
                //返回到上个页面
                //[self.navigationController popViewControllerAnimated:YES];
                [hud hide:YES afterDelay:0.5];
                NSDictionary *dic = [responseObject objectForKey:@"DATA"];
                NSDictionary *dic1 = [dic objectForKey:@"waiter"];
                
                
                NSString *alias = [dic objectForKey:@"alias"];
                NSString *login_key = [dic objectForKey:@"login_key"];
                NSString *shop_id = [dic1 objectForKey:@"shop_id"];
                NSString *name = [dic1 objectForKey:@"name"];
                NSString *business_id = [dic objectForKey:@"business_id"];
                NSString *role_id = [dic objectForKey:@"role_id"];
                NSString *if_check = [dic1 objectForKey:@"if_check"];
                
                NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:tfuserName.text forKey:@"userName_MX"];
                [userDefaults setObject:tfpassWord.text forKey:@"passWord_MX"];
                [userDefaults setObject:alias forKey:@"alias_MX"];
                [userDefaults setObject:login_key forKey:@"login_key_MX"];
                [userDefaults setObject:shop_id forKey:@"shop_id_MX"];
                [userDefaults setObject:name forKey:@"name_MX"];
                [userDefaults setObject:business_id forKey:@"business_id_MX"];
                [userDefaults setObject:role_id forKey:@"role_id_MX"];
                [userDefaults setObject:if_check forKey:@"if_check_MX"];
               
                [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                [self getShopInfo];
               
            }

            else
            {
                hud.labelText = [responseObject objectForKey:@"MESSAGE"];
                [hud hide:YES afterDelay:0.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.labelText = @"网络连接异常";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"Error: ==============%@", error);
        }];
        
    }
}

// 极光别名注册的回调方法
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"极光别名注册的回调方法rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if (iResCode == 0) {
        // 注册成功
        NSLog(@"----设置别名成功");
    }
}

-(void)getShopInfo{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
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
            
            NSString *shop_name = [NSString stringWithFormat:@"%@",[dics objectForKey:@"shop_name"]];
            NSString *menmbers_shop_id = [NSString stringWithFormat:@"%@",[dics objectForKey:@"menmbers_shop_id"]];
            [userDefaults setObject:shop_name forKey:@"shop_name"];
            [userDefaults setObject:menmbers_shop_id forKey:@"menmbers_shop_id"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginState" object:@YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}



#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfuserName resignFirstResponder];
    [tfpassWord resignFirstResponder];
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
