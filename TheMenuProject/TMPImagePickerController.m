//
//  TMPImagePickerController.m
//  TheMenuProject
//
//  Created by Abbin Varghese on 20/07/16.
//  Copyright © 2016 ThePaadamCompany. All rights reserved.
//

#import "TMPImagePickerController.h"
#import "TMPImagePickerCollectionViewCell.h"
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"
@import Photos;

@interface TMPImagePickerController ()<UICollectionViewDelegateFlowLayout,PHPhotoLibraryChangeObserver,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (nonatomic, strong) NSMutableArray *selectedIndex;
@property (nonatomic, strong) NSMutableArray *selectedPHResults;
@property (nonatomic, strong) NSMutableArray *convertedImaged;

@property CGRect previousPreheatRect;

@end

@implementation TMPImagePickerController

static NSString * const reuseIdentifier = @"TMPImagePickerCollectionViewCell";
static CGSize AssetGridThumbnailSize;

-(void)initSelectedArray{
    if (_convertedImaged == nil) {
        _convertedImaged = [NSMutableArray new];
    }
    if (_selectedIndex == nil) {
        _selectedIndex = [NSMutableArray new];
    }
    if (_selectedPHResults == nil) {
        _selectedPHResults = [NSMutableArray new];
    }
    [_selectedIndex removeAllObjects];
    for (int i = 0; i<=_assetsFetchResults.count; i++) {
        [_selectedIndex addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)awakeFromNib{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        _assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self initSelectedArray];
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self resetCachedAssets];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGSize cellSize = CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    AssetGridThumbnailSize = CGSizeMake(cellSize.width, cellSize.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Begin caching assets in and around collection view's visible rect.
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self updateCachedAssets];
    }
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        [self initSelectedArray];
        [self.collectionView reloadData];
    });
    if (self.imageManager == nil) {
        self.imageManager = [[PHCachingImageManager alloc] init];
    }
    [self resetCachedAssets];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Choose photos";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Next"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(nextClicked:)];
    nextButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    UIBarButtonItem *cacnelButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Cancel"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(cancelClicked:)];
    cacnelButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cacnelButton;
    
}

-(void)nextClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMPImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.representedAssetIdentifier = @"";
    }
    else{
        if ([[_selectedIndex objectAtIndex:indexPath.row] boolValue]) {
            [cell selectCell:NO];
        }
        else{
            [cell deSelectCell:NO];
        }
        PHAsset *asset = self.assetsFetchResults[indexPath.item-1];
        cell.representedAssetIdentifier = asset.localIdentifier;
        [self.imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      // Set the cell's thumbnail image if it's still showing the same asset.
                                      if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                          cell.cellImageView.image = result;
                                      }
                                  }];

    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TMPImagePickerCollectionViewCell *cell = (TMPImagePickerCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if (_selectedPHResults.count<=2) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
        else{
            [cell shakeCell];
        }
    }
    else{
        if ([[_selectedIndex objectAtIndex:indexPath.row] boolValue]) {
            [cell deSelectCell:YES];
            [_selectedIndex replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
            [_selectedPHResults removeObject:[_assetsFetchResults objectAtIndex:indexPath.row-1]];
        }
        else{
            if (_selectedPHResults.count>=3) {
                [cell shakeCell];
            }
            else{
                [cell selectCell:YES];
                [_selectedIndex replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
                [_selectedPHResults addObject:[_assetsFetchResults objectAtIndex:indexPath.row-1]];
            }
        }
    }
}

#pragma mark <UICollectionViewDelegate>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self updateCachedAssets];
    }
}

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.row>0){
            PHAsset *asset = self.assetsFetchResults[indexPath.item-1];
            [assets addObject:asset];
        }
    }
    
    return assets;
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
