//
//  AddMemoryView.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 30.11.2025.
//

import SwiftUI
import PhotosUI
import AVFoundation
import Photos

extension UIColor {
    convenience init(_ color: Color) {
        let components = color.cgColor?.components ?? [1, 1, 1, 1]
        self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}

struct WeatherMood {
    let id: Int
    let emoji: String
    let text: String
}

struct AddMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var memoryManager = MemoryManager.shared
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceTypeAlert = false
    @State private var selectedWeather: Int?
    @State private var whatHappened: String = ""
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
    private let weatherMoods: [WeatherMood] = [
        WeatherMood(id: 1, emoji: "emoji_1", text: "Clear — joy, clarity"),
        WeatherMood(id: 2, emoji: "emoji_2", text: "Rain — sadness, reflection"),
        WeatherMood(id: 3, emoji: "emoji_3", text: "Rainbow — miracle, inspiration"),
        WeatherMood(id: 4, emoji: "emoji_4", text: "Storm — chaos, stress"),
        WeatherMood(id: 5, emoji: "emoji_5", text: "Fog — confusion, uncertainty"),
        WeatherMood(id: 6, emoji: "emoji_6", text: "Thunderstorm — anger, tension"),
        WeatherMood(id: 7, emoji: "emoji_7", text: "Light wind — calm, ease"),
        WeatherMood(id: 8, emoji: "emoji_8", text: "Snowstorm — isolation, inner cold"),
        WeatherMood(id: 9, emoji: "emoji_9", text: "Through the clouds — hope"),
        WeatherMood(id: 10, emoji: "emoji_10", text: "Moonlit night — dreaminess, intuition")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: screenHeight * 0.002) {
                    // Back button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.3)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.bottom, screenHeight * 0.02)
                    
                    // Photo frame
                    Button(action: {
                        showSourceTypeAlert = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: screenHeight * 0.23)
                                .mask(
                                    Image("addPhotoFrame")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: screenHeight * 0.23)
                                )
                        } else {
                            Image("addPhotoFrame")
                                .resizable()
                                .scaledToFit()
                                .frame(height: screenHeight*0.23)
                        }
                    }
                    
                    // Select "weather" title
                    HStack {
                        Text("Select \"weather\":")
                            .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                            .foregroundColor(Color("text_2Color"))
                        Spacer()
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.vertical)
                    
                    // Weather mood grid (2 rows x 5 columns)
                    VStack(spacing: screenHeight * 0.015) {
                        // First row
                        HStack(spacing: screenWidth * 0.02) {
                            ForEach(weatherMoods[0..<5], id: \.id) { mood in
                                WeatherMoodItem(
                                    mood: mood,
                                    isSelected: selectedWeather == mood.id,
                                    onTap: {
                                        selectedWeather = mood.id
                                    }
                                )
                            }
                        }
                        
                        // Second row
                        HStack(spacing: screenWidth * 0.02) {
                            ForEach(weatherMoods[5..<10], id: \.id) { mood in
                                WeatherMoodItem(
                                    mood: mood,
                                    isSelected: selectedWeather == mood.id,
                                    onTap: {
                                        selectedWeather = mood.id
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    
                    // What happened? title
                    HStack {
                        Text("What happened?")
                            .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                            .foregroundColor(Color("text_2Color"))
                        Spacer()
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    
                    // Text input frame
                    ZStack {
                        Image("whatHappendFrame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.9)
                        
                        ZStack(alignment: .topLeading) {
                            if whatHappened.isEmpty {
                                Text("Fill in (up to 100 characters)")
                                    .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                    .foregroundColor(Color("text_2Color").opacity(0.5))
                                    .padding(.top, screenHeight * 0.04)
                                    .padding(.leading, screenWidth * 0.08)
                            }
                            
                            CustomTextEditor(
                                text: $whatHappened,
                                font: UIFont(name: "Poppins-Regular", size: screenHeight * 0.018) ?? UIFont.systemFont(ofSize: screenHeight * 0.018),
                                textColor: .white
                            )
                            .frame(width: screenWidth * 0.75, height: screenHeight * 0.15)
                            .padding(.top, screenHeight * 0.03)
                            .onChange(of: whatHappened) { newValue in
                                if newValue.count > 100 {
                                    whatHappened = String(newValue.prefix(100))
                                }
                            }
                        }
                    }
                    
                    // Save button
                    Button(action: {
                        saveMemory()
                    }) {
                        Image("saveButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.9)
                            .opacity((selectedImage != nil && selectedWeather != nil) ? 1.0 : 0.5)
                    }
                    .disabled(selectedImage == nil || selectedWeather == nil)
                    .padding(.bottom, screenHeight * 0.02)
            }
        }
        .alert("Choose Photo Source", isPresented: $showSourceTypeAlert) {
            Button("Camera") {
                requestCameraPermission()
            }
            Button("Photo Library") {
                requestPhotoLibraryPermission()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select where you want to get the photo from")
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imageSourceType)
        }
        .alert("Validation", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
    }
    
    // MARK: - Permission Functions
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    imageSourceType = .camera
                    showImagePicker = true
                } else {
                    validationMessage = "Camera access denied. Please enable in Settings."
                    showValidationAlert = true
                }
            }
        }
    }
    
    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    imageSourceType = .photoLibrary
                    showImagePicker = true
                default:
                    validationMessage = "Photo Library access denied. Please enable in Settings."
                    showValidationAlert = true
                }
            }
        }
    }
    
    // MARK: - Save Memory Function
    private func saveMemory() {
        // Validation
        guard selectedImage != nil else {
            validationMessage = "Please add a photo"
            showValidationAlert = true
            return
        }
        
        guard let weatherId = selectedWeather else {
            validationMessage = "Please select a weather mood"
            showValidationAlert = true
            return
        }
        
        if whatHappened.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationMessage = "Please describe what happened"
            showValidationAlert = true
            return
        }
        
        // Save memory
        memoryManager.saveMemory(
            photo: selectedImage,
            weatherMoodId: weatherId,
            whatHappened: whatHappened
        )
        
        // Dismiss view and return to Today
        dismiss()
    }
}

// MARK: - Weather Mood Item
struct WeatherMoodItem: View {
    let mood: WeatherMood
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Image("weatherFrame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("text_1Color"), lineWidth: isSelected ? 5 : 0)
                    )
                
                VStack(spacing: screenHeight * 0.003) {
                    Image(mood.emoji)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.1)
                    
                    ZStack {
                        Image("weatherTextFrame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.14)
                        
                        Text(mood.text)
                            .font(.custom("Poppins-Regular", size: screenHeight * 0.007))
                            .foregroundColor(Color("text_2Color"))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .frame(width: screenWidth * 0.12)
                    }
                }
            }
        }
    }
}

// MARK: - Custom Text Editor
struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont = .systemFont(ofSize: 16)
    var textColor: UIColor = .white
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.textColor = textColor
        textView.font = font
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.textColor = textColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    AddMemoryView()
}

