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
//int initialGrid[9][9];

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
    CGRect frame = self.view.frame;
    
    // set up start and restart buttons
    CGFloat yButton = CGRectGetHeight(frame) * 0.9;
    CGFloat xButtonStart = CGRectGetWidth(frame) * 0.2;
    CGFloat xButtonRestart = CGRectGetWidth(frame) * 0.6;
    CGFloat startButtonSize = xButtonStart;
    
    CGRect startFrame = CGRectMake(xButtonStart, yButton, startButtonSize, startButtonSize / 2);
    UIButton* start = [[UIButton alloc] initWithFrame:startFrame];
    [start setBackgroundColor:[UIColor grayColor]];
    [start setTitle:@"Start new game" forState:UIControlStateNormal];
    [self.view addSubview:start];
    
    [start addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect restartFrame = CGRectMake(xButtonRestart, yButton, startButtonSize, startButtonSize / 2);
    UIButton* restart = [[UIButton alloc] initWithFrame:restartFrame];
    [restart setBackgroundColor:[UIColor grayColor]];
    [restart setTitle:@"Reset current game" forState:UIControlStateNormal];
    [self.view addSubview:restart];
    
    [restart addTarget:self action:@selector(restartCurrentGame) forControlEvents:UIControlEventTouchUpInside];
    
    // initialize _gridModel
    _gridModel = [[CHZZGridModel alloc] init];
    
    // initilize _gridView
    float framePortion = 0.8;
    CGFloat x    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat y    = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    _gridView = [[CHZZGridView alloc] initWithFrame:gridFrame size:size];
    [self.view addSubview:_gridView];
    [_gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
    
    // initilize _numPadView
    CGFloat numPadX = x;
    CGFloat numPadY = size + 1.5 * y;
    CGFloat numPadheight = size * 0.189; // the portion is calculated
    CGRect numPadFrame = CGRectMake(numPadX, numPadY, size, numPadheight);
    
    _numPadView = [[CHZZNumpadView alloc] initWithFrame:numPadFrame length:size];
    [self.view addSubview:_numPadView];
    
    [self startNewGame];
}

- (void)restartCurrentGame
{
    // empty all user's choices
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = _gridModel->initGrid[row][col];
            [_gridView setValueAtRow:row col:col to:value];
        }
    }
}

- (void)startNewGame
{
    [_gridModel generateGrid];
    [self restartCurrentGame];
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
