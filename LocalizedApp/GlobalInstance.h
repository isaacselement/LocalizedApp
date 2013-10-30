#import <Foundation/Foundation.h>

#define GLOBAL [GlobalInstance getInstance]

@interface GlobalInstance : NSObject


@property (strong) NSMutableArray* allFilePaths;
@property (nonatomic, strong) NSMutableDictionary* allFileContents;
@property (strong, readonly) NSMutableArray* allLocalizeKeys;


+(GlobalInstance*) getInstance ;

@end
