//
//  NoteTests.swift
//  NoteTests
//
//  Created by Otto on 29/06/2024.
//

import XCTest
@testable import Notas

final class NoteTests: XCTestCase {
    
    func testNoteInitialization() {
        // Given or Arrange
        let tittle = "Test title"
        let text = "Test text"
        let date = Date()
        
        // When or Act
        let note = Note(title: tittle, text: text, createAt: date)
        
        // Then or Assert
        XCTAssertEqual(note.title, tittle, "Title should be equal to Test Title")
        XCTAssertEqual(note.getText, text)
        XCTAssertEqual(note.createAt, date)
    }
    
    func testNoteEmptyText() {
        // Given or Arrange
        let tittle = "Test title"
        let date = Date()
        
        // When or Act
        let note = Note(title: tittle, text: nil, createAt: date)
        
        // Then or Assert
        XCTAssertEqual(note.title, tittle, "Title should be equal to Test Title")
        XCTAssertEqual(note.getText, "")
        XCTAssertEqual(note.createAt, date)
    }

}
