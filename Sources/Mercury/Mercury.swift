import Foundation

open class Mercury {
    
    static public func parse(_ resource: URL, withFormat format: ContentType = .html, completion: @escaping (_ result: [String: Any]) -> Void) {
        let currentFile = URL(fileURLWithPath: #file)
        let pwd = currentFile.deletingLastPathComponent()
        let nodeURL = pwd.appendingPathComponent("node")
        let mercuryCLIURL = pwd.appendingPathComponent("cli.js")
        DispatchQueue.global(qos: .userInitiated).async {
            var output = [String: Any]()
            let prototypeString = self.shell("\(nodeURL.path) \(mercuryCLIURL.path) \(resource.absoluteString) --format=\(format.rawValue)")
            let data = Data(prototypeString.utf8)
            do {
                // To make sure this JSON is in the format we expect.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    output = json
                }
                DispatchQueue.main.async {
                    completion(output)
                }
            } catch let error as NSError {
                print("Mercury failed to load: \(error.localizedDescription)")
                completion([:])
            }
        }
    }
    
    class func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    public enum ContentType: String {
        case html = "html"
        case markdown = "markdown"
        case text = "text"
    }
    
}
