-- ============================================================
-- SENTRY ERP MANAGEMENT SCHOOL SMART
--============================================================
 

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create database if not exists  sentry;

/*
TYPES
*/
CREATE TYPE statusUser as ENUM ("banned", "inactive","suspense","active");
CREATE TYPE statusStudent as ENUM ('Active','Transferred','give up','Concluded',"Inactive","Banned")
create type typeGender as enum ("Masculine", "Femenine");
CREATE TABLE schools (
    code_schools            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_school          VARCHAR(200) NOT NULL,
    code          VARCHAR(50)  UNIQUE NOT NULL,          -- código único por escola
    type_school          VARCHAR(50)  CHECK (type IN ('Ensino Médio', 'Ensino Secundário','Ensino Primário')),
    province      VARCHAR(100),
    municipality  VARCHAR(100),
    neighborhood  VARCHAR(100),
    street       varchar(50),
    phone         VARCHAR(50),
    email         VARCHAR(150),
    logotype text,-- logotipo da escola
    active        BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   -- planschool     varchar(15) check(planschool in ("basic","basic plus","primium")),    
);

-- ============================================================
-- DOMÍNIO: UTILIZADORES / AUTENTICAÇÃO
-- ============================================================
create table permission(
    code_permission UUID primary key default gen_random_uuid(),
    permission varchar(100),
    description text
);
create table role(
    code_role         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name  VARCHAR(50) NOT NULL CHECK (role_name IN (

                    'Director',
                    'Director Pedagogico',
                    'Secretário',
                    'Professor',
                    "Estudante",
                    'Encarregado' )),
    description TEXT

);
CREATE TABLE users (
    code_users            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email_user         VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT,
    role_user         UUID REFERENCES role(code_role),
    status_user        statusUser default "inactive",
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    last_login_at datetime,
    created_at    datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime on update default current_timestamp
);
create table permission_user(
    user_code UUID not null references users(code_users),
    permission_code UUID not null references permission(code_permission),
    primary key(user_code,permission_code)
);
CREATE TABLE login_history (
    code_login_history           BIGSERIAL PRIMARY KEY,
    user_code      UUID NOT NULL REFERENCES users(code_users),
    login_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_at    TIMESTAMP,
    ip_address   inet,
    browser      VARCHAR(100),
    device       VARCHAR(100),
    
);
create table refresh_token(
    code_refresh_token uuid primary key default gen_random_uuid(),
    user_code      UUID NOT NULL REFERENCES users(code_users),
    token text,
    expire_at datetime,
    is_revoked boolean default false
);



-- ============================================================
-- DOMÍNIO: DEPARTAMENTOS / FUNCIONÁRIOS
-- ============================================================

CREATE TABLE departments (
    code_departments          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name        VARCHAR(150) NOT NULL
);
create table section(
    code_section          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_name VARCHAR(150) NOT NULL,
    code_department UUID NOT NULL REFERENCES departments(code_departments)
);
create table position(
    code_position          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    position_name   VARCHAR(150) NOT NULL,
    code_section   UUID NOT NULL REFERENCES section(code_section)
    base_salary NUMERIC(12,2)
);
-- tabela funcionario
CREATE TABLE employees (
    code_employees              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code       UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    user_code         UUID REFERENCES users(code_users),              -- liga ao login
    code_card         VARCHAR(20),                             -- bilhete de identidade
    first_name      VARCHAR(100) NOT NULL,
    middle_name      VARCHAR(100)  NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150),
    phone           VARCHAR(50),
    province        VARCHAR(100),
    gender          typeGender not null,
    municipality    VARCHAR(100),
    neighborhood    VARCHAR(100),
    position_code     UUID REFERENCES position(code_position),
    section_code   UUID REFERENCES section(code_section),
    hire_date       DATE,
    is_active          BOOLEAN DEFAULT TRUE,
    image_path text,
    bio             TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp 
);

-- Diretores da escola (geral e pedagógico)
ALTER TABLE schools ADD COLUMN director_code          UUID REFERENCES employees(code_employees);
ALTER TABLE schools ADD COLUMN ped_director_code      UUID REFERENCES employees(code_employees);

CREATE TABLE education_levels ( -- clasificação geral do nível de ensino
    code_education_levels          UUID primary key default gen_random_uuid(),
    level_education     smallint not null;
    level_name        VARCHAR(100) NOT NULL                       -- Ex: 7ª, 8ª, ... 12ª, 1º Ano
);

