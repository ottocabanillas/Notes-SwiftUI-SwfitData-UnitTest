//
//  ViewModelTests.swift
//  NoteTests
//
//  Created by Otto on 29/06/2024.
//

import XCTest
@testable import Notas

final class ViewModelTests: XCTestCase {
    var sut: ViewModel!
    
    override func setUpWithError() throws {
        sut = ViewModel(createNoteUseCase: CreateNoteUseCaseMock(),
                        fetchAllNotesUseCase: FetchAllNoteUseCaseMock(),
                        updateNoteUseCase: UpdateNoteUseCaseMock(),
                        removeNoteUseCase: RemoveNoteUseCaseMock())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockDatabase = []
    }
    
    func testCreateNote() {
        // Given or Arrange
        let title = "Test Title"
        let text = "Test Text"
        
        // When or Act
        sut.createNoteWith(title: title, text: text)
        
        // Then or Assert
        XCTAssertEqual(sut.notes.count, 1)
        XCTAssertEqual(sut.notes.first?.title, title)
        XCTAssertEqual(sut.notes.first?.getText, text)
    }
    
    func testCreateThreeNote() {
        // Given or Arrange
        let title1 = "Test Title 1"
        let text1 = "Test Text 1"
        
        let title2 = "Test Title 2"
        let text2 = "Test Text 2"
        
        let title3 = "Test Title 3"
        let text3 = "Test Text 3"
        
        // When or Act
        sut.createNoteWith(title: title1, text: text1)
        sut.createNoteWith(title: title2, text: text2)
        sut.createNoteWith(title: title3, text: text3)
        
        // Then or Assert
        XCTAssertEqual(sut.notes.count, 3)
        XCTAssertEqual(sut.notes.first?.title, title1)
        XCTAssertEqual(sut.notes.first?.getText, text1)
        XCTAssertEqual(sut.notes[1].title, title2)
        XCTAssertEqual(sut.notes[1].getText, text2)
        XCTAssertEqual(sut.notes[2].title, title3)
        XCTAssertEqual(sut.notes[2].getText, text3)
    }
    
    func testUpdateNote() {
        // Given or Arrange
        let title = "Test Title"
        let text = "Test Text"
        
        
        sut.createNoteWith(title: title, text: text)
        let newTitle = "Test new Title"
        let newText = "Test new Text"
        
        // When or Act
        if let identifier = sut.notes.first?.identifier {
            sut.updateNoteWith(identifier: identifier, newTitle: newTitle, newText: newText)
            
            // Then or Assert
            XCTAssertEqual(sut.notes.count, 1)
            XCTAssertEqual(sut.notes.first?.title, newTitle)
            XCTAssertEqual(sut.notes.first?.getText, newText)
        } else {
            XCTFail("No note was created")
        }
        
    }
    
    func testRemoveNote() {
        // Given or Arrange
        let title = "Test Title"
        let text = "Test Text"
        
        sut.createNoteWith(title: title, text: text)
        
        // When or Act
        if let identifier = sut.notes.first?.identifier {
            sut.removeNoteWith(identifier: identifier)
            
            // Then or Assert
            XCTAssertEqual(sut.notes.count, 0)
            XCTAssertTrue(sut.notes.isEmpty)
        } else {
            XCTFail("No note was created")
        }
    }
    
}
