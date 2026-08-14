import React,{useState} from "react";import FormModal from "./FormModal";
import {InputField,SelectField,FormActions} from "./FormField";

const initial={email:"",
                role:"",
                password:"",
                status:"Active"
              }

export default function UserForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial)
    const change=e=>setForm({...form,[e.target.name]:e.target.value})
    const submit=e=>{e.preventDefault()
        onSave({...form,id:crypto.randomUUID(),last:"Nunca"})
        setForm(initial)};
    
        return <FormModal open = {open} onClose = {onClose} title="Novo utilizador" description="Crie uma conta de acesso ao sistema.">
        <form onSubmit = {submit}>
            <div className="form-grid">
                    <InputField label = "Email" name = "email" value = {form.email} onChange={change} type = "email" required/>
                    <SelectField label = "Perfil" name = "role" value={form.role} onChange={change} required options={["Director","Professor","Secretário","Financeiro","Administrador"]}/>
                    <InputField label = "Palavra-passe" name = "password" value={form.password} onChange={change} type="password" required/>
                    <SelectField label="Estado" name="status" value={form.status} onChange={change} options={["Active","Inactive"]}/>
                </div>
                <FormActions onCancel={onClose} submitLabel="Criar utilizador"/>
        </form>
    </FormModal>
}
