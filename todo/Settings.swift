//
//  Settings.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/30/24.
//

import SwiftUI

struct SettingsSheet: View {
    @Binding var selectedBGImage: String
    @Binding var selectedGradient: GradientOption?
    @Binding var useImageBG: Bool

    private let images = ["bg1", "bg2", "bg3", "bg4", "bg5", "bg6", "bg7", "bg8", "bg9", "bg10"]
    private let gradients: [GradientOption] = [
        GradientOption(name: "Twilight", gradient: Gradient(colors: [Color(hex: "#4b6cb7"), Color(hex: "#182848")])), // Deep Blue to Navy
        GradientOption(name: "Citrus Splash", gradient: Gradient(colors: [Color(hex: "#fceabb"), Color(hex: "#f8b500")])), // Lemon Yellow to Orange
        GradientOption(name: "Candy Floss", gradient: Gradient(colors: [Color(hex: "#f78ca0"), Color(hex: "#f9748f")])), // Pink to Soft Red
        GradientOption(name: "Skyline", gradient: Gradient(colors: [Color(hex: "#1e3c72"), Color(hex: "#2a5298")])), // Navy to Azure
        GradientOption(name: "Mojito", gradient: Gradient(colors: [Color(hex: "#76b852"), Color(hex: "#8dc26f")])), // Lime Green to Fresh Green
        GradientOption(name: "Peachy", gradient: Gradient(colors: [Color(hex: "#ed4264"), Color(hex: "#ffedbc")])), // Deep Pink to Peach
        GradientOption(name: "Tropical Paradise", gradient: Gradient(colors: [Color(hex: "#29ffc6"), Color(hex: "#20e3b2")])), // Turquoise to Mint Green
        GradientOption(name: "Velvet Night", gradient: Gradient(colors: [Color(hex: "#141e30"), Color(hex: "#243b55")])), // Midnight Blue to Steel Blue
        GradientOption(name: "Amber Glow", gradient: Gradient(colors: [Color(hex: "#ff7e5f"), Color(hex: "#feb47b")])), // Coral to Amber
        GradientOption(name: "Galaxy", gradient: Gradient(colors: [Color(hex: "#654ea3"), Color(hex: "#eaafc8")])), // Purple to Soft Pink
    ]

    var body: some View {
        NavigationView {
            VStack {
                Toggle("Image Background", isOn: $useImageBG)
                    .padding()

                if useImageBG {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(images, id: \.self) { image in
                                Button(action: {
                                    selectedBGImage = image
                                    selectedGradient = nil
                                }) {
                                    Image(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    selectedBGImage == image ? Color.indigo : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                }
                                .cornerRadius(10)
                                .padding(4)
                            }
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(gradients) { gradientOption in
                                Button(action: {
                                    selectedGradient = gradientOption
                                    selectedBGImage = ""
                                }) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(LinearGradient(
                                            gradient: gradientOption.gradient,
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ))
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    selectedGradient == gradientOption ? Color.indigo : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                }
                                .padding(4)
                            }
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("Customize")
            .navigationBarItems(trailing: Button("Done") {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
            })
        }
    }
}

struct GradientOption: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let gradient: Gradient

    // Custom Equatable implementation
    static func == (lhs: GradientOption, rhs: GradientOption) -> Bool {
        return lhs.name == rhs.name // Compare based on the name
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
