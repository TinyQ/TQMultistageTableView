//
//  TQMultistageTableView.h
//  TQMultistageTableView
//
//  Created by fuqiang on 13-8-19.
//  Copyright (c) 2013年 Magus. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef TQ_STRONG
#if __has_feature(objc_arc)
#define TQ_STRONG strong
#else
#define TQ_STRONG retain
#endif
#endif

#ifndef TQ_WEAK
#if __has_feature(objc_arc_weak)
#define TQ_WEAK weak
#elif __has_feature(objc_arc)
#define TQ_WEAK unsafe_unretained
#else
#define TQ_WEAK assign
#endif
#endif

#if __has_feature(objc_arc)
#define TQ_AUTORELEASE(exp) exp
#define TQ_RELEASE(exp) exp
#define TQ_RETAIN(exp) exp
#else
#define TQ_AUTORELEASE(exp) [exp autorelease]
#define TQ_RELEASE(exp) [exp release]
#define TQ_RETAIN(exp) [exp retain]
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define MBLabelAlignmentCenter NSTextAlignmentCenter
#else
#define MBLabelAlignmentCenter UITextAlignmentCenter
#endif

@class TQMultistageTableView;
#define DEFULT_HEIGHT_FOR_ROW 50.0f

@protocol TQTableViewDataSource <NSObject>

@required

- (NSInteger)mTableView:(TQMultistageTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)mTableView:(TQMultistageTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)tableView;

- (UIView *)mTableView:(TQMultistageTableView *)tableView openCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TQTableViewDelegate <NSObject>

@optional

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (UIView *)mTableView:(TQMultistageTableView *)tableView viewForHeaderInSection:(NSInteger)section;
//header点击
- (void)mTableView:(TQMultistageTableView *)tableView didSelectHeaderAtSection:(NSInteger)section;
//celll点击
- (void)mTableView:(TQMultistageTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//header展开
- (void)mTableView:(TQMultistageTableView *)tableView willOpenHeaderAtSection:(NSInteger)section;
//header关闭
- (void)mTableView:(TQMultistageTableView *)tableView willCloseHeaderAtSection:(NSInteger)section;

//cell展开
- (void)mTableView:(TQMultistageTableView *)tableView willOpenCellAtIndexPath:(NSIndexPath *)indexPath;
//cell关闭
- (void)mTableView:(TQMultistageTableView *)tableView willCloseCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TQMultistageTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,TQ_WEAK) id <TQTableViewDataSource> dataSource;
@property (nonatomic,TQ_WEAK) id <TQTableViewDelegate>   delegate;
@property (nonatomic,TQ_STRONG) UITableView *tableView;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)openCellViewWithIndexPath:(NSIndexPath *)indexPath;
- (void)openOrCloseHeaderWithSection:(int)section;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadDataWithTableViewCell:(UITableViewCell *)cell;
- (void)reloadData;
- (void)updateTableView;
- (bool)isOpenCellWithIndexPath:(NSIndexPath *)indexPath;
@end
