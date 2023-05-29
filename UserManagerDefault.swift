final class UserManagerDefault: UserManager {
    private let credentialsStore: CredentialsStore
    
    private var signInQuery: SigninQuery?
    public var userPublished: Published<User?> { _user }
    public var userPublisher: Published<User?>.Publisher { $user }
    @Published var user: User?
    
    init(credentialsStore: CredentialsStore) {
        self.credentialsStore = credentialsStore
    }
    
    func signIn(
        _ user: String,
        withPassword password: String,
        onSuccess: @escaping () -> Void,
        onError: @escaping (CCError) -> Void) {
            guard self.user == nil else { return }
            
            signInQuery = SigninQuery(
                params: .init(email: user, password: password),
                authApi: AuthApiDefault(accessTokenProvider: AccessTokenProviderDefault(credentialsStore: credentialsStore)),
                onSuccess: { [unowned self] result in
                    self.store(
                        accessToken: result.accessToken,
                        refreshToken: result.refreshToken,
                        userId: result.userId,
                        userEmail: result.userEmail,
                        roles: result.roles
                    )
                    onSuccess()
                },
                onError: { error in
                    onError(error)
                }
            )
            signInQuery?.execute(errorHandler: { _ in })
    }
    
    func signOut() {
        
    }
    
    func refreshToekn(
        onSuccess: @escaping () -> Void,
        onError: @escaping (CCError) -> Void) {
            Task {
                guard let refreshToken = try? await credentialsStore.getRefreshToken() else {
                    return
                }
                guard let user else {
                    onError(CCError.api(error: .unauthorized))
                    return
                }
                
                RefreshTokenQuery(
                    params: .init(userId: user.id.uuidString, refreshToken: refreshToken),
                    authApi: AuthApiDefault(accessTokenProvider: AccessTokenProviderDefault(credentialsStore: credentialsStore)),
                    onSuccess: { [unowned self] result in
                        self.store(
                            accessToken: result.accessToken,
                            refreshToken: result.refreshToken,
                            userId: result.userId,
                            userEmail: result.userEmail,
                            roles: result.roles
                        )
                        onSuccess()
                    },
                    onError: { error in
                        onError(error)
                    }
                )
                .execute(errorHandler: { _ in })
            }
    }
    
    func store(
        accessToken: String,
        refreshToken: String,
        userId: UUID,
        userEmail: String,
        roles: [UserRole]
    ) {
        let user = User(id: userId, email: userEmail, roles: roles)
        self.user = user
        Task {
            do {
                try await credentialsStore.store(accessToken: accessToken, refreshToken: refreshToken, user: user)
            } catch {
                //TODO: Handle error here
            }
        }
    }
}
