//
//  UpdateNoteUseCase.swift
//  Notas
//
//  Created by Otto on 30/06/2024.
//

import Foundation

protocol UpdateNoteProtocol {
    func updateNoteWith(identifier: UUID, newTitle: String, newText: String?) throws
}

struct UpdateNoteUseCase: UpdateNoteProtocol {
    var notesDatabase: NotesDatabaseProtocol
    
    init(notesDatebase: NotesDatabaseProtocol = NotesDataBase.shared) {
        self.notesDatabase = notesDatebase
    }
    
    func updateNoteWith(identifier: UUID, newTitle: String, newText: String?) throws {
        try notesDatabase.updateNote(identifier: identifier, newTitle: newTitle, newText: newText)
    }
}
