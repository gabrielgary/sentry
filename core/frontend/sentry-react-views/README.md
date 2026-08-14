# Sentry School ERP — Views React

Este projecto contém as views React separadas de acordo com os principais domínios identificados no `schema.sql`.

## Views
- Dashboard
- Alunos
- Funcionários
- Matrículas
- Turmas
- Gestão Académica
- Notas
- Faltas
- Financeiro
- Biblioteca
- Documentos
- Utilizadores
- Auditoria
- Chat

## Instalação

```bash
npm install
npm run dev
```

O frontend usa dados de demonstração em `src/data/mock.js`. Quando o backend estiver pronto, substitua os dados de demonstração pelas chamadas de `src/services/api.js`.

Defina opcionalmente:

```env
VITE_API_URL=http://localhost:3000/api
```

## Estrutura

```text
src/
├── components/
├── data/
├── services/
├── styles/
├── views/
├── App.js
└── main.js
```

Cada view está num ficheiro `.js` independente e é ligada ao React Router em `src/App.js`.
