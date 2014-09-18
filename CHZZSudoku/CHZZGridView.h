//
//  CHZZGridView.h
//  CHZZSudoku
//
//  Created by Cyrus Huang on 9/17/14.
//  Copyright (c) 2014 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZZGridView : UIView

- (id)initWithFrame:(CGRect)frame size:(CGFloat) screenSize;
- (void)setValueAtRow:(int)row col:(int)col to:(int)value;
- (void)setTarget:(id)target action:(SEL)action;

@end

