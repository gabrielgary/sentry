import React, { useState } from "react";
import { Wallet, CreditCard, Receipt, Plus } from "lucide-react";
import PageHeader from "../src/components/PageHeader";
import StatCard from "../src/components/StatCard";
import DataTable from "../src/components/DataTable";

const payments = [
  { id: 1, student: "João Manuel", type: "Propina", amount: "35.000 Kz", method: "Multicaixa", date: "2026-03-05" },
  { id: 2, student: "Maria José", type: "Serviço", amount: "5.000 Kz", method: "Transferência", date: "2026-03-06" }
];

import PaymentForm from "../formsView-jsx/PaymentForm";
export default function FinanceView() {
  const [data, setData] = useState(payments);
  const addPayment = (row) => { setData(prev => [...prev, row]); setShowForm(false); };
  const [showForm, setShowForm] = useState(false);

  const columns = [
    { key: "student", label: "Aluno" },
    { key: "type", label: "Tipo" },
    { key: "amount", label: "Valor" },
    { key: "method", label: "Método" },
    { key: "date", label: "Data" },
    { key: "actions", label: "Acções", render: () => <button className="link-btn">Recibo</button> }
  ];
  return <>
    <PageHeader title="Financeiro" description="Propinas, pagamentos de propinas e pagamentos de serviços." action={<button className="primary-btn" onClick={() => setShowForm(true)}><Plus size={17}/> Novo pagamento</button>} />
    <div className="stats-grid">
      <StatCard label="Receita mensal" value="1.250.000 Kz" icon={Wallet}/>
      <StatCard label="Propinas pagas" value="120" icon={CreditCard}/>
      <StatCard label="Pendentes" value="35" icon={Receipt}/>
    </div>
    <div className="card"><h3>Pagamentos recentes</h3><DataTable columns={columns} rows={data}/></div>
  <PaymentForm open={showForm} onClose={() => setShowForm(false)} onSave={addPayment} />
</>;
}
