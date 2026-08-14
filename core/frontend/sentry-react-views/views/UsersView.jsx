import React, { useState } from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";
import Badge from "../src/components/Badge";

const rows = [
  { id: 1, email: "admin@sentry.ao", role: "Director", status: "Active", last: "Hoje 07:30" },
  { id: 2, email: "professor@sentry.ao", role: "Professor", status: "Active", last: "Hoje 06:55" },
  { id: 3, email: "secretaria@sentry.ao", role: "Secretário", status: "Inactive", last: "Ontem" }
];

import UserForm from "../formsView-jsx/UserForm";
export default function UsersView() {
  const [data, setData] = useState(rows);
  const addUser = (row) => { setData(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "email", label: "Email" },
    { key: "role", label: "Perfil" },
    { key: "status", label: "Estado", render: r => <Badge type={r.status === "Active" ? "success" : "warning"}>{r.status}</Badge> },
    { key: "last", label: "Último acesso" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Gerir</button> }
  ];
  return <>
    <PageHeader title="Utilizadores" description="Contas de autenticação, perfis e estado dos utilizadores."
      action={<button className="primary-btn" onClick={() => setShowForm(true)}>+ Novo utilizador</button>} />
    <div className="card"><DataTable columns={columns} rows={data}/></div>
  <UserForm open={showForm} onClose={() => setShowForm(false)} onSave={addUser} />
</>;
}
