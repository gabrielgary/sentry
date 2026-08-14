import React from "react";
import { X } from "lucide-react";

export default function FormModal({ open, title, description, children, onClose }) {
  if (!open) return null;
  return (
    <div className="modal-overlay" onMouseDown={onClose}>
      <div className="modal-card" onMouseDown={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div><h2>{title}</h2>{description && <p>{description}</p>}</div>
          <button className="icon-btn" type="button" onClick={onClose} aria-label="Fechar"><X size={20}/></button>
        </div>
        {children}
      </div>
    </div>
  );
}
