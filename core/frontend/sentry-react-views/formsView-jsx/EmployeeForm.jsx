import React,{useState} from "react";
import FormModal from "./FormModal";
import {InputField,SelectField,FormActions} from "./FormField";

const initial={firstName:"",
                lastName:"",
                position:"",
                section:"",
                phone:"",
                email:"",
                hireDate:"",
                status:"Active"
            }

export default function EmployeeForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial)
    const change = e => setForm({...form,[e.target.name]:e.target.value})
    const submit = e => {e.preventDefault()
        onSave({...form,id:crypto.randomUUID(),name:`${form.firstName} ${form.lastName}`,status:form.status==="Active"});
        setForm(initial)};
        return <FormModal open = {open} onClose = {onClose} title = "Novo funcionário" 
                                    description = "Cadastre professores, secretaria e outros funcionários.">
                <form onSubmit={submit}>
                    <div className="form-grid">
                        <InputField label="Nome" name="firstName" value={form.firstName} onChange={change} required/>
                        <InputField label = "Apelido" name = "lastName" value={form.lastName} onChange={change} required/>
                        <SelectField label="Cargo" name="position" value={form.position} onChange={change} required options={["Professor","Secretário","Director Pedagógico","Director","Administrativo","Outro"]}/>
                        <SelectField label="Secção" name="section" value={form.section} onChange={change} options={["Pedagogia","Administração","Financeiro","Secretaria"]}/>
                        <InputField label="Telefone" name="phone" value={form.phone} onChange={change}/>
                        <InputField label="Email" name="email" value={form.email} onChange={change} type="email"/>
                        <InputField label="Data de admissão" name="hireDate" value={form.hireDate} onChange={change} type="date"/>
                        <SelectField label="Estado" name="status" value={form.status} onChange={change} options={["Active","Inactive"]}/>
                    </div>
                        <FormActions onCancel={onClose} submitLabel="Cadastrar funcionário"/>
                </form>
            </FormModal>
        }
