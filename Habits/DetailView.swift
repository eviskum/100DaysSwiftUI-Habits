//
//  DetailView.swift
//  Habits
//
//  Created by Esben Viskum on 28/04/2021.
//

import SwiftUI

enum ModalType: Identifiable, View {
    case new
    case update(Habit)
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View {
        switch self {
        case .new:
            return DetailView(detailVM: DetailViewModel())
        case .update(let habit):
            return DetailView(detailVM: DetailViewModel(habit))
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var habits: Habits
    @ObservedObject var detailVM: DetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    TextField("Habit name", text: $detailVM.habitTitle)
                    TextField("Description", text: $detailVM.habitDescription)

                }
                Button(action: { detailVM.habitCount += 1 }) {
                    Text("\(detailVM.habitCount)")
                }
                .frame(width: 250, height: 50, alignment: .center)
                .background(Color.green)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10))
            }
            .navigationTitle("Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSave)
        }
    }
}

extension DetailView {
    func updateHabit() {
        let habit = Habit(id: detailVM.id!, habitTitle: detailVM.habitTitle, habitDescription: detailVM.habitDescription, habitCount: detailVM.habitCount)
        habits.updateHabit(habit)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addHabit() {
        let habit = Habit(habitTitle: detailVM.habitTitle, habitDescription: detailVM.habitDescription, habitCount: detailVM.habitCount)
        habits.addHabit(habit)
        presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var updateSave: some View {
        Button(detailVM.updating ? "Update" : "Save",
               action: detailVM.updating ? updateHabit : addHabit)
            .disabled(detailVM.saveDisable)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailVM: DetailViewModel())
    }
}
