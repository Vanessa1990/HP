//
//  STPickerDate.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerDate.h"
#import "STConfig.h"
#import "NSCalendar+ST.h"

static CGFloat const PickerViewHeight = 260;
static CGFloat const PickerViewLabelWeight = 44;

static NSInteger const yearMin = 1900;
static NSInteger const yearSum = 200;

@interface STPickerDate()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.选择器 */
@property (nonatomic, strong, nullable)UIPickerView *pickerView;
/** 2.工具器 */
@property (nonatomic, strong, nullable)STToolbar *toolbar;
/** 3.边线 */
@property (nonatomic, strong, nullable)UIView *lineView;

/** 4.年 */
@property (nonatomic, assign)NSInteger year;
/** 5.月 */
@property (nonatomic, assign)NSInteger month;
/** 6.日 */
@property (nonatomic, assign)NSInteger day;
/** 7.厚 */
@property (nonatomic, strong)NSArray *thickArray;
/** 8.完成度 */
@property (nonatomic, strong)NSArray *finishArray;

@property (nonatomic, strong)NSString *returnDate;

@end

@implementation STPickerDate

#pragma mark - --- init 视图初始化 ---

- (instancetype)initWithType:(PickerType)type {
    
    self = [self init];
    self.type = type;
     [self loadData];
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = RGBA(0, 0, 0, 102.0/255);
    [self.layer setOpaque:0.0];
    [self addSubview:self.pickerView];
    [self.pickerView addSubview:self.lineView];
    [self addSubview:self.toolbar];
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData
{
    if (self.type == PickerTypeDate) {
        _year  = [NSCalendar currentYear];
        _month = [NSCalendar currentMonth];
        _day   = [NSCalendar currentDay];
        [self.pickerView selectRow:(_year - yearMin) inComponent:0 animated:NO];
        [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
        [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
    }else if (self.type == PickerTypeFinishTwo) {
        self.returnDate = @"未完成";
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    }else{
        self.returnDate = @"全部";
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
    }
    
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.type == PickerTypeDate) {
        if (component == 0) {
            return yearSum;
        }else if(component == 1) {
            return 12;
        }else {
            NSInteger yearSelected = [pickerView selectedRowInComponent:0] + yearMin;
            NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
            return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
        }
    } else {
        if (component == 0) {
            return 0;
        }else if(component == 1) {
            if (self.type == PickerTypeThick) {
                return 6;
            }else if (self.type == PickerTypeFinish){
                return 3;
            }else if (self.type == PickerTypeFinishTwo){
                return 2;
            }else{
                return 0;
            }
        }else {
            return 0;
        }
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return PickerViewLabelWeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.type == PickerTypeDate) {
        switch (component) {
            case 0:
                [pickerView reloadComponent:1];
                [pickerView reloadComponent:2];
                break;
            case 1:
                [pickerView reloadComponent:2];
            default:
                break;
        }
    }
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (self.type == PickerTypeDate) {
        if (component == 0) {
            text =  [NSString stringWithFormat:@"%d", row + 1900];
        }else if (component == 1){
            text =  [NSString stringWithFormat:@"%d", row + 1];
        }else{
            text = [NSString stringWithFormat:@"%d", row + 1];
        }
    } else {
        if (component == 1) {
            if (self.type == PickerTypeThick){
                text = self.thickArray[row];
            }else if (self.type == PickerTypeFinish || self.type == PickerTypeFinishTwo){
                text = self.finishArray[row];
            }else {
                text = @"";
            }
        }
        
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:20]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    NSString *date;
    if (self.type == PickerTypeDate) {
         date = [NSString stringWithFormat:@"%zd-%zd-%zd",self.year,self.month,self.day];
    }else {
        date = self.returnDate;
    }
    
    if (self.finishBlock) {        
        self.finishBlock(date);
    }
   
    [self remove];
}

- (void)selectedCancel
{
    [self remove];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    if (self.type == PickerTypeDate) {
        self.year  = [self.pickerView selectedRowInComponent:0] + yearMin;
        self.month = [self.pickerView selectedRowInComponent:1] + 1;
        self.day   = [self.pickerView selectedRowInComponent:2] + 1;
        
        self.toolbar.title = [NSString stringWithFormat:@"%d年%d月%d日", self.year, self.month, self.day];
    } else if (self.type == PickerTypeThick) {
        self.returnDate = self.thickArray[[self.pickerView selectedRowInComponent:1]];
        self.toolbar.title = [NSString stringWithFormat:@"%@",self.returnDate];
    } else {
        self.returnDate = self.finishArray[[self.pickerView selectedRowInComponent:1]];
        self.toolbar.title = [NSString stringWithFormat:@"%@",self.returnDate];
    }
    
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameTool = self.toolbar.frame;
    frameTool.origin.y -= PickerViewHeight;
    
    CGRect framePicker =  self.pickerView.frame;
    framePicker.origin.y -= PickerViewHeight;
    [UIView animateWithDuration:0.33 animations:^{
        [self.layer setOpacity:1];
        self.toolbar.frame = frameTool;
        self.pickerView.frame = framePicker;
    } completion:^(BOOL finished) {
    }];
}

- (void)remove
{
    CGRect frameTool = self.toolbar.frame;
    frameTool.origin.y += PickerViewHeight;
    
    CGRect framePicker =  self.pickerView.frame;
    framePicker.origin.y += PickerViewHeight;
    [UIView animateWithDuration:0.33 animations:^{
        [self.layer setOpacity:0];
        self.toolbar.frame = frameTool;
        self.pickerView.frame = framePicker;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        CGFloat pickerW = ScreenWidth;
        CGFloat pickerH = PickerViewHeight - 44;
        CGFloat pickerX = 0;
        CGFloat pickerY = ScreenHeight + 44;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

- (STToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[STToolbar alloc]initWithTitle:@"请选择"
                                 cancelButtonTitle:@"取消"
                                     okButtonTitle:@"确定"
                                         addTarget:self
                                      cancelAction:@selector(selectedCancel)
                                          okAction:@selector(selectedOk)];
        _toolbar.x = 0;
        _toolbar.y = ScreenHeight;
    }
    return _toolbar;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [_lineView setBackgroundColor:RGB(205, 205, 205)];
    }
    return _lineView;
}

-(NSArray *)thickArray {
    
    if (!_thickArray) {
        _thickArray = @[@"全部",@"4mm",@"5mm",@"6mm",@"8mm",@"10mm",@"12mm"];
    }
    return _thickArray;
}

-(NSArray *)finishArray {
    
    if (!_finishArray) {
        _finishArray = self.type == PickerTypeFinishTwo?@[@"未完成",@"已完成"]:@[@"全部",@"未完成",@"已完成"];
    }
    return _finishArray;
}

@end


