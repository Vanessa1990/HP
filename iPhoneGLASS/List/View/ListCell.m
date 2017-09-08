//
//  ListCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/9/8.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "ListCell.h"
#import "ListModel.h"

@interface ListCell()

@property(nonatomic, strong) UILabel *typeLabel;

@property(nonatomic, strong) UILabel *sizeLabel;

@property(nonatomic, strong) UILabel *countLabel;

@end

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setUp
{
    self.typeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        make.top.mas_equalTo(0);
    }];
    
    self.countLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.countLabel];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.typeLabel);
    }];
    
    self.sizeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.sizeLabel];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right);
        make.right.mas_equalTo(self.countLabel.mas_left);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.typeLabel);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
    }];

}

-(void)setListModel:(ListModel *)listModel {
    
    _listModel = listModel;
    //    self.nameLable.text = listModel.name;
    if ([listModel.color isEqualToString:@"0"]) {
        self.typeLabel.text = listModel.thick;
    }else {
        self.typeLabel.text = [NSString stringWithFormat:@"%@ 福特蓝",[listModel.thick substringToIndex:1]];
    }
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ * %@",listModel.width,listModel.height];
    self.countLabel.text = (listModel.number == listModel.totalNumber)?@"是":[NSString stringWithFormat:@"%zd/%zd",listModel.number,listModel.totalNumber];
    self.countLabel.textColor = (listModel.number == listModel.totalNumber)?[UIColor redColor]:[UIColor blackColor];
}


@end
