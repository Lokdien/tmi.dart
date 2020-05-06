part of tmidart;

Message parseIrcMessage(data) {
  var position = 0;
  var space = 0;

  var tags = <String, dynamic>{};
  var prefix;
  var command;
  var params = [];

  if (data.codeUnitAt(0) == 64) {
    space = data.indexOf(' ');

    if (space == -1) return null;

    var rawTags = data.substring(1, space).split(';');

    for (var tag in rawTags) {
      tags[tag.split('=')[0]] =
          tag.split('=').length > 1 ? tag.split('=')[1] : true;
    }
    position = space + 1;
  }

  while (data.codeUnitAt(position) == 32) {
    position++;
  }

  if (data.codeUnitAt(position) == 58) {
    space = data.indexOf(' ', position);

    if (space == -1) return null;

    prefix = data.substring(position + 1, space);
    position = space + 1;

    while (data.codeUnitAt(position) == 32) {
      position++;
    }
  }

  space = data.indexOf(' ', position);

  if (space == -1) {
    if (data.length > position) {
      command = data.substring(position);

      return Message(
          command: command, params: [], prefix: prefix, raw: data, tags: tags);
    }
  }

  command = data.substring(position, space);
  position = space + 1;

  while (data.codeUnitAt(position) == 32) {
    position++;
  }

  while (position < data.length) {
    space = data.indexOf(' ', position);

    if (data.codeUnitAt(position) == 58) {
      params.add(data.substring(position + 1));
      break;
    }

    if (space != -1) {
      params.add(data.substring(position, space));
      position = space + 1;

      while (data.codeUnitAt(position) == 32) {
        position++;
      }

      continue;
    }

    if (space == -1) {
      params.add(data.substring(position));
      break;
    }
  }

  return Message(
      command: command, params: params, prefix: prefix, raw: data, tags: tags);
}
