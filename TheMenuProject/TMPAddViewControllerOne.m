//
//  TMPAddViewControllerOne.m
//  TheMenuProject
//
//  Created by Abbin Varghese on 20/07/16.
//  Copyright © 2016 ThePaadamCompany. All rights reserved.
//

#import "TMPAddViewControllerOne.h"
#import "TMPAddOneCollectionViewCell.h"

@interface TMPAddViewControllerOne ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (weak, nonatomic) IBOutlet UITextField *nameTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation TMPAddViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Name and price";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(nextClicked:)];
    nextButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    UIBarButtonItem *cacnelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancelClicked:)];
    cacnelButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cacnelButton;
}

-(void)nextClicked:(id)sender{
    
}

-(void)cancelClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TMPAddOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TMPAddOneCollectionViewCell" forIndexPath:indexPath];
    cell.cellImageView.image = _images[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = _images[indexPath.row];
    return CGSizeMake(collectionView.frame.size.height*image.size.width/image.size.height, collectionView.frame.size.height);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _topConstrain.constant = -180;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _topConstrain.constant = -265;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        return NO;
    }
    else{
        return YES;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _topConstrain.constant = -350;
        [self.view layoutIfNeeded];
    } completion:nil];
    if ([textView.text isEqualToString:@"type here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"type here";
        textView.textColor = [UIColor colorWithWhite:0 alpha:0.25];
    }
}

- (IBAction)didTapOnView:(id)sender {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _topConstrain.constant = 20;
        [self.view layoutIfNeeded];
    } completion:nil];
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
