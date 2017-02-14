//
//  DropdownMenu.m
//  Common
//
//  Created by Han Yahui on 15/9/9.
//  Copyright (c) 2015年 Hanyahui. All rights reserved.
//

#import "HWDropdownMenu.h"
#import "HWDropdownMenuDefine.h"
#import "HWDropdownMenuBar.h"


@interface HWDropdownMenu()<HWDropdownMenuBarDelegate>
{
  NSInteger _lastIndex;
  
  NSInteger _menuBarSelectedIndex;
  NSMutableArray *_menuBarIndexArray;
  
  NSArray *_titles;
  NSArray *_leftArray;
  NSArray *_rightArray;
}

@property (nonatomic,strong) HWDropdownMenuBar *menuBar;
@property (nonatomic,strong) HWDropdownTable *tableView;

@end

@implementation HWDropdownMenu


- (instancetype)initDropdownWithButtonTitles:(NSArray*)titles
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, MENUBAR_HEIGHT);
    _menuBar = [[HWDropdownMenuBar alloc] initDropdownMenuBarWithTitles:titles];
    _menuBar.delegate = self;
    _tableView = [[HWDropdownTable alloc] init];
    _tableView.delegate = self;
    _titles = titles;
    
    [self addSubview:_tableView];
    [self addSubview:_menuBar];
    _menuBarIndexArray = [[NSMutableArray alloc] initWithCapacity:titles.count];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceBackgroundSize) name:@"hideDropdownMenu" object:nil];
  }
  return self;
}


-(void)setDelegate:(id<HWDropdownMenuDelegate>)delegate
{
  _delegate = delegate;
  [self reloadData];
}

-(void)setSelectedColor:(UIColor *)selectedColor
{
  _selectedColor = selectedColor;
  _tableView.selectedColor = selectedColor;
}

-(void)setNormalColor:(UIColor *)normalColor
{
  _normalColor = normalColor;
  _tableView.normalColor = normalColor;
}

-(void)setTextFont:(UIFont *)textFont
{
  _textFont = textFont;
  _tableView.textFont = textFont;
  _menuBar.textFont = textFont;
}

- (void)reloadData
{
  
  if ([self.delegate respondsToSelector:@selector(dataForLeftTableViewWithDropdownMenu:)]) {
    _leftArray = [self.delegate dataForLeftTableViewWithDropdownMenu:self];

  }
  
  if ([self.delegate respondsToSelector:@selector(dataForRightTableViewWithDropdownMenu:)]) {
    _rightArray = [self.delegate dataForRightTableViewWithDropdownMenu:self];
    
  }
  
  [_tableView reloadData];
}

- (void)reloadRightTableView
{
  _rightArray = [self.delegate dataForRightTableViewWithDropdownMenu:self];
  [_tableView reloadRightTableView];
}

- (void)hideDropdownMenu
{
  [_tableView hideTableView];
}

//button点击代理

#pragma mark - menu bar delegate

- (void)showMenuAtButtonIndex:(NSInteger)index
{
  _lastIndex = index;
  self.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
  _menuBarSelectedIndex = index - 10000;
  NSString *selected = @"0-0";
  if (_menuBarIndexArray.count > _menuBarSelectedIndex){
    selected = [_menuBarIndexArray objectAtIndex:_menuBarSelectedIndex];
  }
  else {
    for (int i = 0; i < _menuBarSelectedIndex; i++) {
      
      [_menuBarIndexArray addObject:selected];
    }
  }
  NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
  NSString *left = [selectedArray objectAtIndex:0];
  NSString *right = [selectedArray objectAtIndex:1];
  [_tableView showTableView:_menuBarSelectedIndex withSelectedLeft:left right:right];
}

- (void)hideMenu
{
  [self hideDropdownMenu];
}

- (void)reduceBackgroundSize
{
  [self setFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, MENUBAR_HEIGHT)];
}

- (void)selectedFirstValue:(NSString *)first secondValue:(NSString *)second
{
  NSString *index = [NSString stringWithFormat:@"%@-%@", first, second];
  [_menuBarIndexArray setObject:index atIndexedSubscript:_menuBarSelectedIndex];
  [self returnSelectedLeftIndex:[first integerValue] rightIndex:[second integerValue]];
}

- (void)didSelectedLeftTableAtIndex:(NSInteger)index
{
  NSInteger buttonIndex = (long)_lastIndex - 10000;

  [self.delegate dropdownMenu:self didSelectedButtonIndex:buttonIndex leftIndex:index];
  
  if (buttonIndex == 0 && index == 0) { // 在所在城市里点击‘所有城市’隐藏 dropdown menu
    
    [self changeButtonTitle:_leftArray[buttonIndex][index]];
    
    [self hideDropdownMenu];

  }
}

- (NSArray *)dataForLeftTableView
{
  return [self.delegate dataForLeftTableViewWithDropdownMenu:self];
}

- (NSArray *)dataForRightTableView
{
  return [self.delegate dataForRightTableViewWithDropdownMenu:self];
}


- (void)returnSelectedLeftIndex:(NSInteger)left rightIndex:(NSInteger)right
{
  NSInteger buttonIndex = (long)_lastIndex - 10000;
  NSArray *rightArray     = [_rightArray objectAtIndex:buttonIndex];
  NSArray *rightValueArray= [rightArray objectAtIndex:left];
  NSString *rightValue    = [[rightValueArray objectAtIndex:right] valueForKey:@"title"];
  
  [self changeButtonTitle:rightValue];

  
  if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectedButtonIndex:rightIndex:)]) {
    [self.delegate dropdownMenu:self didSelectedButtonIndex:buttonIndex rightIndex:right];
  }
  
}


- (void)changeButtonTitle:(NSString *)title
{
  [_menuBar changeCurrentButtonTitle:title];
  
}

-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideDropdownMenu" object:nil];

}

@end
