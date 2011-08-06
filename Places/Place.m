#import "Place.h"

@implementation Place

@synthesize title, description, place_id;

-(id) initWithDictionary:dictionary 
{
    self = [super init];
    if (self) {
        NSString * content = [dictionary objectForKey:@"_content"];
        NSArray * components = [content componentsSeparatedByString:@", "];
        self.place_id = [dictionary objectForKey:@"place_id"];
        self.title = [components objectAtIndex:0];
        self.description =  [[components subarrayWithRange:NSMakeRange(1, [components count] -1)] componentsJoinedByString:@", "];        
    }
    return self;
}

+(NSArray *) topPlaces
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSArray * placesAsArray = [[FlickrFetcher topPlaces]
                               sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                             [NSSortDescriptor sortDescriptorWithKey:
                                                              @"_content" ascending:YES]]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSMutableArray *places = [NSMutableArray arrayWithCapacity: [placesAsArray count]];
    for (NSDictionary *json in placesAsArray) {
        Place * place = [[Place alloc] initWithDictionary:json];
        [places addObject:place];
        [place release];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    return places;
}

@end
