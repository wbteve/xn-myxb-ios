//
//  HelpCenterCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HelpCenterCell.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"

@interface HelpCenterCell()
//title
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation HelpCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    //arrow
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"下拉")];
    
    [self.contentView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.equalTo(@11);
        
    }];
    
    self.arrowIV = arrowIV;
    
    //image
    self.iconIV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIV];
    self.iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
    }];
    //title
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:16.0];
    
    self.titleLbl.numberOfLines = 0;
    self.titleLbl.adjustsFontSizeToFitWidth = YES;
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(45);
        make.right.equalTo(arrowIV.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@45);
        make.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    self.line = bottomLine;
    
}

- (void)setQuestion:(QuestionModel *)question {
    
    _question = question;
    
    self.titleLbl.text = question.title;
    
    if (question.isFold) {
        
        self.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
        self.line.hidden = YES;
        
    } else {
        
        self.arrowIV.transform = CGAffineTransformIdentity;
        self.line.hidden = NO;
    }
    
    CGFloat w = kScreenWidth - 45 - 15 - 6 - 15;
    CGFloat h = [question.content calculateStringSize:CGSizeMake(w, MAXFLOAT) font:Font(16.0)].height;
    question.cellHeight = h > 50 ? h: 50;
    
}

@end
