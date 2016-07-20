//
//  TMPImagePickerCollectionViewCell.m
//  TheMenuProject
//
//  Created by Abbin Varghese on 20/07/16.
//  Copyright © 2016 ThePaadamCompany. All rights reserved.
//

#import "TMPImagePickerCollectionViewCell.h"

@implementation TMPImagePickerCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cellImageView.image = nil;
}

-(void)selectCell:(BOOL)animated{
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.cellImageView.transform=CGAffineTransformMakeScale(0.9, 0.9);
                         self.cellImageView.layer.cornerRadius = 5;
                         self.cellImageView.layer.masksToBounds = YES;
                         self.cellImageView.alpha = 0.5;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)deSelectCell:(BOOL)animated{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.cellImageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         self.cellImageView.layer.cornerRadius = 0;
                         self.cellImageView.layer.masksToBounds = YES;
                         self.cellImageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)shakeCell{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.cellImageView center].x - 5.0f, [self.cellImageView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.cellImageView center].x + 5.0f, [self.cellImageView center].y)]];
    [[self.cellImageView layer] addAnimation:animation forKey:@"position"];
}


@end
