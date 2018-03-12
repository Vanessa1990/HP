//
//  BasicTableController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/9.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "BasicTableController.h"

@implementation BasicTableController

- (void)setAddEnable:(BOOL)addEnable {
    _addEnable = addEnable;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(addMore)];
}

- (void)addMore {
    
}

- (void)setItems:(NSArray *)items {
    _items = items;
//    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",self.items[indexPath.row]);
    if ([(id)self.delegate respondsToSelector:@selector(basicTableController:chooseItem:)]) {
        [self.delegate basicTableController:self chooseItem:self.items[indexPath.row]];
    }
}

@end
