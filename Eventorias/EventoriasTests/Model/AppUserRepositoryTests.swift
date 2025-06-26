//
//  AppUserRepositoryTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 26/06/2025.
//

import XCTest
@testable import Eventorias

final class AppUserRepositoryTests: XCTestCase {

    // MARK: Authentification Tests

    func test_SignUpSuccessWithName() async throws {
        // Given user is not connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(isConnected: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When sign up with name
        let user = try await userRepo.signUp(email: "test@gmail.com", password: "xxxx", name: "Test")

        // Then user is created
        XCTAssertEqual(user.email, "test@gmail.com")
        XCTAssertEqual(user.displayName, "Test")
    }

    func test_SignUpSuccessWithoutName() async throws {
        // Given user is not connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(isConnected: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When sign up without name
        let user = try await userRepo.signUp(email: "test@gmail.com", password: "xxxx", name: "")

        // Then user is created
        XCTAssertEqual(user.email, "test@gmail.com")
        XCTAssertNil(user.displayName)
    }

    func test_SignInSuccess() async throws {
        // Given user is not connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(isConnected: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When sign up in
        let user = try await userRepo.signIn(withEmail: "test@gmail.com", password: "xxxx")

        // Then user exist
        XCTAssertEqual(user.email, "test@gmail.com")
    }

    func test_SignOutSuccess() async throws {
        // Given user is connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        await userRepo.reloadUser()

        // When sign out
        try userRepo.signOut()

        // Then user is nil
        XCTAssertNil(userRepo.getUser())
    }

    func test_ResetPasswordSuccess() async {
        // Given user is not connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(isConnected: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When reset password
        do {
            try await userRepo.sendPasswordReset(withEmail: "test@gmail.com")

            // Then there is no error thrown
        } catch {
            XCTFail("Send password reset failed: \(error)")
        }
    }
}

// MARK: Update user name

extension AppUserRepositoryTests {

    func test_UpdateUserFailure() async {
        // Given user is not connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(isConnected: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        do {
            // When update user
            _ = try await userRepo.udpateUser(name: "Test", avatar: nil)
        } catch {
            // Then error is thrown
            XCTAssertEqual(error as? AppError, AppError.currentUserNotFound)
        }
    }

    func test_UpdateUserSuccess() async throws {
        // Given user is connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )

        // When update user
        let newUser = try await userRepo.udpateUser(name: "Test", avatar: nil)

        // Then user is updated
        XCTAssertEqual(newUser.displayName, "Test")
    }
}

// MARK: Update user avatar

extension AppUserRepositoryTests {

    func test_UpdateUserSuccessWithValidAvatar() async throws {
        // Given user is connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )

        // When update user with valid image
        let avatar = MockData().image()
        let newUser = try await userRepo.udpateUser(name: "Test", avatar: avatar)

        // Then user is updated
        XCTAssertEqual(newUser.displayName, "Test")
        XCTAssertNotNil(newUser.avatarURL)
    }

    func test_UpdateUserFailureCauseInvalidImage() async {
        // Given user is connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        do {
            // When update user with invalid image
            _ = try await userRepo.udpateUser(name: "Test", avatar: UIImage())
        } catch {
            // Then error is thrown
            XCTAssertEqual(error as? AppError, AppError.invalidImage)
        }
    }

    func test_DeleteAvatarSuccess() async throws {
        // Given user is connected with avatar
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        XCTAssertNotNil(userRepo.getUser()!.avatarURL)
        
        // When delete avatar
        let newUser = try await userRepo.deleteUserPhoto()

        // Then avatar is nil
        XCTAssertNil(newUser.avatarURL)
    }

    func test_DeleteAvatarWithNoURL() async throws {
        // Given user is connected without avatar
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(withAvatar: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        XCTAssertNil(userRepo.getUser()!.avatarURL)

        // When delete avatar
        let newUser = try await userRepo.deleteUserPhoto()

        // Then avatar is always nil
        XCTAssertNil(newUser.avatarURL)
    }

    func test_DeleteAvatarFailure() async {
        // Given user is not connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(isConnected: false),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        do {
            // When delete avatar
            _ = try await userRepo.deleteUserPhoto()
        } catch {
            // Then error is thrown
            XCTAssertEqual(error as? AppError, AppError.currentUserNotFound)
        }
    }
}

// MARK: Update user email

extension AppUserRepositoryTests {

    func test_UpdateUserEmailSuccess() async throws {
        // Given user is connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )

        // When update user email
        let emailVerification = try await userRepo.udpateUser(email: "new-email@example.com")

        // Then email verification was sent
        XCTAssertTrue(emailVerification)
    }

    func test_UpdateUserEmailWithSameEmail() async throws {
        // Given user is connected
        let userRepo = AppUserRepository(
            authRepo: MockAuthRepository(),
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        let email = userRepo.getUser()!.email!

        // When update email with same email
        let emailVerification = try await userRepo.udpateUser(email: email)

        // Then email verification was not sent
        XCTAssertFalse(emailVerification)
    }
}
