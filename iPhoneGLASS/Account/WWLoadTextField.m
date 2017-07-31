//
//  WWLoadTextField.m


#import "WWLoadTextField.h"

#import <objc/message.h>

@implementation WWLoadTextField

-(void)awakeFromNib{
    
    //1.设置光标颜色
    self.tintColor = [UIColor lightGrayColor];
    
    //2.设置字体颜色
    self.textColor = [UIColor blackColor];
    
    /***=====****======***设置提示文字的属性方式二:***======***======***/
    //3.设置提示文本的文字属性
    
    //3.1.设置文本编辑时候的提示文本的文字属性方式一:***======***======***
    [self resignFirstResponder];
}

-(BOOL)resignFirstResponder{
    
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
    
    return [super resignFirstResponder];
}

-(BOOL)becomeFirstResponder{
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    
    return [super becomeFirstResponder];
}

/*
//3.1.设置文本编辑时候的提示文本的文字属性方式二:***======***======***
-(void)addobserve{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startediting) name:UITextFieldTextDidBeginEditingNotification object:self];//这里的object一定要写self,不能为空,否则键盘弹出的时候,两个文本框的提示文字都是白色的
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endediting) name:UITextFieldTextDidEndEditingNotification object:self];

}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}   


-(void)startediting{
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
}

-(void)endediting{
    
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
}
*/
/***=====****======***设置提示文字的属性方式一:***======***======***/
/*
-(void)drawPlaceholderInRect:(CGRect)rect{
    
    //1.设置写文字的位子
    CGRect placeholderRect = self.bounds;
    placeholderRect.origin.y = (self.height - self.font.lineHeight)/2;
    
    //2.设置文字的属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    
    //3.设置提示文本
    [self.placeholder drawInRect:placeholderRect withAttributes:dict];
 
}
*/

/*
 -(void)getProparty{
     //利用runtime找出属性
     unsigned int count = 0;
     Ivar *ivars = class_copyIvarList([UITextField class], &count);
     
     for (int i = 0; i < count; i++) {
     Ivar ivar = ivars[i];
     NSLog(@"%s",ivar_getName(ivar));//其中一个属性:_placeholderLabel
     }
     
     free(ivars);

 }
 */
@end
