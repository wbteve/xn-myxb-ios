//
//  TLUser.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUser.h"

#import "UserDefaultsUtil.h"
#import "TLNetworking.h"
#import "APICodeMacro.h"
#import "TLUIHeader.h"
#import "AppConfig.h"

#define USER_ID_KEY @"user_id_key"
#define TOKEN_ID_KEY @"token_id_key"
#define USER_INFO_DICT_KEY @"user_info_dict_key"

NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification";
NSString *const kUserInfoChange = @"kUserInfoChange";
//角色类型
NSString *const kUserTypeSalon = @"C";      //美容院
NSString *const kUserTypeBeautyGuide = @"T";//美导
NSString *const kUserTypeLecturer = @"L";   //讲师
NSString *const kUserTypeExpert = @"S";     //专家

@implementation TLUser

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
        
    });
    
    return user;
}

#pragma mark - Setting

- (void)setToken:(NSString *)token {
    
    _token = [token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString *)userId {
    
    _userId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (userId && token) {
        
        self.userId = userId;
        self.token = token;
        [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];
        
        return YES;
    } else {

        return NO;
    }
}

- (void)reLogin {
    
    self.userName = [UserDefaultsUtil getUserDefaultName];
    self.userPassward = [UserDefaultsUtil getUserDefaultPassword];
    self.kind = [UserDefaultsUtil getUserDefaultKind];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_LOGIN_CODE;
    http.parameters[@"loginName"] = self.userName;
    http.parameters[@"loginPwd"] = self.userPassward;
    http.parameters[@"kind"] = self.kind;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.token = responseObject[@"data"][@"token"];
        self.userId = responseObject[@"data"][@"userId"];
        
        [self updateUserInfo];
//        [self requestQiniuDomain];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestQiniuDomain {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"qiniu_domain";
    [http postWithSuccess:^(id responseObject) {
        
        [AppConfig config].qiniuDomain = [NSString stringWithFormat:@"http://%@", responseObject[@"data"][@"cvalue"]];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 账户
//- (void)requestAccountNumber {
//
//    CoinWeakSelf;
//
//    //获取人民币和积分账户
//    TLNetworking *http = [TLNetworking new];
//    http.code = @"802503";
//    http.parameters[@"userId"] = [TLUser user].userId;
//    http.parameters[@"token"] = [TLUser user].token;
//
//    [http postWithSuccess:^(id responseObject) {
//
//        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//
//        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([obj.currency isEqualToString:@"JF"]) {
//
//                weakSelf.jfAccountNumber = obj.accountNumber;
//
//            } else if ([obj.currency isEqualToString:@"CNY"]) {
//
//                weakSelf.rmbAccountNumber = obj.accountNumber;
//            }
//
//        }];
//
//    } failure:^(NSError *error) {
//
//
//    }];
//}

- (void)loginOut {

    self.userId = nil;
    self.token = nil;
    self.photo = nil;
    self.mobile = nil;
    self.level = nil;
    self.jfAccountNumber = nil;
    self.realName = nil;
    self.speciality = nil;
    self.style = nil;
    self.slogan = nil;
    self.introduce = nil;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];
}

- (void)saveUserInfo:(NSDictionary *)userInfo {

    NSLog(@"原%@--现%@",[TLUser user].userId,userInfo[@"userId"]);
    
    if (![[TLUser user].userId isEqualToString:userInfo[@"userId"]]) {
        
        @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)updateUserInfo {

    TLNetworking *http = [TLNetworking new];
    
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = self.userId;
    http.parameters[@"token"] = self.token;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];

    } failure:^(NSError *error) {
        
    }];
}

- (void)setUserInfoWithDict:(NSDictionary *)dict {
    
    self.mobile = dict[@"mobile"];
    self.realName = dict[@"realName"];
    self.level = dict[@"level"];
    self.photo = dict[@"photo"];
    self.speciality = dict[@"speciality"];
    self.style = dict[@"style"];
    self.gender = dict[@"gender"];
    self.slogan = dict[@"slogan"];
    self.introduce = dict[@"introduce"];
}

- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd {
    
    self.userName = userName;
    self.userPassward = pwd;

    [UserDefaultsUtil setUserDefaultName:userName];
    [UserDefaultsUtil setUserDefaultPassword:pwd];
    [UserDefaultsUtil setUserDefaultKind:self.kind];
}

- (NSString *)getUserType {
    
    NSDictionary *dic = @{
                          kUserTypeSalon        : @"美容院",
                          kUserTypeBeautyGuide  : @"美导",
                          kUserTypeLecturer     : @"讲师",
                          kUserTypeExpert       : @"专家",
                          };
    
    return dic[self.kind];
    
}

@end

@implementation AdviserUser

@end

