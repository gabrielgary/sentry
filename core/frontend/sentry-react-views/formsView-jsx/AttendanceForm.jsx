import React, { useState } from "react"; import FormModal from "./FormModal";
import { InputField, SelectField, FormActions } from "./FormField";

const initial = { student: "",
                  subject: "", 
                  date: "", 
                  justified: "false", 
                  reason: "" 
                };
export default function AttendanceForm({ open, onClose, onSave }) { const [form, setForm] = useState(initial);
     const change = e => setForm({ ...form, [e.target.name]: e.target.value });
    const submit = e => { e.preventDefault();
         onSave({ ...form, id: crypto.randomUUID(), justified: form.justified === "true" });
         setForm(initial) 
        };
        
        return <FormModal open={open} onClose={onClose} title="Registar falta" description="Registe uma falta e indique se foi justificada.">
            <form onSubmit={submit}>
                <div className="form-grid">
                    <SelectField label="Aluno" name="student" value={form.student} onChange={change} required options={["João Manuel", "Maria José", "Pedro António"]} />
                    <SelectField label="Disciplina" name="subject" value={form.subject} onChange={change} options={["Matemática", "Português", "Física", "Inglês"]} />
                    <InputField label="Data" name="date" value={form.date} onChange={change} type="date" required />
                    <SelectField label="Justificada" name="justified" value={form.justified} onChange={change} options={[{ value: "false", label: "Não" },{ value: "true", label: "Sim" }]} />
                    <InputField label="Motivo" name="reason" value={form.reason} onChange={change} />
                    </div>
                    <FormActions onCancel={onClose} submitLabel="Registar falta" />
            </form>
            </FormModal>
}
