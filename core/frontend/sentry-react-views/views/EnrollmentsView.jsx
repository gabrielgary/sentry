import React, { useState } from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";

const initialRows = [
  { id: 1, number: "2026/0001", student: "João Manuel", year: "2026", classroom: "10ª A Manhã", date: "2026-01-15" },
  { id: 2, number: "2026/0002", student: "Maria José", year: "2026", classroom: "11ª B Tarde", date: "2026-01-16" }
];

import EnrollmentForm from "../formsView-jsx/EnrollmentForm";
export default function EnrollmentsView() {
  const [rows, setRows] = useState(initialRows);
  const addEnrollment = (row) => { setRows(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "number", label: "Nº matrícula" },
    { key: "student", label: "Aluno" },
    { key: "year", label: "Ano lectivo" },
    { key: "classroom", label: "Turma" },
    { key: "date", label: "Data" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Abrir</button> }
  ];
  return <>
    <PageHeader title="Matrículas" description="Matrícula de alunos por ano lectivo e turma."
      action={<button className = "primary-btn" onClick = {() => setShowForm(true)}>+ Nova matrícula</button>} />
    <div className="card"><DataTable columns={columns} rows={rows}/></div>
  <EnrollmentForm open={showForm} onClose={() => setShowForm(false)} onSave={addEnrollment} />
</>;
}
