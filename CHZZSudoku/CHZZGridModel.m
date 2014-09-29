//
//  CHZZGridModel.m
//  CHZZSudoku
//
//  Created by Zehao Zhang on 14-9-21.
//  Copyright (c) 2014年 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import "CHZZGridModel.h"

// For now, the initial grid is hardcoded
int mutableGridCopy[9][9];

// this grid can be modified
int initGrid[9][9];

@implementation CHZZGridModel
{
    bool debug;
}

-(void) generateGrid
{
    // randomly choose between grid1.txt and grid2.txt
    NSString* path;
    NSInteger fileNum = arc4random() % 1;
    if (fileNum == 0)
        path = [[NSBundle mainBundle] pathForResource:@"grid1" ofType:@"txt"];
    else
        path = [[NSBundle mainBundle] pathForResource:@"grid2" ofType:@"txt"];
    
    NSError* error;
    
    NSString* readString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSInteger stringLength = [readString length];
    NSInteger gridLength   = 82; // 81 grids and a line break
    
    // find how many grids are stored in text file
    NSInteger gridNum  = stringLength / gridLength;
    NSInteger gridLine = arc4random() % gridNum;
    //NSInteger gridLine = 2;
    NSInteger start = gridLine * gridLength;
    
    NSString* gridString = [readString substringWithRange:NSMakeRange(start, gridLength - 1)];
    
    // generate grid
    for (NSInteger row = 0; row < 9; row++)
    {
        for (NSInteger col = 0; col < 9; col++)
        {
            NSString* value = [gridString substringWithRange:NSMakeRange(row * 9 + col, 1)];
            initGrid[row][col] = [value intValue];
        }
    }
    
}

-(void) resetMutableArray
{
    for (NSInteger row = 0; row < 9; row++)
    {
        for (NSInteger col = 0; col < 9; col++)
        {
            mutableGridCopy[row][col] = initGrid[row][col];
        }
    }
}

-(int) getValueAtRow:(int)row colum:(int)colum
{
    return mutableGridCopy[row][colum];
}

-(void) setValueAtRow:(int)row colum:(int)colum to:(int)value
{
    mutableGridCopy[row][colum] = value;
}

-(bool) isMutableAtRow:(int)row colum:(int)colum
{
    return initGrid[row][colum]==0;
}

-(bool) isConsistentAtRow:(int)row colum:(int)colum for:(int)num
{
    return [self rowCheck:row for:num]&&[self colCheck:colum for:num]&&[self blockCheck:row col:colum for:num];
}

-(bool) rowCheck:(int)row for:(int)num
{
    for(int col = 0; col < 9; col++){
        if(mutableGridCopy[row][col] == num) return NO;
    }
    return YES;
}

-(bool) colCheck:(int)col for:(int)num
{
    for(int row = 0;row<9;row++){
        if(mutableGridCopy[row][col]==num) return NO;
    }
    return YES;
}

-(bool) blockCheck:(int)row col:(int)col for:(int)num
{
    int modRow = row % 3;
    int modCol = col % 3;
    
    for(int i = row-modRow; i < 3 +row - modRow; i++)
    {
        for(int j = col-modCol; j < 3 + col - modCol; j++)
        {
            if (mutableGridCopy[i][j] == num) return NO;
        }
    }
    return YES;
}


@end
