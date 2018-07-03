//
//  FeedBackViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController (){
    UITextField *_tfFeedback;
    UIButton *btnFeedsub;
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
}

@end

@implementation FeedBackViewController
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
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    _tfFeedback = [[UITextField alloc]initWithFrame:CGRectMake(5, 40, kWidth-5-5, 150)];
    _tfFeedback.backgroundColor = [UIColor whiteColor];
    _tfFeedback.placeholder = @"请填写意见或者建议";
    _tfFeedback.font = [UIFont systemFontOfSize:13];
    _tfFeedback.layer.cornerRadius = 3.0;
    _tfFeedback.layer.borderWidth = 0.5;
    _tfFeedback.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
      _tfFeedback.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.view addSubview:_tfFeedback];
    
    
    btnFeedsub = [[UIButton alloc] initWithFrame:CGRectMake(30, 150+40+20, kWidth-30-30, 30)];
    [btnFeedsub setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnFeedsub.layer.cornerRadius = 3.0;
    [btnFeedsub setTitle:@"提交" forState:UIControlStateNormal];
    [btnFeedsub setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFeedsub setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnFeedsub addTarget:self action:@selector(feedBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFeedsub];
}
- (void)feedBackClick{
    //开始显示HUD
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"提交中";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL ,SAVESUGGEST];
    NSDictionary *parameters = @{@"content": _tfFeedback.text,
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
            hud.labelText = @"提交成功";
            [hud hide:YES afterDelay:0.5];
             [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            hud.labelText = @"提交失败";
            [hud hide:YES afterDelay:0.5];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"网络连接异常";
        [hud hide:YES afterDelay:0.5];
        NSLog(@"Error: ==============%@", error);
    }];
    
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
