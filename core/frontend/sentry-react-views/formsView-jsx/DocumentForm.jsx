import React,{useState} from "react"
import FormModal from "./FormModal"
import {InputField,SelectField,FormActions} from "./FormField";

const initial={type:"",
                student:"",
                date:"",
                issuedBy:"",
                reference:""
            }
export default function DocumentForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial);
    const change =e => setForm({...form,[e.target.name]:e.target.value})
    const submit = e => {e.preventDefault()
        onSave({...form,id:crypto.randomUUID()})
        setForm(initial)}
            return <FormModal open={open} onClose={onClose} title = "Emitir documento" description="Registe a emissão de um documento escolar.">
                <form onSubmit={submit}>
                    <div className="form-grid">
                        <SelectField label="Tipo de documento" name="type" value={form.type} onChange={change} required options={["Declaração","Certificado","Atestado","Boletim","Outro"]}/>
                        <SelectField label="Aluno" name="student" value={form.student} onChange={change} required options={["João Manuel","Maria José","Pedro António"]}/>
                        <InputField label="Emitido por" name="issuedBy" value={form.issuedBy} onChange={change} required/>
                        <InputField label="Data" name="date" value={form.date} onChange={change} type="date" required/>
                        <InputField label="Referência" name="reference" value={form.reference} onChange={change}/>
                    </div>
                    <FormActions onCancel={onClose} submitLabel="Emitir documento"/>
                </form>
            </FormModal>
}
