//
//  RemoveNoteUseCase.swift
//  Notas
//
//  Created by Otto on 30/06/2024.
//

import Foundation

protocol RemoveNoteProtocol {
    func removeNoteWith(identifier: UUID) throws
}

struct RemoveNoteUseCase: RemoveNoteProtocol {
    var notesDatabase: NotesDatabaseProtocol
    
    init(notesDatebase: NotesDatabaseProtocol = NotesDataBase.shared) {
        self.notesDatabase = notesDatebase
    }
    
    func removeNoteWith(identifier: UUID) throws {
        try notesDatabase.removeNote(identifier: identifier)
    }
}
