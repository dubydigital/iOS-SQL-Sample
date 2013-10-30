//
//  SampleDbManager.h
//  Sqlite3Sample
//
//  Created by Mark Dubouzet on 4/26/13.
//  Copyright (c) 2013 Mark Dubouzet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleDbManager : NSObject


#pragma mark CHECK FOR TABLE EXISTENCE
+(void)checkTable:(const char*)sql;
+(void)clearOutTable:(const char*)sql;

#pragma mark CHECK TABLES
// This method checks if the mood table exists in the database or not. If it exists it is ignored else it gets created.
+(void)checkTableWithName:(NSString*)tableName;

#pragma mark CLEAR OUT TABLES
+ (void)clearOutTableWithName:(NSString*)tableName;

#pragma mark Populate Table Sample
+(void)populateTableSample;

#pragma mark HELPFUL METHODS
+ (NSString *)generateGUID;
+(int)getUTCDate;
+(int)getUTCDateForDate:(NSDate *)date;


@end
