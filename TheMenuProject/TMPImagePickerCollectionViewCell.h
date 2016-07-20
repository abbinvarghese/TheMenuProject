//
//  TMPImagePickerCollectionViewCell.h
//  TheMenuProject
//
//  Created by Abbin Varghese on 20/07/16.
//  Copyright © 2016 ThePaadamCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMPImagePickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (nonatomic, copy) NSString *representedAssetIdentifier;

-(void)selectCell:(BOOL)animated;
-(void)deSelectCell:(BOOL)animated;
-(void)shakeCell;



@end
