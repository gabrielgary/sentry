import React from "react";
import PageHeader from "../src/components/PageHeader";

export default function ChatView() {
  return <>
    <PageHeader title="Chat" description="Comunicação entre utilizadores da escola." />
    <div className="chat-layout">
      <div className="card conversation-list">
        <input className="full-input" placeholder="Pesquisar conversa..." />
        {["Secretaria", "Professores", "Director Pedagógico"].map(name => (
          <button className="conversation" key={name}>
            <div className="avatar small">{name.slice(0,2).toUpperCase()}</div>
            <div><strong>{name}</strong><span>Última mensagem...</span></div>
          </button>
        ))}
      </div>
      <div className="card chat-window">
        <div className="chat-header"><strong>Secretaria</strong><span className="muted">Online</span></div>
        <div className="messages">
          <div className="message received">Bom dia. A matrícula do aluno foi actualizada.</div>
          <div className="message sent">Obrigado. Vou verificar os dados.</div>
        </div>
        <div className="chat-input"><input placeholder="Escreva uma mensagem..." /><button className="primary-btn">Enviar</button></div>
      </div>
    </div>
  </>;
}
