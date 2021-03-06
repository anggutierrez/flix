//
//  MoviesViewController.m
//  flix
//
//  Created by Angel Gutierrez on 6/26/20.
//  Copyright © 2020 Angel Gutierrez. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start setting up the defined UITableViewDataSource and UITableViewDelegate we said we would provide at the top function declaration.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
	
	[self fetchMovies];
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
	[self.tableView insertSubview:self.refreshControl atIndex:0];
	
}

- (void) fetchMovies {
	// Alert for when we have network issues
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Connection Error!"
		   message:@"Please connect to the internet and refresh the page."
	preferredStyle:(UIAlertControllerStyleAlert)];
	
	// create an OK action
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
													   style:UIAlertActionStyleDefault
													 handler:^(UIAlertAction * _Nonnull action) {
															 // handle response here.
													 }];
	// add the OK action to the alert controller
	[alert addAction:okAction];
	
	NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
			   // Our Alert is being called here!
								  [self presentViewController:alert animated:YES completion:^{
								   // Run other stuff off of completion
								   }];
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               self.movies = dataDictionary[@"results"];
	
               // Used to make sure I was properly calling
               // NSLog(@"%@", dataDictionary);
               [self.tableView reloadData];
								  
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
           }
			[self.refreshControl endRefreshing];
       }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do any additional setup after loading the view.
	
	// Start animating the loading screen
	[self.activityIndicator startAnimating];
	
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    
    // Gets our title and overview at the movie index
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    // Strings to access our assets
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
	
	[cell.posterView setImageWithURL:posterURL];
    
	// Stop the activity indicator
	[self.activityIndicator stopAnimating];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	UITableViewCell *tappedCell = sender;
	NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
	NSDictionary *movie = self.movies[indexPath.row];
	
	DetailsViewController *detailsViewController = [segue destinationViewController];
	detailsViewController.movie = movie;
	
}


@end
