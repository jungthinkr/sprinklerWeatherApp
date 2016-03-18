//
//  ViewController.m
//  IOSWifiSender
//
//  Created by tanno on 2015/11/21.
//  Copyright © 2015年 tanno. All rights reserved.
//

//ref http://stackoverflow.com/questions/13047661/sending-udp-packets-in-ios-6

#import "weatherViewController.h"
#import "OWMWeatherAPI.h"
#include <CFNetwork/CFNetwork.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface weatherViewController (){
OWMWeatherAPI *weatherAPI;

    __weak IBOutlet UILabel *city;
    __weak IBOutlet UILabel *weatherDescription;
    __weak IBOutlet UILabel *highTemp;
    __weak IBOutlet UILabel *lowTemp;
    __weak IBOutlet UILabel *humidity;

}
@end

@implementation weatherViewController

int sock = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *movingDot = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height/2, 20, 20))];
    UIView *movingDot2 = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height/2, 20, 20))];
    UIView *movingDot3 = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height/2, 20, 20))];

    movingDot.backgroundColor = [UIColor purpleColor];
    movingDot.layer.cornerRadius = 10;
    movingDot2.backgroundColor = [UIColor greenColor];
    movingDot2.layer.cornerRadius = 10;
    movingDot3.backgroundColor = [UIColor orangeColor];
    movingDot3.layer.cornerRadius = 10;
    [self.view addSubview:movingDot];
    [self.view addSubview:movingDot2];
    [self.view addSubview:movingDot3];
    [UIView animateWithDuration: 5
                          delay: 0            // DELAY
         usingSpringWithDamping: 1
          initialSpringVelocity: 0
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^
     {
         movingDot.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - movingDot.bounds.size.width, 0);//(1, 1);
     } completion: nil
     ];
    [UIView animateWithDuration: 5
                           delay: 1            // DELAY
          usingSpringWithDamping: 1
           initialSpringVelocity: 0
                         options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                      animations:^
      {
          movingDot2.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - movingDot.bounds.size.width, 0);//(1, 1);
      } completion: nil];
      [UIView animateWithDuration: 5
                            delay: 2            // DELAY
           usingSpringWithDamping: 1
            initialSpringVelocity: 0
                          options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                       animations:^
       {
           movingDot3.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - movingDot.bounds.size.width, 0);//(1, 1);
       }
                    completion:nil];
    weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"05f4e6bca74c0df78911398115a7368d"];
    [weatherAPI setTemperatureFormat:kOWMTempFahrenheit];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.LedLabel.text = @"Start LED";
    
    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
    {
        NSLog(@"Failed to create socket, error=%s", strerror(errno));
        //self.LedLabel.text = @"Failed to Create Socket";
    }
    [weatherAPI currentWeatherByCityName:@"LosAngeles" withCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            // handle the error
            NSLog(@"%@", error);
            return;
        }
        
        // The data is ready
        
        NSString *cityName = result[@"name"];
        NSNumber *currentTemp = result[@"main"][@"temp"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 2;
        formatter.roundingMode = NSNumberFormatterRoundUp;
       weatherDescription.text = result[@"weather"][0][@"description"];
        city.text = result[@"name"];
        highTemp.text = [formatter stringFromNumber:result[@"main"][@"temp_max"]];
        lowTemp.text = [formatter stringFromNumber:result[@"main"][@"temp_min"]];
        humidity.text = [formatter stringFromNumber:result[@"main"][@"humidity"]];
        NSLog(@"%@", result);
        
    }];
    
   /* [weatherAPI forecastWeatherByCityName:@"LosAngeles" withCallback:^(NSError *error, NSDictionary *result) {
        if (error){
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@",result);
    }];*/

    
}

static void SendMessage(NSString *msg )
{
    unsigned int echolen;
    struct sockaddr_in destination;
    memset(&destination, 0, sizeof(struct sockaddr_in));
    destination.sin_len = sizeof(struct sockaddr_in);
    destination.sin_family = AF_INET;
    
    NSString *ip = @"192.168.11.2";
    destination.sin_addr.s_addr = inet_addr([ip UTF8String]);
    destination.sin_port = htons(33033); //port
    
    /* server port */
    setsockopt(sock, IPPROTO_IP, IP_MULTICAST_IF, &destination, sizeof(destination));
    const char *cmsg = [msg UTF8String];
    echolen = round(strlen(cmsg));
    if (sendto(sock, cmsg,echolen,0, (struct sockaddr *) &destination, sizeof(destination)) == -1)
    {
        NSLog(@"did not send, error=%s",strerror(errno));
    }
    else
    {
        NSLog(@"did send");
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void) dailyForecastWeatherByCityName:(NSString *) name
                           //  withCount:(int) count
                          // andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
- (IBAction)ChangeSC:(UISegmentedControl *)sender
{
    NSString *state = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
   // self.LedLabel.text = state;
    
    
    if([state isEqualToString:@"ON"])
    {
        SendMessage(@"1");
    }
    
    if([state isEqualToString:@"OFF"])
    {
        SendMessage(@"0");
    }

}

@end
