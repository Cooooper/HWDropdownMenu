//
//  DropdownButton.m
//  Common
//
//  Created by Han Yahui on 15/9/9.
//  Copyright (c) 2015年 Hanyahui. All rights reserved.
//

#import "HWDropdownMenuBar.h"
#import "HWDropdownMenuDefine.h"


#define kDefaultTextFont [UIFont systemFontOfSize:15]

@implementation HWDropdownMenuBar
{
  NSInteger _lastTapButtonIndex;
  
  NSArray *_titles;
  
}


- (id)initDropdownMenuBarWithTitles:(NSArray *)titles
{
  self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MENUBAR_HEIGHT)];
  if (self) {
    
    _titles = titles;
    [self addButtonToView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu:) name:@"hideDropdownMenu" object:nil];
  }
  return self;
}

- (void)addButtonToView
{
  for (int i = 0; i < _titles.count; i++) {
    UIButton *button = [self makeButton:[_titles objectAtIndex:i] andIndex:i];
    [self addSubview:button];
    if (i > 0) {
      UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x, 10, 1, 20)];
      lineView.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
      [self addSubview:lineView];
    }
  }
  UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, MENUBAR_HEIGHT, SCREEN_WIDTH, 1)];
  bottomLine.backgroundColor = kSeparatorColor;
  [self addSubview:bottomLine];
}

- (UIButton *)makeButton:(NSString *)title andIndex:(int)index
{
  if(title.length > 5) {
    title=[NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
  }
  
  float width = SCREEN_WIDTH / _titles.count;
  float offsetX = width * index;
  UIImage *image = [UIImage imageNamed:@"expandable"];
  
  CGFloat realWidth = [self calculateTitleSizeWithString:title].width;
  CGFloat padding = (width - (image.size.width + realWidth)) / 2;
  
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, width, MENUBAR_HEIGHT)];
  button.tag = 10000 + index;
  [button setImage:image forState:UIControlStateNormal];
  [button setImageEdgeInsets:UIEdgeInsetsMake(11, realWidth + padding + 5, 11, 0)];
  [button.titleLabel setFont:self.textFont?:kDefaultTextFont];
  [button setTitle:title forState:UIControlStateNormal];
  [button setTitleEdgeInsets:UIEdgeInsetsMake(11, 0, 11, image.size.width + 5)];
  button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  [button setBackgroundColor:[UIColor whiteColor]];
  [button setTitleColor:kTextColor forState:UIControlStateNormal];
  [button addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
  UIFont *font = self.textFont?:kDefaultTextFont;
  NSDictionary *dic = @{NSFontAttributeName: font};
  CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dic context:nil].size;
  return size;
}

- (void)showMenuAction:(id)sender
{
  NSInteger i = [sender tag];
  [self openMenuBtnAnimation:i];
}

- (void)openMenuBtnAnimation:(NSInteger)index
{
  if (_lastTapButtonIndex != index) {
    if (_lastTapButtonIndex > 0) {
      [self changeButtionTag:_lastTapButtonIndex rotation:0];
    }
    _lastTapButtonIndex = index;
    [self changeButtionTag:index rotation:M_PI];
    [self.delegate showMenuAtButtonIndex:index];
  }
  else {
    [self changeButtionTag:_lastTapButtonIndex rotation:0];
    _lastTapButtonIndex = 0;
    [self.delegate hideMenu];
  }
}

- (void)hideMenu:(NSNotification *)notification
{
  NSNumber *index = [notification object];
  
    [self changeButtionTag:([index intValue] + 10000) rotation:0];

  _lastTapButtonIndex = 0;
}

- (void)changeButtionTag:(NSInteger)index rotation:(CGFloat)angle
{
  [UIView animateWithDuration:0.1f animations:^{
    UIButton *btn = (UIButton *)[self viewWithTag:index];
    if (angle == 0) {
      [btn setTitleColor:kTextColor forState:UIControlStateNormal];
    }
    else {
      [btn setTitleColor:kMainColor forState:UIControlStateNormal];


    }
    btn.imageView.transform = CGAffineTransformMakeRotation(angle);
  }];
}

- (void)changeCurrentButtonTitle:(NSString *)title
{
  
  if(title.length > 5) {
    title=[NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
  }
  
  UIButton *btn = (UIButton *)[self viewWithTag:_lastTapButtonIndex];
  
  CGFloat realWidth = [self calculateTitleSizeWithString:title].width;
  CGFloat padding = (btn.frame.size.width - (10 + realWidth)) / 2;

  [btn setImageEdgeInsets:UIEdgeInsetsMake(11, realWidth + padding + 5, 11, 0)];

  [btn setTitle:title forState:UIControlStateNormal];

}

-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideDropdownMenu" object:nil];
  
}

@end
