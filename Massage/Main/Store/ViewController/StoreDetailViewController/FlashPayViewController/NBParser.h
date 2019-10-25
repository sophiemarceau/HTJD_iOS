
#import <Foundation/Foundation.h>
#import "NBTextField.h"

@class NBGroup;

@interface NBParser : NSObject
{
    NSString *_pattern;
    BOOL _ignoreCase;
    NBGroup *_node;
    BOOL _finished;
    NSRegularExpression *_exactQuantifierRegex;
    NSRegularExpression *_rangeQuantifierRegex;
}

- (id)initWithPattern:(NSString*)pattern;
- (id)initWithPattern:(NSString*)pattern ignoreCase:(BOOL)ignoreCase;
- (NSString*)reformatString:(NSString*)input andRegEx:(RegExTextFieldType)_regEx;

@property (readonly, nonatomic) NSString *pattern;

@end
