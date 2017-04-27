//
//  MyViewController2.m
//  仿轻芒
//
//  Created by 唐天成 on 2017/4/16.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "MyViewController2.h"

@interface MyViewController2 ()

@end

@implementation MyViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadNewRequestWithDataList {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.array addObject:@"34"];
        [self.array addObject:@""];
        [self.array addObject:@"14"];
        [self.array addObject:@"74"];
        [self.array addObject:@"34"];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

#pragma mark - lazyLoad
- (NSMutableArray *)array{
    if(!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}


@end
