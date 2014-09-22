//
//  CHZZGridModel.m
//  CHZZSudoku
//
//  Created by Zehao Zhang on 14-9-21.
//  Copyright (c) 2014年 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import "CHZZGridModel.h"

// For now, the initial grid is hardcoded
int mutableGridCopy[9][9]={
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

// this grid can be modified
int initGrid[9][9]={
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


@implementation CHZZGridModel

-(int) getValueAtRow:(int)row colum:(int)colum{
    return mutableGridCopy[row][colum];
}

-(void) setValueAtRow:(int)row colum:(int)colum to:(int)value{
    mutableGridCopy[row][colum] = value;
}

-(bool) isMutableAtRow:(int)row colum:(int)colum
{
    return initGrid[row][colum]==0;
}

-(bool) isConsistentAtRow:(int)row colum:(int)colum for:(int)num{
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
