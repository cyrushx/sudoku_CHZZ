//
//  CHZZGridModel.h
//  CHZZSudoku
//
//  Created by Zehao Zhang on 14-9-21.
//  Copyright (c) 2014 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZZGridModel : NSObject
{
    @public
    int initGrid[9][9];
}

-(void) generateGrid;
-(NSString*) readString:(NSString*) fileName;
-(void) parseString:(NSString*) gridString;
-(void) resetMutableArray;
-(int) getValueAtRow:(int)row colum:(int)colum;
-(void) setValueAtRow:(int)row colum:(int)colum to:(int)to;
-(bool) isMutableAtRow:(int)row colum:(int)colum;
-(bool) isConsistentAtRow:(int)row colum:(int)colum for:(int)num;

@end
