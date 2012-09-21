//
//  DBAccess.m
//  Business Calendar Network
//
//  Created by mac user on 8/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DBAccess.h"

static sqlite3_stmt *update_statement = nil;
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *delete_statement = nil;



@interface DBAccess (private)
- (void)createEditableCopyOfDatabaseIfNeeded;
@end

@implementation DBAccess
#pragma mark -
#pragma mark Private Methods

- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%s",DB_NAME]];
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%s",DB_NAME]];
    
    /*if (success) return;
     // The writable database does not exist, so copy the default to the appropriate location.
     NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%s",DB_NAME]];
     success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
     if (!success) {
     NSLog(@"Failed to create writable database file with message");
     }*/
    
    if(sqlite3_open([writableDBPath UTF8String], &database) == SQLITE_OK) //Create the database and tables
	{
		char *err; 
		NSString *sql = @"CREATE TABLE IF NOT EXISTS Somfy('username' CHAR(255),'password' CHAR(255),'userrole' CHAR(255))";
		
		if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
		{ 
			sqlite3_close(database);
			[fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
			return;
		}
		
		sql = @"CREATE TABLE IF NOT EXISTS ServerPath('RequestUrl' CHAR(255))";
		
		if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
		{ 
			sqlite3_close(database);
			[fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
			return;
		}
        
		NSString *query;
		query = @"SELECT COUNT(*) FROM ServerPath";
		query = [self selectFieldValueFromDatabase:query];
		if(query==nil || [query isEqualToString:@"0"])
		{
			query = @"INSERT INTO ServerPath(RequestUrl)VALUES(?)";
			NSArray *arr=[[NSArray alloc]initWithObjects:@"https://connect.somfytahoma.com/support/xml.php",nil];
			[self InsertIntoDB:query :arr];
			[arr release];
		}
        
		//sqlite3_close(database);
	}
}


#pragma mark -
#pragma mark Public Methods
//Select Particular Field Value From data base table
-(NSString*)selectFieldValueFromDatabase:(NSString *)sQuery
{
	NSString *result = @"";
	const char *columnText;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement=[sQuery UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results 
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				columnText = (const char *)sqlite3_column_text(compiledStatement, 0);
				if(columnText != NULL)
				{
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			compiledStatement=nil;
			sqlite3_close(database);
		}
	}
	return result;
}

//Select Max Row Id Value From data base table
-(int)selectMaxIdFromDatabase:(NSString *)sQuery
{
	int result=0;
	const char *columnText;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement=[sQuery UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results 
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				columnText = (const char *)sqlite3_column_text(compiledStatement, 0);
				if(columnText != NULL)
				{
					result = sqlite3_column_int(compiledStatement, 0);
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			compiledStatement=nil;
			sqlite3_close(database);
		}
	}
	return result;
}



//Select All Values From data base table
-(NSMutableArray*)selectAllValueFromDatabase:(NSString *)sQuery :(NSArray*)tempArr {
	//const char *columnText;
	NSMutableArray *GlobalArr=[[NSMutableArray alloc]init];
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement=[sQuery UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results 
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
				for(int i=0;i<[tempArr count];i++)
				{
					char *result = (char *)sqlite3_column_text(compiledStatement, i);
					if(result==nil)
						result = "";
					NSString *str = [NSString stringWithUTF8String:result];
					if(str==nil)
						str = @"";
					[dictionary setObject:str forKey:[tempArr objectAtIndex:i]];
				}
				[GlobalArr addObject:dictionary];
				[dictionary release];
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			compiledStatement=nil;
			sqlite3_close(database);
		}
	}
	return GlobalArr;
}




//Select All Values From data base table
-(NSMutableArray*)selectValueFromDatabase:(NSString *)sQuery :(NSArray*)tempArr {
	//const char *columnText;
	NSData *data;
	NSMutableArray *Events = [[NSMutableArray alloc]init];
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement=[sQuery UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results 
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
				for(int i=0;i<[tempArr count];i++)
				{
					if(i==[tempArr count]-1){
						data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, i) length:sqlite3_column_bytes(compiledStatement, i)];
					}
					else 
						[dictionary setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] forKey:[tempArr objectAtIndex:i]];
				}
				NSMutableArray *event;
				if([data length]>0)
					event = [NSKeyedUnarchiver unarchiveObjectWithData:data];
				[Events addObjectsFromArray:event];
				[dictionary release];
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			compiledStatement=nil;
			sqlite3_close(database);
		}
		
	}
	return Events;
}

