//
//  BrandListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandListCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
//Extension
#import <UIImageView+WebCache.h>
//M
//V
//C

@interface BrandListCell()
//产品图片
@property (nonatomic, strong) UIImageView *goodIV;
//产品名称
@property (nonatomic, strong) UILabel *nameLbl;
//产品说明
@property (nonatomic, strong) UILabel *descLbl;
//产品价格
@property (nonatomic, strong) UILabel *priceLbl;
//产品销量
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation BrandListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //产品图片
    self.goodIV = [[UIImageView alloc] init];
    
    self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
    self.goodIV.clipsToBounds = YES;
    
    [self addSubview:self.goodIV];
    
    //产品名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self addSubview:self.nameLbl];
    //产品说明
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:14.0];
    self.descLbl.numberOfLines = 0;
    
    [self addSubview:self.descLbl];
    //产品价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kThemeColor
                                                 font:18.0];
    
    [self addSubview:self.priceLbl];
    //产品销量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor2
                                               font:14.0];
    
    [self addSubview:self.numLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)setSubviewLayout {

    CGFloat leftMargin = 15;
    
    //产品图片
    [self.goodIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.width.height.equalTo(@(110));
    }];
    //产品名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.goodIV.mas_right).offset(leftMargin);
        make.top.equalTo(self.goodIV.mas_top).offset(8);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@40);
    }];
    //产品说明
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@20);
    }];
    //产品价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.goodIV.mas_bottom).offset(-5);
    }];
    //产品销量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.goodIV.mas_right).offset(110);
        make.centerY.equalTo(self.priceLbl.mas_centerY);
    }];
}

#pragma mark - Setting
- (void)setBrandModel:(BrandModel *)brandModel {
    
    _brandModel = brandModel;
    
    _goodIV.image = kImage(@"健康专家");
    _nameLbl.text = @"欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅欧莱雅";
    _descLbl.text = @"绽放你的美绽放你的美绽放你的美绽放你的美绽放你的美绽放你的美绽放你的美绽放你的美绽放你的美";
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", @"1999.00"];
    _numLbl.text = [NSString stringWithFormat:@"已售: %@", @"999"];
    //    [_goodIV sd_setImageWithURL:[NSURL URLWithString:brandModel.pics[0]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    //    _nameLbl.text = brandModel.name;
    [self setSubviewLayout];
}
@end