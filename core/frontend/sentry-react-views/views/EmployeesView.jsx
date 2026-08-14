import React, { useState } from "react";
import { Plus } from "lucide-react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";
import Badge from "../src/components/Badge";
import { employees } from "../src/data/mock";

import EmployeeForm from "../formsView-jsx/EmployeeForm";
export default function EmployeesView() {
  const [rows, setRows] = useState(employees);
  const addEmployee = (row) => { setRows(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "name", label: "Funcionário" },
    { key: "position", label: "Cargo" },
    { key: "section", label: "Secção" },
    { key: "status", label: "Estado", render: r => <Badge type={r.status ? "success" : "warning"}>{r.status ? "Activo" : "Inactivo"}</Badge> },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Ver / Editar</button> }
  ];
  return <>
    <PageHeader title="Funcionários" description="Directores, professores, secretaria e restantes funcionários."
      action={<button className="primary-btn" onClick={() => setShowForm(true)}><Plus size={17}/> Novo funcionário</button>} />
    <div className="card"><DataTable columns={columns} rows={rows}/></div>
  <EmployeeForm open={showForm} onClose={() => setShowForm(false)} onSave={addEmployee} />
</>;
}
