//
//  ContentView.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            vm.isShowingResetAlert.toggle()
                        }) {
                            Text("Reset")
                        }
                        Spacer()
                    }
                    Text("Shopping List")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                Divider()
                HStack {
                    Text("Expected: ")
                    Spacer()
                    Text(vm.getExSum())
                }
                .padding(.horizontal)
                HStack {
                    Text("Actual: ")
                    Spacer()
                    Text(vm.getAcSum())
                }
                .padding(.horizontal)
                HStack {
                    Text("Difference: ")
                    Spacer()
                    Text(vm.getDiff())
                }
                .padding(.horizontal)
                Divider()
                ZStack {
                    List {
                        ForEach(vm.items, id: \.id) { itm in
                            Button(action: {
                                vm.isShowingUpdateSheet.toggle()
                            }) {
                                ItemView(itm: itm)
                            }
                        }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                vm.isShowingAddSheet.toggle()
                            }) {
                                Text("+")
                                    .font(.system(.largeTitle))
                                    .frame(width: 77, height: 70)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 7)
                            }
                            .background(Color.green)
                            .cornerRadius(38.5)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3),
                                    radius: 3,
                                    x: 3,
                                    y: 3)
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
            .halfSheet(showSheet: $vm.isShowingAddSheet) {
                VStack{
                    Text("Hello iPeter")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Button {
                        vm.isShowingAddSheet.toggle()
                    } label: {
                        Text("Close From Sheet")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .ignoresSafeArea()
            } onEnd: {
                print("Dismissed")
            }
            //.onAppear(perform: vm.fetchAllItems)
//            .sheet(isPresented: $vm.isShowingAddSheet) {
//                VStack(alignment: .leading) {
//                    TextField("Item Name", text: $vm.newName)
//                    HStack {
//                        Text("Expected Price")
//                            .foregroundColor(.primary)
//                        TextField("Expected Price", value: $vm.newExpectedPrice, formatter: vm.formatter)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.numberPad)
//                            .foregroundColor(.primary)
//                    }
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            vm.addItem()
//                            vm.isShowingAddSheet.toggle()
//                        }) {
//                            Image(systemName: "arrow.up.circle")
//                        }
//                    }
//                }
//
//            }
//            .sheet(isPresented: $vm.isShowingUpdateSheet) {
//
//            }
//            .alert("Do you want to reset?", isPresented: $vm.isShowingResetAlert) {
//
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView, onEnd: @escaping ()->()) -> some View {
        
        // why we using overlay...
        // bcz if will automatically use the swiftui fame size only...
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        if showSheet {
            // presenting Modal view ....
            
            let sheetController = CustomHostingController(rootView: sheetView)
            
            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true)
        } else {
            // closing view when showSheet toggled again...
            uiViewController.dismiss(animated: true)
        }
    }
    
    // On Dismiss...
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}

// Custom UIHostingController for halfSheet....
class CustomHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        // setting presentation controller properties...
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            
            // to show grab portion...
            // presentationController.prefersGrabberVisible = true
        }
    }
}
