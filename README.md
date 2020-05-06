# TMI.DART

## Example
```dart
import 'package:tmidart/tmidart.dart';
void main() {
  var client = Client('<botname>', '<channel>');
  client.connect('<TOKEN>');

  client.onPrivateMessage((PrivMessage message) {
    if(message.content.startsWith('!ping')){
      client.say('@${message.author} Pong !');
    }
  });

  client.onRoomState((RoomState roomState) {
    print(roomState);
  });

  client.onUserNotice((UserNotice notice){
    print(notice.toString());
  });

  client.onClearChat((ClearChat clearchat){
    print(clearchat);
  });
}
```