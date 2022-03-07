

import Foundation

enum IntentListState<T>{
    case upToDate
    case listUpdated
    case deleteRequest(_ id:Int)
    case createRequest(_ element:T)
}


