import React, { useState } from "react";
import AcademicRecordForm from "../formsView-jsx/AcademicRecordForm";
import PageHeader from "../src/components/PageHeader";

const blocks = [
  ["Anos lectivos", "Defina o ano, datas de início/fim e ano activo."],
  ["Níveis de ensino", "Configure níveis como 7ª, 8ª, 9ª, 10ª, 11ª e 12ª."],
  ["Áreas de formação", "Organize as áreas de formação da escola."],
  ["Cursos", "Associe cursos às áreas de formação."],
  ["Disciplinas", "Cadastre as disciplinas da escola."],
  ["Matriz curricular", "Associe curso, nível, ano lectivo e disciplinas."],
  ["Salas e períodos", "Configure salas, capacidade e períodos."],
];

export default function AcademicView() {
  const [showForm, setShowForm] = useState(false);
  const [recordType, setRecordType] = useState("Ano lectivo");
  const openForm = (type) => { setRecordType(type); setShowForm(true); };
  const saveRecord = (record) => { console.log("Novo registo académico:", record); setShowForm(false); };
  return <>
    <PageHeader title="Gestão Académica" description="Configuração das estruturas académicas do banco de dados." />
    <div className="cards-grid">
      {blocks.map(([title, text]) => (
        <div className="card module-card" key={title}>
          <h3>{title}</h3><p>{text}</p><button className="secondary-btn" onClick={() => openForm(title)}>Novo registo</button>
        </div>
      ))}
    </div>
  <AcademicRecordForm open={showForm} onClose={() => setShowForm(false)} onSave={saveRecord} type={recordType} />
</>;
}
