//
//  ResultCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/1.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ResultCell.h"

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
        [self.delegate ResultCell:self didPutaway:dict];
    }
}


@end
