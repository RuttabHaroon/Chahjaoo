
 import UIKit

class BackGroundClass: NSObject {

    func callPostService(url:String,parameters:NSDictionary){


        //print("url is===>\(url)")

        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)

        let session = URLSession.shared
        request.httpMethod = "POST"

        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else {
                //print("no data found: \(String(describing: error))")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                   // print("Response: \(json)")
                    self.mainResponse(result: json)
                } else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                   // print("Error could not parse JSON: \(String(describing: jsonStr))")
                    self.eroorResponse(result: jsonStr!)
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
               // print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                self.eroorResponse(result: jsonStr!)
            }
        }

        task.resume()
    }

    func mainResponse(result:NSDictionary){
       // delegate?.getResponse(result)
    }

    func eroorResponse(result:NSString){
        //delegate?.getErrorResponse(result)
    }
}
