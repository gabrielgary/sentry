import React,{useState} from "react";import FormModal from "./FormModal";
import {InputField,SelectField,FormActions} from "./FormField";

const initial={name:"",
                course:"",
                level:"",
                period:"",
                room:"",
                capacity:""
            }

export default function ClassroomForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial);
    const change = e => setForm({...form,[e.target.name]:e.target.value})
    const submit=e=>{e.preventDefault();
        onSave({...form,id:crypto.randomUUID()});setForm(initial)
    };
    
    return <FormModal open={open} onClose={onClose} title="Nova turma" description="Configure turma, curso, nível, sala e período.">
            <form onSubmit={submit}>
                <div className="form-grid">
                    <InputField label="Nome da turma" name="name" value={form.name} onChange={change} required/>
                    <SelectField label="Curso" name="course" value={form.course} onChange={change} options={["Informática","Contabilidade","Enfermagem","Administração"]}/>
                    <SelectField label="Nível" name="level" value={form.level} onChange={change} options={["7ª","8ª","9ª","10ª","11ª","12ª"]}/>
                    <SelectField label="Período" name="period" value={form.period} onChange={change} options={["Manhã","Tarde","Noite"]}/>
                    <InputField label="Sala" name="room" value={form.room} onChange={change}/>
                    <InputField label="Capacidade" name="capacity" value={form.capacity} onChange={change} type="number"/>
                </div>
                    <FormActions onCancel={onClose} submitLabel="Cadastrar turma"/>
            </form>
        </FormModal>
}
