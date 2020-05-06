part of tmidart;

class Message {
  final String raw;
  final Map<String, dynamic> tags;
  final String prefix;
  final String command;
  final List params;

  Message({this.raw, this.tags, this.prefix, this.command, this.params});
  
  @override
  String toString() {
    return '${command} ${prefix} ${params} ${tags}';
  }

}

/// Sends a message to a channel.
class PrivMessage {
  /// Currently this is used only for subscriber, to indicate the exact number of months the user has been a subscriber. This number is finer grained than the version number in badges. For example, a user who has been a subscriber for 45 months would have a badge-info value of 45 but might have a badges version number for only 3 years.
  final int subscribeDuration;

  /// Hexadecimal RGB color code; the empty string if it is never set.
  final String color;

  /// The user’s display name, escaped as described in the IRCv3 spec. This is empty if it is never set.
  final String author;

  /// A unique ID for the message.
  final String id;

  /// The message
  final String content;

  /// True if the user has a moderator badge, otherwise, false.
  final bool isMod;

  /// The channel
  final String channel;

  /// The channel ID
  final String channelID;

  /// Timestamp when the server received the message.
  final int timestamp;

  /// The user’s ID.
  final String userID;

  PrivMessage.fromMessage(Message msg)
      : subscribeDuration = msg.tags['badge-info'].length != 0
            ? int.tryParse(msg.tags['badge-info'].split('/')[1])
            : null,
        color = msg.tags['color'],
        author = msg.tags['display-name'],
        id = msg.tags['id'],
        content = msg.params[1],
        isMod = msg.tags['mod'] == '1',
        channel = msg.params[0],
        channelID = msg.tags['room-id'],
        timestamp = int.tryParse(msg.tags['tmi-sent-ts']),
        userID = msg.tags['user-id'];
}

/// Purges all chat messages in a channel, or purges chat messages from a specific user (typically after a timeout or ban).
class ClearChat {
  /// (Optional) Duration of the timeout, in seconds. If null, the ban is permanent.
  final int duration;

  /// The channel
  final String channel;

  /// The user
  final String target;

  ClearChat.fromMessage(Message msg)
      : duration = msg.tags['ban-duration'] != null &&
                msg.tags['ban-duration'].length != 0
            ? int.tryParse(msg.tags['ban-duration'])
            : null,
        channel = msg.params[0],
        target = msg.params.length > 1 ? msg.params[1] : null;
}

/// Sends a notice to the user when any of the following events occurs:
///
/// • Subscription, resubscription, or gift subscription to a channel.
///
/// • Incoming raid to a channel. Raid is a Twitch tool that allows broadcasters to send their viewers to another channel, to help support and grow other members in the community.)
///
/// • Channel ritual. Many channels have special rituals to celebrate viewer milestones when they are shared. The rituals notice extends the sharing of these messages to other viewer milestones (initially, a new viewer chatting for the first time).
class UserNotice {
  /// The channel
  final String channel;
  
  /// Currently this is used only for subscriber, to indicate the exact number of months the user has been a subscriber. This number is finer grained than the version number in badges. For example, a user who has been a subscriber for 45 months would have a badge-info value of 45 but might have a badges version number for only 3 years.
  final int subscribeDuration;

  /// Comma-separated list of chat badges and the version of each badge (each in the format <badge>/<version>, such as admin/1). There are many valid badge values; e.g., admin, bits, broadcaster, global_mod, moderator, subscriber, staff, turbo. Many badges have only 1 version, but some badges have different versions (images), depending on how long you hold the badge status; e.g., subscriber.
  // final Map<String, dynamic> badges;
  /// Hexadecimal RGB color code; the empty string if it is never set.
  final String color;

  /// The user’s display name, escaped as described in the IRCv3 spec. This is empty if it is never set.
  final String displayName;

  /// The name of the user who sent the notice.
  final String login;

  /// A unique ID for the message.
  final String id;

  /// The message. This is empty if the user did not enter a message.
  final String message;

  /// True if the user has a moderator badge; otherwise, false.
  final bool isMod;

  /// The type of notice (not the ID). Valid values: sub, resub, subgift, anonsubgift, submysterygift, giftpaidupgrade, rewardgift, anongiftpaidupgrade, raid, unraid, ritual, bitsbadgetier.
  final String type;

  /// The message printed in chat along with this notice.
  final String systemMessage;

  /// The channel ID.
  final String channelID;

  /// Timestamp when the server received the message.
  final int timestamp;

  /// The user’s ID.
  final String userID;

