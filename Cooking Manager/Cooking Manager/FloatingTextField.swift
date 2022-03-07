

import SwiftUI

struct FloatingTextField: View {
    var title:String
    @Binding var text:String
    init(_ title:String, text:Binding<String>){
        self._text = text
        self.title = title
    }
    var body: some View {
        VStack(alignment: .leading){
            if !text.isEmpty{
                Text(title).font(.caption)
                    .foregroundColor(.accentColor)
            }
            TextField(title, text: $text)
        }.animation(.default)
    }
}
struct FloatingValueField<F:ParseableFormatStyle> : View where F.FormatOutput == String {
    var title:String
    var value: Binding<F.FormatInput>
    var format : F
    
    
    init(_ title:String, value:Binding<F.FormatInput>,format:F){
        self.value = value
        self.title = title
        self.format = format
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title).font(.caption)
                    .foregroundColor(.accentColor)
            TextField(title, value: value ,format: format)
        }.animation(.default)
    }
}



