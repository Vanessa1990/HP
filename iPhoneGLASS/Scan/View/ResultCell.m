//
//  ResultCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/1.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ResultCell.h"
#import "NSDate+YZBim.h"

@implementation ResultCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellbg.jpg"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)save:(id)sender {
    
    //上传数据
    NSDictionary *dict = [NSDictionary dictionary];
    if ([self.delegate respondsToSelector:@selector(ResultCell:didPutaway:)]) {
        [self.delegate ResultCell:self didPutaway:self.model];
    }
}

- (void)setModel:(ListModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.length.text = model.height;
    self.width.text = model.width;
    self.typeLabel.text = model.thick;
    self.writeCount.text = [NSString stringWithFormat:@"%ld/%ld",model.number,model.totalNumber];
    NSDate *date = [NSDate dateFromISOString:model.date];
    self.dateLabel.text = [date format];
}


@end
