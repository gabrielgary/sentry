import React from "react";

export function InputField({ label, name, value, onChange, type="text", required=false, placeholder="" }) {
  return <label className="form-field">
      <span>{label}{required && " *"} </span>
        <input name = {name} value = {value ?? ""} onChange = {onChange} type = {type} required={required} placeholder = {placeholder}/>
    </label>;
}
export function SelectField({ label, name, value, onChange, options=[], required=false }) {
  return <label className="form-field"><span>{label}{required && " *"}</span><select name={name} value={value ?? ""} onChange={onChange} required={required}><option value="">Seleccione...</option>{options.map(o => <option key={o.value ?? o} value={o.value ?? o}>{o.label ?? o}</option>)}</select></label>;
}
export function TextAreaField({ label, name, value, onChange, required=false, placeholder="" }) {
  return <label className="form-field form-field-full"><span>{label}{required && " *"}</span><textarea name={name} value={value ?? ""} onChange={onChange} required={required} placeholder={placeholder} rows="4"/></label>;
}
export function FormActions({ onCancel, submitLabel="Guardar" }) {
  return <div className="form-actions"><button type="button" className="secondary-btn" onClick={onCancel}>Cancelar</button><button type="submit" className="primary-btn">{submitLabel}</button></div>;
}
