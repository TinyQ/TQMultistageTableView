//
//  TQViewController.m
//  TQMultistageTableViewDemo
//
//  Created by fuqiang on 13-9-3.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQViewController.h"

@interface TQViewController ()

@end

@implementation TQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if(OSVersionIsAtLeastiOS7())
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }

    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    self.mTableView.dataSource = self;
    self.mTableView.delegate   = self;

    [self.view addSubview:self.mTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.bounds.size.width, 100)];
    view.backgroundColor = [UIColor colorWithRed:187/255.0 green:206/255.0 blue:190/255.0 alpha:1];;
    
    self.mTableView.atomView = view;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(addbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)addbuttonClick:(id)sender
{
    [self.mTableView sendCellTouchActionWithIndexPath:[NSIndexPath indexPathForRow:6 inSection:2]];
}

#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    
    view.backgroundColor = [UIColor colorWithRed:128/255.0 green:156/255.0 blue:151/255.0 alpha:1];
    cell.backgroundView = view;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return 10;
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    UIView * control = [[UIView alloc] init];
    control.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d",section];
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(20, 0, 200, 40);
    [control addSubview:label];
    return control;
}
#pragma mark -
- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mTableView.bounds.size.width, 100)];
    view.backgroundColor = [UIColor colorWithRed:187/255.0 green:206/255.0 blue:190/255.0 alpha:1];;
    return view;
}

#pragma mark -
- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"Open Header ----%d",section);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    NSLog(@"Close Header ---%d",section);
}

#pragma mark -
- (void)mTableView:(TQMultistageTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Open Row ----%d",indexPath.row);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Close Row ----%d",indexPath.row);
}


@end
