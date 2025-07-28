import XCTest
@_spi(SI_SPI) @testable import SparkSwitch

final class SwitchDynamicColorsTests: XCTestCase {
    func test_defaultValues() {
        let colors = SwitchDynamicColors()
        XCTAssertTrue(colors.backgroundColors.equals(ColorTokenClear()))
        XCTAssertTrue(colors.dotForegroundColors.equals(ColorTokenClear()))
    }

    func test_propertyAssignment() {
        let mockColor1 = ColorTokenMock(id: "bg")
        let mockColor2 = ColorTokenMock(id: "dot")
        let colors = SwitchDynamicColors(backgroundColors: mockColor1, dotForegroundColors: mockColor2)
        XCTAssertTrue(colors.backgroundColors.equals(mockColor1))
        XCTAssertTrue(colors.dotForegroundColors.equals(mockColor2))
    }

    func test_equatable_true_whenAllPropertiesEqual() {
        let mockColor1 = ColorTokenMock(id: "bg")
        let mockColor2 = ColorTokenMock(id: "dot")
        let lhs = SwitchDynamicColors(backgroundColors: mockColor1, dotForegroundColors: mockColor2)
        let rhs = SwitchDynamicColors(backgroundColors: mockColor1, dotForegroundColors: mockColor2)
        XCTAssertEqual(lhs, rhs)
    }

    func test_equatable_false_whenPropertiesDiffer() {
        let mockColor1 = ColorTokenMock(id: "bg")
        let mockColor2 = ColorTokenMock(id: "dot")
        let mockColor3 = ColorTokenMock(id: "other")
        let lhs = SwitchDynamicColors(backgroundColors: mockColor1, dotForegroundColors: mockColor2)
        let rhs = SwitchDynamicColors(backgroundColors: mockColor3, dotForegroundColors: mockColor2)
        XCTAssertNotEqual(lhs, rhs)
    }
}

// MARK: - Mock
private struct ColorTokenMock: ColorToken, Equatable {
    let id: String
    func equals(_ other: any ColorToken) -> Bool {
        (other as? ColorTokenMock)?.id == id
    }
} 