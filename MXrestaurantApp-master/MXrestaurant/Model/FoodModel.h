//
//  FoodModel.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *pre_price;
@property(nonatomic,strong)NSString *good_id;
@property(nonatomic,strong)NSString *good_exts_flag;
@property(nonatomic,strong)NSArray *goods_exts_list;
@end
