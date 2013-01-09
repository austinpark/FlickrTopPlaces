//
//  UITopPlacesTableViewController.m
//  Flickr Top Places
//
//  Created by Austin on 1/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "UITopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "UIPlaceTableViewController.h"


@implementation UITopPlacesTableViewController
@synthesize places = _places;

- (void) setPlaces:(NSArray *)places {
    if (places != _places) {
        _places = places;
        [self.tableView reloadData];
    }
}
- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *sortedPhotos = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
        
        NSArray *places = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortedPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.places = places;
        });
    });
    dispatch_release(downloadQueue);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    id currentBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *sortedPhotos = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
        
        NSArray *places = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortedPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = currentBarButtonItem;
            self.places = places;
        });
    });
    dispatch_release(downloadQueue);


    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    NSString *placeName = [place objectForKey:FLICKR_PLACE_NAME];
    NSRange cityIndex = [placeName rangeOfString:@","];
    
    if (cityIndex.location == NSNotFound) {
        cell.textLabel.text = placeName;
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = [placeName substringToIndex:cityIndex.location];
        cell.detailTextLabel.text = [placeName substringFromIndex:cityIndex.location + 1];
    }
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *placeDictionary = [self.places objectAtIndex:self.tableView.indexPathForSelectedRow.row];

    UIPlaceTableViewController* placePhotosController = [segue destinationViewController];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    id currentButtonItem = placePhotosController.navigationItem.leftBarButtonItem;

    placePhotosController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t photoListDownloadQueue = dispatch_queue_create("photoListDownload Queue", NULL);
    
        
    dispatch_async(photoListDownloadQueue, ^{
        NSArray* photoList = [FlickrFetcher photosInPlace:placeDictionary maxResults:50];
        [placePhotosController setPhotoList:photoList withTitle:[sender textLabel].text];
        placePhotosController.navigationItem.leftBarButtonItem = currentButtonItem;
    });
    
}

@end
