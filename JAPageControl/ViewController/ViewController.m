//
//  ViewController.m
//  JAPageControl
//
//  Created by daisuke on 2017/1/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "ViewController.h"
#import "JAPageControl.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) JAPageControl *jaPageControl;

@end

@implementation ViewController

#pragma mark - IBAction

- (IBAction)pageButtonAction:(id)sender {
    NSInteger randomIndex = arc4random() % 4;
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.bounds);
    [self.scrollView setContentOffset:CGPointMake(randomIndex * scrollViewWidth, 0) animated:YES];
}

#pragma mark - private

#pragma mark * init values

- (void)setupScrollViews {
    NSInteger pages = 10;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.scrollView.contentSize = CGSizeMake(pages * screenWidth, 0);
    
    for (int pageIndex = 0; pageIndex < pages; pageIndex++) {
        CGFloat height = CGRectGetHeight(self.scrollView.bounds);
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(pageIndex * screenWidth, 0, screenWidth, height)];
        pageView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255)/255.0 green:(arc4random() % 255)/255.0 blue:(arc4random() % 255)/255.0 alpha:1.0];
        [self.scrollView addSubview:pageView];
    }
}

- (void)setupJAPageControls {
    NSInteger pageCount = 5;
    self.jaPageControl = [[JAPageControl alloc] init];
    self.jaPageControl.scrollView = self.scrollView;
    self.jaPageControl.pageCount = pageCount;
//    self.jaPageControl.selectedColor = [UIColor redColor];
//    self.jaPageControl.unSelectedColor = [UIColor blueColor];
    
    CGFloat x = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5;
    CGFloat y = CGRectGetHeight(self.scrollView.bounds) - 20;
    self.jaPageControl.center = CGPointMake(x, y);
    [self.view addSubview:self.jaPageControl];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollViews];
    [self setupJAPageControls];
}

@end
