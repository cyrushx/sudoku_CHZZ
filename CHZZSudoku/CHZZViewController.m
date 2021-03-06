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


@interface CHZZViewController () {
    CHZZGridView* _gridView;
    CHZZNumpadView* _numPadView;
    CHZZGridModel* _gridModel;
    
    // assist switch methods
    bool ASSISTON; // a flag to indicate if the assist switch is on or not
    int selectedRow;
    int selectedCol;
    int numpadEnable[9];
}

@end

@implementation CHZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    CGRect frame = self.view.frame;
    
    // set up start button
    CGFloat yButton = CGRectGetHeight(frame) * 0.9;
    CGFloat xButtonStart = CGRectGetWidth(frame) * 0.1;
    CGFloat startButtonSize = xButtonStart * 2;
    CGFloat xButtonReset = (xButtonStart * 3 + startButtonSize * 2);
    CGFloat resetButtonSize = startButtonSize;
    
    CGRect startFrame = CGRectMake(xButtonStart, yButton, startButtonSize, startButtonSize / 2);
    UIButton* start = [[UIButton alloc] initWithFrame:startFrame];
    start.layer.cornerRadius = startButtonSize / 10;
    start.layer.borderWidth = 1.0f;
    [start setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [start setTitle:@"Start New" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    start.titleLabel.font = [UIFont systemFontOfSize:startButtonSize/5];
    [self.view addSubview:start];
    [start addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
    
    // set up reset button
    CGRect resetFrame = CGRectMake(xButtonReset, yButton, resetButtonSize, resetButtonSize / 2);
    UIButton* reset = [[UIButton alloc] initWithFrame:resetFrame];
    reset.layer.cornerRadius = startButtonSize / 10;
    reset.layer.borderWidth = 1.0f;
    [reset setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [reset setTitle:@"Reset" forState:UIControlStateNormal];
    [reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reset.titleLabel.font = [UIFont systemFontOfSize:startButtonSize/5];
    [self.view addSubview:reset];
    [reset addTarget:self action:@selector(resetCurrentGame) forControlEvents:UIControlEventTouchUpInside];
    
    // set up assist switch
    CGFloat xSwitch = CGRectGetWidth(frame) * 0.52;
    CGFloat ySwitch = CGRectGetHeight(frame) * 0.92;
    CGFloat switchSize = startButtonSize;
    CGRect switchFrame = CGRectMake(xSwitch, ySwitch, switchSize, switchSize/2);
    UISwitch* assist = [[UISwitch alloc] initWithFrame:switchFrame];
    [self.view addSubview:assist];
    [assist addTarget:self action:@selector(flip:) forControlEvents:UIControlEventValueChanged];
    
    ASSISTON = NO;
    
    // set up assist label
    CGFloat yLabel = CGRectGetHeight(frame) * 0.9;
    CGFloat labelSize = startButtonSize;
    CGFloat xLabel = xSwitch - labelSize;
    NSLog(@"%f",xSwitch);
    NSLog(@"%f",labelSize);
    NSLog(@"%f",xLabel);
    CGRect labelFrame = CGRectMake(xLabel, yLabel, labelSize, labelSize/2);
    UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setText:@"TURN ASSIST ON: "];
    [label setTextColor:[UIColor blackColor]];
    label.adjustsFontSizeToFitWidth = YES;
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
    [_numPadView setTarget:self action:@selector(numPadSelected:)];
    [_numPadView setAssist:NO];

    [self startNewGame];
}

- (void)resetCurrentGame
{
    // reset all colors
    [_numPadView resetColor];
    [_gridView resetColor];
    [_gridModel resetMutableArray];
    
    // empty all user's choices
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = _gridModel->initGrid[row][col];
            [_gridView setDefaultValueAtRow:row col:col to:value];
        }
    }
}

- (void)startNewGame
{
    // generate a new grid and reset the game
    [_gridModel generateGrid];
    [_numPadView setAssist:ASSISTON];
    [self resetCurrentGame];
}

- (void)numPadSelected:(NSNumber*)value
{
    int v = [value intValue];
    [_gridModel setValueAtRow:selectedRow colum:selectedCol to:v];
    [_gridView setValueAtRow:selectedRow col:selectedCol to:v];
    [self numpadCheckAtRow:selectedRow Col:selectedCol];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row col:(NSNumber*) col
{
    // convert row and col to int
    selectedRow = [row intValue];
    selectedCol = [col intValue];
    
    // check mutability and consistence of the selected space
    [self numpadCheckAtRow:selectedRow Col:selectedCol];
}

- (void)numpadCheckAtRow:(int)row Col:(int)col
{
    for(int i = 0; i < 9; i++){
        int numpadVal = i + 1;
        
        if([_gridModel isMutableAtRow:row colum:col]){

            if([_gridModel isConsistentAtRow:row colum:col for:numpadVal])
                numpadEnable[i] = 1;
            else
                numpadEnable[i] = 0;
        } else{
            numpadEnable[i] = 0;
        }
    }
    [_numPadView setEnableWithArray:numpadEnable];
}

// flip the flag when switch value is changed
- (IBAction)flip:(id)sender {
    UISwitch* assist = (UISwitch*) sender;
    
    if (assist.on)  ASSISTON = YES;
    else    ASSISTON = NO;
    
    [_numPadView setAssist:ASSISTON];
    [_numPadView setEnableWithArray:numpadEnable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
