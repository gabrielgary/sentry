import React, { useState } from "react"
import FormModal from "./FormModal"
import { InputField, SelectField, FormActions } from "./FormField";

const initial={firstName:"",
                lastName:"",
                birthDate:"",
                gender:"",
                phone:"",
                email:"",
                address:"",
                classroom:"",
                status:"Active"
            }

export default function StudentForm({open,onClose,onSave}){
 const [form,setForm]=useState(initial)
 const change = e => setForm({...form,[e.target.name]:e.target.value})
 const submit = e => {e.preventDefault()
    onSave({...form,id:crypto.randomUUID(),name:`${form.firstName} ${form.lastName}`})
    setForm(initial);};

        return<FormModal open = {open} onClose = {onClose} title = "Novo aluno" description="Cadastre os dados pessoais e académicos do aluno.">
        <form onSubmit={submit}>
                <div className="form-grid">
                    <InputField label="Nome" name="firstName" value={form.firstName} onChange={change} required/>
                    <InputField label="Apelido" name="lastName" value={form.lastName} onChange={change} required/>
                    <InputField label="Data de nascimento" name="birthDate" value={form.birthDate} onChange={change} type="date"/>
                    <SelectField label="Género" name="gender" value={form.gender} onChange={change} options={["Masculino","Feminino"]}/>
                    <InputField label="Telefone" name="phone" value={form.phone} onChange={change}/>
                    <InputField label="Email" name="email" value={form.email} onChange={change} type="email"/>
                    <InputField label="Morada" name="address" value={form.address} onChange={change}/>
                    <SelectField label="Turma" name="classroom" value={form.classroom} onChange={change} options={["10ª A Manhã","11ª B Tarde","9ª A"]}/>
                    <SelectField label="Estado" name="status" value={form.status} onChange={change} options={["Active","Inactive"]}/>
                </div>
                <FormActions onCancel={onClose} submitLabel="Cadastrar aluno"/>
        </form>
        </FormModal>;
}
