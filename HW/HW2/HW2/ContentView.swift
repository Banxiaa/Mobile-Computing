//
//  ContentView.swift
//  HW2
//
//  Created by Bo Fu on 10/20/24.
//

import SwiftUI
import PhotosUI
import Photos

struct ContentView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isPhotoPickerPresented = false
    @State private var defaultImage = UIImage(named: "Default") // Default image
    @State private var photoPickerItem: PhotosPickerItem?
    @AppStorage("themePreference") private var themePreference: Int = 0
    @State private var isDarkMode: Bool = false

    var body: some View {
        VStack {
            // Display selected image or default image
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
            } else {
                Image(uiImage: defaultImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
            }
            // Use PhotosPicker to select a photo
            PhotosPicker("Select Image",
                         selection: $photoPickerItem,
                         matching: .images)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .onChange(of: photoPickerItem) {
                Task{
                    //load item
                    if let data = try? await photoPickerItem?.loadTransferable(type: Data.self)
                    {
                        selectedImage = UIImage(data: data)
                    }
                }
            }
            
            // Use PHPickerViewController to select a photo
            Button(action: {
                isPhotoPickerPresented = true
            }) {
                Text("Another Way to Select Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            //Use UIImageWriteToSavedPhotosAlbum to save a photo
            Button(action: {
                if let imageToSave = selectedImage {
                    saveImageToPhotoAlbum(imageToSave)
                }
                else{
                    saveImageToPhotoAlbum(defaultImage!)
                }
            }) {
                Text("Save Image to Photo Library")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            //change themes and save it to AppStorage
            Button(action: {
                toggleTheme()
            }) {
                Text("Toggle Theme")
                    .padding()
                    .background(isDarkMode ? Color.white : Color.black)
                    .foregroundColor(isDarkMode ? Color.black : Color.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(){
            //when appear, load themePreference and change theme
            updateTheme()
        }
        .sheet(isPresented: $isPhotoPickerPresented) {
            //when click the button, open photoPicker view
            PhotoPicker(selectedImage: $selectedImage)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // save a photo to Album
    func saveImageToPhotoAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    private func toggleTheme(){
        //change themePreference when click button
        switch themePreference {
        case 1:
            themePreference = 2
        case 2:
            themePreference = 1
        default:
            themePreference = 2
        }
        updateTheme()
    }
    
    private func updateTheme(){
        //change theme
        switch themePreference{
        case 1:
            isDarkMode = false
        case 2:
            isDarkMode = true
        default:
            isDarkMode = false
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    //use UIKit controller to select image and bind it to swiftUI
    //get variable from parent view
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // do not update ui
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if let firstResult = results.first {
                firstResult.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}

