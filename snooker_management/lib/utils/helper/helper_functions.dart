String getPlayersList(List<String>? playersName) {
  // Join player names with a comma
  String players = playersName!.join(", ");

  // Truncate the list if it exceeds 16 characters
  if (players.length > 50) {
    return "${players.substring(0, 50)}...";
  }
  return players;
}
