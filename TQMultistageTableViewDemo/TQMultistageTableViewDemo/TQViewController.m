//
//  TQViewController.m
//  TQMultistageTableViewDemo
//
//  Created by fuqiang on 13-9-3.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TQViewController ()

@end

@implementation TQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *titleBgColor = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1];
    CGRect rect = [UIScreen mainScreen ].bounds;
    
    if (!OSVersionIsAtLeastiOS7())
    {
        rect.size.height -= 20 + 44;
        [self.navigationController.navigationBar setTintColor:titleBgColor];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:titleBgColor];
    }

    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:rect];
    self.mTableView.dataSource = self;
    self.mTableView.delegate   = self;
    self.mTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.mTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.bounds.size.width, 100)];
    view.backgroundColor = [UIColor colorWithRed:251/255.0 green:125/255.0 blue:91/255.0 alpha:1];
    
    self.mTableView.atomView = view;
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
    view.layer.backgroundColor  = [UIColor colorWithRed:246/255.0 green:213/255.0 blue:105/255.0 alpha:1].CGColor;
    view.layer.masksToBounds    = YES;
    view.layer.borderWidth      = 0.5;
    view.layer.borderColor      = [UIColor colorWithRed:250/255.0 green:77/255.0 blue:83/255.0 alpha:1].CGColor;
    
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return 20;
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[UIView alloc] init];
    
    header.layer.backgroundColor    = [UIColor colorWithRed:218/255.0 green:249/255.0 blue:255/255.0 alpha:1].CGColor;
    header.layer.masksToBounds      = YES;
    header.layer.borderWidth        = 0.5;
    header.layer.borderColor        = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1].CGColor;
    return header;
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
