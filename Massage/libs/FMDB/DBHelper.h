//
//  DBHelper.h
//  PilotManual
//
//  Created by sophiemarceau_qu on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBHelper : NSObject

+(DBHelper *) sharedDBHelper;

- (id) initWithDBName:(NSString*) dbName;
- (FMResultSet*) Query:(NSString*)sql;
- (void) ExecuteSql:(NSString*)sql;
- (void) ExecuteSqlList:(NSArray*)sqlArr;
- (void) CloseDB;

@end