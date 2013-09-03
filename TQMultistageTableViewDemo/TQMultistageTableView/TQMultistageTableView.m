//
//  TQMultistageTableView.m
//  TQMultistageTableView
//
//  Created by fuqiang on 13-8-19.
//  Copyright (c) 2013年 Magus. All rights reserved.
//

#import "TQMultistageTableView.h"
@interface TQMultistageTableView ()

@property (nonatomic,assign) BOOL isReusableCell;
@property (nonatomic,TQ_STRONG) UIView * viewForExpand;

@property (nonatomic,assign) BOOL selectIndexPathIsOpen;
@property (nonatomic,TQ_STRONG) NSIndexPath *selectIndexPath;

@property (nonatomic,assign) BOOL selectOldIndexPathIsOpen;
@property (nonatomic,TQ_STRONG) NSIndexPath *selectOldIndexPath;

@end

@implementation TQMultistageTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isReusableCell = NO;
        self.selectIndexPathIsOpen = NO;
        self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        self.selectOldIndexPathIsOpen = NO;
        self.selectOldIndexPath = nil;
        
        //
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    
#if !__has_feature(objc_arc)
    [_tableView release];
    
    [_viewForExpand release];
    [_selectIndexPath release];
    [_selectOldIndexPath release];
    [super dealloc];

#endif

}

#pragma mark - Set

-(void)setFrame:(CGRect)frame
{
    self.tableView.frame = frame;
    [super setFrame:frame];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self.tableView setBackgroundColor:backgroundColor];
    [super setBackgroundColor:backgroundColor];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self dataSource_numberOfSectionsInTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        if (self.selectIndexPath.section != section)
        {
            return 0;
        }
    }
    
    NSInteger n = 0;
    n = [self dataSource_numberOfRowsInSection:section];
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self dataSource_cellForRowAtIndexPath:indexPath];
    
    if (cell && !self.isReusableCell)
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewCellTouchUpInside:)];
        [cell addGestureRecognizer:tapGesture];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self delegate_heightForRowAtIndexPath:indexPath];
    
    if (self.selectIndexPathIsOpen && self.selectIndexPath && [self.selectIndexPath compare:indexPath] == NSOrderedSame)
    {
        h += [self delegate_heightForOpenCellAtIndexPath:indexPath];
    }
    
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource && ![self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return 0;
    }
    return [self delegate_heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [self delegate_viewForHeaderInSection:section];
    
    if (view)
    {
        CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
        CGRect frame = CGRectMake(0, 0, self.tableView.bounds.size.width, height);
        view.frame = frame;
        view.tag = section;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewHeaderTouchUpInside:)];
        [view addGestureRecognizer:tapGesture];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewForExpand)
    {
        if ([self.selectIndexPath compare:indexPath] == NSOrderedSame && self.selectIndexPathIsOpen)
        {
            if (self.viewForExpand.superview && ![self.viewForExpand.subviews isEqual:cell])
            {
                [self.viewForExpand removeFromSuperview];
            }
            [cell addSubview:self.viewForExpand];
        }
        else
        {
            if ([cell.subviews containsObject:self.viewForExpand])
            {
                [self.viewForExpand removeFromSuperview];
            }
        }
    }
}

#pragma mark - Selector

//列表Header点击
- (void)tableViewHeaderTouchUpInside:(UITapGestureRecognizer *)gesture
{
    int section = gesture.view.tag;
    [self delegate_didSelectHeaderAtSection:section];
    [self openOrCloseHeaderWithSection:section];
}

//列表cell点击
- (void)tableViewCellTouchUpInside:(UITapGestureRecognizer *)gesture
{
    //判断点击区域
    UITableViewCell *cell = (UITableViewCell *)gesture.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CGFloat h = [self delegate_heightForRowAtIndexPath:indexPath];
    CGFloat w = cell.bounds.size.width;
    CGRect rect = CGRectMake(0, 0, w, h);
    CGPoint point = [gesture locationInView:cell];
    if(CGRectContainsPoint(rect,point))
    {
        [self delegate_didSelectRowAtIndexPath:indexPath];
        [self openCellViewWithIndexPath:indexPath];
    }
}

#pragma mark - Private

- (void)insertViewForExpandWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewForExpand && self.viewForExpand.superview)
    {
        [self.viewForExpand removeFromSuperview];
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = [self delegate_heightForRowAtIndexPath:indexPath];
    CGFloat openHeight = [self delegate_heightForOpenCellAtIndexPath:indexPath];
    
    self.viewForExpand = [self delegate_openCellForRowAtIndexPath:indexPath];
    self.viewForExpand.frame = CGRectMake(0, cellHeight,cell.bounds.size.width, 0);
    //cell.isOpen = YES;
    __block __unsafe_unretained UITableViewCell * weekCell = cell;
    __block __unsafe_unretained TQMultistageTableView     * weekSelf = self;
    
    [UIView transitionWithView:cell
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^
     {
         [weekCell addSubview:weekSelf.viewForExpand];
         
         weekSelf.viewForExpand.frame = CGRectMake(0, cellHeight, weekCell.bounds.size.width, openHeight);
     }
                    completion:^(BOOL finished)
     {
         [self handleCellOpenThanTheView];
     }];
}

