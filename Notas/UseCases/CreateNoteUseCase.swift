//
//  CreateNoteUseCase.swift
//  Notas
//
//  Created by Otto on 30/06/2024.
//

import Foundation

protocol CreateNoteProtocol {
    func createNoteWith(title: String, text: String) throws
}

struct CreateNoteUseCase: CreateNoteProtocol {
    var notesDatabase: NotesDatabaseProtocol
    
    init(notesDatebase: NotesDatabaseProtocol = NotesDataBase.shared) {
        self.notesDatabase = notesDatebase
    }
    
    func createNoteWith(title: String, text: String) throws {
        let note: Note = .init(identifier: .init(), title: title, text: text, createAt: .now)
        try notesDatabase.insertNote(note: note)
    }
}
