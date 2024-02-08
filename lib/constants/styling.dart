// Values for padding used in various widgets.
// This is to keep the padding length uniform throughout the app
// There doesn't seem to be many alternatives, and from what I have
// looked at other apps, padding seems to also be just hardcoded in.
// (https://stackoverflow.com/questions/61961988/how-do-i-store-my-default-padding-in-theme-of-in-flutter)

// Initially, I wanted to create a class of constants, but that seemed
// like it was not a good practice (https://stackoverflow.com/a/64795039)
// So we will just declare them at the top level like so
const double kSmallPadding = 8.0;
const double kMediumPadding = 12.0;
const double kLargePadding = 16.0;

const double kSmallRoundedCornerRadius = 8.0;
const double kMediumRoundedCornerRadius = 12.0;