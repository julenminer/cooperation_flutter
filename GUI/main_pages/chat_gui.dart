import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatGUI extends StatefulWidget {
  @override
  _ChatGUIState createState() => _ChatGUIState();
}

class _ChatGUIState extends State<ChatGUI> {
  String creatorUid = "";
  String title = "Título";
  String description =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper neque nec metus euismod, a bibendum turpis sagittis. In aliquet, ipsum nec interdum varius, leo urna eleifend felis, accumsan pharetra justo risus quis dui. Sed non semper nulla. Nunc sed nibh quis diam sollicitudin efficitur. Nullam dictum suscipit tristique. Phasellus vel est nisi. Integer ut lacinia tellus. Pellentesque pretium laoreet velit id convallis. Duis laoreet nisl non mauris sagittis, vel viverra libero vulputate. Aliquam faucibus quis lectus vitae dapibus. Curabitur congue diam euismod nulla vestibulum, eu euismod nisi egestas.  Nulla efficitur, dolor vitae faucibus bibendum, diam mauris aliquam nisl, a bibendum diam nunc sed purus. Nullam gravida sem nec nisl feugiat, eu rhoncus nibh bibendum. Phasellus venenatis nisl mi, at vehicula dolor condimentum sed. Nam bibendum ornare ligula vitae elementum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; In a ipsum orci. Proin suscipit lectus eget dui vestibulum accumsan. Nullam eleifend diam ut augue tristique, vitae tincidunt dolor venenatis. Cras porta finibus tincidunt. Donec non orci felis. Phasellus et pellentesque ligula. Fusce felis nisl, ullamcorper sit amet libero et, convallis ullamcorper elit. Integer ac ultricies augue. Morbi et tortor ut velit pharetra imperdiet.  Duis ut fermentum erat, aliquet finibus odio. Nulla maximus sagittis eros sed mattis. Cras condimentum porttitor elementum. Duis tincidunt arcu hendrerit sodales dapibus. Fusce ipsum mauris, commodo quis nisi sit amet, finibus rutrum sapien. Suspendisse convallis gravida purus, eget pellentesque mauris laoreet faucibus. Phasellus vel viverra arcu, at venenatis odio. Nam sit amet sem sit amet neque gravida luctus in a velit. Ut et nibh vel purus auctor imperdiet non at urna. Quisque nec scelerisque leo, eu pretium felis. Curabitur a mauris nec nisi sodales tempus. Etiam gravida eget leo vitae vehicula. Cras eget malesuada quam. Suspendisse rhoncus justo dapibus tellus viverra, in aliquam metus faucibus. Aenean aliquam lectus vel porta bibendum. Suspendisse finibus, lorem at condimentum imperdiet, quam diam feugiat risus, sed mollis tellus orci eget dolor. ";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Aquí habrá un chat"),
      ),
    );
  }
}
