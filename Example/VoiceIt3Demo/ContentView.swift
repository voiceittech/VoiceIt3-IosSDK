import SwiftUI

struct ContentView: View {
    @StateObject private var vm = VoiceItViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#FBC132"))
                        Text("VoiceIt API 3.0")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("Biometric Verification Demo")
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#919EAB"))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)

                    // Credentials
                    VStack(spacing: 12) {
                        DarkTextField(label: "API Key", text: $vm.apiKey, icon: "info.circle.fill")
                        DarkTextField(label: "API Token", text: $vm.apiToken, icon: "lock.fill", isSecure: true)
                        DarkTextField(label: "User ID", text: $vm.userId, icon: "person.fill")

                        // Phrase - separate label above field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Phrase")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#919EAB"))
                            TextField("", text: $vm.phrase)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color(hex: "#38424F"))
                                .cornerRadius(8)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }

                        // Language picker - separate row
                        HStack {
                            Picker("", selection: $vm.contentLanguage) {
                                Text("en-US").tag("en-US")
                                Text("es-ES").tag("es-ES")
                                Text("no-STT").tag("no-STT")
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(hex: "#38424F"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                    Divider()
                        .background(Color(hex: "#38424F"))

                    // Enrollment
                    VStack(spacing: 16) {
                        Text("Enrollment")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#919EAB"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        ActionButton(title: "Voice Enrollment", icon: "waveform", color: Color(hex: "#505050")) {
                            vm.startVoiceEnrollment()
                        }
                        ActionButton(title: "Face Enrollment", icon: "faceid", color: Color(hex: "#505050")) {
                            vm.startFaceEnrollment()
                        }
                        ActionButton(title: "Video Enrollment", icon: "video.fill", color: Color(hex: "#505050")) {
                            vm.startVideoEnrollment()
                        }

                        Text("Verification")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#919EAB"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)

                        ActionButton(title: "Voice Verification", icon: "waveform", color: Color(hex: "#FBC132")) {
                            vm.startVoiceVerification()
                        }
                        ActionButton(title: "Face Verification", icon: "faceid", color: Color(hex: "#FBC132")) {
                            vm.startFaceVerification()
                        }
                        ActionButton(title: "Video Verification", icon: "video.fill", color: Color(hex: "#FBC132")) {
                            vm.startVideoVerification()
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .background(Color(hex: "#212B36"))
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .alert("Result", isPresented: $vm.showAlert) {
                Button("OK") {}
            } message: {
                Text(vm.alertMessage)
            }
        }
    }
}

struct DarkTextField: View {
    let label: String
    @Binding var text: String
    let icon: String
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#FBC132"))
                .frame(width: 20)
            if isSecure {
                SecureField(label, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(label, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding(12)
        .background(Color(hex: "#38424F"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "#FBC132").opacity(0.3), lineWidth: 1)
        )
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(color)
            .cornerRadius(12)
        }
        .padding(.horizontal, 24)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

#Preview {
    ContentView()
}
