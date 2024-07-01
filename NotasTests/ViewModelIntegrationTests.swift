//
//  ViewModelIntegrationTests.swift
//  NotasTests
//
//  Created by Otto on 30/06/2024.
//

import XCTest
@testable import Notas

@MainActor
final class ViewModelIntegrationTests: XCTestCase {
    // Note: sut --> system under test
    var sut: ViewModel!

    override func setUpWithError() throws {
        let database = NotesDataBase.shared
        database.container = NotesDataBase.setupContainer(inMemory: true)
        
        let createNoteUseCase = CreateNoteUseCase(notesDatebase: database)
        let fetchAllNotesUseCase = FetchAllNotesUseCase(notesDatabase: database)
        let updateNoteUseCase = UpdateNoteUseCase(notesDatebase: database)
        let removeNoteUseCase = RemoveNoteUseCase(notesDatebase: database)
        
        sut = ViewModel(createNoteUseCase: createNoteUseCase,
                        fetchAllNotesUseCase: fetchAllNotesUseCase,
                        updateNoteUseCase: updateNoteUseCase,
                        removeNoteUseCase: removeNoteUseCase)
    }

    override func tearDownWithError() throws { }
    
    func testCreateNote() {
        // Given or Arrange
        let title = "Test Title"
        let text = "Test Text"
        sut.createNoteWith(title: title, text: text)
        
        // When or Act
        let note = sut.notes.first
        
        // Then or Assert
        XCTAssertNotNil(note)
        XCTAssertEqual(note?.title, title)
        XCTAssertEqual(note?.getText, text)
        XCTAssertEqual(sut.notes.count, 1)
    }
    
    func testCreateTwoNote() {
        // Given or Arrange
        let title1 = "Test Title 1"
        let text1 = "Test Text 1"
        sut.createNoteWith(title: title1, text: text1)
        
        let title2 = "Test Title 2"
        let text2 = "Test Text 2"
        sut.createNoteWith(title: title2, text: text2)
        
        // When or Act
        let firstNote = sut.notes.first
        let secondNote = sut.notes.last
        
        // Then or Assert
        XCTAssertNotNil(firstNote)
        XCTAssertEqual(firstNote?.title, title1)
        XCTAssertEqual(firstNote?.getText, text1)
        XCTAssertNotNil(secondNote)
        XCTAssertEqual(secondNote?.title, title2)
        XCTAssertEqual(secondNote?.getText, text2)
        XCTAssertEqual(sut.notes.count, 2)
    }
    
    func testFetchAllNotes() {
//        // Given or Arrange
//        let title1 = "Test Title 1"
//        let text1 = "Test Text 1"
//        sut.createNoteWith(title: title1, text: text1)
//        
//        let title2 = "Test Title 2"
//        let text2 = "Test Text 2"
//        sut.createNoteWith(title: title2, text: text2)
//        
//        // When or Act
//        let firstNote = sut.notes.first
//        let secondNote = sut.notes.last
//        
//        // Then or Assert
    }
    
    func testUpdateNote() {
        // Given or Arrange
        sut.createNoteWith(title: "Note 1", text: "Text 1")
        
        // When or Act
        guard let note = sut.notes.first else {
            XCTFail()
            return
        }
        
        sut.updateNoteWith(identifier: note.identifier, newTitle: "New Note", newText: "New Text")
        sut.fetchAllNotes()
        
        // Then or Assert
        XCTAssertNotNil(sut.notes)
        XCTAssertEqual(sut.notes.count, 1)
        XCTAssertEqual(sut.notes.first?.title, "New Note")
        XCTAssertEqual(sut.notes.first?.getText, "New Text")
    }
    
    func testRemoveNote() {
        // Given or Arrange
        sut.createNoteWith(title: "Note 1", text: "Text 1")
        sut.createNoteWith(title: "Note 2", text: "Text 2")
        sut.createNoteWith(title: "Note 3", text: "Text 3")
        
        // When or Act
        guard let note = sut.notes.first else {
            XCTFail()
            return
        }
        sut.removeNoteWith(identifier: note.identifier)
        XCTAssertEqual(sut.notes.count, 2)
        XCTAssertEqual(sut.notes.first?.title, "Note 2")
        XCTAssertEqual(sut.notes.first?.getText, "Text 2")
    }
    
    func testRemoveNoteInDatabaseShouldThrowError(){
        sut.removeNoteWith(identifier: UUID())
        
        // Then or Assert
        XCTAssertEqual(sut.notes.count, 0)
        XCTAssertEqual(sut.databaseError, DatabaseError.errorRemove)
        XCTAssertNotNil(sut.databaseError)
        
    }
    
    
}
