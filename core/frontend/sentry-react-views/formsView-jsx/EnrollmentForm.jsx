import React,{useState} from "react";
import FormModal from "./FormModal";
import {InputField,SelectField,FormActions} from "./FormField";

const initial={student:"",
                year:"2026",
                classroom:"",
                date:"",
                number:""
            }

export default function EnrollmentForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial)
    const change = e => setForm({...form,[e.target.name]:e.target.value})
    const submit = e => {e.preventDefault()
        onSave({...form,id:crypto.randomUUID()})
        setForm(initial)}
            return <FormModal open={open} onClose={onClose} title="Nova matrícula" description="Associe um aluno ao ano lectivo e à turma.">
            <form onSubmit = {submit}>
                <div className="form-grid"> 
                        <InputField label="Nº matrícula" name="number" value={form.number} onChange={change} required/>
                        <SelectField label="Aluno" name="student" value={form.student} onChange={change} required options={["João Manuel","Maria José","Pedro António"]}/>
                        <SelectField label="Ano lectivo" name="year" value={form.year} onChange={change} required options={["2026","2027","2028"]}/>
                        <SelectField label="Turma" name="classroom" value={form.classroom} onChange={change} required options={["10ª A Manhã","11ª B Tarde","9ª A"]}/>
                        <InputField label="Data da matrícula" name="date" value={form.date} onChange={change} type="date" required/>
                </div>
                <FormActions onCancel={onClose} submitLabel="Cadastrar matrícula"/>
            </form>
        </FormModal>
    }
