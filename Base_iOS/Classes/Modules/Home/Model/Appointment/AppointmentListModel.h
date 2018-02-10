//
//  AppointmentListModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface AppointmentListModel : BaseModel
//头像
@property (nonatomic, copy) NSString *photo;
//昵称
@property (nonatomic, copy) NSString *nickName;
//性别
@property (nonatomic, assign) NSInteger gender;
//职业
@property (nonatomic, copy) NSString *job;
//专长
@property (nonatomic, copy) NSString *expertise;
//风格
@property (nonatomic, strong) NSArray <NSString *>*style;
@property (nonatomic, strong) NSArray <UIColor *>*styleColor;
//评分
@property (nonatomic, assign) NSInteger score;
//个人简介
@property (nonatomic, copy) NSString *introduce;
//预约状态
@property (nonatomic, copy) NSString *status;
//
@property (nonatomic, assign) CGFloat cellHeight;

@end