  UserNotice.fromMessage(Message msg)
      : channel = msg.params[0],
        subscribeDuration = msg.tags['badge-info'].length != 0
            ? int.tryParse(msg.tags['badge-info'].split('/')[1])
            : null,
        // badges            = msg.tags['badges'],
        color = msg.tags['color'],
        displayName = msg.tags['display-name'],
        login = msg.tags['login'],
        type = msg.tags['msg-id'],
        channelID = msg.tags['room-id'],
        systemMessage = msg.tags['system-msg'].replaceAll('\\s', ' '),
        userID = msg.tags['user-id'],
        id = msg.tags['id'],
        isMod = msg.tags['mod'] == '1',
        timestamp = int.tryParse(msg.tags['tmi-sent-ts']),
        message = msg.tags['message'] ?? '';
}

/// Sends room-state data when a user joins a channel or a room setting is changed. For a join, the message contains all chat-room settings. For changes, only the relevant tag is sent.
class RoomState {
  /// The channel
  final String channel;

  /// Emote-only mode. If true, only emotes are allowed in chat.
  final bool isEmoteOnly;

  ///Followers-only mode. If true, controls which followers can chat. Valid values: false (disabled), true (all followers can chat).
  final bool isFollowersOnly;

  /// If followers-only mode, only users following for at least the specified number of minutes can chat.
  final int followersOnlySpec;

  /// R9K mode. If true, messages with more than 9 characters must be unique.
  final bool isR9K;

  /// The number of seconds a chatter without moderator privileges must wait between sending messages.
  final int slowDuration;

  /// Subscribers-only mode. If true, only subscribers and moderators can chat.
  final bool isSubOnly;

  RoomState.fromMessage(Message msg)
      : isEmoteOnly = msg.tags['emote-only'] == '1',
        channel = msg.params[0],
        isFollowersOnly = msg.tags['followers-only'] != '-1',
        followersOnlySpec = msg.tags['followers-only'] != '-1'
            ? int.tryParse(msg.tags['followers-only'])
            : 0,
        isR9K = msg.tags['emote-only'] == '1',
        slowDuration = int.tryParse(msg.tags['slow']),
        isSubOnly = msg.tags['subs-only'] == '1';
}

class Notice {
  final String message;
  final String channel;
  final String msgID;

  Notice.fromMessage(Message msg)
      : message = msg.params[1],
        channel = msg.params[0],
        msgID = msg.tags['msg-id'];

  @override
  String toString() => '$channel $message ID:$msgID';
}

class GlobalUserState {
  final int subscribeDuration;

  /// Comma-separated list of chat badges and the version of each badge (each in the format <badge>/<version>, such as admin/1). There are many valid badge values; e.g., admin, bits, broadcaster, global_mod, moderator, subscriber, staff, turbo. Many badges have only 1 version, but some badges have different versions (images), depending on how long you hold the badge status; e.g., subscriber.
  // final Map<String, dynamic> badges;
  /// Hexadecimal RGB color code; the empty string if it is never set.
  final String color;

  /// The user’s display name, escaped as described in the IRCv3 spec. This is empty if it is never set.
  final String displayName;

  /// The user’s ID.
  final String userID;

  GlobalUserState.fromMessage(Message msg)
      : subscribeDuration = msg.tags['badge-info'].length != 0
            ? int.tryParse(msg.tags['badge-info'].split('/')[1])
            : null,
        // badges            = msg.tags['badges'],
        // emotesSets        = msg.tags['emotes-sets'],
        color = msg.tags['color'],
        displayName = msg.tags['display-name'],
        userID = msg.tags['user-id'];

  @override
  String toString() => '$color $displayName : userid:$userID subscribe duration: $subscribeDuration';
}

class UserState {
  final int subscribeDuration;

  /// Comma-separated list of chat badges and the version of each badge (each in the format <badge>/<version>, such as admin/1). There are many valid badge values; e.g., admin, bits, broadcaster, global_mod, moderator, subscriber, staff, turbo. Many badges have only 1 version, but some badges have different versions (images), depending on how long you hold the badge status; e.g., subscriber.
  // final Map<String, dynamic> badges;
  /// Hexadecimal RGB color code; the empty string if it is never set.
  final String color;

  /// The user’s display name, escaped as described in the IRCv3 spec. This is empty if it is never set.
  final String displayName;

  /// True if the user has a moderator badge; otherwise, false.
  final bool isMod;

  UserState.fromMessage(Message msg)
      : subscribeDuration = msg.tags['badge-info'].length != 0
            ? int.tryParse(msg.tags['badge-info'].split('/')[1])
            : null,
        // badges            = msg.tags['badges'],
        // emotesSets        = msg.tags['emotes-sets'],
        color = msg.tags['color'],
        isMod = msg.tags['mod'] == '1',
        displayName = msg.tags['display-name'];

  @override
  String toString() => '$color $displayName : mod:$isMod subscribe duration: $subscribeDuration';
}
