//
//  POIDetails.m
//  demoTHY
//
//  Created by Timur Yildirim on 27/02/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

#import "POIDetails.h"


@interface POIDetails ()

@end

@implementation POIDetails

- (id)initWithFrame:(CGRect)frame{
    if (self) {
        // Initialization code
        
        
        // 1. Load .xib
        //[[NSBundle mainBundle] loadNibNamed:@"POIDetails" owner:self options:nil];
        
        // 2. Adjust Bounds
        //self.bounds = self.view.bounds;
        
        // 3. add as subview
        //[self addSubview:self.view];
        
        //[self.view addSubview:<#(nonnull UIView *)#>]
        
        /*
         replace
         [[self.myValidator alloc] init];
         with
         self.myValidator = [[TextValidator alloc] init];
         */
    }
    return self;
}

- (IBAction)backButton:(id)sender {
    // https://www.youtube.com/watch?v=MO3NX_Fkbhc : bu linkten NSWindow'un nasıl ekleneceğine bakabilirsin sanırım
    // buna da bak: https://www.youtube.com/watch?v=upGJgEPbQMw&app=desktop
    
    // bu da çok önemli: http://stackoverflow.com/questions/9282365/load-view-from-an-external-xib-file-in-storyboard
    //[self.view performClose: sender];
    //[self.view setHidden:true];
    [self dismissViewControllerAnimated:self completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *iata = nil;
    NSString *icao = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int x = [defaults objectForKey:@"id"];
    
    
    NSString *limanAdi = [defaults objectForKey:@"title"];
    
    NSInteger id = [defaults integerForKey:@"id"];
    
    label1.text = [NSString stringWithFormat:@"%d", id];

    
    //label1.text = "Havalimanı Adı"
    
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

@end
