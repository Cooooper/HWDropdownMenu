//
//  ConditionDoubleTableView.m
//  MacauFood
//
//  Created by Han Yahui on 15/8/21.
//  Copyright (c) 2015年 Hanyahui. All rights reserved.
//

#import "HWDropdownTable.h"
#import "HWDropdownMenuDefine.h"

#define CELLHEIGHT 44.0

@interface HWDropdownTable ()<UIGestureRecognizerDelegate>
{
  
  UITableView *_leftTableView;
  UITableView *_rightTableView;
  
  NSArray *_leftItems;
  NSArray *_rightItems;
  NSArray *_leftArray;
  NSArray *_rightArray;
  
  NSInteger _leftSelectedIndex;
  NSInteger _rightSelectedIndex;
  
  NSInteger _buttonIndex;
  
  BOOL isHidden;
}

@property (nonatomic,strong) UIView *rootView;

@end

@implementation HWDropdownTable


- (instancetype)init
{
  self = [super init];
  if (self) {
    
    self.frame = CGRectMake(0, MENUBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - MENUBAR_HEIGHT);
    self.backgroundColor = [self colorWithRGB:0x000000 alpha:0.3];
    
    _rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2)];

    UITapGestureRecognizer *tapDimissMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    tapDimissMenu.delegate = self;
    [self addGestureRecognizer:tapDimissMenu];
    
    _buttonIndex = -1;
    isHidden = YES;
    
    _leftItems = [self.delegate dataForLeftTableView];
    _rightItems = [self.delegate dataForRightTableView];
    
    
    [self initFirstTableViewWithFrame:_rootView.frame];
    [self initSecondTableViewWithFrame:_rootView.frame];
    [self addSubview:_rootView];
    
    [self setHidden:YES];
    
  }
  return self;
}


- (void)initFirstTableViewWithFrame:(CGRect)frame
{
  _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2.0f, frame.size.height)
                                                 style:UITableViewStylePlain];
  _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
  _leftTableView.backgroundColor = [self colorWithRGB:0xFAFAFA];
  _leftTableView.delegate = self;
  _leftTableView.dataSource = self;
  _leftTableView.rowHeight = CELLHEIGHT;
  [_rootView addSubview:_leftTableView];
}

- (void)initSecondTableViewWithFrame:(CGRect)frame
{
  _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width / 2, 0, frame.size.width/2.0f, frame.size.height)
                                                  style:UITableViewStylePlain];
  _rightTableView.separatorStyle = UITableViewCellSelectionStyleNone;
  _rightTableView.backgroundColor = [UIColor whiteColor];
  _rightTableView.delegate = self;
  _rightTableView.dataSource = self;
  _rightTableView.rowHeight = CELLHEIGHT;
  [_rootView addSubview:_rightTableView];
}

- (void)reloadRightTableView
{
  _leftItems = [self.delegate dataForLeftTableView];
  _rightItems = [self.delegate dataForRightTableView];
  
  if (_buttonIndex != -1) {
    [self reloadTableViewData:_buttonIndex];
  }
  
  [_rightTableView reloadData];
}


- (void)reloadData
{
  _leftItems = [self.delegate dataForLeftTableView];
  _rightItems = [self.delegate dataForRightTableView];
  
  if (_buttonIndex != -1) {
    [self reloadTableViewData:_buttonIndex];
  }
  
  
  [_leftTableView reloadData];
  [_rightTableView reloadData];
}

- (void)tapView
{
  [self hideTableView];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if([touch.view isKindOfClass:[self class]]){
    return YES;
  }
  return NO;
  
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == _leftTableView) {
    return _leftArray.count;
  }
  else if (tableView == _rightTableView) {
    if (_rightArray.count > _leftSelectedIndex) {
      NSArray *array = [_rightArray objectAtIndex:_leftSelectedIndex];
      return array.count;
    } else {
      return 0;
    }
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (tableView == _leftTableView) {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTableCellId"];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftTableCellId"];
    }
//    [self removeCellView:cell];
    if (_leftArray.count > 0) {
      cell.textLabel.text = [_leftArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.font = self.textFont;
    
    UIView *selectView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    selectView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = selectView;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
  }
  else if (tableView == _rightTableView){
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"rightTableCellId"];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightTableCellId"];
    }
    NSArray *array = [_rightArray objectAtIndex:_leftSelectedIndex];
   
    if (array.count > 0) {
      NSDictionary *dic = [array objectAtIndex:indexPath.row];
      cell.textLabel.text = [dic valueForKey:@"title"];
    }
    
    
    cell.textLabel.font = self.textFont;

    cell.textLabel.highlightedTextColor = self.selectedColor?:[self colorWithRGB:0x90EE90];
    
    UIView *noSelectView = [[UIView alloc] initWithFrame:cell.bounds];
    UIView *noSelectLine = [[UIView alloc] initWithFrame:CGRectMake(15, noSelectView.bounds.size.height-1, tableView.frame.size.width - 15, 0.5)];
    noSelectLine.backgroundColor = self.normalColor?:[self colorWithRGB:0xBEBEBE];

    [noSelectView addSubview:noSelectLine];
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    UIView *selectLine = [[UIView alloc] initWithFrame:CGRectMake(15, selectView.bounds.size.height-1, tableView.frame.size.width - 15, 0.5)];
    selectLine.backgroundColor = self.selectedColor?:[self colorWithRGB:0x90EE90];
    [selectView addSubview:selectLine];
    cell.backgroundView = noSelectView;
    cell.selectedBackgroundView = selectView;
    
    return cell;
    
  }
  
  return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == _leftTableView && _leftArray.count > 0) {
    _leftSelectedIndex = 0;
    [self.delegate didSelectedLeftTableAtIndex:indexPath.row];
    [_rightTableView reloadData];
  }
  else {
    [self returnSelectedValue:indexPath.row];
  }
  
}

