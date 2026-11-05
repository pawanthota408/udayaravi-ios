import SwiftUI

public struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    public let onLoginSuccess: () -> Void
    public let onSkip: () -> Void

    @State private var emailOrPhone: String = "honey@udayaravicreations.com"
    @State private var password: String = "admin123"
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showSignUpSheet: Bool = false

    // Sign up form
    @State private var regName: String = ""
    @State private var regEmail: String = ""
    @State private var regPhone: String = ""
    @State private var regPassword: String = ""

    public init(
        onLoginSuccess: @escaping () -> Void,
        onSkip: @escaping () -> Void
    ) {
        self.onLoginSuccess = onLoginSuccess
        self.onSkip = onSkip
    }

    public var body: some View {
        ZStack {
            // Background
            Color(red: 16/255, green: 16/255, blue: 18/255)
                .edgesIgnoringSafeArea(.all)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer().frame(height: 36)

                    // Brand Logo & Title
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.gold.opacity(0.15))
                                .frame(width: 80, height: 80)
                            Text("UR")
                                .font(.system(size: 32, weight: .black))
                                .foregroundColor(AppTheme.lightGold)
                        }

                        Text("UDAYARAVI")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(AppTheme.lightGold)
                            .tracking(2.0)

                        Text("CREATIONS")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(3.5)

                        Text("Heritage Handloom Sarees & Industrial Looms")
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                            .padding(.top, 2)
                    }

                    // Login Card
                    VStack(spacing: 16) {
                        Text("Sign In to Your Account")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if let err = errorMessage {
                            Text(err)
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.royalRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Email / Phone Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email or Mobile Number")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)

                            HStack(spacing: 10) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(AppTheme.gold)
                                    .font(.system(size: 14))

                                TextField("Enter Email or Mobile", text: $emailOrPhone)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .autocapitalization(.none)
                            }
                            .padding(12)
                            .background(Color(red: 28/255, green: 28/255, blue: 32/255))
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                        }

                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)

                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppTheme.gold)
                                    .font(.system(size: 14))

                                if isPasswordVisible {
                                    TextField("Enter Password", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                } else {
                                    SecureField("Enter Password", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }

                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 14))
                                }
                            }
                            .padding(12)
                            .background(Color(red: 28/255, green: 28/255, blue: 32/255))
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                        }

                        // Sign In Button
                        Button(action: handleSignIn) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                }
                                Text(isLoading ? "Signing in..." : "Sign In")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(AppTheme.gold)
                            .cornerRadius(6)
                        }
                        .disabled(isLoading)

                        // Create Account Link
                        Button(action: { showSignUpSheet = true }) {
                            Text("New to UdayaRavi? Create an Account")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppTheme.lightGold)
                        }
                    }
                    .padding(20)
                    .background(Color(red: 24/255, green: 24/255, blue: 27/255))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.gold.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    // Skip & Continue as Guest
                    Button(action: onSkip) {
                        Text("Continue as Guest / Explore Catalog →")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.top, 8)

                    Spacer().frame(height: 36)
                }
            }
        }
        .sheet(isPresented: $showSignUpSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Personal Details")) {
                        TextField("Full Name", text: $regName)
                        TextField("Email Address", text: $regEmail)
                            .autocapitalization(.none)
                        TextField("10-Digit Mobile", text: $regPhone)
                            .keyboardType(.phonePad)
                        SecureField("Choose Password", text: $regPassword)
                    }

                    Button(action: {
                        guard !regName.isEmpty else { return }
                        let newProfile = UserProfile(
                            id: "usr_\(Int.random(in: 1000...9999))",
                            name: regName,
                            email: regEmail.isEmpty ? "customer@udayaravicreations.com" : regEmail,
                            phone: regPhone.isEmpty ? "+91 98765 43210" : regPhone
                        )
                        userManager.login(user: newProfile)
                        showSignUpSheet = false
                        onLoginSuccess()
                    }) {
                        Text("Register & Start Shopping")
                            .font(.system(size: 14.5, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(AppTheme.flipkartBlue)
                            .cornerRadius(6)
                    }
                }
                .navigationTitle("Create Account")
                .navigationBarItems(trailing: Button("Cancel") { showSignUpSheet = false })
            }
        }
    }

    private func handleSignIn() {
        guard !emailOrPhone.isEmpty else {
            errorMessage = "Please enter your email or phone number"
            return
        }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
            let profile = UserProfile(
                id: "usr_001",
                name: emailOrPhone.contains("@") ? emailOrPhone.components(separatedBy: "@").first?.capitalized ?? "Customer" : "Honey Sharma",
                email: emailOrPhone.contains("@") ? emailOrPhone : "honey@udayaravicreations.com",
                phone: emailOrPhone.contains("@") ? "+91 98765 43210" : emailOrPhone
            )
            userManager.login(user: profile)
            onLoginSuccess()
        }
    }
}

