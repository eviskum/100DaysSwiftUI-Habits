//
//  DetailViewModel.swift
//  Habits
//
//  Created by Esben Viskum on 28/04/2021.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var habitTitle = ""
    @Published var habitDescription = ""
    @Published var habitCount = 0
    @Published var completed = false
    var id: UUID?
    
    var updating: Bool {
        id != nil
    }
    
    var saveDisable: Bool {
        habitTitle.isEmpty || habitDescription.isEmpty
    }
    
    init() {}
    
    init(_ currentHabit: Habit) {
        self.habitTitle = currentHabit.habitTitle
        self.habitDescription = currentHabit.habitDescription
        self.habitCount = currentHabit.habitCount
        id = currentHabit.id
    }
}
