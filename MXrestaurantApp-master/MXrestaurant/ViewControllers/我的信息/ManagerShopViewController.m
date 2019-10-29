	//
//  ManagerShopViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/14.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerShopViewController.h"
#import "YLButton.h"
#import "TZImagePickerController.h"
#import "HWPopTool.h"
#import "CategoryModel.h"

@interface ManagerShopViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIScrollView *_scrollView;
    UITextField *_tfShopName;
    UITextField *_tfShopPersonName;
    UITextField *_tfShopPersonPhone;
    UITextField *_tfShopAddress;
    UITextField *_tfShopIntroduction;
    UITextField *_tfShopNotice;
    UITextField *_tfShopMobilePhone;
    UIButton *btnSelect;
    YLButton *btnCsXb;
    YLButton *btnJzTime;
    UITextField *_tfServiceTs;
    UITextField *_tfZhaopin;
    
    YLButton *btnStartTime;
    YLButton *btnEndTime;
    
    UIButton *btnSubmit;
    
    UIView* dataPicker;
    UIDatePicker *date;
    
    NSString *starttime;
    NSString *endtime;
    NSString *csXbTime;
    NSString *jzTime;
        int timespos;
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
    NSString *shop_id;
    
    UIImageView *imgLogo;
    UIButton *btnImageLogo;
    UIImageView *wxLogo;
    UIButton *btnWxLogo;
    UIImageView *alpayLogo;
    UIButton *btnAlLogo;
    
    NSInteger *managerType;
    
    NSData *logoData;
    NSData *wxData;
    NSData *alData;
    UITableView *tableViewChoose;
    UIView *headView;
    UIView *viewTableState;
    NSString *print_way;
    
    NSString *logoFile;
    NSString *wxFile;
    NSString *alFile;
    
    NSString *fileNameWx;
    NSString *fileNameAl;
    NSString *fileNameLogo;
    
}
//餐桌分类
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation ManagerShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
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
    _scrollView.contentSize = CGSizeMake(kWidth, kHeight+300);//滚动范围的大小
    
    
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
    
    
    
    UILabel *labMobilePhone = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50, 80, 40)];
    [labMobilePhone setText:@"店铺电话"];
    labMobilePhone.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labMobilePhone];
    
    _tfShopMobilePhone = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50, kWidth-15-80-10-15, 40)];
    _tfShopMobilePhone.placeholder = @"请输入店铺电话";
    _tfShopMobilePhone.delegate = self;
    [_tfShopMobilePhone setTextColor:[UIColor blackColor]];
    _tfShopMobilePhone.font = [UIFont systemFontOfSize:13];
    _tfShopMobilePhone.layer.cornerRadius = 3.0;
    _tfShopMobilePhone.layer.borderWidth = 0.5;
    _tfShopMobilePhone.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopMobilePhone];
    
    
    UILabel *printType = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50, 80, 40)];
    [printType setText:@"打印方式"];
    printType.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:printType];

    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50, kWidth-15-80-10-15, 40)];
    [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSelect setTitle:@"请选择打印方式" forState:UIControlStateNormal];
    btnSelect.font = [UIFont systemFontOfSize:13];
    btnSelect.layer.cornerRadius = 3.0;
    btnSelect.layer.borderWidth = 0.5;
    btnSelect.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scrollView addSubview:btnSelect];

    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [headView setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    UILabel *labTableViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [labTableViewTitle setText:@"请选择打印方式"];
    [labTableViewTitle setFont:[UIFont systemFontOfSize:16]];
    [labTableViewTitle setTextColor:[UIColor whiteColor]];
    labTableViewTitle.textAlignment = UITextAlignmentCenter;
    [headView addSubview:labTableViewTitle];
    
    viewTableState = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewTableState.backgroundColor = [UIColor whiteColor];
    
    tableViewChoose = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, kHeight-100-100) style:UITableViewStylePlain];
    tableViewChoose.delegate = self;
    tableViewChoose.dataSource = self;
    
    
    
    UILabel *labcs = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50, 80, 40)];
    [labcs setText:@"厨师下班"];
    labcs.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labcs];
    
    btnCsXb = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnCsXb setFont:[UIFont systemFontOfSize:14]];
    [btnCsXb customButtonWithFrame1:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50,kWidth-15-80-10-15, 40) title:@"请选择时间" rightImage:[UIImage imageNamed:@""]];
    [btnCsXb setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnCsXb.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnCsXb.layer.borderWidth = 0.5;
    btnCsXb.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:btnCsXb];
    [btnCsXb addTarget:self action:@selector(selectCsXbTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *labjiezhang = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50+50, 80, 40)];
    [labjiezhang setText:@"结账时间"];
    labjiezhang.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labjiezhang];
    
    btnJzTime = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnJzTime setFont:[UIFont systemFontOfSize:14]];
    [btnJzTime customButtonWithFrame1:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50+50,kWidth-15-80-10-15, 40) title:@"请选择时间" rightImage:[UIImage imageNamed:@""]];
    [btnJzTime setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnJzTime.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    btnJzTime.layer.borderWidth = 0.5;
    btnJzTime.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:btnJzTime];
    [btnJzTime addTarget:self action:@selector(selectjuiezTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50+50+50, 80, 40)];
    [lab2 setText:@"特色服务"];
    lab2.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:lab2];
    
    _tfServiceTs = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50+50+50, kWidth-15-80-10-15, 40)];
    _tfServiceTs.placeholder = @"请输入特色服务";
    _tfServiceTs.delegate = self;
    [_tfServiceTs setTextColor:[UIColor blackColor]];
    _tfServiceTs.font = [UIFont systemFontOfSize:13];
    _tfServiceTs.layer.cornerRadius = 3.0;
    _tfServiceTs.layer.borderWidth = 0.5;
    _tfServiceTs.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfServiceTs];
    
    UILabel *lab32 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50+50+50+50, 80, 40)];
    [lab32 setText:@"招聘信息"];
    lab32.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:lab32];
    
    _tfZhaopin = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50, kWidth-15-80-10-15, 40)];
    _tfZhaopin.placeholder = @"请输入招聘信息";
    _tfZhaopin.delegate = self;
    [_tfZhaopin setTextColor:[UIColor blackColor]];
    _tfZhaopin.font = [UIFont systemFontOfSize:13];
    _tfZhaopin.layer.cornerRadius = 3.0;
    _tfZhaopin.layer.borderWidth = 0.5;
    _tfZhaopin.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfZhaopin];
    
    
    UILabel *labShopH = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60-10, 80, 60)];
    [labShopH setText:@"店铺图片"];
    labShopH.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopH];
    
    imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60-10, 60, 60)];
    [_scrollView addSubview:imgLogo];
    
    btnImageLogo = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10+60+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60-10, 60, 60)];
    btnImageLogo.tag = 0;
    [btnImageLogo setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [btnImageLogo addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnImageLogo];
    
    
    UILabel *labShopI = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60+60, 80, 60)];
    [labShopI setText:@"微信支付图片"];
    labShopI.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopI];
    
    wxLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60+60, 60, 60)];
    [_scrollView addSubview:wxLogo];
    
    btnWxLogo = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10+60+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60+60, 60, 60)];
    btnWxLogo.tag = 1;
    [btnWxLogo addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
    [btnWxLogo setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnWxLogo];
    
    
    UILabel *labShopJ = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60+60+60+10, 90, 60)];
    [labShopJ setText:@"支付宝支付"];
    labShopJ.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopJ];
    
    alpayLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60+60+60+10, 60, 60)];
    [_scrollView addSubview:alpayLogo];
    
    btnAlLogo = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10+60+10, 10+40+10+50+50+50+50+50+50+50+50+50+50+50+60+60+60+10, 60, 60)];
    btnAlLogo.tag = 2;
     [btnAlLogo setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [btnAlLogo addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnAlLogo];
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30,  kHeight-30-44-20-10, kWidth-30-30, 30)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 3.0;
    [btnSubmit setTitle:@"修改" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSubmit setFont:[UIFont systemFontOfSize:14]];
    [btnSubmit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
}


