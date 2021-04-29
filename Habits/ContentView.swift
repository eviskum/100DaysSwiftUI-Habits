//
//  ContentView.swift
//  Habits
//
//  Created by Esben Viskum on 28/04/2021.
//

import SwiftUI

struct Habit: Identifiable, Codable {
    var id = UUID()
    var habitTitle = ""
    var habitDescription = ""
    var habitCount: Int = 0
}

class Habits: ObservableObject {
    @Published var habitList = [Habit]()

    init() {
        loadHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        guard let index = habitList.firstIndex(where: { $0.id == habit.id }) else { return }
        habitList[index] = habit
        saveHabits()
    }
    
    func addHabit(_ habit: Habit) {
        habitList.append(habit)
        saveHabits()
    }
    
    func deleteHabit(at indexSet: IndexSet) {
        habitList.remove(atOffsets: indexSet)
        saveHabits()
    }
    
    func saveHabits() {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode((self.habitList)) {
            UserDefaults.standard.set(data, forKey: "Habits")
        }
    }
    
    func loadHabits() {
        if let habits = UserDefaults.standard.data(forKey: "Habits") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Habit].self, from: habits) {
                self.habitList = decoded
                return
            }
        }
        self.habitList = []
    }
}

struct ContentView: View {
    @EnvironmentObject var habits: Habits
    @State private var showDetails = false
    @State private var modalType: ModalType? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.habitList, id: \.id) { habit in
                    Button(action: { modalType = .update(habit) }) {
                        HStack {
                            Text(habit.habitTitle)
                            Spacer()
                            Text("# \(habit.habitCount)")
                        }
                        
                    }
                }
                .onDelete(perform: removeHabit)
            }
            .navigationBarTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        modalType = .new
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $modalType) { modalType in
                modalType
            }
        }
    }
    
    func removeHabit(at offsets: IndexSet) {
        habits.habitList.remove(atOffsets: offsets)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
