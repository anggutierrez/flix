//
//  MoviesGridViewController.m
//  flix
//
//  Created by Angel Gutierrez on 7/1/20.
//  Copyright © 2020 Angel Gutierrez. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	
	[self fetchMovies];
	
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	
	layout.minimumInteritemSpacing = 0;
	layout.minimumLineSpacing = 7;
	
	// Cell view
	CGFloat postersPerRow = 3;
	CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
	CGFloat itemHeight = itemWidth * 1.5;
	layout.itemSize = CGSizeMake(itemWidth, itemHeight);
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
			   [self.collectionView reloadData];
               
           }
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
	MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
	
	NSDictionary *movie = self.movies[indexPath.item];
	
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
	cell.posterView.image = nil;
	
	[cell.posterView setImageWithURL:posterURL];
	
	return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.movies.count;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	UICollectionViewCell *tappedCell = sender;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
	NSDictionary *movie = self.movies[indexPath.item];
	
	DetailsViewController *detailsViewController = [segue destinationViewController];
	detailsViewController.movie = movie;
	
}

@end
