//
//  DatabaseManager.h
//  Sqlite3Sample
//
//  Created by Mark Dubouzet on 4/26/13.
//  Copyright (c) 2013 Mark Dubouzet. All rights reserved.
//

#import <sqlite3.h>
#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject




+ (sqlite3*)sampleDatabase;

+ (void)closeSampleDatabase;

+ (void)createSampleDatabaseIfNeeded;

+ (void)getSampleDatabaseLock;

+ (void)releaseSampleDatabaseLock;

+ (void)deleteEntireSampleDatabase;

@end
