//
//  ServiceDetaliedViewController.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/11.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface ServiceDetaliedViewController : RootViewController
@property(nonatomic,strong)NSString *service_id;
@property(nonatomic,strong)NSString *service_state;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSString *serviceTime;


@property(nonatomic,strong)UILabel *labServiceState;
@property(nonatomic,strong)UILabel *labSendServiceTime;
@property(nonatomic,strong)UILabel *labServiceContent;
@property(nonatomic,strong)UIButton *btnServiceHander;
@property(nonatomic,strong)UILabel *labTableNumber;
@end
