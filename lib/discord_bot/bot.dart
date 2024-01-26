import 'package:apod/config/config.dart';
import 'package:apod/apod.dart';
import 'package:apod/models/log_function.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

void bot() {
  // Create Nyxx bot instance with necessary intents
  final bot = NyxxFactory.createNyxxWebsocket(
      Config.getDiscordToken(),
      GatewayIntents.allUnprivileged |
          GatewayIntents.allPrivileged |
          GatewayIntents.messageContent)
    ..registerPlugin(Logging());

  CommandsPlugin commands = CommandsPlugin(
    prefix: (message) => '>>',
    options: CommandsOptions(
      logErrors: true,
    ),
  );
  bot.registerPlugin(commands);

  // Listener for when the bot is ready
  bot.eventsWs.onReady.listen((event) {
    print("Ready!");
  });

  final ping = ChatCommand(
    'ping',
    'Ping the bot',
    (IChatContext context) => context.respond(MessageBuilder.content('Pong!')),
  );
  commands.addCommand(ping);

  bot.eventsWs.onSelfMention.listen((event) async {
    final content = event.message.content;
    if (content.startsWith('<')) {
      while (true) {
        try {
          await apod();
          var randomItem = (apodImages..shuffle()).first;
          DateTime dateTime = DateTime.parse(randomItem['date']);
          String? brDateFormat =
              '${dateTime.day}/${dateTime.month}/${dateTime.year}';
          await event.message.channel.sendMessage(
            MessageBuilder.embed(
              EmbedBuilder(
                title: randomItem['title'],
                description:
                    '${randomItem['description']}\n\nData: $brDateFormat',
                imageUrl: randomItem['url'],
                type: randomItem['type'],
              ),
            ),
          );
          apodImages.clear();
        } catch (e) {
          sendEmbedMessageErrorHandler(e, event, bot);
        }
        await Future.delayed(Duration(minutes: 10));
      }
    } else {
      try {
        await event.message.channel
            .sendMessage(MessageBuilder.content('Não entendi.'));
      } catch (e) {
        sendEmbedMessageErrorHandler(e, event, bot);
      }
    }
  });

  bot.connect();
}
