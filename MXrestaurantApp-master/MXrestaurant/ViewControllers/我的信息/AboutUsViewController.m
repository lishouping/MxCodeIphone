//
//  AboutUsViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
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
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, kWidth-10-10, 120)];
    headView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:headView];
    
    UILabel *labablut = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    labablut.text = @"关于我们";
    labablut.font = [UIFont systemFontOfSize:15];
    [headView addSubview:labablut];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kWidth-10-10, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
    [headView addSubview:lineView];
    
    UILabel *labablutinfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 40+5, kWidth-10-10-10-10, 80)];
    labablutinfo.text = @"“嘿！伙计”坚持用高效创造服务，让服务缔造品质。高效率、高服务、高品质，助你打造星级品牌。";
    labablutinfo.font = [UIFont systemFontOfSize:12];
    labablutinfo.numberOfLines = 5;
    [headView addSubview:labablutinfo];
    
    
    UIView *headView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 120+20+20, kWidth-10-10, 100)];
    headView1.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:headView1];
    
    UILabel *labablut1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    labablut1.text = @"联系我们";
    labablut1.font = [UIFont systemFontOfSize:12];
    [headView1 addSubview:labablut1];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kWidth-10-10, 1)];
    [lineView1 setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
    [headView1 addSubview:lineView1];
    
    UILabel *labphone = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+40, 100, 20)];
    labphone.text = @"024-31128174";
    labphone.font = [UIFont systemFontOfSize:12];
    [headView1 addSubview:labphone];
    
    
    
    
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
