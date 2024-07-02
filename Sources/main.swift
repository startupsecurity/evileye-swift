import Foundation
import Vision

func recognizeTextInImage(url: URL) {
    if #available(macOS 10.15, *) {
        let requestHandler = VNImageRequestHandler(url: url, options: [:])
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                print("\(topCandidate.string)")
            }
        }

        textRecognitionRequest.recognitionLevel = .accurate

        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Failed to perform text recognition: \(error.localizedDescription)")
        }
    } else {
        print("Text recognition requires macOS 10.15 or newer.")
    }
}

func main() {
    guard CommandLine.arguments.count > 1 else {
        print("Usage: TextRecognitionCLI <image_path>")
        return
    }
    
    let imagePath = CommandLine.arguments[1]
    let imageUrl = URL(fileURLWithPath: imagePath)

    recognizeTextInImage(url: imageUrl)
}

main()