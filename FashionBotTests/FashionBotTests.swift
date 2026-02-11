import Testing
@testable import FashionBot

struct FashionBotTests {
    @Test func buildVerification() {
        // Verifies the project builds and the test target links against FashionBot
        #expect(Bool(true))
    }
}