CREATE TABLE training_areas ( --- áreas de formação (útil para ensino superior e médio)
    code_training_areas          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name        VARCHAR(150) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses ( -- cursos especificos dentro de uma área de formação
    code_courses               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code        UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    training_area_code UUID NOT NULL REFERENCES training_areas(code_training_areas),
    name             VARCHAR(150) NOT NULL,
    duration_years   INT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic_years (
    code_academic_years          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    title_school_years varchar(100),
    updated_at datetime on update default current_timestamp
    created_at    datetime DEFAULT CURRENT_TIMESTAMP,
    year        varchar(10) NOT NULL,
    start_date  DATE,
    end_date    DATE,
    is_active      BOOLEAN DEFAULT FALSE,
    UNIQUE (school_code, year)
);
create table matrix_grade(
    code_matrix_grade UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    course_code UUID NOT NULL REFERENCES courses(code_courses),
    education_level_code int not null references education_levels(code_education_levels),
    active boolean default true,
    description text,
    code_academic_years uuid references academic_years(code_academic_years),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE subjects (
    code_subjects          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name        VARCHAR(150) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
create table matrix_subject(
    code_matrix_subject UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    is_nuclear boolean default false,
    code_matrix_grade UUID NOT NULL REFERENCES matrix_grade(code_matrix_grade),
    subject_code UUID NOT NULL REFERENCES subjects(code_subjects),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rooms (
    code_rooms               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code        UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    room_number      SMALLINT,
    location_of_school         VARCHAR(255),
    data_location json,
    student_capacity INT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE periods (
    code_periods          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name        VARCHAR(50) NOT NULL                        -- Manhã, Tarde, Noite
);



CREATE TABLE classrooms (
    code_classrooms    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code        UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    academic_year_code UUID NOT NULL REFERENCES academic_years(code_academic_years),
    course_code        UUID NOT NULL REFERENCES courses(code_courses),
    room_code          UUID REFERENCES rooms(code_rooms),
    level_code         INT  REFERENCES education_levels(code_education_levels),
    period_code        UUID REFERENCES periods(code_periods),
    name_classrooms             VARCHAR(50) UNIQUE NOT NULL,           -- Ex: "10ª A Manhã"
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE enrollments (
    code_enrollments               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    enrollment_number varchar(50) not null,
    school_code        UUID NOT NULL REFERENCES schools(code_schools_schools) ON DELETE CASCADE,
    enrolled_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_code, academic_year_code)                  -- um aluno por ano letivo
);
CREATE TABLE students (
    code_students       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code         UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,    
    user_code           UUID REFERENCES users(code_users),
    code_enrollment UUID REFERENCES enrollments(code_enrollments);
    first_name          VARCHAR(100) NOT NULL,
    middle_name         VARCHAR(100),
    last_name           VARCHAR(100) NOT NULL,
    birth_date          DATE,
    gender              VARCHAR(10),
    document_number     VARCHAR(50),
    phone               VARCHAR(50),
    email               VARCHAR(150),
    province            VARCHAR(100),
    municipality        VARCHAR(100),
    neighborhood        VARCHAR(100),
    status              statusUser default "Active",
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(school_code, enrollment_number)
);

-- Dados médicos (útil especialmente para creche)
CREATE TABLE student_medical (
    code_student_medical          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_code  UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    allergies   TEXT,
    medications TEXT,
    blood_type  VARCHAR(10),
    notes       TEXT
);

-- Encarregados de educação
CREATE TABLE guardians (
    code_guardians          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name        VARCHAR(200) NOT NULL,
    phone       VARCHAR(50),
    email       VARCHAR(100),
    code_card     VARCHAR(20), -- bilhete de identidade
    photo text
);

CREATE TABLE student_guardians (
    student_code  UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    guardian_code UUID NOT NULL REFERENCES guardians(code_guardians) ON DELETE CASCADE,
    relation    VARCHAR(50) not null,                                -- Pai, Mãe, Tio...
    PRIMARY KEY (student_code, guardian_code)
);

-- Autorizados a levantar o aluno (creche)
CREATE TABLE authorized_pickups (
    code_authorized_pickups          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_code  UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    name        VARCHAR(200) NOT NULL,
    phone       VARCHAR(50),
    relation    VARCHAR(50)
);

CREATE TABLE teacher_classroom (
    code_teacher_subjects            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code     UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    employee_code   UUID NOT NULL REFERENCES employees(code_employees),
    subject_code    UUID NOT NULL REFERENCES subjects(code_subjects),
    classroom_code  UUID NOT NULL REFERENCES classrooms(code_classrooms),
);

-- ============================================================
-- DOMÍNIO: NOTAS
-- ============================================================
create table note_avaluetion (
    code_note_avaluetion UUID primary key default gen_random_uuid(),
    avaluetion_type        VARCHAR(50) NOT NULL CHECK (name IN ( 'Prova do Professor do 1º Trimestre','Prova Trimestre do 1º Trimestre','Média das Avaliações Continuas do 1º Trimestre','Prova do Professor do 2º Trimestre','Prova Trimestre do 2º Trimestre','Média das Avaliações Continuas do 2º Trimestre','Prova do Professor do 3º Trimestre','Prova Trimestre do 3º Trimestre','Média das Avaliações Continuas do 3º Trimestre')),-- thinking about create a new table to 
    code_subjects   UUID NOT NULL REFERENCES subjects(code_subjects) ON DELETE CASCADE,
    value_note numeric(5,2),
    student_code   UUID NOT NULL REFERENCES student(student_code) ON DELETE CASCADE,
    classroom_code   UUID NOT NULL REFERENCES classrooms(classroom_code) ON DELETE CASCADE,
    lunched_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- DOMÍNIO: FALTAS
-- ============================================================

CREATE TABLE student_attendance (
    code_student_attendance           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code   UUID NOT NULL REFERENCES students(code_students),
    subject_code   UUID NOT NULL REFERENCES subjects(code_subjects),
    classroom_code UUID NOT NULL REFERENCES classrooms(code_classrooms),
    date         DATE NOT NULL,
    justified    BOOLEAN DEFAULT FALSE
);

CREATE TABLE employee_attendance ( -- : faltas dos professores/funcionários
    code_employee_attendance           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    employee_code  UUID NOT NULL REFERENCES employees(code_employees),
    subject_code   UUID REFERENCES subjects(code_subjects) null,
    classroom_code UUID REFERENCES classrooms(code_classrooms) null,
    date         DATE NOT NULL,
    description text,
    justified    BOOLEAN DEFAULT FALSE
);

-- ============================================================
-- DOMÍNIO: FINANCEIRO
-- ============================================================

CREATE TABLE services (
    code_services          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools_schools) ON DELETE CASCADE,
    name        VARCHAR(200) NOT NULL,
    price       NUMERIC(12, 2) NOT NULL
);
create table price_tips(
    code_prive_tips UUID primary key default gen_random_uuid(),
    code_course uuid not null references courses(code_courses),
    code_education_levels uuid not null references education_levels(code_education_levels),

    price_tips money check(price_tips > 0),
    school_code        UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
);
create table tips(
    code_tips UUID primary key default gen_random_uuid(),
    student_code   UUID NOT NULL REFERENCES students(code_students_students),
    classroom_code UUID REFERENCES classrooms(code_classrooms) null,
    month_reference month,
    amount numeric(10,2),
    expire_data date,
    status_tips varchar(20) check(status_tips in ('pedding','payed','late'))    
);

CREATE TABLE payments_tips (
    code_payments  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code   UUID NOT NULL REFERENCES students(code_students_students),
    code_tips   UUID NOT NULL REFERENCES tips(code_tips),
    amount       NUMERIC(12, 2) NOT NULL,
    payment_date DATE NOT NULL,
    method       VARCHAR(50) CHECK (method IN ('Dinheiro','Transferência','Multicaixa','Outro')),
    reference    VARCHAR(100),
    recorded_by  UUID REFERENCES employees(code_employees),--traducao: registrado por (funcionário que processou o pagamento)
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE payments_service (
    code_payments  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code   UUID NOT NULL REFERENCES students(code_students_students),
    service_code   UUID NOT NULL REFERENCES services(code_services),
    amount       NUMERIC(12, 2) NOT NULL,
    payment_date DATE NOT NULL,
    method       VARCHAR(50) CHECK (method IN ('Dinheiro','Transferência','Multicaixa','Outro')),
    reference    VARCHAR(100),
    recorded_by  UUID REFERENCES employees(code_employees),--traducao: registrado por (funcionário que processou o pagamento)
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- DOMÍNIO: BIBLIOTECA
-- ============================================================

CREATE TABLE book_categories (
    code_book_categories       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name     VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    code_books            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code     UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    title         VARCHAR(200) NOT NULL,
    publisher     VARCHAR(150),
    category_code   UUID REFERENCES book_categories(code_book_categories),
    file_path     TEXT,
    thumb_path text,
    uploaded_by   UUID REFERENCES employees(code_employees),
    uploaded_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: DOCUMENTOS EMITIDOS
-- ============================================================

CREATE TABLE documents (
    code_documents            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code     UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code    UUID REFERENCES students(code_students),
    document_type VARCHAR(100) NOT NULL,                   
    issued_by     UUID REFERENCES employees(code_employees),
    file_path     VARCHAR(255),
    issued_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: AUDITORIA
-- ============================================================

CREATE TABLE audit_logs (
    code_audit_logs             BIGSERIAL PRIMARY KEY,
    school_code      UUID REFERENCES schools(code_schools),
    user_code        UUID REFERENCES users(code_users),
    table_name     VARCHAR(100) NOT NULL,
    action         VARCHAR(20) NOT NULL CHECK (action IN ('Adicionou','Actuliazou','Eliminou')),
    old_data       JSONB,
    new_data       JSONB,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ============================================================
-- CHAT
-- ============================================================
CREATE TABLE chat(
    chat_code UUID primary key default gen_random_uuid(),
    user_source UUID REFERENCES users(code_users),
    user_destination UUID REFERENCES users(code_users),
    school_code UUID REFERENCES schools(code_schools),
    message text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    is_readed boolean default false

);

-- ============================================================
-- ÍNDICES DE PERFORMANCE
-- ============================================================

-- Escola (todas as queries filtram por school_code)
CREATE INDEX idx_users_school           ON users(school_code);
CREATE INDEX idx_employees_school       ON employees(school_code);
CREATE INDEX idx_students_school        ON students(school_code);
CREATE INDEX idx_classrooms_school      ON classrooms(school_code);
CREATE INDEX idx_enrollments_school     ON enrollments(school_code);
CREATE INDEX idx_grades_school          ON grades(school_code);
CREATE INDEX idx_payments_school        ON payments(school_code);
CREATE INDEX idx_attendance_school      ON student_attendance(school_code);
CREATE INDEX idx_audit_school           ON audit_logs(school_code);

-- Queries comuns
CREATE INDEX idx_grades_student         ON grades(student_code, academic_year_code);
CREATE INDEX idx_grades_term            ON grades(student_code, subject_code, term, academic_year_code);
CREATE INDEX idx_attendance_date        ON student_attendance(student_code, date);
CREATE INDEX idx_enrollments_year       ON enrollments(academic_year_code, classroom_code);
CREATE INDEX idx_payments_student       ON payments(student_code, payment_date);
CREATE INDEX idx_login_history_user     ON login_history(user_code, login_at);
CREATE INDEX idx_audit_table            ON audit_logs(table_name, record_code);

-- ============================================================
-- ROW LEVEL SECURITY (multi-escola)
-- Garante isolamento total de dados entre escolas
-- ============================================================

ALTER TABLE students         ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees        ENABLE ROW LEVEL SECURITY;
ALTER TABLE classrooms       ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades           ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments         ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_attendance ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- COMENTÁRIOS NAS TABELAS PRINCIPAIS
-- ============================================================

COMMENT ON TABLE schools             IS 'Instituições de ensino (multi-escola)';
COMMENT ON TABLE users               IS 'Contas de autenticação — professores, alunos, admin';
COMMENT ON TABLE employees           IS 'Funcionários: diretores, professores, secretaria';
COMMENT ON TABLE students            IS 'Dados dos alunos matriculados';
COMMENT ON TABLE enrollments         IS 'Matrícula do aluno por ano letivo e turma';
COMMENT ON TABLE academic_years      IS 'Controlo do ano letivo por escola';
COMMENT ON TABLE classrooms          IS 'Turmas com sala, curso, nível, período e ano';
COMMENT ON TABLE teacher_subjects    IS 'Atribuição professor-disciplina-turma por ano';
COMMENT ON TABLE grades              IS 'Notas por trimestre e tipo de avaliação';
COMMENT ON TABLE student_attendance  IS 'Faltas dos alunos por disciplina';
COMMENT ON TABLE employee_attendance IS 'Faltas dos professores/funcionários';
COMMENT ON TABLE payments_tips            IS 'Pagamentos de propinas e proprina';
COMMENT ON TABLE payments_services            IS 'Pagamentos de propinas e serviços';
COMMENT ON TABLE audit_logs          IS 'Histórico completo de INSERT/UPDATE/DELETE';



 