import React from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";
import Badge from "../src/components/Badge";

const rows = [
  { id: 1, user: "admin@sentry.ao", table: "students", action: "Adicionou", record: "student-001", date: "2026-03-11 08:10" },
  { id: 2, user: "secretaria@sentry.ao", table: "enrollments", action: "Actualizou", record: "enroll-014", date: "2026-03-11 08:22" },
  { id: 3, user: "admin@sentry.ao", table: "grades", action: "Eliminou", record: "grade-018", date: "2026-03-11 08:35" }
];

export default function AuditView() {
  const columns = [
    { key: "user", label: "Utilizador" },
    { key: "table", label: "Tabela" },
    { key: "action", label: "Acção", render: r =><Badge type = {r.action === "Eliminou" ? "danger" : r.action === "Actualizou" ? "warning" : "success"}>{r.action}</Badge> },
    { key: "record", label: "Registo" },
    { key: "date", label: "Data" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Detalhes</button> }
  ]
  return <>
    <PageHeader title = "Auditoria" 
    description = "Histórico das operações de adição, actualização e eliminação."/>
    <div className="card">
      <DataTable columns={columns} rows={rows}/>
      </div>
  </>
}
