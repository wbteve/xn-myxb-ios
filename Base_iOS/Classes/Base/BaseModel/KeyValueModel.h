//
//  KeyValueModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/12.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface KeyValueModel : BaseModel

@property (nonatomic, copy) NSString *cvalue;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *ckey;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *updateDatetime;


@end
