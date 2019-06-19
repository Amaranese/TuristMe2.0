
import Foundation

class Site{
    
    var title : String
    var description : String
    var since : Date
    var until : Date
    var x_coordinate : Double
    var y_coordinate : Double
    
    
    init(title : String, since : Date, until : Date, description : String, x_coordinate : Double, y_coordinate : Double) {
        self.title = title
        self.description = description
        self.since = since
        self.until = until
        self.x_coordinate = x_coordinate
        self.y_coordinate = y_coordinate
    }
    
    init(title : String, since : String, until : String, description : String, x_coordinate : Double, y_coordinate : Double) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"

        self.title = title
        self.description = description
        self.since = dateFormat.date(from: since)!
        self.until = dateFormat.date(from: until)!
        self.x_coordinate = x_coordinate
        self.y_coordinate = y_coordinate
    }
}
