//
//  DBHelper.m
//  PilotManual
//
//  Created by sophiemarceau_qu on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DBHelper.h"

static DBHelper* _sharedDBHelper = nil;

@implementation DBHelper
{
    FMDatabase *db;
}

+(DBHelper *) sharedDBHelper
{
    if(_sharedDBHelper == nil)
    {
        _sharedDBHelper = [[super allocWithZone:NULL] initWithDBName:@"massagehuatuojiadao.db"];
    }
    
    return _sharedDBHelper;
}

- (id) initWithDBName:(NSString*) dbName
{
    self = [super init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dbFullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dbName];

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    
    if(![fileMgr fileExistsAtPath:dbFullPath])
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        
        BOOL ret = [fileMgr removeItemAtPath:dbFullPath error:&error];
        
        ret = [fileMgr copyItemAtPath:defaultDBPath toPath:dbFullPath error:&error];
        
        if(!ret)
        {
            NSLog(@"Faile to create database !!");
        }
        
    }
    
    db = [FMDatabase databaseWithPath:dbFullPath];
    db.logsErrors = YES;
    
    return self;
}

- (FMResultSet*) Query:(NSString*)sql
{
    if(![db open])
    {
        NSLog(@"DB Open Failed.");
        return nil;
    }

    FMResultSet *rs = [db executeQuery:sql];
    return rs;
}

- (void) ExecuteSql:(NSString*)sql
{
    if(![db open])
    {
        NSLog(@"DB Open Failed.");
        return;
    }

    [db executeUpdate:sql];
    
    [db close];
}

- (void) ExecuteSqlList:(NSArray*)sqlArr
{
    if(![db open])
    {
        NSLog(@"DB Open Failed.");
        return;
    }
    
    [db beginTransaction];
    
    for(NSString* sql in sqlArr)
    {
        [db executeUpdate:sql];
    }
    
    [db commit];
    [db close];   
}

- (void) CloseDB
{
    [db close];
}

@end
