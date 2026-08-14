import React, { useState } from "react";
import PageHeader from "../src/components/PageHeader";
import DataTable from "../src/components/DataTable";

const books = [
  { id: 1, title: "Matemática 10ª Classe", publisher: "Editora Escolar", category: "Matemática", file: "PDF" },
  { id: 2, title: "Introdução à Informática", publisher: "Sentry Press", category: "Informática", file: "PDF" }
];

import BookForm from "../formsView-jsx/BookForm";
export default function LibraryView() {
  const [rows, setRows] = useState(books);
  const addBook = (row) => { setRows(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "title", label: "Livro" },
    { key: "publisher", label: "Editora" },
    { key: "category", label: "Categoria" },
    { key: "file", label: "Ficheiro" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Abrir</button> }
  ];
  return <>
    <PageHeader title="Biblioteca" description="Categorias e livros digitais da escola."
      action={<button className="primary-btn" onClick={() => setShowForm(true)}>+ Novo livro</button>} />
    <div className="card"><DataTable columns={columns} rows={rows}/></div>
  <BookForm open={showForm} onClose={() => setShowForm(false)} onSave={addBook} />
</>;
}
