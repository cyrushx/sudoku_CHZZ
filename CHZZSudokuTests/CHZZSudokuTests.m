//
//  CHZZSudokuTests.m
//  CHZZSudokuTests
//
//  Created by Cyrus Huang on 9/17/14.
//  Copyright (c) 2014 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHZZGridModel.h"

@interface CHZZSudokuTests : XCTestCase
{
    CHZZGridModel* _gridModel;
}

@end

@implementation CHZZSudokuTests


- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _gridModel = [[CHZZGridModel alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReadSimpleFile
{
    NSString* result = [_gridModel readString:@"test"];
    NSString* anwser = @"....2..374.76...8.5.24.7..18.63...5.3.4.6..18.1..5...66...7.......9....5.98..6...";
    XCTAssertTrue([result isEqualToString:anwser], @"check reading string from a text file with only one string in it");
}

// if input file name is invalid, return an empty string
- (void)testBadFile
{
    NSString* result = [_gridModel readString:@"bad"];
    XCTAssertTrue([result isEqualToString:@""], @"check reading string from a text file that doesn't existt");
}

- (void)testParseSimpleString
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];

    int trueGrid[9][9]={
        {0,0,0,0,2,0,0,3,7},
        {4,0,7,6,0,0,0,8,0},
        {5,0,2,4,0,7,0,0,1},
        {8,0,6,3,0,0,0,5,0},
        {3,0,4,0,6,0,0,1,8},
        {0,1,0,0,5,0,0,0,6},
        {6,0,0,0,7,0,0,0,0},
        {0,0,0,9,0,0,0,0,5},
        {0,9,8,0,0,6,0,0,0}
    };
    
    int result;
    int answer;
    
    for (int row = 0; row < 9; row++)
    {
        for (int col = 0; col < 9; col++)
        {
            result = [_gridModel getValueAtRow:row colum:col];
            answer = trueGrid[row][col];
            XCTAssertTrue(result == answer,@"check valid string parsing");
        }
    }

}

- (void)testParseEmptyString
{
    NSString* string = [_gridModel readString:@"bad"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    for (int row = 0; row < 9; row++)
    {
        for (int col = 0; col < 9; col++)
        {
            XCTAssertTrue([_gridModel getValueAtRow:row colum:col] == 0,@"check empty string parsing");
        }
    }
}

- (void)testParseInvalidString
{
    NSString* string = [_gridModel readString:@"bad2"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    for (int row = 0; row < 9; row++)
    {
        for (int col = 0; col < 9; col++)
        {
            XCTAssertTrue([_gridModel getValueAtRow:row colum:col] == 0,@"check invalid string parsing");
        }
    }
}


- (void)testGet
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel getValueAtRow:0 colum:0] == 0, @"check top left corner");
    XCTAssertTrue([_gridModel getValueAtRow:5 colum:4] == 5, @"check a random place");
}

- (void)testGetWithInvalidInput
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel getValueAtRow:-1 colum:0] == 0, @"check invalid row input");
    XCTAssertTrue([_gridModel getValueAtRow:0 colum:10] == 0, @"check invalid col input");
}


- (void)testSetAtBlankCell
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    [_gridModel setValueAtRow:0 colum:0 to:9];
    XCTAssertTrue([_gridModel getValueAtRow:0 colum:0] == 9, @"check setting value");
}

- (void)testSetWithInvalidValue
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    [_gridModel setValueAtRow:0 colum:0 to:10];
    XCTAssertTrue([_gridModel getValueAtRow:0 colum:0] == 0, @"check setting invalid value");
}


- (void)testNonMutable
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel isMutableAtRow:1 colum:0] == NO, @"check nonmutable cell");
}

- (void)testMutable
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel isMutableAtRow:0 colum:6] == YES, @"check mutable cell");
}

- (void)testMutableWithInvalidInput
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel isMutableAtRow:0 colum:-1] == NO, @"check mutable cell at invalid place");
}

- (void)testConsistent
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel isConsistentAtRow:8 colum:8 for:3] == YES, @"check consistency");
}

- (void)testNonConsistent
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel isConsistentAtRow:1 colum:1 for:8] == NO, @"check inconsistency in row");
    XCTAssertTrue([_gridModel isConsistentAtRow:0 colum:0 for:6] == NO, @"check inconsistency in col");
    XCTAssertTrue([_gridModel isConsistentAtRow:5 colum:5 for:6] == NO, @"check inconsistency in block");
}

- (void)testNonConsistentWithInvalidInput
{
    NSString* string = [_gridModel readString:@"test"];
    [_gridModel parseString:string];
    [_gridModel resetMutableArray];
    
    XCTAssertTrue([_gridModel isConsistentAtRow:-1 colum:1 for:8] == NO, @"check invalid input in row");
    XCTAssertTrue([_gridModel isConsistentAtRow:0 colum:-5 for:6] == NO, @"check invalid input in col");
    XCTAssertTrue([_gridModel isConsistentAtRow:8 colum:8 for:10] == NO, @"check invalid inpu in block");
}


@end