- (void)removeCellView:(UITableViewCell*)cell
{
  for (UIView *subview in cell.contentView.subviews) {
    [subview removeFromSuperview];
  }
}

#pragma mark - 私有方法
//显示下拉菜单
- (void)showTableView:(NSInteger)index withSelectedLeft:(NSString *)left right:(NSString *)right
{
  if (isHidden == YES || _buttonIndex != index) {
    _buttonIndex = index;
    isHidden = NO;
    self.alpha = 1.0;
    [self setHidden:NO];
    [self reloadTableViewData:index];
    [self showSingleOrDouble];
    [self showLastSelectedLeft:left right:right];
    _rootView.center = CGPointMake(self.frame.size.width / 2, 0 - _rootView.bounds.size.height / 2);
    [UIView animateWithDuration:0.5 animations:^{
      _rootView.center = CGPointMake(self.frame.size.width / 2, _rootView.bounds.size.height / 2);
    }];
  }
  else {
    [self hideTableView];
  }
}

- (void)showSingleOrDouble
{
  if (_leftArray.count <= 0) {
    [_leftTableView setHidden:YES];
    _rightTableView.frame = CGRectMake( 0, 0, _rootView.frame.size.width, _rootView.frame.size.height);
  }
  else {
    [_leftTableView setHidden:NO];
    _rightTableView.frame = CGRectMake(_rootView.frame.size.width / 2, 0, _rootView.frame.size.width/2, _rootView.frame.size.height);
  }
}

//按了不同按钮,刷新菜单数据
- (void)reloadTableViewData:(NSInteger)index
{
  _leftArray = [[NSArray alloc] initWithArray:[_leftItems objectAtIndex:index]];
  _rightArray = [[NSArray alloc] initWithArray:[_rightItems objectAtIndex:index]];
}

//渐渐隐藏菜单
- (void)hideTableView
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hideDropdownMenu"
                                                      object:[NSString stringWithFormat:@"%ld",(long)_buttonIndex]];

  isHidden = YES;
  [UIView animateWithDuration:0.5 animations:^{
    self.alpha = 0.0;
  } completion:^(BOOL finish){
    [self setHidden:YES];
    _rootView.center = CGPointMake(self.frame.size.width / 2, 0 - _rootView.bounds.size.height / 2);
  }];
}

//返回选中位置
- (void)returnSelectedValue:(NSInteger)index
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFirstValue:secondValue:)]) {
    NSInteger firstSelected = _leftSelectedIndex > 0 ? _leftSelectedIndex : 0;
    NSString *firstIndex = [NSString stringWithFormat:@"%ld", (long)firstSelected];
    NSString *indexObj = [NSString stringWithFormat:@"%ld", (long)index];
    [self.delegate performSelector:@selector(selectedFirstValue:secondValue:) withObject:firstIndex withObject:indexObj];
    [self hideTableView];
  }
}

//显示最后一次选中位置
- (void)showLastSelectedLeft:(NSString *)leftSelected right:(NSString *)rightSelected
{
  
  NSInteger left = [leftSelected intValue];
  if (_leftArray.count > 0) {
    [_leftTableView reloadData];
    NSIndexPath *leftSelectedIndexPath = [NSIndexPath indexPathForRow:left inSection:0];
    [_leftTableView selectRowAtIndexPath:leftSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  }
  _leftSelectedIndex = left;
  
  NSInteger right = [rightSelected intValue];
  [_rightTableView reloadData];
  NSIndexPath *rightSelectedIndexPath = [NSIndexPath indexPathForRow:right inSection:0];
  [_rightTableView selectRowAtIndexPath:rightSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (UIColor*)colorWithRGB:(unsigned int)RGBValue
{
  return [UIColor colorWithRed:((RGBValue&0xFF0000)>>16)/255.0 green:((RGBValue&0xFF00)>>8)/255.0 blue:(RGBValue&0xFF)/255.0 alpha:1];
}

- (UIColor*)colorWithRGB:(unsigned int)RGBValue alpha:(CGFloat)alpha
{
  return [UIColor colorWithRed:((RGBValue&0xFF0000)>>16)/255.0 green:((RGBValue&0xFF00)>>8)/255.0 blue:(RGBValue&0xFF)/255.0 alpha:alpha];
}


-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideDropdownMenu" object:nil];

}

@end
