import React,{useState} from "react";import FormModal from "./FormModal";
import {InputField,SelectField,TextAreaField,FormActions} from "./FormField";

const initial={title:"",
                publisher:"",
                category:"",
                file:"",
                description:""
            };
export default function BookForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial);
    const change = e => setForm({...form,[e.target.name]:e.target.value})
    const submit=e=>{e.preventDefault();
        onSave({...form,id:crypto.randomUUID()});
        setForm(initial)};
        
        return <FormModal open = {open} onClose = {onClose} title = "Novo livro" description = "Cadastre um livro ou    recurso digital da biblioteca.">
        <form onSubmit={submit}>
            <div className="form-grid">
                <InputField label="Título" name="title" value={form.title} onChange={change} required/>
                <InputField label="Editora" name="publisher" value={form.publisher} onChange={change}/>
                <SelectField label="Categoria" name="category" value={form.category} onChange={change} options={["Matemática","Informática","Línguas","Ciências","Outro"]}/>
                <InputField label="Ficheiro / URL" name="file" value={form.file} onChange={change} placeholder="PDF ou endereço"/>
                <TextAreaField label="Descrição" name="description" value={form.description} onChange={change}/>
            </div>
                <FormActions onCancel={onClose} submitLabel="Cadastrar livro"/>
        </form>
    </FormModal>
                    
                
                
                
                
                
                
                
                
}
