import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import Layout from "./components/Layout";



import DashboardView from "../views/DashboardView.jsx";
import StudentsView from "../views/StudentsView.jsx";
import EmployeesView from "../views/EmployeesView.jsx";
import EnrollmentsView from "../views/EnrollmentsView.jsx";
import ClassroomsView from "../views/ClassroomsView.jsx";
import AcademicView from "../views/AcademicView.jsx";
import GradesView from "../views/GradesView.jsx";
import AttendanceView from "../views/AttendanceView.jsx";
import FinanceView from "../views/FinanceView.jsx";
import LibraryView from "../views/LibraryView.jsx";
import DocumentsView from "../views/DocumentsView.jsx";
import UsersView from "../views/UsersView.jsx";
import AuditView from "../views/AuditView.jsx";
import ChatView from "../views/ChatView.jsx";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardView />} />
        <Route path="students" element={<StudentsView />} />
        <Route path="employees" element={<EmployeesView />} />
        <Route path="enrollments" element={<EnrollmentsView />} />
        <Route path="classrooms" element={<ClassroomsView />} />
        <Route path="academic" element={<AcademicView />} />
        <Route path="grades" element={<GradesView />} />
        <Route path="attendance" element={<AttendanceView />} />
        <Route path="finance" element={<FinanceView />} />
        <Route path="library" element={<LibraryView />} />
        <Route path="documents" element={<DocumentsView />} />
        <Route path="users" element={<UsersView />} />
        <Route path="audit" element={<AuditView />} />
        <Route path="chat" element={<ChatView />} />
      </Route>
    </Routes>
  );
}
