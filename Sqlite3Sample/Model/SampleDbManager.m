//
//  SampleDbManager.m
//  Sqlite3Sample
//
//  Created by Mark Dubouzet on 4/26/13.
//  Copyright (c) 2013 Mark Dubouzet. All rights reserved.
//

#import "SampleDbManager.h"
#import "DatabaseManager.h"


@implementation SampleDbManager

#pragma mark CHECK FOR TABLE EXISTENCE
+(void)checkTable:(const char*)sql{
    [DatabaseManager getSampleDatabaseLock];
    sqlite3 *db = [DatabaseManager sampleDatabase];
    sqlite3_stmt *sql_statement = nil;
    
    if (sqlite3_prepare_v2(db, sql, -1, &sql_statement, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error: checkTable: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
    
    if(sqlite3_step(sql_statement) == SQLITE_ROW)
    {
        // flush the resultset
    }
    
    sqlite3_finalize(sql_statement);
    [DatabaseManager releaseSampleDatabaseLock];
}

+(void)clearOutTable:(const char*)sql{
    [DatabaseManager getSampleDatabaseLock];
    sqlite3 *db = [DatabaseManager sampleDatabase];
    sqlite3_stmt *sql_statement = nil;
    
    if (sqlite3_prepare_v2(db, sql, -1, &sql_statement, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
    
    if(sqlite3_step(sql_statement) != SQLITE_DONE){
        NSLog(@"CHECK ERROR!!");
    }
    
    sqlite3_finalize(sql_statement);
    [DatabaseManager releaseSampleDatabaseLock];
}

#pragma mark CHECK TABLES
// This method checks if the mood table exists in the database or not. If it exists it is ignored else it gets created.
+(void)checkTableWithName:(NSString*)tableName
{   
    const char *sql = [[NSString stringWithFormat:@"CREATE TABLE '%@' (rid TEXT PRIMARY KEY, name TEXT, address TEXT, notes TEXT, ratings NUMERIC);COMMIT;",tableName] UTF8String]; //restaurants_tble
    [self checkTable:sql];
    //If we have existing table check to see if we have notes column
}

#pragma mark CLEAR OUT TABLES
+ (void)clearOutTableWithName:(NSString*)tableName
{
    //const char *sql = "DELETE FROM my_table";
    const char *sql = [[NSString stringWithFormat:@"DELETE FROM '%@' ", tableName] UTF8String];
    [self checkTableWithName:tableName];
    [self clearOutTable:sql];
}

#pragma mark Populate Table Sample
+(void)populateTableSample{
    [DatabaseManager getSampleDatabaseLock];
	sqlite3 *db = [DatabaseManager sampleDatabase];
	sqlite3_stmt *sql_statement = nil;
    
    NSString *rid = [self generateGUID];
    
	const char *sql = "insert into restaurants_tble (rid, name, address, notes, ratings) values (?,?,?,?,?)";
	if (sqlite3_prepare_v2(db, sql, -1, &sql_statement, NULL) != SQLITE_OK)
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
    
    sqlite3_bind_text(sql_statement, 1, [rid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(sql_statement, 2, [@"sampleName" UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(sql_statement, 3, [@"sampleAddress" UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(sql_statement, 4, [@"sampleNotes that goes ooohh ooh oooh ohoh" UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(sql_statement,  5, 500);
        //sqlite3_step(sql_statement);
    
    if(sqlite3_step(sql_statement) != SQLITE_DONE){
        NSLog(@"ERROR");
    }
    
    sqlite3_finalize(sql_statement);
	[DatabaseManager releaseSampleDatabaseLock];
}

#pragma mark HELPFUL METHODS
+ (NSString *)generateGUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    //CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    
    CFStringRef str = CFUUIDCreateString(NULL, theUUID); //# _uuid is of type CFUUIDRef
    CFRelease(theUUID);
    
    return [(__bridge NSString *) str lowercaseString];
}

+(int)getUTCDate
{
    return [[NSDate date] timeIntervalSince1970] ;
}

+(int)getUTCDateForDate:(NSDate *)date
{
    return [date timeIntervalSince1970] ;
}

@end
