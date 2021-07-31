//
//  MachineDetailSwiftUI.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 31/07/21.
//

import SwiftUI

struct MachineDetailSwiftUI: View {
    
    @State private var maintenanceDate : Date = Date()
//    {
//        get {
//            let date = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd MMMM yyyy HH:mm"
//            return formatter.string(from: date)
//        }
//    }
    
    @State private var id : String = "123456789"
    @State private var type : String = "this is a type"
    @State private var qrCodeNumber : String = "987654321"
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView(content: {
            HStack(alignment: .center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil, content: {
                VStack {
                    Form(content: {
                        Section(header: Text("Information")) {
                            HStack(content: {
                                Text("ID")
                                Spacer()
                                Text("\(id)")
                            })
                            HStack(content: {
                                Text("Type")
                                Spacer()
                                Text("\(type)")
                            })
                            HStack(content: {
                                Text("QR Code Number")
                                Spacer()
                                Text("\(qrCodeNumber)")
                            })
                        }
                        
                        Section(header: Text("Last Maintenance")) {
                            DatePicker("Date Time", selection: $maintenanceDate, in: ...Date())
                                .disabled(true)
                                .datePickerStyle(CompactDatePickerStyle())
                        }
                        
                        Section(header: Text("Images")) {
                            HStack {
                                Spacer()
                                Button("Pick Machine Images") {
                                    print("Pick Images")
                                }
                                .font(Font.system(size: 16, weight: .medium, design: .rounded))
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8.0)
                                Spacer()
                            }.padding()
                            
                            LazyVGrid(columns: columns, content: {
                                ForEach(0...20, id: \.self) { _ in
                                    Color.orange.frame(width: 70, height: 70)
                                }
                            })
                            .padding()
                            
                        }
                        
                    }).listStyle(GroupedListStyle())
                }
                Spacer()
            })
            .navigationTitle("Machine 1")
            .navigationViewStyle(DefaultNavigationViewStyle())
            
        })
    }
    
    
}


struct MachineDetailSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        MachineDetailSwiftUI()
    }
}
