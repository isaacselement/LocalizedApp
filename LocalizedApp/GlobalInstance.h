#import <Foundation/Foundation.h>

#define GLOBAL [GlobalInstance getInstance]

@interface GlobalInstance : NSObject


@property (strong) NSMutableArray* allFilePaths;
@property (strong, readonly) NSMutableArray* allLocalizeKeys;
@property (nonatomic, strong) NSMutableDictionary* allFileContents;


+(GlobalInstance*) getInstance ;

@end
