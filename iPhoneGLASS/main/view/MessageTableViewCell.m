//
//  MessageTableViewCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2019/9/9.
//  Copyright © 2019年 Yizhu. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "NSDate+YZBim.h"

@interface MessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    // 设置 list 圆角
    CAShapeLayer *mask = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.listView.bounds];
    mask.path = path.CGPath;
    self.listView.layer.mask = mask;
    self.listView.backgroundColor = YZ_GrayColor33;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(NSDictionary *)message {
    _message = message;
    self.mTitleLabel.text = message[@"title"];
    self.contentLabel.text = message[@"content"];
    self.timeLabel.text = [message[@"date"] formatOnlyDay];
}


@end
