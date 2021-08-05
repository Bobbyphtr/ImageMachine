//
//  MachineDetailSwiftUI.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 31/07/21.
//

import SwiftUI

struct MachineDetailSwiftUI: View {
    
    @ObservedObject var machineModel : MachineDetailViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            Form(content: {
                Section(header: Text("Information")) {
                    HStack(content: {
                        Text("ID")
                        Spacer()
                        Text("\(machineModel.id)")
                    })
                    HStack(content: {
                        Text("Type")
                        Spacer()
                        Text("\(machineModel.type)")
                    })
                    HStack(content: {
                        Text("QR Code Number")
                        Spacer()
                        Text("\(machineModel.qrCodeNumber)")
                    })
                }
                Section(header: Text("Last Maintenance")) {
                    DatePicker("Date Time", selection: $machineModel.maintenanceDate, in: ...machineModel.maintenanceDate)
                        .disabled(true)
                        .datePickerStyle(CompactDatePickerStyle())
                }
                
                Section(header: Text("Images")) {
                    HStack {
                        Spacer()
                        Button("Pick Machine Images") {
                            machineModel.showImagePicker()
                        }
                        .font(Font.system(size: 16, weight: .medium, design: .rounded))
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8.0)
                        Spacer()
                    }.padding()
                    
                    LazyVGrid(columns: columns, content: {
                        ForEach(0..<machineModel.thumbnailImages.value.count, id: \.self) { index in
                            ImageCell(image: machineModel.thumbnailImages.value[index], index: index)
                                .onTapGesture {
                                    machineModel.showImage(index: index)
                                }
                        }
                    })
                    .padding()
                }
                
                Button("Delete Machine") {
                    machineModel.deleteMachine()
                }.foregroundColor(.red)
                
            }).listStyle(GroupedListStyle())
        }
        .navigationBarTitle(
            "\(machineModel.name)",
            displayMode: .large
        )
        .navigationViewStyle(DefaultNavigationViewStyle())
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    machineModel.editMachine()
                }, label: {
                    Image(uiImage: UIImage(systemName: "square.and.pencil")!)
                })
            }
        })
        .onAppear {
            machineModel.updateMachine()
        }
        Spacer()
    }
}
