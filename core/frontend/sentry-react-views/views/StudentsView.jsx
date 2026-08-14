import React, { useMemo, useState } from "react";
import { Plus, Search } from "lucide-react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";
import Badge from "../src/components/Badge";
import { students as initialStudents } from "../src/data/mock";

import StudentForm from "../formsView-jsx/StudentForm";

export default function StudentsView() {
  const [showForm, setShowForm] = useState(false);

  const [search, setSearch] = useState("");
  const [rows, setRows] = useState(initialStudents);

  const addStudent = (row) => { setRows(prev => [...prev, { ...row, gender: row.gender, class: row.classroom, phone: row.phone, status: row.status }]); setShowForm(false); };

  const filtered = useMemo(
    () => rows.filter(s => `${s.name} ${s.phone} ${s.class}`.toLowerCase().includes(search.toLowerCase())),
    [rows, search]
  )
  const columns = [
    { key: "name", label: "Aluno" },
    { key: "gender", label: "Género" },
    { key: "class", label: "Turma" },
    { key: "phone", label: "Telefone" },
    { key: "status", label: "Estado", render: r => <Badge type={r.status === "Active" ? "success" : "warning"}>{r.status}</Badge> },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Ver / Editar</button> }
  ];

  return (
    <>
      <PageHeader title="Alunos" description="Gestão dos dados pessoais, estado e informações dos alunos."
        action={<button className="primary-btn" onClick={() => setShowForm(true)}><Plus size={17}/> Novo aluno</button>} />
      <div className="card">
        <div className="toolbar">
          <div className="search"><Search size={17}/><input placeholder="Pesquisar aluno..." value={search} onChange={e => setSearch(e.target.value)} /></div>
          <select><option>Todos os estados</option><option>Active</option><option>Inactive</option></select>
        </div>
        <DataTable columns={columns} rows={filtered} />
      </div>
    </>
  );
}
