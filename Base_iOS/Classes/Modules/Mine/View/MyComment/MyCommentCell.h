//
//  MyCommentCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "CommentModel.h"

@interface MyCommentCell : BaseTableViewCell
//
@property (nonatomic, strong) CommentModel *comment;

@end
