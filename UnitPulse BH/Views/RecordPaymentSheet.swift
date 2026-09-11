//
//  RecordPaymentSheet.swift
//  UnitPulse BH
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI

struct RecordPaymentSheet: View {
    
    @ObservedObject var controller: PaymentController
    @ObservedObject var tenantController: TenantController
    @Binding var isPresented: Bool
    
    @State private var tenantName = ""
    @State private var dueDate = ""
    @State private var mode = "GCash"
    @State private var amount = ""
    @State private var selectedStatus = "Paid"
    
    let modeOptions = ["GCash", "Cash", "Bank Transfer", "Maya"]
    let statusOptions = ["Paid", "Pending", "Overdue"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Record Payment")
                .font(.headline)
            
            if tenantController.tenants.isEmpty {
                Text("No tenants yet. Add one first in the Tenant screen.")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Tenant Name")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Menu {
                        ForEach(tenantController.tenants) { tenant in
                            Button(tenant.name) {
                                tenantName = tenant.name
                            }
                        }
                    } label: {
                        HStack {
                            Text(tenantName.isEmpty ? "Select Tenant" : tenantName)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                }
            }
            
            TextField("Due Date (e.g. Aug 5)", text: $dueDate)
                .textFieldStyle(.roundedBorder)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Mode of Payment")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Menu {
                    ForEach(modeOptions, id: \.self) { option in
                        Button(option) {
                            mode = option
                        }
                    }
                } label: {
                    HStack {
                        Text(mode)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
            }
            
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Status")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Picker("Status", selection: $selectedStatus) {
                    ForEach(statusOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Button("Save") {
                let amountValue = Double(amount) ?? 0
                controller.recordPayment(tenantName: tenantName, dueDate: dueDate, mode: mode, amount: amountValue, status: selectedStatus)
                isPresented = false
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(tenantName.isEmpty || dueDate.isEmpty || amount.isEmpty)
            
            Spacer()
        }
        .padding()
        .onAppear {
            if let firstTenant = tenantController.tenants.first {
                tenantName = firstTenant.name
            }
        }
    }
}

