//
//  GlassTableViewCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/15.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "GlassTableViewCell.h"

@interface GlassTableViewCell()



@end

@implementation GlassTableViewCell

+(instancetype)glassCell {
    
    return [[NSBundle mainBundle]loadNibNamed:@"GlassTableViewCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.num = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addClick:(id)sender {
    
    self.num++;
    self.numberLable.text = [NSString stringWithFormat:@"%d",self.num];
//    self.changeNumberBlock(self.numberLable.text);
    
}
- (IBAction)reduceClick:(id)sender {
    self.num--;
    self.numberLable.text = [NSString stringWithFormat:@"%d",self.num];
//    self.changeNumberBlock(self.numberLable.text);
}


@end
