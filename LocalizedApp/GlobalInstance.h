#import <Foundation/Foundation.h>

#define GLOBAL [GlobalInstance getInstance]

@interface GlobalInstance : NSObject


@property (strong) NSMutableArray* allFilePaths;
@property (strong, readonly) NSMutableArray* allLocalizeKeys;
@property (nonatomic, strong) NSMutableDictionary* allFileContents; // filePath as key


+(GlobalInstance*) getInstance ;


-(void) addNewKeyInAllFileContents;
-(void) addKeyInAllFileContents: (NSString*)newKey contents:(NSDictionary*)contents;
-(BOOL) changeKeyInAllFileContents: (NSString*)oldKey newKey:(NSString*)newKey;


-(void) changeContentInFile: (NSString*)filePath newContent:(NSString*)newContent forKey:(NSString*)key;

@end
