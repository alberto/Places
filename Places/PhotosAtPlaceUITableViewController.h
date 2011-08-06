//
//  PhotosAtPlaceUITableViewController.h
//  Places
//
//  Created by moviles on 04/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PhotosAtPlaceUITableViewController : UITableViewController {
    Place *place;
    UIImageView *imageView;
}

@property (retain) Place *place;

@end
