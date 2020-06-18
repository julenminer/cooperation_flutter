// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'You have zoomed out too far. There are no points in this region.', one: 'You have zoomed out too far. Zoom in to see ${howMany} point.', other: 'You have zoomed out too far. Zoom in to see ${howMany} points.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "askForHelp" : MessageLookupByLibrary.simpleMessage("Ask for help"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "chat" : MessageLookupByLibrary.simpleMessage("Chat"),
    "close" : MessageLookupByLibrary.simpleMessage("Close"),
    "description" : MessageLookupByLibrary.simpleMessage("Description"),
    "descriptionError" : MessageLookupByLibrary.simpleMessage("The description field can not be empty"),
    "editImage" : MessageLookupByLibrary.simpleMessage("Edit image"),
    "editProfile" : MessageLookupByLibrary.simpleMessage("Edit profile"),
    "errorLogIn" : MessageLookupByLibrary.simpleMessage("Log in error, please try again"),
    "help" : MessageLookupByLibrary.simpleMessage("Help"),
    "helpOffer" : MessageLookupByLibrary.simpleMessage("Help offers"),
    "information" : MessageLookupByLibrary.simpleMessage("Information"),
    "location" : MessageLookupByLibrary.simpleMessage("Location"),
    "logInAndStart" : MessageLookupByLibrary.simpleMessage("Log in and start cooperating"),
    "logInGoogle" : MessageLookupByLibrary.simpleMessage("Log in with Google"),
    "logOut" : MessageLookupByLibrary.simpleMessage("Log out"),
    "directions" : MessageLookupByLibrary.simpleMessage("Directions"),
    "changeLightDarkMode" : MessageLookupByLibrary.simpleMessage("Change light/dark mode"),
    "changeLanguage" : MessageLookupByLibrary.simpleMessage("Change language"),
    "message" : MessageLookupByLibrary.simpleMessage("Message"),
    "myProfile" : MessageLookupByLibrary.simpleMessage("My profile"),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "noChanges" : MessageLookupByLibrary.simpleMessage("There are no changes"),
    "noMessages" : MessageLookupByLibrary.simpleMessage("You haven\'t received a message yet"),
    "offerYourHelp" : MessageLookupByLibrary.simpleMessage("Offer your help"),
    "openCamera" : MessageLookupByLibrary.simpleMessage("Open camera"),
    "openGallery" : MessageLookupByLibrary.simpleMessage("Open gallery"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "publish" : MessageLookupByLibrary.simpleMessage("Publish"),
    "saveChanges" : MessageLookupByLibrary.simpleMessage("Save changes"),
    "sendFirstMessage" : MessageLookupByLibrary.simpleMessage("Be the one to send the first message!"),
    "sendMessage" : MessageLookupByLibrary.simpleMessage("Send message"),
    "showQ" : MessageLookupByLibrary.simpleMessage("Show?"),
    "title" : MessageLookupByLibrary.simpleMessage("Title"),
    "titleError" : MessageLookupByLibrary.simpleMessage("The title field can not be empty"),
    "zoomTooFar" : m0
  };
}
