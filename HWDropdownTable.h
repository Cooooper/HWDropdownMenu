//
//  ConditionDoubleTableView.h
//  MacauFood
//
//  Created by Han Yahui on 15/8/21.
//  Copyright (c) 2015年 Hanyahui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HWDropdownTableDelegate <NSObject>

@required

- (void)didSelectedLeftTableAtIndex:(NSInteger)index;
- (void)selectedFirstValue:(NSString *)first secondValue:(NSString *)second;
- (void)hideMenu;

- (NSArray *)dataForLeftTableView;
- (NSArray *)dataForRightTableView;

@end

@interface HWDropdownTable : UIView <UITableViewDelegate, UITableViewDataSource> 
@property (nonatomic, weak) id <HWDropdownTableDelegate>delegate;

@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIFont *textFont;


- (void)reloadRightTableView;

- (void)reloadData;

//显示下拉菜单
- (void)showTableView:(NSInteger)index withSelectedLeft:(NSString *)left right:(NSString *)right;
- (void)hideTableView;
@end
