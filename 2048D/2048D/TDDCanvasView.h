//
//  TDDCanvasView.h
//  2048D
//
//  Created by DAA on 2018/5/15.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TD_MaxLineNum 4
#define TD_BLOCK_Interval  5.0
#define TD_ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define TD_BLOCK_WITH      (TD_ScreenWidth - 5.0 * (TD_MaxLineNum + 1))/TD_MaxLineNum

@class TDDCanvasView;
@protocol TDDCanvasViewDelegate <NSObject>
- (void)actionComplete;
- (void)gameOver;
- (void)generateDigital:(int)num;
@end

@interface TDDCanvasView : UIView

@property (nonatomic, strong)NSMutableDictionary *mDataDict;    //纪录有数字的格子
@property (nonatomic, strong)NSMutableArray *mDataArr;          //纪录没有数字的格子
@property (nonatomic, assign)id<TDDCanvasViewDelegate>delegate;

- (void)startLayout;

@end
