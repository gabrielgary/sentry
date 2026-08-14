import React from "react";
import { GraduationCap, Users, Wallet, AlertTriangle } from "lucide-react";
import PageHeader from "../src/components/PageHeader";
import StatCard from "../src/components/StatCard";
import { students, employees, grades } from "../src/data/mock";

export default function DashboardView() {
  const average = grades.reduce((a, b) => a + Number(b.value), 0) / grades.length;

  return (
    <>
      <PageHeader title="Dashboard" description="Visão geral da gestão da escola." />
      <div className="stats-grid">
        <StatCard label="Alunos" value={students.length} note="Registos de demonstração" icon={GraduationCap} />
        <StatCard label="Funcionários" value={employees.length} note="Funcionários activos" icon={Users} />
        <StatCard label="Média das notas" value={average.toFixed(1)} note="Avaliações carregadas" icon={Wallet} />
        <StatCard label="Alertas" value="3" note="Itens que precisam de atenção" icon={AlertTriangle} />
      </div>

      <div className="grid-2">
        <div className="card">
          <h3>Resumo académico</h3>
          <div className="summary-list">
            <div><span>Turmas activas</span><strong>2</strong></div>
            <div><span>Disciplinas</span><strong>8</strong></div>
            <div><span>Alunos matriculados</span><strong>{students.length}</strong></div>
          </div>
        </div>
        <div className="card">
          <h3>Financeiro</h3>
          <div className="summary-list">
            <div><span>Propinas pendentes</span><strong>35</strong></div>
            <div><span>Propinas pagas</span><strong>120</strong></div>
            <div><span>Receita do mês</span><strong>1.250.000 Kz</strong></div>
          </div>
        </div>
      </div>
    </>
  );
}
