enum ChatListStrings: String {
    case chatListTitle = "ChatListTitle"
}

extension ChatListStrings {
    var localizedString: String {
        LocalizationProvider.localizedString(forKey: rawValue)
    }
}
