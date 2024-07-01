//
//  NotesDataBase.swift
//  Notas
//
//  Created by Otto on 30/06/2024.
//

import Foundation
import SwiftData

enum DatabaseError: Error {
    case errorInsert
    case errorFetch
    case errorUpdate
    case errorRemove
}

protocol NotesDatabaseProtocol {
    func insertNote(note: Note) throws
    func fetchAll() throws -> [Note]
    func updateNote(identifier: UUID, newTitle: String, newText: String?) throws
    func removeNote(identifier: UUID) throws
}

class NotesDataBase: NotesDatabaseProtocol {
    static let shared: NotesDataBase = NotesDataBase()
    
    @MainActor
    var container: ModelContainer = setupContainer(inMemory: false)
    
    private init() { }
    
    @MainActor
    static func setupContainer(inMemory: Bool) -> ModelContainer {
        do{
            let container = try ModelContainer(for: Note.self,
                                               configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory)
            )
            container.mainContext.autosaveEnabled = true
            return container
        } catch {
            print("Error \(error.localizedDescription)")
            fatalError("Datebase can't be created")
        }
    }
    
    @MainActor
    func insertNote(note: Note) throws {
        container.mainContext.insert(note)
        
        do {
            try container.mainContext.save()
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorInsert
        }
    }
    
    @MainActor
    func fetchAll() throws -> [Note] {
        let fetchDescriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor<Note>(\.createAt)])
        
        do {
            return try container.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorFetch
        }
    }
    
    @MainActor
    func updateNote(identifier: UUID, newTitle: String, newText: String?) throws {
        let notePredicate = #Predicate<Note> {
            $0.identifier == identifier
        }
        
        var fetchDescriptor = FetchDescriptor<Note>(predicate: notePredicate)
        fetchDescriptor.fetchLimit = 1
        
        do {
            guard let updateNote = try container.mainContext.fetch(fetchDescriptor).first else {
                throw DatabaseError.errorUpdate
            }
            
            updateNote.title = newTitle
            updateNote.text = newText
            
            try container.mainContext.save()
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorUpdate
        }
        
    }
    
    @MainActor
    func removeNote(identifier: UUID) throws {
        let notePredicate = #Predicate<Note> {
            $0.identifier == identifier
        }
        
        var fetchDescriptor = FetchDescriptor<Note>(predicate: notePredicate)
        fetchDescriptor.fetchLimit = 1
        
        do {
            guard let deleteNote = try container.mainContext.fetch(fetchDescriptor).first else {
                throw DatabaseError.errorRemove
            }
    
            container.mainContext.delete(deleteNote)
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorRemove
        }
    }
    
    
}
