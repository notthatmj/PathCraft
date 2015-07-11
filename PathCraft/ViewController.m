//
//  ViewController.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ViewController.h"
#import "Environment.h"
#import "Event.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property Event *currentEvent;
@property int currentChoiceIndex;
@property NSArray *events;
@property NSMutableArray *eventHistory;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Environment *forrest = [Environment new];
    forrest.environmentDescription = @"Forest";

    [self generateEvents];
    
    Event *initialEvent = self.events[0];
    
    self.currentEvent = initialEvent;
    [self populateEventDisplay: self.currentEvent];
    
    self.eventHistory = [NSMutableArray new];
    [self.eventHistory addObject: self.currentEvent];
}

- (IBAction)choiceButtonPressed:(id)sender {
    [self updateChoice];
}

- (void) updateChoice {
    int numberOfChoices = (int)self.currentEvent.choices.count;

    if (self.currentChoiceIndex >= numberOfChoices - 1) {
        self.currentChoiceIndex = 0;
    } else {
        self.currentChoiceIndex++;
    }
    [self.choiceButton setTitle:self.currentEvent.choices[self.currentChoiceIndex] forState:UIControlStateNormal];
}

- (void) logEvent:(Event *)event {
    NSLog(@"%@", event.eventDescription);
}

- (void) advance {
    // Add current event ot the end of the history array
    Event *newEvent;
    do {
        NSUInteger index = (NSUInteger) arc4random() % [self.events count];
        newEvent = [self.events objectAtIndex:index];
        
    } while ([newEvent isEqual:self.currentEvent]);
    
    self.currentEvent = newEvent;
    [self populateEventDisplay: self.currentEvent];
    [self.eventHistory addObject: self.currentEvent];
}

- (void) moveBack {
    
    if (self.eventHistory.count > 1) {
        [self.eventHistory removeLastObject];
    }
    
    Event *lastEvent = [self.eventHistory lastObject];
    
    if (lastEvent) {
        self.currentEvent = lastEvent;
        [self populateEventDisplay: self.currentEvent];
    }
}

- (void) populateEventDisplay:(Event *)event {
    NSLog(@"popEventDisplay");
    [self logEvent:event];
    self.descriptionTextField.text = event.eventDescription;
    [self.choiceButton setTitle: event.choices[0] forState:UIControlStateNormal];
    self.currentChoiceIndex = 0;
}

- (IBAction)actionButtonPressed:(id)sender {
    // If the user chose "Move Forward", then generate a new event
    if ([self.choiceButton.titleLabel.text isEqualToString:@"Move Forward"]) {
        [self advance];
    } else {
        [self moveBack];
    }

    // If the user chose "Move Backward", go back to the previous event
}

- (void) generateEvents {

    Event *event1 = [Event new];
    event1.eventDescription = @"Trees surround you all around.";
    NSString *choice1 = @"Move Forward";
    NSString *choice2 = @"Move Backwards";
    NSArray *choices = [NSArray arrayWithObjects:choice1, choice2, nil];
    event1.choices = choices;

    Event *event2 = [Event new];
    event2.eventDescription = @"Sun light peaks through leaves of a tree.";
    choice1 = @"Move Forward";
    choice2 = @"Move Backwards";
    choices = [NSArray arrayWithObjects:choice1, choice2, nil];
    event2.choices = choices;

    Event *event3 = [Event new];
    event3.eventDescription = @"You think you hear something. You wait and nothing happens.";
    choice1 = @"Move Forward";
    choice2 = @"Move Backwards";
    choices = [NSArray arrayWithObjects:choice1, choice2, nil];
    event3.choices = choices;

    self.events = [NSArray arrayWithObjects:event1, event2, event3, nil];

}

@end
