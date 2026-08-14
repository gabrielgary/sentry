import React, { useState } from "react"
import PageHeader from "../src/components/PageHeader"
import DataTable from "../src/components/DataTable"
import Badge from "../src/components/Badge"
import { grades } from "../src/data/mock"

import GradeForm from "../formsView-jsx/GradeForm"
export default function GradesView() {
  const [rows, setRows] = useState(grades)
  const addGrade = (row) => { setRows(prev => [...prev, row]); setShowForm(false) }
  const [showForm, setShowForm] = useState(false)

  const columns = [
    {  key: "student",
       label: "Aluno" 
    },
    { key: "subject",
      label: "Disciplina" 
    },
    { key: "term", 
      label: "Trimestre" 
    },
    { key: "evaluation", 
      label: "Avaliação" 
    },
    { key: "value",
       label: "Nota", render: r => 
       <Badge type = {r.value >= 10 ? "success" : "danger"}>{r.value}</Badge> },
    { key: "actions", 
      label: "Acções", render: () => <button className="link-btn">Editar</button> }
  ];
  return <>
    <PageHeader title="Notas" 
    description="Notas por aluno, disciplina, turma, trimestre e tipo de avaliação."

      action={<button className="primary-btn" onClick={() => setShowForm(true)}>+ Registar nota</button>} />
    <div className="card">
      <div className="toolbar">
        <select>
          <option>1º Trimestre</option>
          <option>2º Trimestre</option>
          <option>3º Trimestre</option>
          </select>
          <select>
            <option>Todas as turmas</option>
            </select>
            </div>
      <DataTable columns={columns} rows={rows}/>
    </div>
  <GradeForm open={showForm} onClose={() => setShowForm(false)} onSave={addGrade} />
</>;
}
