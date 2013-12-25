#import "GlobalInstance.h"

@implementation GlobalInstance

static GlobalInstance* sharedInstance = nil ;


@synthesize allFilePaths;
@synthesize allFileContents;
@synthesize allLocalizeKeys;

+(void)initialize {
    if (self == [GlobalInstance class]) {
        sharedInstance = [[GlobalInstance alloc] init];
    }
}

+(GlobalInstance*) getInstance {
    return sharedInstance;
}

// when set allFileContents , set the allLocalizeKeys
-(void)setAllFileContents:(NSMutableDictionary *)allFileContentsObj {
    if (allFileContents) {
        allFileContents = nil;
    }
    if (allLocalizeKeys) {
        allLocalizeKeys = nil;
    }
    
    allFileContents = allFileContentsObj;
    
    // set allLocalizeKeys, get the biggest count onw
    NSArray* temp = nil;
    for (NSString* key in allFileContents) {
        NSArray* contentskeys = [allFileContents[key] allKeys];
        if (contentskeys.count > temp.count) temp = contentskeys;
    }
    
    // sort allLocalizeKeys
    NSArray* sorted = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { return [obj1 compare:obj2];}];
    allLocalizeKeys = [NSMutableArray arrayWithArray: sorted];
}

#define NEW_KEY         @"zz--"
#define NEW_CONTENT     @"z"
-(void) addNewKeyInAllFileContents
{
    // add key . change all the keys-values
    NSMutableDictionary* contents = [NSMutableDictionary dictionary];
    for (NSString* filePath in allFilePaths) [contents setObject: NEW_CONTENT forKey:filePath];
    [self addKeyInAllFileContents: NEW_KEY contents:contents];
}

-(void) addKeyInAllFileContents: (NSString*)newKey contents:(NSDictionary*)contents
{
    // add key . change all the keys-values
    [allLocalizeKeys addObject: newKey];
    for (NSString* fileKey in allFileContents) {
        NSMutableDictionary* fileContent = [allFileContents objectForKey:fileKey];
        [fileContent setObject:contents[fileKey] forKey:newKey];
    }
}


-(BOOL) changeKeyInAllFileContents: (NSString*)oldKey newKey:(NSString*)newKey
{
    if ([allLocalizeKeys containsObject: newKey])return NO;
    int editingRow = 0;
    for (int i = 0; i < allLocalizeKeys.count; i++) {
        if ([allLocalizeKeys[i] isEqualToString: oldKey]){
            editingRow = i;
            break;
        }
    }
    [allLocalizeKeys replaceObjectAtIndex:editingRow withObject:newKey];
    
    for (NSString* key in allFileContents) {
        NSMutableDictionary* content = [allFileContents objectForKey:key];
        id value = [content objectForKey: oldKey];
        [content setObject: value forKey:newKey];
        [content removeObjectForKey: oldKey];
    }
    return YES;
}


-(void) changeContentInFile: (NSString*)filePath newContent:(NSString*)newContent forKey:(NSString*)key
{
    NSMutableDictionary* fileContents = [allFileContents objectForKey: filePath];
    [fileContents setObject: newContent forKey:key];
}

@end
