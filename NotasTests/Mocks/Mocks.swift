//
//  Mocks.swift
//  NotasTests
//
//  Created by Otto on 30/06/2024.
//

import Foundation
@testable import Notas

var mockDatabase: [Note] = []

struct CreateNoteUseCaseMock: CreateNoteProtocol {
    func createNoteWith(title: String, text: String) throws {
        let note: Note = Note(title: title, text: text, createAt: .now)
        mockDatabase.append(note)
    }
}

struct FetchAllNoteUseCaseMock: FetchAllNotesProtocol {
    func fetchAll() throws -> [Note] {
        return mockDatabase
    }
}

struct UpdateNoteUseCaseMock: UpdateNoteProtocol {
    func updateNoteWith(identifier: UUID, newTitle: String, newText: String?) throws {
        if let index = mockDatabase.firstIndex(where: { $0.identifier == identifier }) {
            let updateNote = Note(identifier: identifier, title: newTitle, text: newText, createAt: mockDatabase[index].createAt)
            mockDatabase[index] = updateNote
        }
    }
}

struct RemoveNoteUseCaseMock: RemoveNoteProtocol {
    func removeNoteWith(identifier: UUID) throws {
        mockDatabase.removeAll(where: { $0.identifier == identifier })
    }
}
