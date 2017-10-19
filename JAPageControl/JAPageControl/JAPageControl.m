//
//  JAPageControl.m
//  JAPageControl
//
//  Created by daisuke on 2017/1/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "JAPageControl.h"

@interface JAPageControl () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *animateCircle;
@property (strong, nonatomic) NSMutableArray *circles;
@property (assign, nonatomic) NSInteger startOffset;

@end

@implementation JAPageControl
@synthesize scrollView = _scrollView;
@synthesize selectedColor = _selectedColor;
@synthesize unSelectedColor = _unSelectedColor;
@synthesize width = _width;
@synthesize gap = _gap;

#pragma mark - instance method

- (void)update {
    // JAPageControl frame
    CGRect newFrame = self.frame;
    newFrame.size.height = self.width;
    newFrame.size.width = (self.pages * self.width) + ((self.pages - 1) * self.gap);
    self.frame = newFrame;
    
    if (self.animateCircle == nil) {
        // 初始化
        self.animateCircle = [[UIView alloc] init];
        [self addSubview:self.animateCircle];
    }
    else {
        // 移除目前所有元件, 重新創造新的元件
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.circles removeAllObjects];
    }
    
    for (NSInteger index = 0; index < self.pages; index++) {
        CGFloat x = (self.width * index) + (index * self.gap);
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.width, self.width)];
        circle.backgroundColor = (index >= self.currentPage) ? self.selectedColor : self.unSelectedColor;
        circle.layer.cornerRadius = self.width / 2.0f;
        circle.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        [self addSubview:circle];
        [self.circles addObject:circle];
    }
    
    self.animateCircle.frame = CGRectMake(0, 0, self.width, self.width);
    self.animateCircle.layer.cornerRadius = self.width / 2.0f;
    self.animateCircle.backgroundColor = self.selectedColor;
}

#pragma mark - properties

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.delegate = self;
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
}

- (UIColor *)selectedColor {
    return _selectedColor ? _selectedColor : [UIColor whiteColor];
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
}

- (UIColor *)unSelectedColor {
    return _unSelectedColor ? _unSelectedColor : [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:0.2f];
}

#pragma mark * readonly

- (CGFloat)gap {
    if (!_gap) {
        _gap = 10.0f;
    }
    return _gap;
}

- (CGFloat)width {
    if (!_width) {
        _width = 10.0f;
    }
    return _width;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // page value
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    CGFloat pageHalfWidth = (pageWidth / 2.0f);
    
    // scroll min/max bound
    CGFloat minBound = 0;
    CGFloat maxBound = pageWidth * (self.pages - 1);
    BOOL isScrollBoundRange = (scrollView.contentOffset.x >= minBound && scrollView.contentOffset.x <= maxBound);
    
    if (isScrollBoundRange) {
        // full page index, continuous scroll page, need change page index
        NSInteger pageIndex = (scrollView.contentOffset.x / pageWidth);
        if (self.currentPage != pageIndex) {
            self.currentPage = pageIndex;
            self.startOffset = scrollView.contentOffset.x;
        }
        
        // half page index, turn the page halfway, page index
        int pageHalfIndex = floor((scrollView.contentOffset.x - pageHalfWidth) / pageWidth) + 1;
        
        // modify animateCircle frame
        CGRect animateCircleFrame = self.animateCircle.frame;
        CGFloat pageOffset = scrollView.contentOffset.x - (self.currentPage * pageWidth);
        if (self.currentPage == pageHalfIndex) {
            CGFloat mainValue = MIN(pageHalfWidth, (pageOffset * 2.5));
            CGFloat flexibleWidth = (self.width * (mainValue / pageHalfWidth));
            
            // width + flexibleWidth(max) = width + self.gap
            animateCircleFrame.size.width = self.width + flexibleWidth;
            
            // modify circle backgroundColor
            UIView *circle = self.circles[pageHalfIndex];
            circle.backgroundColor = self.unSelectedColor;
        }
        else {
            CGFloat mainValue = MIN(pageHalfWidth, ((pageOffset - pageHalfWidth)));
            CGFloat flexibleWidth = (self.width * (mainValue / pageHalfWidth));
            CGFloat animateCircleMaxWidth = (self.width + self.gap);
            animateCircleFrame.size.width = animateCircleMaxWidth - flexibleWidth;
            
            // modify circle backgroundColor
            UIView *circle = self.circles[self.currentPage + 1];
            circle.backgroundColor = self.selectedColor;
        }
        
        // modify animateCircle x
        CGFloat nextCircleX = (self.width + self.gap);
        CGFloat flexibleX = (nextCircleX / pageWidth) * scrollView.contentOffset.x;
        animateCircleFrame.origin.x = flexibleX;
        self.animateCircle.frame = animateCircleFrame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    NSInteger pageIndex = scrollView.contentOffset.x / pageWidth;
    
    self.currentPage = pageIndex;
}

#pragma mark - private instance method

#pragma mark * init values

- (void)setupInitValues {
    self.circles = [NSMutableArray new];
}

#pragma mark * misc

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitValues];
    }
    return self;
}

@end
