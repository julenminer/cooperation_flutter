// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'Te has alejado demasiado. No hay puntos en esta región.', one: 'Te has alejado demasiado. Haz zoom para ver ${howMany} punto.', other: 'Te has alejado demasiado. Haz zoom para ver ${howMany} puntos.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "askForHelp" : MessageLookupByLibrary.simpleMessage("Pedir ayuda"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "chat" : MessageLookupByLibrary.simpleMessage("Chat"),
    "close" : MessageLookupByLibrary.simpleMessage("Cerrar"),
    "description" : MessageLookupByLibrary.simpleMessage("Descripción"),
    "descriptionError" : MessageLookupByLibrary.simpleMessage("La descripción no puede estar vacía"),
    "editImage" : MessageLookupByLibrary.simpleMessage("Editar imagen"),
    "editProfile" : MessageLookupByLibrary.simpleMessage("Editar perfil"),
    "errorLogIn" : MessageLookupByLibrary.simpleMessage("Error al iniciar sesión, pruebe de nuevo"),
    "help" : MessageLookupByLibrary.simpleMessage("Ayuda"),
    "helpOffer" : MessageLookupByLibrary.simpleMessage("Oferta de ayuda"),
    "information" : MessageLookupByLibrary.simpleMessage("Información"),
    "location" : MessageLookupByLibrary.simpleMessage("Ubicación"),
    "logInAndStart" : MessageLookupByLibrary.simpleMessage("Inicia sesión y comienza a cooperar"),
    "logInGoogle" : MessageLookupByLibrary.simpleMessage("Inicia sesión con Google"),
    "logOut" : MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "message" : MessageLookupByLibrary.simpleMessage("Mensaje"),
    "myProfile" : MessageLookupByLibrary.simpleMessage("Mi perfil"),
    "name" : MessageLookupByLibrary.simpleMessage("Nombre"),
    "noChanges" : MessageLookupByLibrary.simpleMessage("No has realizado cambios"),
    "noMessages" : MessageLookupByLibrary.simpleMessage("Aún no tienes ningún mensaje"),
    "offerYourHelp" : MessageLookupByLibrary.simpleMessage("Ofrecer ayuda"),
    "openCamera" : MessageLookupByLibrary.simpleMessage("Abrir cámara"),
    "openGallery" : MessageLookupByLibrary.simpleMessage("Abrir galería"),
    "profile" : MessageLookupByLibrary.simpleMessage("Perfil"),
    "publish" : MessageLookupByLibrary.simpleMessage("Publicar"),
    "saveChanges" : MessageLookupByLibrary.simpleMessage("Guardar cambios"),
    "sendFirstMessage" : MessageLookupByLibrary.simpleMessage("¡Envía el primer mensaje!"),
    "sendMessage" : MessageLookupByLibrary.simpleMessage("Enviar mensaje"),
    "showQ" : MessageLookupByLibrary.simpleMessage("¿Mostrar?"),
    "title" : MessageLookupByLibrary.simpleMessage("Título"),
    "titleError" : MessageLookupByLibrary.simpleMessage("El título no puede estar vacío"),
    "zoomTooFar" : m0
  };
}
