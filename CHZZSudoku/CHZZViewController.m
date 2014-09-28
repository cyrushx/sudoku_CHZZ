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


BOOL ASSISTON = NO;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    CGRect frame = self.view.frame;
    
    // set up start and reset buttons
    CGFloat yButton = CGRectGetHeight(frame) * 0.9;
    CGFloat xButtonStart = CGRectGetWidth(frame) * 0.1;
    CGFloat startButtonSize = xButtonStart * 2;
    CGFloat xButtonReset = (xButtonStart * 3 + startButtonSize * 2);
    CGFloat resetButtonSize = startButtonSize;
    
    CGRect startFrame = CGRectMake(xButtonStart, yButton, startButtonSize, startButtonSize / 2);
    UIButton* start = [[UIButton alloc] initWithFrame:startFrame];
    start.layer.cornerRadius = 20;
    start.layer.borderWidth = 1.0f;
    [start setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    start.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:start];
    [start addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect resetFrame = CGRectMake(xButtonReset, yButton, resetButtonSize, resetButtonSize / 2);
    UIButton* reset = [[UIButton alloc] initWithFrame:resetFrame];
    reset.layer.cornerRadius = 20;
    reset.layer.borderWidth = 1.0f;
    [reset setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [reset setTitle:@"Reset" forState:UIControlStateNormal];
    [reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reset.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:reset];
    [reset addTarget:self action:@selector(resetCurrentGame) forControlEvents:UIControlEventTouchUpInside];
    
    // set up assist switch
    CGFloat xSwitch = CGRectGetWidth(frame) * 0.53;
    CGFloat ySwitch = CGRectGetHeight(frame) * 0.925;
    CGFloat switchSize = startButtonSize;
    CGRect switchFrame = CGRectMake(xSwitch, ySwitch, switchSize, switchSize/2);
    UISwitch* assist = [[UISwitch alloc] initWithFrame:switchFrame];
    [self.view addSubview:assist];
    [assist addTarget:self action:@selector(flip:) forControlEvents:UIControlEventValueChanged];
    
    // set up assist label
    CGFloat xLabel = CGRectGetWidth(frame) * 0.43;
    CGFloat yLabel = CGRectGetHeight(frame) * 0.9;
    CGFloat labelSize = startButtonSize;
    CGRect labelFrame = CGRectMake(xLabel, yLabel, labelSize, labelSize/2);
    UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setText:@"Assit On: "];
    [label setTextColor:[UIColor blackColor]];
    [self.view addSubview:label];
    
    
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

- (void)resetCurrentGame
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
    // generate a new grid and reset the game
    [_gridModel generateGrid];
    [self resetCurrentGame];
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

- (IBAction)flip:(id)sender {
    UISwitch* assist = (UISwitch*) sender;
    if (assist.on)
    {
        ASSISTON = YES;
    }
    else
    {
        ASSISTON = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
