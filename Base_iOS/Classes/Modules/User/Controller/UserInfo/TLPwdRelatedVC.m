//
//  TLPwdRelatedVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLPwdRelatedVC.h"
#import "CaptchaView.h"
#import "APICodeMacro.h"

#import "NSString+Check.h"

@interface TLPwdRelatedVC ()

@property (nonatomic,assign) TLPwdType type;
@property (nonatomic,strong) TLTextField *phoneTf;
//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;

@property (nonatomic,strong) CaptchaView *captchaView;
@property (nonatomic,strong) TLTextField *pwdTf;
@property (nonatomic,strong) TLTextField *rePwdTf;


@end

@implementation TLPwdRelatedVC

- (instancetype)initWithType:(TLPwdType)type {
    
    if (self = [super init]) {
        
        self.type = type;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    if ([TLUser user].mobile) {
        
        self.phoneTf.enabled = NO;
        self.phoneTf.text = [TLUser user].mobile;
    }
    
    if(self.type == TLPwdTypeForget) {
        
        self.title = @"忘记密码";
        
    } else if (self.type == TLPwdTypeReset) {
        
        self.title = @"修改登录密码";
    }
}

#pragma mark - Init

- (void)setUpUI {
    
    CGFloat leftW = 100;
    
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)
                                                    leftTitle:@"用户名"
                                                   titleWidth:leftW
                                                  placeholder:@"请输入手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, phoneTf.width, phoneTf.height)
                                                 leftTitle:@"谷歌验证码"
                                                titleWidth:leftW
                                               placeholder:@"请输入谷歌验证码"];
    
    [self.view addSubview:self.googleAuthTF];
    
    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:@"粘贴" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:13.0 cornerRadius:5];
    
    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);
    
    pasteBtn.centerY = authView.height/2.0;
    
    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
    
    [authView addSubview:pasteBtn];
    
    self.googleAuthTF.rightView = authView;
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, phoneTf.y + 1, phoneTf.width, phoneTf.height)];
    
    captchaView.captchaTf.leftLbl.text = @"短信验证码";
    
    [self.bgSV addSubview:captchaView];
    _captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //新密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(phoneTf.x, captchaView.yy + 10, phoneTf.width, phoneTf.height)
                                                  leftTitle:@"新密码"
                                                 titleWidth:leftW
                                                placeholder:@"请输入密码(不少于6位)"];
    
    pwdTf.returnKeyType = UIReturnKeyNext;
    
    [pwdTf addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.bgSV addSubview:pwdTf];
    pwdTf.secureTextEntry = YES;
    self.pwdTf = pwdTf;
    
    //重新输入
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(phoneTf.x, pwdTf.yy + 1, phoneTf.width, phoneTf.height)
                                                    leftTitle:@"确认密码"
                                                   titleWidth:leftW
                                                  placeholder:@"请确认密码"];
    
    rePwdTf.returnKeyType = UIReturnKeyDone;

    [rePwdTf addTarget:self action:@selector(done:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.bgSV addSubview:rePwdTf];
    rePwdTf.secureTextEntry = YES;
    
    self.rePwdTf = rePwdTf;
    
    NSString *btnStr = @"";
    
    if(self.type == TLPwdTypeForget) {
        
        btnStr = @"确认找回";
        
    } else if (self.type == TLPwdTypeReset) {
        
        btnStr= @"确认修改";
        
    }
    
    //确认按钮
    UIButton *confirmBtn = [UIButton buttonWithTitle:btnStr titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(15, rePwdTf.yy + 30, kScreenWidth - 30, 44);
    [self.bgSV addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}



#pragma mark - Events

- (void)sendCaptcha {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    if (self.type == TLPwdTypeForget || self.type == TLPwdTypeReset){ //找回密码||修改登录密码
        
        http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
    }
    
    http.parameters[@"mobile"] = self.phoneTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)clickPaste {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.string != nil) {
        
        self.googleAuthTF.text = pasteboard.string;
        
    } else {
        
        [TLAlert alertWithInfo:@"粘贴内容为空"];
    }
}

- (void)next:(UIButton *)sender {

    [_rePwdTf becomeFirstResponder];
}

- (void)done:(UIButton *)sender {

    [_rePwdTf resignFirstResponder];
}

- (void)confirm {
    
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    if (![self.pwdTf.text isEqualToString:self.rePwdTf.text]) {
        
        [TLAlert alertWithInfo:@"输入的密码不一致"];
        return;
        
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.type == TLPwdTypeForget || self.type == TLPwdTypeReset){
        
        http.code = USER_FIND_PWD_CODE;
        http.parameters[@"kind"] = @"C";
        http.parameters[@"mobile"] = self.phoneTf.text;
        http.parameters[@"newLoginPwd"] = self.pwdTf.text;
    }
    
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;

    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = @"";
        
        if(self.type == TLPwdTypeForget) {
            
            promptStr = @"找回成功";
            
        } else if (self.type == TLPwdTypeReset) {
            
            promptStr= @"修改成功";
        }
        
        [TLAlert alertWithSucces:promptStr];
        //保存用户账号和密码
        [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
        
        if (self.success) {
            
            self.success();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
