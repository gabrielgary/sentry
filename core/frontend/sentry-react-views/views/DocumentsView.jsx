import React, { useState } from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";

const rows = [
  { id: 1, type: "Declaração", student: "João Manuel", issuedBy: "Carlos Domingos", date: "2026-03-01" },
  { id: 2, type: "Certificado", student: "Maria José", issuedBy: "Marta Paulo", date: "2026-03-02" }
];

import DocumentForm from "../formsView-jsx/DocumentForm";
export default function DocumentsView() {
  const [data, setData] = useState(rows);
  const addDocument = (row) => { setData(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "type", label: "Documento" },
    { key: "student", label: "Aluno" },
    { key: "issuedBy", label: "Emitido por" },
    { key: "date", label: "Data" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Visualizar PDF</button> }
  ];
  return <>
    <PageHeader title="Documentos" description="Documentos emitidos para os alunos."
      action={<button className="primary-btn" onClick={() => setShowForm(true)}>+ Emitir documento</button>} />
    <div className="card"><DataTable columns={columns} rows={data}/></div>
  <DocumentForm open={showForm} onClose={() => setShowForm(false)} onSave={addDocument} />
</>;
}