- (void)removeViewForExpandWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewForExpand)
    {
        __block __unsafe_unretained TQMultistageTableView * weekSelf = self;
        
        CGRect rect = self.viewForExpand.frame;
        
        [UIView transitionWithView:self.viewForExpand
                          duration:0.2
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^
         {
             weekSelf.viewForExpand.frame = CGRectMake(0, rect.origin.y,rect.size.width, 0);
         }
                        completion:^(BOOL finished)
         {
             [weekSelf.viewForExpand removeFromSuperview];
             self.viewForExpand.frame = rect;
         }];
    }
}

//插入row
- (void)insertRowWithSection:(int)section toIndexPaths:(NSMutableArray *)indexPaths
{
    int insert = [self dataSource_numberOfRowsInSection:section];
    
    if (insert != 0)
    {
        [self delegate_willOpenHeaderAtSection:section];
    }
    
    for (int i = 0; i < insert; i++)
    {
        [indexPaths addObject: [NSIndexPath indexPathForRow:i inSection:section]];
    }
}

//删除row
- (void)deleteRowWithSection:(int)section toIndexPaths:(NSMutableArray *)indexPaths
{
    int delete = [self dataSource_numberOfRowsInSection:section];;
    
    if (delete != 0)
    {
        [self delegate_willCloseHeaderAtSection:section];
    }
    
    for (int i = 0; i < delete; i++)
    {
        [indexPaths addObject: [NSIndexPath indexPathForRow:i inSection:section]];
    }
}

//处理打开Cell的时候。cell中的内容超出了列表的Fram
- (void)handleCellOpenThanTheView
{
    CGFloat h = [self delegate_heightForRowAtIndexPath:self.selectIndexPath];
    
    h += [self delegate_heightForOpenCellAtIndexPath:self.selectIndexPath];
  
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
    
    CGPoint p = [cell convertPoint:CGPointZero fromView:self];
    
    if((h - p.y) > self.frame.size.height)
    {
        [self.tableView scrollToRowAtIndexPath:self.selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Public

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    id cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    self.isReusableCell = cell ? YES : NO;
    
    return cell;
}

//展开或关闭点开的View
- (void)openCellViewWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationAutomatic;
    NSMutableArray *updataIndexPathArray = [NSMutableArray array];
    
    if (self.selectOldIndexPath == nil)
    {
        //第一次展开
        self.selectIndexPath = indexPath;
        self.selectIndexPathIsOpen = YES;
        //
        [self delegate_willOpenCellAtIndexPath:self.selectIndexPath];
        //
        [updataIndexPathArray addObject:self.selectIndexPath];
        [self.tableView reloadRowsAtIndexPaths:updataIndexPathArray withRowAnimation:rowAnimation];
        [self insertViewForExpandWithIndexPath:self.selectIndexPath];
        
        self.selectOldIndexPath = [NSIndexPath indexPathForRow:self.selectIndexPath.row inSection:self.selectIndexPath.section];
        self.selectOldIndexPathIsOpen = self.selectIndexPathIsOpen;
    }
    else
    {
        //!=第一次展开
        if ([indexPath compare:self.selectOldIndexPath] == NSOrderedSame)
        {
            //相同Cell
            self.selectIndexPathIsOpen = NO;
            //
            [self delegate_willCloseCellAtIndexPath:self.selectIndexPath];
            //
            [updataIndexPathArray addObject:self.selectIndexPath];
            [self.tableView reloadRowsAtIndexPaths:updataIndexPathArray withRowAnimation:rowAnimation];
            [self removeViewForExpandWithIndexPath:self.selectIndexPath];
            
            self.selectOldIndexPath = nil;
            self.selectOldIndexPathIsOpen = NO;
        }
        else
        {
            //不同Cell
            self.selectIndexPath = indexPath;
            self.selectIndexPathIsOpen = YES;
            //
            [self delegate_willCloseCellAtIndexPath:self.selectOldIndexPath];
            [self delegate_willOpenCellAtIndexPath:self.selectIndexPath];
            //
            [updataIndexPathArray addObject:self.selectOldIndexPath];
            [updataIndexPathArray addObject:self.selectIndexPath];
            [self.tableView reloadRowsAtIndexPaths:updataIndexPathArray withRowAnimation:rowAnimation];
            [self insertViewForExpandWithIndexPath:self.selectIndexPath];
            
            self.selectOldIndexPath = [NSIndexPath indexPathForRow:self.selectIndexPath.row inSection:self.selectIndexPath.section];
            self.selectOldIndexPathIsOpen = self.selectIndexPathIsOpen;
        }
    }
}

//展开或关闭点开的Header
- (void)openOrCloseHeaderWithSection:(int)section
{
    self.selectIndexPathIsOpen = NO;
    self.selectOldIndexPath = nil;
    self.selectOldIndexPathIsOpen = NO;
    
    NSMutableArray *deleteIndexPaths = TQ_AUTORELEASE([[NSMutableArray alloc] init]);
    NSMutableArray *insertIndexPaths = TQ_AUTORELEASE([[NSMutableArray alloc] init]);
    if(self.selectIndexPath.section == section)
    {
        [self deleteRowWithSection:self.selectIndexPath.section toIndexPaths:deleteIndexPaths];
        self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    else
    {
        if (self.selectIndexPath.section < 0)
        {
            [self insertRowWithSection:section toIndexPaths:insertIndexPaths];
            self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
        }
        else
        {
            [self deleteRowWithSection:self.selectIndexPath.section toIndexPaths:deleteIndexPaths];
            
            self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
            
            [self insertRowWithSection:section toIndexPaths:insertIndexPaths];
        }
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)reloadDataWithTableViewCell:(UITableViewCell *)cell
{
    if (cell)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableArray *updataIndexPathArray = [NSMutableArray array];
        [updataIndexPathArray addObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:updataIndexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)reloadData
{
    self.isReusableCell = NO;
    self.selectIndexPathIsOpen = NO;
    self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    self.selectOldIndexPathIsOpen = NO;
    self.selectOldIndexPath = nil;
    [self.tableView reloadData];
}

- (void)updateTableView
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self handleCellOpenThanTheView];
}

- (bool)isOpenCellWithIndexPath:(NSIndexPath *)indexPath
{
    if([self.selectIndexPath compare:indexPath] == NSOrderedSame)
    {
        return self.selectIndexPathIsOpen;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Safety Delegate & DataSource Call
#pragma mark - Safety DataSource

- (NSInteger)dataSource_numberOfSectionsInTableView
{
    NSInteger n = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        n = [self.dataSource numberOfSectionsInTableView:self];
    }
    return n;
}

- (NSInteger)dataSource_numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(mTableView: numberOfRowsInSection:)])
    {
        n = [self.dataSource mTableView:self numberOfRowsInSection:section];
    }
    return n;
}

