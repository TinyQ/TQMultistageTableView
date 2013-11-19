//
//  TQMultistageTableView.h
//  TQMultistageTableView
//
//  Created by fuqiang on 13-8-19.
//  Copyright (c) 2013年 Magus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    //最外层
	TQHeaderLineTouch,
    //中间层
	TQCellLineTouch,
    //代码
	TQCodeSendTouch,
} TQLineTouchType;

@protocol TQTableViewDataSource , TQTableViewDelegate;

@interface TQMultistageTableView : UIView <UITableViewDelegate, UITableViewDataSource>

/**
 *  数据源相关委托
 */
@property (nonatomic,assign) id <TQTableViewDataSource> dataSource;

/**
 *  事件回调相关委托
 */
@property (nonatomic,assign) id <TQTableViewDelegate>   delegate;

/**
 *  展开的列表层级索引 Default is [NSIndexPath indexPathForRow:-1 inSection:-1]
 */
@property (nonatomic,readonly,strong) NSIndexPath *openedIndexPath;

/**
 *  主体列表对象
 */
@property (nonatomic,readonly,strong) UITableView *tableView;

/**
 *  展开最内层cell 要显示的View
 */
@property (nonatomic,strong) UIView *atomView;

/**
 *  展开后atomView的位置坐标（相对于展开的 Cell 左下角）Default is CGPointMake(0, 0);
 */
@property (nonatomic) CGPoint atomOrigin;

/**
 *  列表单元添加复用标识
 *
 *  @param identifier 复用标识字符串
 *
 *  @return 列表单元对象
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

/**
 *  模拟列表Cell点击事件 -1 为关闭
 *
 *  @param indexPath cell所在路径
 */
- (void)sendCellTouchActionWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  模拟列表Header点击事件 －1 为关闭
 *
 *  @param section header 索引
 */
- (void)sendHeaderTouchActionWithSection:(NSInteger)section;

- (void)reloadData;

@end




@protocol TQTableViewDataSource <NSObject>

@required

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView;              // Default is 1 if not implemented

- (NSString *)mTableView:(TQMultistageTableView *)mTableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)mTableView:(TQMultistageTableView *)mTableView titleForFooterInSection:(NSInteger)section;

@end



@protocol TQTableViewDelegate <NSObject>

@optional

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section;
- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section;

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)mTableView:(TQMultistageTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath;

@end



