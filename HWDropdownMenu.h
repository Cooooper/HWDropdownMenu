//
//  DropdownMenu.h
//  Common
//
//  Created by Han Yahui on 15/9/9.
//  Copyright (c) 2015年 Hanyahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWDropdownTable.h"

@class HWDropdownMenu;

@protocol HWDropdownMenuDelegate <NSObject>

@optional

- (void)dropdownMenu:(HWDropdownMenu *)menu didSelectedButtonIndex:(NSInteger)index rightIndex:(NSInteger)rightIndex;

- (void)dropdownMenu:(HWDropdownMenu *)menu didSelectedButtonIndex:(NSInteger)index leftIndex:(NSInteger)leftIndex;

- (NSArray *)dataForLeftTableViewWithDropdownMenu:(HWDropdownMenu *)menu;
- (NSArray *)dataForRightTableViewWithDropdownMenu:(HWDropdownMenu *)menu;


@end

@interface HWDropdownMenu : UIView<HWDropdownTableDelegate>

@property (weak, nonatomic) id<HWDropdownMenuDelegate> delegate;

@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIFont *textFont;

- (instancetype)initDropdownWithButtonTitles:(NSArray*)titles;

- (void)reloadData;

- (void)reloadRightTableView;

- (void)hideDropdownMenu;


@end
