#import "RecentUITableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoInfo.h"

@implementation RecentUITableViewController

- (NSArray*) photos
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *photosFromDefaults = [defaults objectForKey:@"recent"];
    NSMutableArray *mutablePhotos = [NSMutableArray array];
    for (NSData *data in photosFromDefaults) {
        [mutablePhotos addObject: [NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    photos = mutablePhotos;
    [self.view setNeedsDisplay];
    return photos;
}

- (void)dealloc
{
    [photos release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait 
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (PhotoInfo *) photoAtIndex:(NSIndexPath *)indexPath {
    return [self.photos objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentUITableViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    PhotoInfo *photo = [self photoAtIndex:indexPath];
    cell.textLabel.text = photo.title;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *vc = [[UIViewController alloc] init ];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:frame];
    PhotoInfo *photo = [self photoAtIndex:indexPath];
    
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
