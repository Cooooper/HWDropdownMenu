//
//  HWDropdownMenuBar.h
//  HWDropdownMenu
//
//  Created by Han Yahui on 16/12/08.
//  Copyright (c) 2015年 Hanyahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWDropdownMenuBarDelegate <NSObject>

- (void)showMenuAtButtonIndex:(NSInteger)index;
- (void)hideMenu;

@end

@interface HWDropdownMenuBar : UIView

@property (nonatomic, weak) id<HWDropdownMenuBarDelegate> delegate;

@property (nonatomic,strong) UIFont *textFont;

- (id)initDropdownMenuBarWithTitles:(NSArray *)titles;

- (void)changeCurrentButtonTitle:(NSString *)title;

@end
