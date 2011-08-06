#import "PhotosAtPlaceUITableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoInfo.h"


@interface  PhotosAtPlaceUITableViewController()
@property (nonatomic, retain) NSArray *photos;
@end

@implementation PhotosAtPlaceUITableViewController

@synthesize place, photos;

-(NSArray *) photos {
    if (!photos) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        photos = [PhotoInfo photosAtPlace:self.place];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    [photos retain];
    return photos;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.place.title;
    self.clearsSelectionOnViewWillAppear = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait 
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self photos] count];
}

- (PhotoInfo *) photoAtIndex:(NSIndexPath *)indexPath {
    PhotoInfo* photoInfo = [[PhotoInfo alloc] initWithDictionary:[[self photos] objectAtIndex:indexPath.row]];
    return photoInfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotosAtPlaceUITableViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    PhotoInfo* photo = [self photoAtIndex:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.description;
    return cell;
}

#pragma mark - Table view delegate

- (void) addToRecentPhotos: (PhotoInfo *) photo  {
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* recentPhotos = [defaults objectForKey:@"recent"];
    if(!recentPhotos) recentPhotos = [NSArray array];
	
    NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:photo];
    recentPhotos = [recentPhotos arrayByAddingObject:theData];
    [defaults setObject:recentPhotos forKey:@"recent"];    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *vc = [[UIViewController alloc] init ];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:frame];
    PhotoInfo *photo = [self photoAtIndex:indexPath];
    [self addToRecentPhotos: photo];

    UIImage *image = photo.image;

    imageView = [[UIImageView alloc] initWithImage:image];
    [detailView addSubview:imageView];
    detailView.contentSize = imageView.bounds.size;
    detailView.minimumZoomScale = 0.3;
    detailView.maximumZoomScale = 3.0;
    detailView.delegate = self;

    [detailView zoomToRect:[imageView bounds] animated:NO];
    vc.view = detailView;
    vc.title = photo.title;
    [self.navigationController pushViewController:vc animated:YES];

    [imageView release];
    [detailView release];
    [vc release];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

@end
