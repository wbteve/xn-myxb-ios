//
//  IntegralGoodDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface IntegralGoodDetailVC : BaseViewController
//产品编号
@property (nonatomic, copy) NSString *code;
//
@property (nonatomic,copy) void(^paySuccess)(void);

@end
