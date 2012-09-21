//
//  DBAccess.h
//  Business Calendar Network
//
//  Created by mac user on 8/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DB_NAME "Somfy.sqlite"

@interface DBAccess : NSObject {
	sqlite3 *database;
	NSString *databaseName,*databasePath;
}

-(id)init;
-(NSString*)selectFieldValueFromDatabase:(NSString *)sQuery;
-(int)selectMaxIdFromDatabase:(NSString *)sQuery;
-(NSMutableArray*)selectValueFromDatabase:(NSString *)sQuery :(NSArray*)tempArr;
-(BOOL)InsertIntoDatabase:(NSString *)sQuery :(NSArray*)Array;
-(BOOL)InsertIntoDB:(NSString *)sQuery :(NSArray*)Array;
-(BOOL)UpdateValueToDatabase:(NSString *)sQuery :(NSArray*)Array;
-(BOOL)DeleteFromDatabase:(NSString *)sQuery :(int)EventId;
-(BOOL)DeleteFromDB:(NSString *)sQuery;
-(NSMutableArray*)selectAllValueFromDatabase:(NSString *)sQuery :(NSArray*)tempArr;




@end
