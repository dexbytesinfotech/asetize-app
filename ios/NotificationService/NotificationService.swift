import UserNotifications
import Foundation

class NotificationService: UNNotificationServiceExtension {

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        // Modify the notification content here...
//        if let bestAttemptContent = bestAttemptContent {
//            // Example of modifying the notification content
//            bestAttemptContent.title = "\(decodeUTF8Data("\(bestAttemptContent.title)".data(using: .utf8)!))"
//            bestAttemptContent.body = "\(bestAttemptContent.body.utf8)"
//            contentHandler(bestAttemptContent)
//        }

        if let bestAttemptContent = bestAttemptContent {
            // Example of modifying the notification content
            if let decodedTitle = decodeUTF8Data(bestAttemptContent.title.data(using: .utf8) ?? Data()) {
                bestAttemptContent.title = decodedTitle
            }

            // Directly setting body as it is already a String
            bestAttemptContent.body = bestAttemptContent.body

            contentHandler(bestAttemptContent)
        }
    }


    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    func decodeUTF8Data(_ data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }

    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
}

