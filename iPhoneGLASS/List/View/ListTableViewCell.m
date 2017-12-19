//
//  ListTableViewCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListTableViewCell.h"
#import "ListModel.h"

@interface ListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *thickLable;

@property (weak, nonatomic) IBOutlet UILabel *sizeLable;

@property (weak, nonatomic) IBOutlet UILabel *finishLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;


@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setListModel:(ListModel *)listModel {
    
    _listModel = listModel;
//    self.nameLable.text = listModel.name;
    self.thickLable.text = [NSString stringWithFormat:@"%@",listModel.thick];
    self.sizeLable.text = [NSString stringWithFormat:@"%@ * %@ * %zd",listModel.width,listModel.height,listModel.totalNumber];
    self.finishLable.text = (listModel.number == listModel.totalNumber)?@"⭕️":[NSString stringWithFormat:@"%zd/%zd",listModel.number,listModel.totalNumber];
    self.finishLable.textColor = (listModel.number == listModel.totalNumber)?[UIColor redColor]:[UIColor blackColor];
}



@end
