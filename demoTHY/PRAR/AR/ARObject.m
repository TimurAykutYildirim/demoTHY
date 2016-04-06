//
//  ARObject.m
//  PrometAR
//
// Created by Geoffroy Lesage on 4/24/13.
// Copyright (c) 2013 Promet Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 

#import "ARObject.h"
#import "POIDetails.h"
#import <CNPPopupController/CNPPopupController-umbrella.h>


@interface ARObject () <CNPPopupControllerDelegate>
@property (nonatomic,strong) CNPPopupController *popupController;
@end
/*
@interface UIViewController () <CNPPopupControllerDelegate>
@property (nonatomic,strong) CNPPopupController *popupController;
@end
*/

@implementation ARObject

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"It's A Popup!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"You can add text and images" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Close Me" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button.layer.cornerRadius = 4;
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    
    UILabel *lineTwoLabel = [[UILabel alloc] init];
    lineTwoLabel.numberOfLines = 0;
    lineTwoLabel.attributedText = lineTwo;
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 55)];
    customView.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 35)];
    textFied.borderStyle = UITextBorderStyleRoundedRect;
    textFied.placeholder = @"Custom view!";
    [customView addSubview:textFied];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, imageView, lineTwoLabel, customView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

#pragma mark - event response

-(void)showPopupCentered:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleCentered];
}

- (void)showPopupFormSheet {
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
}

- (void)showPopupFullscreen:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleFullscreen];
}

@synthesize arTitle, distance;

- (id)initWithId:(int)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
andCurrentLocation:(CLLocationCoordinate2D)currLoc
{
    self = [super init];
    if (self) {
        arId = newId;
        
        arTitle = [[NSString alloc] initWithString:newTitle];
        //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK3
        
        lat = newCoordinates.latitude;
        lon = newCoordinates.longitude;
        
        distance = @([self calculateDistanceFrom:currLoc]);
        
        [self.view setTag:newId];
    }
    return self;
}

-(double)calculateDistanceFrom:(CLLocationCoordinate2D)user_loc_coord
{
    CLLocationCoordinate2D object_loc_coord = CLLocationCoordinate2DMake(lat, lon);
    
    CLLocation *object_location = [[CLLocation alloc] initWithLatitude:object_loc_coord.latitude
                                                              longitude:object_loc_coord.longitude];
    CLLocation *user_location = [[CLLocation alloc] initWithLatitude:user_loc_coord.latitude
                                                            longitude:user_loc_coord.longitude];
    
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK4
    return [object_location distanceFromLocation:user_location];
    
}
-(NSString*)getDistanceLabelText
{
    // tekirdağ 80.24 mil-> 129.41 km
    // gebze 28.40 mil -> 45.80 km
    /*
    if (distance.doubleValue > POINT_ONE_MILE_METERS)
         return [NSString stringWithFormat:@"%.2f mi", distance.doubleValue*METERS_TO_MILES];
    else return [NSString stringWithFormat:@"%.0f ft", distance.doubleValue*METERS_TO_FEET];
     */
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK5
    
    if(distance.doubleValue > POINT_ONE_MILE_METERS)
        return [NSString stringWithFormat:@"%.2f km.", distance.doubleValue*METERS_TO_KM];
    else return [NSString stringWithFormat:@"%f mt.", distance.doubleValue];
}

- (NSDictionary*)getARObjectData
{
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK6
    NSArray *keys = @[@"id",@"title", @"latitude", @"longitude", @"distance"];
    
    NSArray *values = @[@(arId),
                       arTitle,
                       @(lat),
                       @(lon),
                       distance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:arId forKey:@"id"];
    NSLog(@"arID: {0}", arId);
    [defaults setObject:arTitle forKey:@"title"];
    [defaults setDouble:lat forKey:@"latitude"];
    [defaults setDouble:lon forKey:@"longtitude"];
    [defaults setDouble:[distance doubleValue] forKey:@"distance"];
    
    [defaults synchronize];
    NSLog(@"persistent data saved");
    
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [titleL setText:arTitle];
    
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK1
    
    [distanceL setText:[self getDistanceLabelText]];
    
    //viewDidAppear önce buraya düşünmüştün!!! sorun olursa buraya geri çekip tekrar dene!!
}

-(void)myPOITapping:(UIGestureRecognizer *)recognizer
{
    NSLog(@"image click");
    
    //[self showPopupWithStyle:CNPPopupStyleActionSheet];
    //[self showPopupWithStyle:CNPPopupStyleCentered];
    //self.showPopupFormSheet();
    
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
    
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK7
    
    //POIDetails *poiDetails = [[POIDetails alloc] initWithNibName:@"POIDetails" bundle:nil]; // constructor
    //[self presentViewController:poiDetails animated:YES completion:nil];
    
    
    // obj-c popup kütüphanesinden önce, en son aktif olan bu
    /*
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"This is an alert."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
     */
    
    /*
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Test Alert" message: @"Alert With Custom View" delegate:nil cancelButtonTitle:@"BTN1" otherButtonTitles:@"BTN2", nil];
    
    UIImage* imgMyImage = [UIImage imageNamed:@"ist.png"];
    UIImageView* ivMyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgMyImage.size.width, imgMyImage.size.height)];
    [ivMyImageView setImage:imgMyImage];
    
    [alert setValue: ivMyImageView forKey:@"accessoryView"];
    [alert show];
     */
    
}

// bunu methodu timur ekledi
- (void)viewDidLoad {
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK2
    myPOI.contentMode = UIViewContentModeScaleToFill;
    myPOI.translatesAutoresizingMaskIntoConstraints=YES;
    [myPOI setUserInteractionEnabled:YES];
    UITapGestureRecognizer *myPOITap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myPOITapping:)];
    [myPOITap setNumberOfTapsRequired:1];
    [myPOI addGestureRecognizer:myPOITap];
    [self.view addSubview:myPOI];
}


#pragma mark -- OO Methods

- (NSString *)description {
    
    //[myPOI sizeThatFits:CGSizeMake(50, 50)]; // AMK8
    return [NSString stringWithFormat:@"ARObject %d - %@ - lat: %f - lon: %f - distance: %@",
            arId, arTitle, lat, lon, distance];
}

@end
