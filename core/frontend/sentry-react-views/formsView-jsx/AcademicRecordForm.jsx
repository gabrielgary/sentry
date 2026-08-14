import React,{useState} from "react";import FormModal from "./FormModal"
import {InputField,SelectField,FormActions} from "./FormField"

const initial={type:"Ano lectivo",
    name:"",
    startDate:"",
    endDate:"",
    active:"true",
    description:""
}

export default function AcademicRecordForm({open,onClose,onSave,type="Ano lectivo"}){const [form,setForm]=useState({...initial,type})
const change=e=>setForm({...form,[e.target.name]:e.target.value})
const submit=e=>{e.preventDefault();
    onSave({...form,id:crypto.randomUUID()});
    setForm({...initial,type})};
    
    return <FormModal open={open} onClose={onClose} title={`Novo registo: ${type}`} description="Cadastre uma estrutura académica do sistema.">
        <form onSubmit={submit}>
            <div className="form-grid">
                <InputField label="Nome / descrição" name="name" value={form.name} onChange={change} required/>
                <InputField label="Data inicial" name="startDate" value={form.startDate} onChange={change} type="date"/>
                <InputField label="Data final" name="endDate" value={form.endDate} onChange={change} type="date"/>
                <SelectField label="Activo" name="active" value={form.active} onChange={change} options={[{value:"true",label:"Sim"},{value:"false",label:"Não"}]}/>
            </div>
                <FormActions onCancel={onClose} submitLabel="Guardar registo"/>
        </form>
    </FormModal>
}
