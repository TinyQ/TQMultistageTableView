//
//  TQMultistageTableView.h
//  TQMultistageTableView
//
//  Created by fuqiang on 13-8-19.
//
//  Copyright (c) 2013 TinyQ (http://tinyq.me )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

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

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;


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

/**
 *  重新加载数据
 */
- (void)reloadData;

@end

/**
 *  TQMultistageTableView 数据协议
 */
@protocol TQTableViewDataSource <NSObject>

@required

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView;              // Default is 1 if not implemented

@end


/**
 *  TQMultistageTableView 委托协议
 */
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
- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end



