#import <Foundation/Foundation.h>
#import "FlickrFetcher.h"

@interface Place : NSObject {
}

@property (nonatomic,copy) NSString* title;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* place_id;

+(NSArray *) topPlaces;
@end