-(BOOL)DeleteFromDatabase:(NSString *)sQuery :(int)EventId
{
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		if (delete_statement == nil) {
			const char *sql = [sQuery UTF8String];
			if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
				NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
				return NO;
			}
		}
		sqlite3_bind_int(delete_statement, 1, EventId);
		int success = sqlite3_step(delete_statement);

		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			return NO;
		} 
		
		sqlite3_finalize(delete_statement);
		delete_statement=nil;
		sqlite3_close(database);
	}
	else
		return NO;
	
	return YES;
}

-(BOOL)DeleteFromDB:(NSString *)sQuery
{
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		if (delete_statement == nil) {
			const char *sql = [sQuery UTF8String];
			if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
				NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
				return NO;
			}
		}
		//sqlite3_bind_int(delete_statement, 1, EventId);
		//sqlite3_bind_text(delete_statement, 1, [StrName UTF8String], -1, SQLITE_TRANSIENT);
		int success = sqlite3_step(delete_statement);
		
		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			return NO;
		} 
		
		sqlite3_finalize(delete_statement);
		delete_statement=nil;
		sqlite3_close(database);
	}
	else
		return NO;
	
	return YES;
}

-(BOOL)InsertIntoDatabase:(NSString *)sQuery :(NSArray*)Array
{
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		if (insert_statement == nil) {
			const char *sql = [sQuery UTF8String];
			if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
				NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
				return NO;
			}
		}
			
		for(int i=0;i<[Array count];i++)
		{
			if(i==[Array count]-1)
				sqlite3_bind_blob(insert_statement, i+1, [[Array objectAtIndex:i] bytes], [[Array objectAtIndex:i] length], SQLITE_TRANSIENT);
			else if(i==0)
				sqlite3_bind_int(insert_statement, i+1, [[Array objectAtIndex:i] intValue]);
			else
				sqlite3_bind_text(insert_statement, i+1, [[Array objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
		}
		
		int success = sqlite3_step(insert_statement);
		
		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			return NO;
		} 
		
		sqlite3_finalize(insert_statement);
		insert_statement=nil;
		sqlite3_close(database);
	}
	else
		return NO;
	
	return YES;
}

-(BOOL)InsertIntoDB:(NSString *)sQuery :(NSArray*)Array
{
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		if (insert_statement == nil) {
			const char *sql = [sQuery UTF8String];
			if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
				NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
				return NO;
			}
		}
		
		for(int i=0;i<[Array count];i++)
				sqlite3_bind_text(insert_statement, i+1, [[Array objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(insert_statement);
		
		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			return NO;
		} 
		
		sqlite3_finalize(insert_statement);
		insert_statement=nil;
		sqlite3_close(database);
	}
	else
		return NO;
	
	return YES;
}


-(BOOL)UpdateValueToDatabase:(NSString *)sQuery :(NSArray*)Array
{
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
	{
		if (update_statement == nil) {
            const char *sql = [sQuery UTF8String];
            if (sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL) != SQLITE_OK) {
                NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
				return NO;
            }
        }
		
		// Bind the query variables.
		
		for(int i=0;i<[Array count];i++)
		{
			sqlite3_bind_text(update_statement, i+1, [[Array objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
		}
		
		// Execute the query.
        int success = sqlite3_step(update_statement);
		
		// Handle errors.
        if (success != SQLITE_DONE) {
            NSLog(@"Error: failed to update with message '%s'.", sqlite3_errmsg(database));
			return NO;
        }
		
		sqlite3_finalize(update_statement);
		update_statement=nil;
		sqlite3_close(database);
	}
	else
	{
		return NO;
	}
	
	return YES;
}



#pragma mark -
#pragma mark Initialization & Deallocation
//Initialize database and creation
-(id)init {
	self = [super init];
	if (self != nil) {
		[self createEditableCopyOfDatabaseIfNeeded];
		databaseName = [NSString stringWithFormat:@"%s",DB_NAME];
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	}
	return self;
}

- (void)dealloc {
	
    [super dealloc];
}



@end
