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
    BOOL assistOn;
}
@end

@implementation CHZZNumpadView

- (id) initWithFrame:(CGRect)frame length:(CGFloat) length
{
    self  = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    // calculate the size of the spacing between cells and blocks, and button size
    float cellSeparatorPortion = 1 / 80.0;
    float blockSeparatorPortion = 1 / 20.0;
    
    CGFloat cellSeparatorWidth = length * cellSeparatorPortion;
    CGFloat blockSeparatorWidth = length * blockSeparatorPortion;
    
    CGFloat buttonSize = (length - (blockSeparatorWidth * 2) - (cellSeparatorWidth * 9))/10.0;
    
    // set up cells
    _cells = [[NSMutableArray alloc] init];
    
    CGFloat buttonY = blockSeparatorWidth;
    int titleNum;
    for (int col = 0; col < 10; col++)
    {
        int cellSepLeftNum = col;
        titleNum = col + 1;
        
        // calculate the x-coordinate
        CGFloat x = cellSepLeftNum * cellSeparatorWidth + blockSeparatorWidth + col*buttonSize;
        
        // create button and assign properties
        CGRect buttonFrame = CGRectMake(x, buttonY, buttonSize, buttonSize);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight.png"] forState:UIControlStateHighlighted];
        if (titleNum==10){
            [button setTitle:@"⬅︎" forState:UIControlStateNormal];
            [button setTag:2];
        }else{
            [button setTitle:[NSString stringWithFormat:@"%d", titleNum] forState:UIControlStateNormal];

        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
        [_cells addObject:button];
        
        [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setAssist:(BOOL)assist
{
    assistOn = assist;
}

-(void)resetColor
{
    for(int i = 0; i<9; i++)
        [_cells[i] setBackgroundColor:[UIColor whiteColor]];
}

-(void)setEnableWithArray:(int[])array
{
    for(int i = 0; i<9; i++){
        [_cells[i] setBackgroundColor:[UIColor whiteColor]];
        
        if(array[i] == 0){
            [_cells[i] setTag:0];
            if(assistOn) [_cells[i] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        }else{
            [_cells[i] setTag:1];
        }
    }
}

- (void)cellSelected:(id)sender
{
    UIButton* button = (UIButton*) sender;
    
    if([sender tag] == 1){
        _currentValue = (int) [[button currentTitle] integerValue];
        //[self getCurrentValue];
        [_target performSelector:_action withObject:[NSNumber numberWithInt:_currentValue]];
    }else if([sender tag] == 2){
        [_target performSelector:_action withObject:[NSNumber numberWithInt:0]];
    }
}

- (int)getCurrentValue
{
    return _currentValue;
}

- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
