import React, { useState } from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";
import { classrooms } from "../src/data/mock";

import ClassroomForm from "../formsView-jsx/ClassroomForm";
export default function ClassroomsView() {
  const [rows, setRows] = useState(classrooms);
  const addClassroom = (row) => { setRows(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "name", label: "Turma" },
    { key: "course", label: "Curso" },
    { key: "level", label: "Nível" },
    { key: "period", label: "Período" },
    { key: "room", label: "Sala" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Gerir</button> }
  ];
  return <>
    <PageHeader title="Turmas" description="Turmas, salas, períodos, cursos e níveis de ensino."
      action={<button className="primary-btn" onClick={() => setShowForm(true)}>+ Nova turma</button>} />
    <div className="card"><DataTable columns={columns} rows={rows}/></div>
  <ClassroomForm open={showForm} onClose={() => setShowForm(false)} onSave={addClassroom} />
</>;
}
