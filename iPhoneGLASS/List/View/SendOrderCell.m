//
//  SendOrderCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/25.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "SendOrderCell.h"

@interface SendOrderCell()

@property (assign, nonatomic) NSUInteger count;

@end

@implementation SendOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ListModel *)model {
    _model = model;
    self.count = model.sendCount;
    self.typeLabel.text = model.thick;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ * %@ * %zd ",model.height,model.width,model.totalNumber];
    self.countLable.text = [NSString stringWithFormat:@"%zd",self.count];
}


- (IBAction)editClick:(UIButton *)sender {
    if (sender.tag == 100) {// 减
        if (self.count == 0) {
            return;
        }
        self.count--;
    }else if (sender.tag == 101){// 加
        if (self.count == self.model.number) {
            return;
        }
        self.count++;
    }
    self.countLable.text = [NSString stringWithFormat:@"%zd",self.count];
    [self.delegate sendOrderCellCountClick:self.model count:self.count];
}

@end
