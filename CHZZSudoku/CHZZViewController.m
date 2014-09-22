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
#import "CHZZGridModel.h"

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
    CHZZGridModel* _gridModel;
}

@end

@implementation CHZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // create gridFrame
    float framePortion = 0.8;
    CGRect frame = self.view.frame;
    CGFloat x    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat y    = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    // initialize _gridView and set initial values from initialGrid
    _gridView = [[CHZZGridView alloc] initWithFrame:gridFrame size:size];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = initialGrid[row][col];
            [_gridView setValueAtRow:row col:col to:value];
        }
    }
    [self.view addSubview:_gridView];
    
    [_gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
    
    // create numPadFrame
    CGFloat numPadX = x;
    CGFloat numPadY = size + 1.5 * y;
    CGFloat numPadheight = size * 0.189; // the portion is calculated
    
    CGRect numPadFrame = CGRectMake(numPadX, numPadY, size, numPadheight);
    
    // initialize _nunPadView
    _numPadView = [[CHZZNumpadView alloc] initWithFrame:numPadFrame length:size];
    [self.view addSubview:_numPadView];
    
    // initialize _gridModel
    _gridModel = [[CHZZGridModel alloc] init];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row col:(NSNumber*) col
{
    // The message is for debug use
    NSLog(@"The button is pressed, with row %@ and col %@", row, col);
    
    // convert row and col to int
    int r = [row intValue];
    int c = [col intValue];
    
    // check mutability and consistence of the selected space
    if([_gridModel isMutableAtRow:r colum:c]){
        // ask numPadView for the current value
        int value = [_numPadView getCurrentValue];
       
        // set values to gridModel and gridView
        if([_gridModel isConsistentAtRow:r colum:c for:value]){
            [_gridModel setValueAtRow:r colum:c to:value];
            [_gridView setValueAtRow:r col:c to:value];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
