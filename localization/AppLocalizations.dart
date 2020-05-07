import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get help { // "Ayuda"
    return Intl.message('Help', name: 'help');
  }

  String get helpOffer { // "Oferta de ayuda"
    return Intl.message('Help offers', name: 'helpOffer');
  }

  String get chat { // "Chat"
    return Intl.message('Chat', name: 'chat');
  }

  String get profile { // "Perfil"
    return Intl.message('Profile', name: 'profile');
  }

  String get logInAndStart { // "Inicia sesión y comienza a cooperar"
    return Intl.message('Log in and start cooperating', name: 'logInAndStart');
  }

  String get logInGoogle { // "Inicia sesión con Google"
    return Intl.message('Log in with Google', name: 'logInGoogle');
  }

  String get errorLogIn { // "Error al iniciar sesión, pruebe de nuevo"
    return Intl.message('Log in error, please try again', name: 'errorLogIn');
  }

  String get editProfile { // "Editar perfil"
    return Intl.message('Edit profile', name: 'editProfile');
  }

  String get editImage { // "Editar image"
    return Intl.message('Edit image', name: 'editImage');
  }

  String get name { // "Nombre"
    return Intl.message('Name', name: 'name');
  }

  String get saveChanges { // "Guardar cambios"
    return Intl.message('Save changes', name: 'saveChanges');
  }

  String get openCamera { // "Abrir cámara"
    return Intl.message('Open camera', name: 'openCamera');
  }

  String get openGallery { // "Abrir galería"
    return Intl.message('Open gallery', name: 'openGallery');
  }

  String get cancel { // "Cancelar"
    return Intl.message('Cancel', name: 'cancel');
  }

  String get noChanges { // "No has realizado cambios"
    return Intl.message('There are no changes', name: 'noChanges');
  }

  String get sendFirstMessage { // "¡Envía el primer mensaje!"
    return Intl.message('Be the one to send the first message!', name: 'sendFirstMessage');
  }

  String get message { // "Mensaje"
    return Intl.message('Message', name: 'message');
  }

  String get askForHelp { // "Pedir ayuda"
    return Intl.message('Ask for help', name: 'askForHelp');
  }

  String get offerYourHelp { // "Ofrecer ayuda"
    return Intl.message('Offer your help', name: 'offerYourHelp');
  }

  String get title { // 'Título'
    return Intl.message('Title', name: 'title');
  }

  String get titleError { // "El título no puede estar vacío"
    return Intl.message('The title field can not be empty', name: 'titleError');
  }

  String get description { // 'Descripción'
    return Intl.message('Description', name: 'description');
  }

  String get descriptionError { // "La descripción no puede estar vacía"
    return Intl.message('The description field can not be empty', name: 'descriptionError');
  }

  String get location { // "Ubicación"
    return Intl.message('Location', name: 'location');
  }

  String get publish { // "Publicar"
    return Intl.message('Publish', name: 'publish');
  }

  String get myProfile { // "Mi perfil"
    return Intl.message('My profile', name: 'myProfile');
  }

  String zoomTooFar(int howMany) => Intl.plural( // "Te has alejado demasiado.\nHaz zoom para ver " + x + " puntos."
    howMany,
    zero: 'You have zoomed out too far. There are no points in this region.',
    one: 'You have zoomed out too far. Zoom in to see $howMany point.',
    other: 'You have zoomed out too far. Zoom in to see $howMany points.',
    args: [howMany],
    name: 'zoomTooFar',
  );

  String get noMessages { // "Aún no tienes ningún mensaje"
    return Intl.message('You haven\'t received a message yet', name: 'noMessages');
  }

  String get showQ { // "¿Mostrar?"
    return Intl.message('Show?', name: 'showQ');
  }

  String get logOut { // "Cerrar sesión"
    return Intl.message('Log out', name: 'logOut');
  }

  String get information { // "Información"
    return Intl.message('Information', name: 'information');
  }

  String get close { // "Cerrar"
    return Intl.message('Close', name: 'close');
  }

  String get sendMessage { // "Enviar mensaje"
    return Intl.message('Send message', name: 'sendMessage');
  }

  String get changeLightDarkMode { // "Cambiar modo día/noche"
    return Intl.message('Change light/dark mode', name: 'changeLightDarkMode');
  }

  String get changeLanguage { // "Cambiar idioma"
    return Intl.message('Change language', name: 'changeLanguage');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'pt'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
