import React from "react";
import { NavLink, Outlet } from "react-router-dom";
import {
  LayoutDashboard, GraduationCap, 
  Users, ClipboardList, 
  School, BookOpen, 
  BarChart3, CalendarCheck, 
  Wallet, Library,
  FileText,
  ShieldCheck, History,
  MessageSquare, LogOut
} from "lucide-react";

const menu = [
  ["dashboard", "Dashboard", LayoutDashboard],
  ["students", "Alunos", GraduationCap],
  ["employees", "Funcionários", Users],
  ["enrollments", "Matrículas", ClipboardList],
  ["classrooms", "Turmas", School],
  ["academic", "Académico", BookOpen],
  ["grades", "Notas", BarChart3],
  ["attendance", "Faltas", CalendarCheck],
  ["finance", "Financeiro", Wallet],
  ["library", "Biblioteca", Library],
  ["documents", "Documentos", FileText],
  ["users", "Utilizadores", ShieldCheck],
  ["audit", "Auditoria", History],
  ["chat", "Chat", MessageSquare],
];

export default function Layout() {
  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark">S</div>
          <div>
            <strong>School</strong>
            <span>School ERP</span>
          </div>
        </div>

        <nav className="nav-menu">
          {menu.map(([path, label, Icon]) => (
            <NavLink
              key={path}
              to={`/${path}`}
              className={({ isActive }) => `nav-link ${isActive ? "active" : ""}`}
            >
              <Icon size={18} />
              <span>{label}</span>
            </NavLink>
          ))}
        </nav>

        <button className="logout">
          <LogOut size={18} /> Terminar sessão
        </button>
      </aside>

      <main className="main-content">
        <header className="topbar">
          <div>
            <span className="muted">Escola</span>
            <strong>Sentry School</strong>
          </div>
          <div className="profile">
            <div className="avatar">ADM</div>
            <div>
              <strong>Administrador</strong>
              <span className="muted">Director</span>
            </div>
          </div>
        </header>
        <section className="page-content">
          <Outlet />
        </section>
      </main>
    </div>
  );
}
