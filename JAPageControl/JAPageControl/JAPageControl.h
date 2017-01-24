//
//  JAPageControl.h
//  JAPageControl
//
//  Created by daisuke on 2017/1/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JAPageControl : UIView

@property (strong, nonatomic) UIColor *selectedColor;

@property (strong, nonatomic) UIColor *unSelectedColor;

@property (assign, nonatomic) NSInteger pageCount;

@property (assign, nonatomic) NSInteger currentPage;

// default 10.0f, value than 10
@property (assign, nonatomic) CGFloat gapValue;

@property (weak, nonatomic) UIScrollView *scrollView;

@end
