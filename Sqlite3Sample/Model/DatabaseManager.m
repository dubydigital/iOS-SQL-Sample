//
//  DatabaseManager.m
//  Sqlite3Sample
//
//  Created by Mark Dubouzet on 4/26/13.
//  Copyright (c) 2013 Mark Dubouzet. All rights reserved.
//


#define SAMPLE_DATABASE_SCHEMA_PATH     @"/restaurants.db"
#define SAMPLE_DATABASE_BUNDLE_PATH  @"restaurants.db"



#import "DatabaseManager.h"
#import <libkern/OSAtomic.h>


@implementation DatabaseManager

static NSRecursiveLock *sampleDbLock = nil;
static NSInteger sampleLockCount = 0;
static sqlite3 *sampleDatabase;


+ (NSString *)sampleDbBundlePath
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *dbPath = [documentsDir stringByAppendingPathComponent:SAMPLE_DATABASE_BUNDLE_PATH];
    
    return dbPath;
}

+ (sqlite3*)sampleDatabase{
    if (sampleDatabase == NULL)
	{
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		NSString *dbPath = [documentsDir stringByAppendingString:SAMPLE_DATABASE_SCHEMA_PATH];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL dbExists = [fileManager fileExistsAtPath:dbPath];
		
		if (!dbExists)
        {
			[fileManager copyItemAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:SAMPLE_DATABASE_SCHEMA_PATH] toPath:dbPath error:nil];
        }
		
		if (!sqlite3_open([dbPath UTF8String], &sampleDatabase) == SQLITE_OK)
		{
			NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(sampleDatabase));
			sqlite3_close(sampleDatabase);
		}
	}
	return sampleDatabase;
}

+ (void)closeSampleDatabase{
    if(sampleDatabase != NULL)
	{
		@try
		{
			sqlite3_close(sampleDatabase);
			sampleDatabase = NULL;
		}
		@catch (NSException * e)
		{}
	}
}

+ (void)createSampleDatabaseIfNeeded{
    NSString *dbPath = [self sampleDbBundlePath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL dbExists = [fileManager fileExistsAtPath: dbPath];
	
	NSUInteger dbVersionNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"DBVerNum"];
	NSLog(@"Database version num: %d", dbVersionNum);
    
	if(!dbExists)
	{
		[fileManager createFileAtPath: dbPath contents: nil attributes: nil];		
        if (!sqlite3_open([[self sampleDbBundlePath] UTF8String], &sampleDatabase) == SQLITE_OK)
        {
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(sampleDatabase));
            sqlite3_close(sampleDatabase);
        }
        //        dbVersionNum = 3;
	}
}

+ (void)getSampleDatabaseLock{
    if (!sampleDbLock)
		sampleDbLock = [[NSRecursiveLock alloc] init];
	
	[sampleDbLock lock];
	OSAtomicIncrement32(&sampleLockCount);
	
	/*
     #ifdef DEBUG
     NSLog(@"Favorites DB Lock count: %d", lockCount);
     #endif
     */
}

+ (void)releaseSampleDatabaseLock{
    [sampleDbLock unlock];
	
	OSAtomicDecrement32(&sampleLockCount);
	
	/*
     #ifdef DEBUG
     NSLog(@"Favorites DB Lock count: %d", lockCount);
     #endif
     */
}

+ (void)deleteEntireSampleDatabase{
    [self getSampleDatabaseLock];
	//TODO delete entire user database
	[self releaseSampleDatabaseLock];
}


@end
