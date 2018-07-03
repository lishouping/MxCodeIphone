//
//  ResViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/25.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ResViewController.h"
#import "ResModel.h"
#import "ResTableViewCell.h"
#import "FoodCustomViewController.h"
@interface ResViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *resTableView;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation ResViewController
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
    self.navigationItem.title = @"预定信息";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
    
    [self maekUI];
    [self loadDate];
}
- (void)loadDate{
    for (NSDictionary * dic in self.book_list)
    {
        NSString *use_time = [dic objectForKey:@"use_time"];
        NSString *people_num = [dic objectForKey:@"people_num"];
        NSString *name = [dic objectForKey:@"name"];
        NSString *phone = [dic objectForKey:@"phone"];
        NSString *table_name = [dic objectForKey:@"table_name"];
        NSString *table_id = [dic objectForKey:@"table_id"];
        
        ResModel *resv = [[ResModel alloc] init];
        resv.use_time = use_time;
        resv.people_num = people_num;
        resv.name = name;
        resv.phone = phone;
        resv.table_name = table_name;
        resv.table_id = table_id;
        [self.dateArray addObject:resv];
    }

    [resTableView reloadData];
}
- (void)maekUI{
    resTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    resTableView.delegate = self;
    resTableView.dataSource = self;
    [self.view addSubview:resTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[ResTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    ResModel *svm = self.dateArray[indexPath.section];
    tabcell.labTableNumber.text = [NSString stringWithFormat:@"需求时间:%@",[self timeWithTimeIntervalString:svm.use_time]];
    tabcell.labCreateTime.text = [NSString stringWithFormat:@"预定人:%@",svm.name] ;
    tabcell.labServiceTime.text = [NSString stringWithFormat:@"联系电话:%@",svm.phone] ;
    tabcell.labServiceContent.text = [NSString stringWithFormat:@"餐桌名称:%@",svm.table_name];
    tabcell.labServiceState.text = [NSString stringWithFormat:@"用餐人数:%@",svm.people_num];
    tabcell.btnServiceHander.tag = indexPath.section;
    [tabcell.btnServiceHander addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return tabcell;
}
-(void)btnClick:(UIButton *)btn{
    ResModel *svm = self.dateArray[btn.tag];
    FoodCustomViewController *fov = [[FoodCustomViewController alloc] init];
    fov.table_id = svm.table_id;
    fov.table_name = svm.table_name;
    [self.navigationController pushViewController:fov animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSTimeInterval interval    =[timeString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
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
