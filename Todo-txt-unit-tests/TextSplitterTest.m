/**
 * This file is part of Todo.txt, an iOS app for managing your todo.txt file.
 *
 * @author Todo.txt contributors <todotxt@yahoogroups.com>
 * @copyright 2011-2013 Todo.txt contributors (http://todotxt.com)
 *  
 * Dual-licensed under the GNU General Public License and the MIT License
 *
 * @license GNU General Public License http://www.gnu.org/licenses/gpl.html
 *
 * Todo.txt is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any
 * later version.
 *
 * Todo.txt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with Todo.txt.  If not, see
 * <http://www.gnu.org/licenses/>.
 *
 *
 * @license The MIT License http://www.opensource.org/licenses/mit-license.php
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "TextSplitterTest.h"
#import "Priority.h"
#import "TextSplitter.h"

@implementation TextSplitterTest

- (void)testSplit_empty
{
	TextSplitter* result = [TextSplitter split:@""];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"", result.prependedDate, @"prependedDate should be blank");
	XCTAssertEqualObjects(@"", result.text, @"text should be blank");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_nil
{
	TextSplitter* result = [TextSplitter split:nil];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"", result.prependedDate, @"prependedDate should be blank");
	XCTAssertEqualObjects(@"", result.text, @"text should be blank");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_withPriority
{
	TextSplitter* result = [TextSplitter split:@"(A) test"];
	XCTAssertEqual(PriorityA, result.priority.name, @"priority should be A");
	XCTAssertEqualObjects(@"", result.prependedDate, @"prependedDate should be blank");
	XCTAssertEqualObjects(@"test", result.text, @"text should be \"test\"");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_withPrependedDate
{
	TextSplitter* result = [TextSplitter split:@"2011-01-02 test"];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"2011-01-02", result.prependedDate, @"prependedDate should be 2011-01-02");
	XCTAssertEqualObjects(@"test", result.text, @"text should be \"test\"");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_withPriorityAndPrependedDate
{
	TextSplitter* result = [TextSplitter split:@"(A) 2011-01-02 test"];
	XCTAssertEqual(PriorityA, result.priority.name, @"priority should be A");
	XCTAssertEqualObjects(@"2011-01-02", result.prependedDate, @"prependedDate should be 2011-01-02");
	XCTAssertEqualObjects(@"test", result.text, @"text should be \"test\"");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_dateInterspersedInText
{
	TextSplitter* result = [TextSplitter split:@"Call Mom 2011-03-02"];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"", result.prependedDate, @"prependedDate should be blank");
	XCTAssertEqualObjects(@"Call Mom 2011-03-02", result.text, @"text should be \"Call Mom 2011-03-02\"");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_missingSpace
{
	TextSplitter* result = [TextSplitter split:@"(A)2011-01-02 test"];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"", result.prependedDate, @"prependedDate should be blank");
	XCTAssertEqualObjects(@"(A)2011-01-02 test", result.text, @"text should be \"(A)2011-01-02 test\"");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_outOfOrder
{
	TextSplitter* result = [TextSplitter split:@"2011-01-02 (A) test"];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"2011-01-02", result.prependedDate, @"prependedDate should be 2011-01-02");
	XCTAssertEqualObjects(@"(A) test", result.text, @"text should be \"(A) test\"");
	XCTAssertFalse(result.completed, @"completed should be false");
	XCTAssertEqualObjects(@"", result.completedDate, @"completedDate should be blank");
}

- (void)testSplit_completed
{
	TextSplitter* result = [TextSplitter split:@"x 2011-01-02 test 123"];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"", result.prependedDate, @"prependedDate should be blank");
	XCTAssertEqualObjects(@"test 123", result.text, @"text should be \"test 123\"");
	XCTAssertTrue(result.completed, @"completed should be true");
	XCTAssertEqualObjects(@"2011-01-02", result.completedDate, @"completedDate should be 2011-01-02");
}

- (void)testSplit_completedWithPrependedDate
{
	TextSplitter* result = [TextSplitter split:@"x 2011-01-02 2011-01-01 test 123"];
	XCTAssertEqualObjects([Priority NONE], result.priority, @"priority should be NONE");
	XCTAssertEqualObjects(@"2011-01-01", result.prependedDate, @"prependedDate should be 2011-01-01");
	XCTAssertEqualObjects(@"test 123", result.text, @"text should be \"test 123\"");
	XCTAssertTrue(result.completed, @"completed should be true");
	XCTAssertEqualObjects(@"2011-01-02", result.completedDate, @"completedDate should be 2011-01-02");
}

@end
