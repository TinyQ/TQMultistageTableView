//
//  TQViewController.h
//  TQMultistageTableViewDemo
//
//  Created by fuqiang on 13-9-3.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"

@interface TQViewController : UIViewController <TQTableViewDataSource, TQTableViewDelegate>

@property (nonatomic, strong) TQMultistageTableView *mTableView;

@end
