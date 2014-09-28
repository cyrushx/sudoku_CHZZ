//
//  CHZZNumpadView.h
//  CHZZSudoku
//
//  Created by Zehao Zhang on 14-9-21.
//  Copyright (c) 2014年 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZZNumpadView : UIView

- (id) initWithFrame:(CGRect)frame length:(CGFloat) length;
- (int) getCurrentValue;

@end
