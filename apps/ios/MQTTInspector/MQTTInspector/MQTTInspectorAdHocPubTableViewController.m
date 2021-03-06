//
//  MQTTInspectorAdHocPubTableViewController.m
//  MQTTInspector
//
//  Created by Christoph Krey on 15.11.13.
//  Copyright (c) 2013 Christoph Krey. All rights reserved.
//

#import "MQTTInspectorAdHocPubTableViewController.h"
#import "Publication+Create.h"
#import "MQTTInspectorDataViewController.h"

@interface MQTTInspectorAdHocPubTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *topicText;
@property (weak, nonatomic) IBOutlet UITextField *dataText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *qosSegment;
@property (weak, nonatomic) IBOutlet UISwitch *retainSwitch;

@property (strong, nonatomic) Publication *pub;

@end

@implementation MQTTInspectorAdHocPubTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pub = [Publication publicationWithName:@"<last>"
                                          topic:@"MQTTInspector"
                                            qos:0
                                       retained:FALSE
                                           data:[@"manual ping %t %c" dataUsingEncoding:NSUTF8StringEncoding] session:self.mother.session
                         inManagedObjectContext:self.mother.session.managedObjectContext];
    
    self.topicText.text = self.pub.topic;
    self.dataText.text = [MQTTInspectorDataViewController dataToString:self.pub.data];
    self.qosSegment.selectedSegmentIndex = [self.pub.qos intValue];
    self.retainSwitch.on = [self.pub.retained boolValue];
}


- (IBAction)pubNow:(UIButton *)sender {
    self.pub.topic = self.topicText.text;
    self.pub.data = [self.dataText.text dataUsingEncoding:NSUTF8StringEncoding];
    self.pub.retained = @(self.retainSwitch.on);
    self.pub.qos = @(self.qosSegment.selectedSegmentIndex);
    
    [self.mother publish:self.pub];
}

@end
