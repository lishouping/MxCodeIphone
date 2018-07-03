//
//  CategoryModel.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property(nonatomic,strong)NSString *category_id;
@property(nonatomic,strong)NSString *category_name;
@property(nonatomic,strong)NSString *category_status;
@property(nonatomic,strong)NSArray *goods_list;
@end
