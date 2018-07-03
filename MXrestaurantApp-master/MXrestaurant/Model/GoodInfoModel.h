//
//  GoodInfoModel.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodInfoModel : NSObject
@property(nonatomic,strong)NSString*good_id;
@property(nonatomic,strong)NSString*pre_price;
@property(nonatomic,strong)NSString *good_name;
@property(nonatomic,strong)NSString *good_price;
@property(nonatomic,strong)NSString *good_num;
@property(nonatomic,strong)NSString *good_total_price;
@property(nonatomic,strong)NSString *cart_good_id;
@property(nonatomic,strong)NSString *if_up;
@property(nonatomic,strong)NSString *ext_size_id;
@end
