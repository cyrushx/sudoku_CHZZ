//
//  CHZZNumpadView.m
//  CHZZSudoku
//
//  Created by Zehao Zhang on 14-9-21.
//  Copyright (c) 2014年 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import "CHZZNumpadView.h"
@interface CHZZNumpadView () {
    NSMutableArray* _cells;
    id _target;
    SEL _action;
    int _currentValue;
}
@end

@implementation CHZZNumpadView

- (id) initWithFrame:(CGRect)frame length:(CGFloat) length
{
    self  = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blueColor];
    
    // calculate the size of the spacing between cells and blocks, and button size
    float cellSeparatorPortion = 1 / 80.0;
    float blockSeparatorPortion = 1 / 20.0;
    
    CGFloat cellSeparatorWidth = length * cellSeparatorPortion;
    CGFloat blockSeparatorWidth = length * blockSeparatorPortion;
    
    CGFloat buttonSize = (length - (blockSeparatorWidth * 2) - (cellSeparatorWidth * 8))/9.0;
    
    // set up cells
    _cells = [[NSMutableArray alloc] init];
    
    CGFloat buttonY = blockSeparatorWidth;
    int titleNum;
    for (int col = 0; col < 9; col++) {
        int cellSepLeftNum = col;
        titleNum = col + 1;
        
        // calculate the x-coordinate
        CGFloat x = cellSepLeftNum * cellSeparatorWidth + blockSeparatorWidth + col*buttonSize;
        
        // create button and assign properties
        CGRect buttonFrame = CGRectMake(x, buttonY, buttonSize, buttonSize);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight"] forState:UIControlStateHighlighted];
        [button setTitle:[NSString stringWithFormat:@"%d", titleNum] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
        [_cells addObject:button];
        
        [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)cellSelected:(id)sender
{
    UIButton* button = (UIButton*) sender;
    _currentValue = [[button currentTitle] integerValue];
    [self getCurrentValue];
}

- (int)getCurrentValue
{
    return _currentValue;
}

@end
