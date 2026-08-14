import React from "react";

export default function PageHeader({ title, description, action, children }) {
  return (
    <div className="page-header">
      <div>
        <h1>{title}</h1>
        {description && <p>{description}</p>}
      </div>
      {action || children}
    </div>
  );
}