-(void)selectOnclick{
    [tableViewChoose reloadData];
    tableViewChoose.tableHeaderView = headView;
    tableViewChoose.tableFooterView = [[UIView alloc] init];
    [viewTableState addSubview:tableViewChoose];
    [self.dateArray removeAllObjects];
    [tableViewChoose reloadData];
    NSArray *array = @[@"一单一打",@"一菜一打"];
    [self.dateArray addObjectsFromArray:array];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone    ;
    [[HWPopTool sharedInstance] showWithPresentView:viewTableState animated:YES];
}


-(void)selectPic:(UIButton *)btn{
    managerType = btn.tag;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    
    }];
    
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


//当相片选取完成之后回来到这个函数
//完成后获取图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
    if (managerType==0) {
         imgLogo.image = selectedPhotos[0];
        logoData = UIImageJPEGRepresentation(imgLogo.image, 0.5);
        PHAsset *ass = assets[0];
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageDataForAsset:ass options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
            NSString *str = [url absoluteString];   //url>string
            NSArray *arr = [str componentsSeparatedByString:@"/"];
            fileNameLogo = [arr lastObject];  // 图片名字
            NSInteger length = imageData.length;   // 图片大小，单位B
            UIImage * image = [UIImage imageWithData:imageData];
        }];
    }else if (managerType==1){
        wxLogo.image = selectedPhotos[0];
        wxData = UIImageJPEGRepresentation(wxLogo.image, 0.5);
        PHAsset *ass = assets[0];
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageDataForAsset:ass options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
            NSString *str = [url absoluteString];   //url>string
            NSArray *arr = [str componentsSeparatedByString:@"/"];
            fileNameWx = [arr lastObject];  // 图片名字
            NSInteger length = imageData.length;   // 图片大小，单位B
            UIImage * image = [UIImage imageWithData:imageData];
        }];
    }else if (managerType==2){
        alpayLogo.image = selectedPhotos[0];
        alData = UIImageJPEGRepresentation(alpayLogo.image, 0.5);
        PHAsset *ass = assets[0];
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageDataForAsset:ass options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
            NSString *str = [url absoluteString];   //url>string
            NSArray *arr = [str componentsSeparatedByString:@"/"];
            fileNameAl = [arr lastObject];  // 图片名字
            NSInteger length = imageData.length;   // 图片大小，单位B
            UIImage * image = [UIImage imageWithData:imageData];
            
        }];
    }
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
            NSString *wechat_img = [NSString stringWithFormat:@"%@/heygay%@",RESOURCE_URL,[dics objectForKey:@"wechat_img"]];
            NSString *alipay_img = [NSString stringWithFormat:@"%@/heygay%@",RESOURCE_URL,[dics objectForKey:@"alipay_img"]];
            NSString *icon = [NSString stringWithFormat:@"%@/heygay%@",RESOURCE_URL,[dics objectForKey:@"icon"]];
            
            NSURL *icon_img = [[NSURL alloc] initWithString:icon];
            [imgLogo sd_setImageWithURL:icon_img];
            
            NSURL *wx_img = [[NSURL alloc] initWithString:wechat_img];
            [wxLogo sd_setImageWithURL:wx_img];
            
            NSURL *alp_img = [[NSURL alloc] initWithString:alipay_img];
            [alpayLogo sd_setImageWithURL:alp_img];
            
            NSString *shop_phone = [dics objectForKey:@"shop_phone"];
            
            NSNumber *printWay = [dics objectForKey:@"print_way"];
            if (printWay==1) {
                print_way = @"1";
                [btnSelect setTitle:@"一菜一打" forState:UIControlStateNormal];
            }else{
                print_way = @"2";
                [btnSelect setTitle:@"一单一打" forState:UIControlStateNormal];
            }
          
            NSString *cooker_off_time = [dics objectForKey:@"cooker_off_time"];
            csXbTime =cooker_off_time;
            NSString *last_check_time = [dics objectForKey:@"last_check_time"];
            jzTime = last_check_time;
            
            [btnCsXb setTitle:cooker_off_time forState:UIControlStateNormal];
            [btnJzTime setTitle:last_check_time forState:UIControlStateNormal];
            
            NSString *other = [dics objectForKey:@"other"];
            
            NSString *offer = [dics objectForKey:@"offer"];
            
            
            [_tfServiceTs setText:other];
            [_tfZhaopin setText:offer];
            
            
            
            [_tfShopName setText:shop_name];
            [_tfShopAddress setText:address];
            [_tfShopPersonName setText:shop_owner_name];
            [btnStartTime setTitle:begin_time forState:UIControlStateNormal];
            [btnEndTime setTitle:end_time forState:UIControlStateNormal];
            [_tfShopPersonPhone setText:shop_owner_phone];
            [_tfShopIntroduction setText:introduction];
            [_tfShopNotice setText:notice];
            [_tfShopMobilePhone setText:shop_phone];
           
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
        hud.labelText=@"更新中...";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        [self uploadImage];
    }
}

