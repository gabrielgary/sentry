import React, { useState } from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";
import Badge from "../src/components/Badge";

const rows = [
  { id: 1, student: "João Manuel", subject: "Matemática", date: "2026-03-10", justified: false },
  { id: 2, student: "Maria José", subject: "Português", date: "2026-03-10", justified: true },
  { id: 3, student: "Pedro António", subject: "Física", date: "2026-03-11", justified: false }
];

import AttendanceForm from "../formsView-jsx/AttendanceForm";
export default function AttendanceView() {
  const [data, setData] = useState(rows);
  const addAttendance = (row) => { setData(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "student", label: "Aluno" },
    { key: "subject", label: "Disciplina" },
    { key: "date", label: "Data" },
    { key: "justified", label: "Justificada", render: r => <Badge type={r.justified ? "success" : "warning"}>{r.justified ? "Sim" : "Não"}</Badge> },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Editar</button> }
  ];
  return <>
    <PageHeader title="Faltas" description="Controlo das faltas dos alunos e funcionários."
      action={<button className="primary-btn" onClick={() => setShowForm(true)}>+ Registar falta</button>} />
    <div className="card"><DataTable columns={columns} rows={data}/></div>
  <AttendanceForm open={showForm} onClose={() => setShowForm(false)} onSave={addAttendance} />
</>;
}
