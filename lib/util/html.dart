import 'package:html/parser.dart';

class Html{
  static String fromHtml(String string) {
    return parse(string).body.text;
  }


}