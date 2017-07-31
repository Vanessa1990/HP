//
//  LocalBimService+Account.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@class AccountModel;

@interface LocalBimService (Account)

- (SHXPromise *)insertLocalAccountWithAccount:(AccountModel *)accountModel;
- (SHXPromise *)getLocalAccountWithAccountID:(NSString *)accountID;

@end
