//
//  ListCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/9/8.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "ListCell.h"
#import "ListModel.h"
#import "NSDate+YZBim.h"

@interface ListCell()

@property(nonatomic, strong) UILabel *typeLabel;

@property(nonatomic, strong) UILabel *sizeLabel;

@property(nonatomic, strong) UILabel *countLabel;

@property(nonatomic, strong) UIImageView *editImageView;

@property(nonatomic, strong) UILabel *dataLabel;

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
    self.editImageView = [[UIImageView alloc] init];
    self.editImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.editImageView];
    [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
    self.editImageView.hidden = YES;
    
    self.dataLabel = [[UILabel alloc] init];
    self.dataLabel.font = YZ_Font(12);
    [self.contentView addSubview:self.dataLabel];
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
    self.dataLabel.hidden = YES;
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.editImageView.mas_right).offset(10);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        make.top.mas_equalTo(0);
    }];
    
    self.countLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.countLabel];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.dataLabel.mas_left).offset(-10);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    
    self.sizeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.sizeLabel];
    self.sizeLabel.textAlignment = NSTextAlignmentCenter;
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right);
        make.right.mas_equalTo(self.countLabel.mas_left);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.typeLabel).offset(0);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
    }];
}

-(void)setListModel:(ListModel *)listModel {
    
    _listModel = listModel;
    //    self.nameLable.text = listModel.name;
    self.typeLabel.text = [NSString stringWithFormat:@"%@",listModel.thick];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ * %@",listModel.height,listModel.width];
    self.countLabel.text = listModel.isFinish?[NSString stringWithFormat:@"⭕️%zd",listModel.totalNumber]:[NSString stringWithFormat:@"%zd/%zd",listModel.number,listModel.totalNumber];
    self.countLabel.textColor = listModel.isFinish?[UIColor redColor]:[UIColor blackColor];
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    [self.editImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(edit?10:0);
        make.width.mas_equalTo(edit?35:0);
        make.height.mas_equalTo(edit?self.contentView.bounds.size.height:0);
    }];
    self.editImageView.hidden = !edit;
}

- (void)setChoose:(BOOL)choose {
    _choose = choose;
    self.imageView.image = [UIImage imageNamed:self.edit?(choose?@"choose.png":@"unchoose.png"):@""];
}

- (void)setShowDate:(BOOL)showDate {
    _showDate = showDate;
    if (showDate) {
        self.dataLabel.hidden = NO;
        self.dataLabel.text = [[NSDate dateFromISOString:self.listModel.date] formatMonthAndDay];
    }else{
        self.dataLabel.hidden = YES;
        self.dataLabel.text = @"";
    }
    [self.dataLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(showDate?-3:0);
        make.width.mas_equalTo(showDate?35:0);
    }];
}


@end
