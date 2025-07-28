import XCTest
@_spi(SI_SPI) @testable import SparkSwitch

final class SwitchStaticColorsTests: XCTestCase {
    func test_defaultValues() {
        let colors = SwitchStaticColors()
        XCTAssertTrue(colors.dotBackgroundColor.equals(ColorTokenClear()))
        XCTAssertTrue(colors.textForegroundColor.equals(ColorTokenClear()))
        XCTAssertTrue(colors.hoverColor.equals(ColorTokenClear()))
    }

    func test_propertyAssignment() {
        let mockColor1 = ColorTokenMock(id: "dot")
        let mockColor2 = ColorTokenMock(id: "text")
        let mockColor3 = ColorTokenMock(id: "hover")
        let colors = SwitchStaticColors(dotBackgroundColor: mockColor1, textForegroundColor: mockColor2, hoverColor: mockColor3)
        XCTAssertTrue(colors.dotBackgroundColor.equals(mockColor1))
        XCTAssertTrue(colors.textForegroundColor.equals(mockColor2))
        XCTAssertTrue(colors.hoverColor.equals(mockColor3))
    }

    func test_equatable_true_whenAllPropertiesEqual() {
        let mockColor1 = ColorTokenMock(id: "dot")
        let mockColor2 = ColorTokenMock(id: "text")
        let mockColor3 = ColorTokenMock(id: "hover")
        let lhs = SwitchStaticColors(dotBackgroundColor: mockColor1, textForegroundColor: mockColor2, hoverColor: mockColor3)
        let rhs = SwitchStaticColors(dotBackgroundColor: mockColor1, textForegroundColor: mockColor2, hoverColor: mockColor3)
        XCTAssertEqual(lhs, rhs)
    }

    func test_equatable_false_whenPropertiesDiffer() {
        let mockColor1 = ColorTokenMock(id: "dot")
        let mockColor2 = ColorTokenMock(id: "text")
        let mockColor3 = ColorTokenMock(id: "hover")
        let mockColor4 = ColorTokenMock(id: "other")
        let lhs = SwitchStaticColors(dotBackgroundColor: mockColor1, textForegroundColor: mockColor2, hoverColor: mockColor3)
        let rhs = SwitchStaticColors(dotBackgroundColor: mockColor4, textForegroundColor: mockColor2, hoverColor: mockColor3)
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