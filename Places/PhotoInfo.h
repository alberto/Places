#import <Foundation/Foundation.h>
#import "Place.h"

@interface PhotoInfo : NSObject {
    
}
@property (nonatomic,copy) NSString* title;
@property (nonatomic, copy) NSString* description;
@property(nonatomic, retain) UIImage *image;

+(NSArray *) photosAtPlace:(Place *) place;
@end
