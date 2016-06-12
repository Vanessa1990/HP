//
//  SearchTVC.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchTVC;

@protocol SearchTVCDelegate <NSObject>

-(void)SearchTVC:(SearchTVC *)VC searchSuccess:(NSArray *)array;

@end

@interface SearchTVC : UITableViewController

@property (nonatomic, strong) id <SearchTVCDelegate> delegate;

@end
