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

@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger pages;

@property (assign, nonatomic) CGFloat gap;

@property (assign, nonatomic) CGFloat width;

@property (weak, nonatomic) UIScrollView *scrollView;

- (void)update;

@end
