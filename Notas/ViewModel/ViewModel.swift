//
//  ViewModel.swift
//  Notas
//
//  Created by Otto on 29/06/2024.
//

import Foundation
import Observation

@Observable
class ViewModel {
    var notes: [Note]
    var databaseError: DatabaseError?
    
    var createNoteUseCase: CreateNoteProtocol
    var fetchAllNotesUseCase: FetchAllNotesProtocol
    var updateNoteUseCase: UpdateNoteProtocol
    var removeNoteUseCase: RemoveNoteProtocol
    
    init(notes: [Note] = [],
         createNoteUseCase: CreateNoteProtocol = CreateNoteUseCase(), 
         fetchAllNotesUseCase: FetchAllNotesProtocol = FetchAllNotesUseCase(),
         updateNoteUseCase: UpdateNoteProtocol = UpdateNoteUseCase(),
         removeNoteUseCase: RemoveNoteProtocol = RemoveNoteUseCase()) {
        self.notes = notes
        self.createNoteUseCase = createNoteUseCase
        self.fetchAllNotesUseCase = fetchAllNotesUseCase
        self.updateNoteUseCase = updateNoteUseCase
        self.removeNoteUseCase = removeNoteUseCase
        fetchAllNotes()
    }
    
    func createNoteWith(title: String, text: String) {
//        let note: Note = .init(title: title, text: text, createAt: .now)
//        notes.append(note)
        do {
            try createNoteUseCase.createNoteWith(title: title, text: text)
            fetchAllNotes()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchAllNotes() {
        do {
            notes = try fetchAllNotesUseCase.fetchAll()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    func updateNoteWith(identifier: UUID, newTitle: String, newText: String?) {
//        if let index = notes.firstIndex(where: { $0.identifier == identifier }) {
//            let updateNote = Note(identifier: identifier, title: newTitle, text: newText, createAt: notes[index].createAt)
//            notes[index] = updateNote
//        }
        do{
            try updateNoteUseCase.updateNoteWith(identifier: identifier, newTitle: newTitle, newText: newText)
            fetchAllNotes()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func removeNoteWith(identifier: UUID) {
//        notes.removeAll(where: { $0.identifier == identifier })
        do{
            try removeNoteUseCase.removeNoteWith(identifier: identifier)
            fetchAllNotes()
        } catch let error as DatabaseError {
            databaseError = error
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
