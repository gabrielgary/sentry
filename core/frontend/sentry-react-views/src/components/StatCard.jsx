import React from "react";

export default function StatCard({ label, value, note, icon: Icon }) {

  return (
    <div className = "stat-card">
      <div className = "stat-top">
        <span>{label}</span>
        {Icon && <Icon size = {20} />}
      </div>
      <strong>{value}</strong>
      {note && <small>{note}</small>}
    </div>
  );
}
