//
//  CHZZGridModel.m
//  CHZZSudoku
//
//  Created by Zehao Zhang on 14-9-21.
//  Copyright (c) 2014 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import "CHZZGridModel.h"

// this grid can be modified
int mutableGridCopy[9][9];

// this grid represents a copy of original grid
int initGrid[9][9];

@implementation CHZZGridModel

-(void) generateGrid
{
    // randomly choose between grid1.txt and grid2.txt
    NSString* fileName;
    NSInteger fileNum = arc4random() % 2;
    if (fileNum == 0)
        fileName = @"grid1";
    else
        fileName = @"grid2";
    
    NSString* gridString =[self readString:fileName];
    [self parseString:gridString];
}

// if the input is invalid, return empty string
-(NSString*) readString:(NSString*) fileName
{
    // genearte path and read the string
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    NSError* error;
    
    NSString* readString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSString* gridString = @"";
    
    if (readString != nil)
    {
        NSInteger stringLength = [readString length];
        NSInteger gridLength   = 82; // 81 cells and a line break
        
        if (stringLength % gridLength == 0)
        {
            // find how many grids are stored in text file
            NSInteger gridNum  = stringLength / gridLength;
            NSInteger gridLine = arc4random() % gridNum;
            NSInteger start = gridLine * gridLength;
            
            gridString = [readString substringWithRange:NSMakeRange(start, gridLength - 1)];
        }
        
    }
    
    return gridString;
}

-(void) parseString:(NSString*) gridString
{
    // parse the string and add it to the grid
    for (NSInteger row = 0; row < 9; row++)
    {
        for (NSInteger col = 0; col < 9; col++)
        {
            if (![gridString isEqualToString:@""])
            {
                NSString* value = [gridString substringWithRange:NSMakeRange(row * 9 + col, 1)];
                initGrid[row][col] = [value intValue];
            } else {
                initGrid[row][col] = 0; // if input is an empty string, add 0 to grid
            }
        }
    }
}



-(void) resetMutableArray
{
    // copy values from initGrid
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
    if (row > 9 || row < 0 || colum > 9 || colum < 0)
        return 0;
    else
        return mutableGridCopy[row][colum];
}

-(void) setValueAtRow:(int)row colum:(int)colum to:(int)value
{
    if (value > 9 || value < 0)
        mutableGridCopy[row][colum] = 0;
    else
        mutableGridCopy[row][colum] = value;
}

-(bool) isMutableAtRow:(int)row colum:(int)colum
{
    if (row > 9 || row < 0 || colum > 9 || colum < 0)
        return NO;
    else
        return initGrid[row][colum] == 0;
}

-(bool) isConsistentAtRow:(int)row colum:(int)colum for:(int)num
{
    if (row > 9 || row < 0 || colum > 9 || colum < 0 || num > 9 || num <0)
        return NO;
    else
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
