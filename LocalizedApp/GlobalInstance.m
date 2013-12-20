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


-(void)setAllFileContents:(NSMutableDictionary *)allFileContentsObj {
    if (allFileContents) {
        allFileContents = nil;
    }
    if (allLocalizeKeys) {
        allLocalizeKeys = nil;
    }
    
    allFileContents = allFileContentsObj;
    
    
    // set allLocalizeKeys
    NSArray* temp = nil;
    for (NSString* key in allFileContents) {
        NSDictionary* fileContents = [allFileContents objectForKey: key];
        NSArray* keys = [fileContents allKeys];
        if (keys.count > temp.count) {
            temp = keys;
        }
    }
    
    // sort allLocalizeKeys
    NSArray* sorted = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    allLocalizeKeys = [NSMutableArray arrayWithArray: sorted];
}

@end
