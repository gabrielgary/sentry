import React,{useState} from "react";import FormModal from "./FormModal"
import {InputField,SelectField,FormActions} from "./FormField"

const initial={student:"",
                subject:"",
                term:"1",
                evaluation:"",
                value:""
            }

export default function GradeForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial)
    const change = e => setForm({...form,[e.target.name]:e.target.value})
    const submit = e => {e.preventDefault()
        onSave({...form,id:crypto.randomUUID(),value:Number(form.value)});setForm(initial)};
        
        return <FormModal open={open} onClose={onClose} title="Registar nota" description="Registe a nota de um aluno numa disciplina e avaliação.">
                    <form onSubmit = {submit}> 
                        <div className="form-grid">
                            <SelectField label="Aluno" name="student" value={form.student} onChange={change} required options={["João Manuel","Maria José","Pedro António"]}/>
                            <SelectField label="Disciplina" name="subject" value={form.subject} onChange={change} required options={["Matemática","Português","Física","Inglês","Informática"]}/>
                            <SelectField label="Trimestre" name ="term" value = {form.term} onChange={change} options={["1","2","3"]}/>
                            <SelectField label="Tipo de avaliação" name="evaluation" value={form.evaluation} onChange={change} required options={["Prova do Professor","Prova Trimestral","Avaliação Contínua","Exame"]}/>
                            <InputField label="Nota" name="value" value={form.value} onChange={change} type="number" required placeholder="0 a 20"/>
                        </div>
                        <FormActions onCancel={onClose} submitLabel="Guardar nota"/>
                    </form>
                </FormModal>}
