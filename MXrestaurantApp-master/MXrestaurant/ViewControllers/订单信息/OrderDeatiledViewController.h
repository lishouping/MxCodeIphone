//
//  OrderDeatiledViewController.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/22.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface OrderDeatiledViewController : RootViewController
@property(nonatomic,strong)NSString *order_num;
@property(nonatomic,strong)NSString *pageflag;// 0未处理，1正在用餐，2已完成

@end
