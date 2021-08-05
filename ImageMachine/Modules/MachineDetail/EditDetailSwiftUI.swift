//
//  EditDetailSwiftUI.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 02/08/21.
//

import SwiftUI

struct EditDetailSwiftUI: View {
    
    @ObservedObject var viewModel : EditMachineViewModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("INFORMATION")) {
                    TextField("Name", text: $viewModel.currentName)
                    TextField("Type", text: $viewModel.currentType)
                }
                
                Section(header: Text("LAST MAINTENANCE")) {
                    DatePicker("Date Time", selection: $viewModel.currentTime)
                        .datePickerStyle(DefaultDatePickerStyle())
                }
                
            }
        }
        .navigationBarTitle("Edit")
        .toolbar(content: {
            Button("Save") {
                viewModel.saveInformationData()
            }
        })
        
    }
}

//struct EditDetailSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//      EditDetailSwiftUI()
//    }
//}
