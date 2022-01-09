import 'package:dotenv/dotenv.dart' show load, env;
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

Future<void> main() async {
  load();
  final username = (await Telegram(env['BOT_TOKEN']!).getMe()).username;
  final teledart = TeleDart(Telegram(env['BOT_TOKEN']!), Event(username!));

  teledart.start();

  // create buttons
  final makeOrderButton = KeyboardButton(text: 'Зробити замовлення');
  final dishesButton = KeyboardButton(text: 'Страви');
  final drinksButton = KeyboardButton(text: 'Напої');
  final cleanButton = KeyboardButton(text: 'Очистити');

  ReplyKeyboardMarkup getReplyKeyboardMarkup(List<KeyboardButton> buttonsRow1,
      {List<KeyboardButton> buttonsRow2 = const [],
      List<KeyboardButton> buttonsRow3 = const []}) {
    return ReplyKeyboardMarkup(
      resize_keyboard: true,
      keyboard: [buttonsRow1, buttonsRow2, buttonsRow3],
    );
  }

  InlineKeyboardMarkup getInlineKeyboardMarkup(List<String> buttonsNames) {
    final buttons = buttonsNames
        .map((e) => [InlineKeyboardButton(text: e, callback_data: e)])
        .toList();

    return InlineKeyboardMarkup(inline_keyboard: [...buttons]);
  }

  teledart.onCommand('start').listen((message) {
    // send message to user
    teledart.telegram.sendMessage(
      message.chat.id,
      'Натисніть кнопку "Зробити замовлення"',
      reply_markup: getReplyKeyboardMarkup([makeOrderButton]),
    );
  });

  teledart
      .onMessage(keyword: RegExp('Зробити замовлення', caseSensitive: false))
      .listen((message) {
    teledart.telegram.sendMessage(message.chat.id, 'Виберіть з списку меню',
        reply_markup: getReplyKeyboardMarkup([dishesButton, drinksButton],
            buttonsRow2: [cleanButton]));
  });

  teledart
      .onMessage(keyword: RegExp('Страви', caseSensitive: false))
      .listen((message) {
    print(message.text);
    teledart.telegram.sendMessage(message.chat.id, 'Страви',
        // '/ColdSnacks - Холодні закуски. \n/Salads - Салати. \n/FirstCourses - Перші страви. \n/HotMeals - Гарячі страви. \n/Garnish - Гарніри. \n/BeerSnacks - Пивні закуски. \n/Desserts - Десерти.',
        reply_markup: getInlineKeyboardMarkup([
          'Холодні закуски.',
          'Салати.',
          'Перші страви.',
          'Гарячі страви.',
          'Гарніри.',
          'Пивні закуски.',
          'Десерти.',
        ]));
  });

  teledart.onCommand().listen((message) {
    // send message to user
    teledart.telegram.sendMessage(
      message.chat.id,
      message.text ?? 's',
      reply_markup: InlineKeyboardMarkup(inline_keyboard: [
        [InlineKeyboardButton(text: 'NSadas ', callback_data: 'sdaw')]
      ]),
    );
  });

  // // You can listen to messages like this
  // teledart
  //     .onMessage(
  //         entityType: 'bot_command',
  //         keyword: RegExp('fagot', caseSensitive: false))
  //     .listen((message) {
  //   print(message.text);
  //   teledart.telegram.sendMessage(message.chat.id, 'You fagot');
  // });
}