// 店铺LOGO
-(void)uploadImage{
    if (logoData.length>0) {
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",UPLOADIMAGE_URL,UPLOADCAIPINIMAGE];
        NSDictionary *parameters = @{
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
        
        [manager POST:postUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
           [formData appendPartWithFileData:logoData name:@"file" fileName:fileNameLogo mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                NSString *url = [responseObject objectForKey:@"URL"];
                logoFile = url;
                [self uploadImage1];
            }
            else
            {
                [self uploadImage1];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@", error);
        }];
    }else{
        [self uploadImage1];
    }
}
// 微信LOGO
-(void)uploadImage1{
    if (wxData.length>0) {
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",UPLOADIMAGE_URL,UPLOADCAIPINIMAGE];
        NSDictionary *parameters = @{
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
        
        [manager POST:postUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
           [formData appendPartWithFileData:wxData name:@"file" fileName:fileNameWx mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                NSString *url = [responseObject objectForKey:@"URL"];
                wxFile = url;
                [self uploadImage2];
            }
            else
            {
                [self uploadImage2];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@", error);
        }];
    }else{
        [self uploadImage2];
    }
}
 // 支付宝LOGO
-(void)uploadImage2{
    if (alData.length>0) {
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",UPLOADIMAGE_URL,UPLOADCAIPINIMAGE];
        NSDictionary *parameters = @{
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
        
        [manager POST:postUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
          [formData appendPartWithFileData:alData name:@"file" fileName:fileNameAl mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                NSString *url = [responseObject objectForKey:@"URL"];
                alFile = url;
                [self uploadDate];
            }
            else
            {
                [self uploadDate];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@", error);
        }];
    }else{
        [self uploadDate];
    }
}
// 更新店铺
-(void)uploadDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,UPDATESHOP];
    if (logoFile==nil) {
        logoFile = @"";
    }
    if (wxFile == nil) {
        wxFile = @"";
    }
    if (alFile == nil) {
        alFile = @"";
    }
    NSDictionary *parameters = @{@"shop_id":shop_id,
                                 @"shop_name":_tfShopName.text,
                                 @"address":_tfShopAddress.text,
                                 @"shop_owner_name":_tfShopPersonName.text,
                                 @"shop_owner_phone":_tfShopPersonPhone.text,
                                 @"introduction":_tfShopIntroduction.text,
                                 @"notice":_tfShopNotice.text,
                                 @"begin_time":starttime,
                                 @"end_time":endtime,
                                 @"shop_phone":_tfShopMobilePhone.text,
                                 @"cooker_off_time":csXbTime,
                                 @"last_check_time":jzTime,
                                 @"other":_tfServiceTs.text,
                                 @"offer":_tfZhaopin.text,
                                 @"print_way":print_way,
                                 @"icon":logoFile,
                                 @"wechat_img":wxFile,
                                 @"alipay_img":alFile
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
            hud.labelText = @"修改成功";
            [hud hide:YES afterDelay:0.5];
        }
        else
        {
            hud.labelText = @"修改失败";
            [hud hide:YES afterDelay:0.5];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
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

-(void)selectCsXbTimeClick{
    timespos = 2;
    dataPicker = nil;
    [self dataChoose];
}
-(void)selectjuiezTimeClick{
    timespos = 3;
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
    }else if(timespos==1){
        endtime = destDateString;
        [btnEndTime setTitle:endtime forState:UIControlStateNormal];
    }else if(timespos==2){
        csXbTime = destDateString;
        [btnCsXb setTitle:csXbTime forState:UIControlStateNormal];
    }else if(timespos==3){
        jzTime = destDateString;
        [btnJzTime setTitle:jzTime	 forState:UIControlStateNormal];
    }
    
    [dataPicker removeFromSuperview];
    dataPicker = nil;
}
-(void)dismiss{
    [dataPicker removeFromSuperview];
    dataPicker = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    tabcell.textLabel.textAlignment = UITextAlignmentCenter;
    
    NSString *array = self.dateArray[indexPath.section];
    
    tabcell.textLabel.text = array;
    
    return tabcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSString *array = self.dateArray[indexPath.section];
    [btnSelect setTitle:array forState:UIControlStateNormal];
    if ([array isEqualToString:@"一单一打"]) {
        print_way = @"2";
    }else{
        print_way = @"1";
    }
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
    }];
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
    [_tfZhaopin resignFirstResponder];
    [_tfShopMobilePhone resignFirstResponder];
    [_tfServiceTs resignFirstResponder];
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
