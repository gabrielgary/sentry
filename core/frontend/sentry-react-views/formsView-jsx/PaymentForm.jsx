import React,{useState} from "react";
import FormModal from "./FormModal";
import {InputField,SelectField,FormActions} from "./FormField";

const initial={student:"",
                type:"Propina",
                amount:"",
                method:"",
                date:"",
                reference:""
            }

export default function PaymentForm({open,onClose,onSave}){
    const [form,setForm]=useState(initial)
    const change = e => setForm({...form,[e.target.name]:e.target.value})
    const submit = e => {e.preventDefault()
        onSave({...form,id:crypto.randomUUID()});
        setForm(initial)};
        
    return <FormModal open={open} onClose={onClose} title = "Novo pagamento" description="Registe pagamentos de propinas ou serviços.">
                
            <form onSubmit={submit}>
                <div className="form-grid">
                    <SelectField label="Aluno" name="student" value={form.student} onChange={change} required options={["João Manuel","Maria José","Pedro António"]}/>

                    <SelectField label="Tipo" name="type" value={form.type} onChange={change} options={["Propina","Serviço","Matrícula","Outro"]}/>
                    <InputField label="Valor (Kz)" name="amount" value={form.amount} onChange={change} type="number" required/>
                    <SelectField label="Método de pagamento" name="method" value={form.method} onChange={change} required options={["Multicaixa","Transferência","Numerário","TPA"]}/>
                    <InputField label="Data" name="date" value={form.date} onChange={change} type="date" required/>
                    <InputField label="Referência" name="reference" value={form.reference} onChange={change}/>
                </div>
                <FormActions onCancel={onClose} submitLabel="Registar pagamento"/>
            </form>
        </FormModal>
}