- (UITableViewCell *)dataSource_cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(mTableView: cellForRowAtIndexPath:)])
    {
        cell = [self.dataSource mTableView:self cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (UIView *)delegate_openCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(mTableView: openCellForRowAtIndexPath:)])
    {
        view = [self.dataSource mTableView:self openCellForRowAtIndexPath:indexPath];
    }
    return view;
}

#pragma mark - Safety Delegate
- (CGFloat)delegate_heightForHeaderInSection:(NSInteger)section
{
    NSInteger h = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: heightForHeaderInSection:)])
    {
        h = [self.delegate mTableView:self heightForHeaderInSection:section];
    }
    return h;
}

- (CGFloat)delegate_heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = DEFULT_HEIGHT_FOR_ROW;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: heightForRowAtIndexPath:)])
    {
        h = [self.delegate mTableView:self heightForRowAtIndexPath:indexPath];
    }
    return h;
}

- (CGFloat)delegate_heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: heightForOpenCellAtIndexPath:)])
    {
        h = [self.delegate mTableView:self heightForOpenCellAtIndexPath:indexPath];
    }
    return h;
}

- (UIView *)delegate_viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    if(self.delegate && [self.delegate respondsToSelector:@selector(mTableView: viewForHeaderInSection:)])
    {
        view = [self.delegate mTableView:self viewForHeaderInSection:section];
    }
    return view;
}

//header点击
- (void)delegate_didSelectHeaderAtSection:(NSInteger)section;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: didSelectHeaderAtSection:)])
    {
        [self.delegate mTableView:self didSelectHeaderAtSection:section];
    }
}

//celll点击
- (void)delegate_didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: didSelectRowAtIndexPath:)])
    {
        [self.delegate mTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

//header展开
- (void)delegate_willOpenHeaderAtSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: willOpenHeaderAtSection:)])
    {
        [self.delegate mTableView:self willOpenHeaderAtSection:section];
    }
}

//header关闭
- (void)delegate_willCloseHeaderAtSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: willCloseHeaderAtSection:)])
    {
        [self.delegate mTableView:self willCloseHeaderAtSection:section];
    }
}

//cell展开
- (void)delegate_willOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: willOpenCellAtIndexPath:)])
    {
        [self.delegate mTableView:self willOpenCellAtIndexPath:indexPath];
    }
}

//cell关闭
- (void)delegate_willCloseCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTableView: willCloseCellAtIndexPath:)])
    {
        [self.delegate mTableView:self willCloseCellAtIndexPath:indexPath];
    }
}

@end














