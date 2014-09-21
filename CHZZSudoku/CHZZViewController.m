//
//  CHZZViewController.m
//  CHZZSudoku
//
//  Created by Cyrus Huang on 9/17/14.
//  Copyright (c) 2014 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import "CHZZViewController.h"
#import "CHZZGridView.h"
#import "CHZZNumpadView.h"

// For now, the initial grid is hardcoded
int initialGrid[9][9]={
    {7,0,0,4,2,0,0,0,9},
    {0,0,9,5,0,0,0,0,4},
    {0,2,0,6,9,0,5,0,0},
    {6,5,0,0,0,0,4,3,0},
    {0,8,0,0,0,6,0,0,7},
    {0,1,0,0,4,5,6,0,0},
    {0,0,0,8,6,0,0,0,2},
    {3,4,0,9,0,0,1,0,0},
    {8,0,0,3,0,2,7,4,0}
};

@interface CHZZViewController () {
    CHZZGridView* _gridView;
    CHZZNumpadView* _numPadView;
}

@end

@implementation CHZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // create frame
    float framePortion = 0.8;
    CGRect frame = self.view.frame;
    CGFloat x    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat y    = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    CGFloat numPadx = x;
    CGFloat numPady = size + 1.5 * y;
    CGFloat numPadheight = size * 0.189;
    
    CGRect numPadFrame = CGRectMake(numPadx, numPady, size, numPadheight);
    
    _numPadView = [[CHZZNumpadView alloc] initWithFrame:numPadFrame length:size];
    [self.view addSubview:_numPadView];
    
    // Initialize _gridView and set initial values from initialGrid
    _gridView = [[CHZZGridView alloc] initWithFrame:gridFrame size:size];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = initialGrid[row][col];
            [_gridView setValueAtRow:row col:col to:value];
        }
    }
    [self.view addSubview:_gridView];
    
    [_gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row col:(NSNumber*) col
{
    // For now, simply display row and col info of the cell selected
    NSLog(@"The button is pressed, with row %@ and col %@", row, col);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
