#import "PhotoInfo.h"
#import "FlickrFetcher.h"

@interface PhotoInfo()
@property(retain) NSDictionary* flickrInfo;
@end

@implementation PhotoInfo
@synthesize title, description, flickrInfo, image;

- (NSString *) description
{
    return [[self.flickrInfo objectForKey: @"description"]objectForKey:@"_content" ];
}

- (UIImage *) image
{
    if (!image) {
        image = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithFlickrInfo:self.flickrInfo format:FlickrFetcherPhotoFormatLarge]];
    }
    return image;
}

- (NSString *) titleFromFlickrInfo
{
    NSString * flickrTitle = [self.flickrInfo objectForKey: @"title"];
    return flickrTitle ? flickrTitle : self.description ? self.description : @"Unknown";
}

-(id) initWithDictionary:dictionary 
{
    self = [super init];
    if (self) {
        self.flickrInfo = dictionary;
        self.title = [self titleFromFlickrInfo];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:self.flickrInfo forKey:@"flickrInfo"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.flickrInfo = [decoder decodeObjectForKey:@"flickrInfo"];        
    }
    return self;
}

+(NSArray *) photosAtPlace:(Place *)place
{
    NSArray* flickrInfo = [FlickrFetcher photosAtPlace:place.place_id];
    return flickrInfo;
}
@end