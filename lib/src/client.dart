part of tmidart;

/// IRC Client for Twitch
class Client {
  final String _host = 'irc.twitch.tv';
  final int _port = 6667;
  String _nickname, _channel;
  Socket _socket;
  // Events
  Function(PrivMessage) _onPrivMessage;
  Function(ClearChat) _onClearChat;
  Function(UserNotice) _onUserNotice;
  Function(RoomState) _onRoomState;

  Function(PrivMessage) _onAction;


  Client(String nick, String channel) {
    _nickname = nick;
    _channel = '#$channel';
  }

  // connect the Client throught Socket
  void connect(authkey) {
    Socket.connect(_host, _port).then((socket) {
      _socket = socket;
      _socket.writeln(
          'CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership');
      _socket.writeln('PASS $authkey');
      _socket.writeln('NICK ${_nickname.toLowerCase()}');
      _socket.writeln('JOIN ${_channel.toLowerCase()}');
      print('\n [+] Connected on channel $_channel as $_nickname \n');
      _socket.listen(_onData);
    }).catchError((onError) => print(onError));
  }

  void disconnect() {
    _socket.destroy();
  }

  void _onData(data) {
    var msg = parseIrcMessage(String.fromCharCodes(data));

    switch (msg.command) {
      case 'PING':
        {
          _socket.writeln('PONG tmi.twitch.tv');
        }
        break;

      case '001':
        break;
      case '002':
        break;
      case '003':
        break;
      case '004':
        break;
      case '375':
        break;
      case '372':
        break;
      case '376':
        break;
      case '353':
        break;
      case '366':
        break;

      case 'JOIN':
        {
          print(msg.toString());
        }
        break;

      case 'PRIVMSG':
        {
          if (_onPrivMessage == null) break;
          _onPrivMessage(PrivMessage.fromMessage(msg));
        }
        break;

      case 'CLEARCHAT':
        {
          if (_onClearChat == null) break;
          _onClearChat(ClearChat.fromMessage(msg));
        }
        break;

      case 'USERNOTICE':
        {
          if (_onUserNotice == null) break;
          _onUserNotice(UserNotice.fromMessage(msg));
        }
        break;

      case 'ROOMSTATE':
        {
          if (_onRoomState == null) break;
          _onRoomState(RoomState.fromMessage(msg));
        }
        break;

      default:
        {
          print(msg.command);
          print(msg.raw);
        }
        break;
    }
  }
  
  // Commands
  void say(String msg) => _socket.write('PRIVMSG $_channel :$msg \r\n');

  void action(String message) => say('/me $message');

  void color(String color) => say('/color $color');

  void whisper(String username, String message) => say('/w $username $message');

  void deleteMessage(String id) => say('/delete $id');

  void timeout(String username, int seconds) => say('/timeout $username $seconds');

  void ban(String user, String reason) => say('/ban $user $reason');

  void unBan(String user) => say('/ban $user');

  void slow(int seconds) => say('/slow $seconds');

  void slowOff() => say('/slowoff');

  void followersOnly({int days, int hours, int minutes}){
    if(days != null){
      say('/followers ${days}d');
    } else if(hours != null){
      say('/followers ${hours}h');
    } else if(minutes != null){
      say('/followers ${minutes}m');
    } else {
      say('/followers');
    }
  }

  void followersOff() => say('/followersoff');

  void subscribersOnly() => say('/subscribers');

  void subscribersOff() => say('/subscribersoff');

  void clear() => say('/clear');

  void uniqueChat() => say('/Uniquechat');

  void uniqueChatOff() => say('/Uniquechatoff');

  void emoteOnly() => say('/emoteonly');

  void emoteOnlyOff() => say('/emoteonlyoff');

  void commercial([int seconds = 30]) => say('/commercial $seconds');

  void host(String channel) => say('/host $channel');

  void unHost() => say('/unhost');

  void mod(String username) => say('/mod $username');

  void unMod(String username) => say('/unmod $username');

  void vip(String username) => say('/vip $username');

  void unVip(String username) => say('/unvip $username');
 

  // Event setters
  void onPrivateMessage(Function(PrivMessage) callback) => _onPrivMessage = callback;

  void onClearChat(Function(ClearChat) callback) => _onClearChat = callback;

  void onUserNotice(Function(UserNotice) callback) => _onUserNotice = callback;

  void onRoomState(Function(RoomState) callback) => _onRoomState = callback;
}
