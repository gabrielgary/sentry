-- ============================================================
-- SENTRY ERP MANAGEMENT SCHOOL SMART
-- ============================================================
-- Este script deve ser executado DENTRO da base de dados "sentry".
-- O PostgreSQL não suporta "CREATE DATABASE IF NOT EXISTS", então
-- crie a base separadamente antes de rodar este script:
--   CREATE DATABASE sentry;
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- necessário para gen_random_uuid() em PG < 13

-- ============================================================
-- TYPES
-- ============================================================
CREATE TYPE user_status    AS ENUM ('Banned', 'Inactive', 'Suspended', 'Active');
CREATE TYPE student_status AS ENUM ('Active', 'Transferred', 'Dropped Out', 'Concluded', 'Inactive', 'Banned');
CREATE TYPE gender_type    AS ENUM ('Masculine', 'Feminine');

-- ============================================================
-- DOMÍNIO: ESCOLAS
-- ============================================================
CREATE TABLE schools (
    code_schools   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_school    VARCHAR(200) NOT NULL,
    code           VARCHAR(50)  UNIQUE NOT NULL,          -- código único por escola
    type_school    VARCHAR(50)  CHECK (type_school IN ('Ensino Médio', 'Ensino Secundário', 'Ensino Primário')),
    province       VARCHAR(100),
    municipality   VARCHAR(100),
    neighborhood   VARCHAR(100),
    street         VARCHAR(50),
    phone          VARCHAR(50),
    email          VARCHAR(150),
    logotype       TEXT,                                  -- logotipo da escola
    active         BOOLEAN DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    planschool   VARCHAR(15) CHECK (planschool IN ('basic', 'basic plus', 'premium')),
);

-- ============================================================
-- DOMÍNIO: UTILIZADORES / AUTENTICAÇÃO
-- ============================================================
CREATE TABLE permissions (
    code_permissions UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permission       VARCHAR(100),
    description      TEXT
);

CREATE TABLE roles (
    code_roles  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name   VARCHAR(50) NOT NULL CHECK (role_name IN (
                    'Director',
                    'Director Pedagogico',
                    'Secretário',
                    'Professor',
                    'Estudante',
                    'Encarregado'
                )),
    description TEXT
);

CREATE TABLE users (
    code_users     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email_user     VARCHAR(150) UNIQUE NOT NULL,
    password_hash  TEXT,
    role_code      UUID REFERENCES roles(code_roles),
    status_user    user_status DEFAULT 'Inactive',
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    last_login_at  TIMESTAMP,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE permissions_users (
    user_code       UUID NOT NULL REFERENCES users(code_users) ON DELETE CASCADE,
    permission_code UUID NOT NULL REFERENCES permissions(code_permissions) ON DELETE CASCADE,
    PRIMARY KEY (user_code, permission_code)
);

CREATE TABLE login_history (
    code_login_history UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_code          UUID NOT NULL REFERENCES users(code_users) ON DELETE CASCADE,
    login_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_at          TIMESTAMP,
    ip_address         INET,
    browser            VARCHAR(100),
    device             VARCHAR(100)
);

CREATE TABLE refresh_tokens (
    code_refresh_tokens UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_code           UUID NOT NULL REFERENCES users(code_users) ON DELETE CASCADE,
    token                TEXT,
    expire_at            TIMESTAMP,
    is_revoked           BOOLEAN DEFAULT FALSE
);

-- ============================================================
-- DOMÍNIO: DEPARTAMENTOS / FUNCIONÁRIOS
-- ============================================================
CREATE TABLE departments (
    code_departments UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code      UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name             VARCHAR(150) NOT NULL
);

CREATE TABLE sections (
    code_sections   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_name    VARCHAR(150) NOT NULL,
    department_code UUID NOT NULL REFERENCES departments(code_departments) ON DELETE CASCADE
);

CREATE TABLE positions (
    code_positions UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    position_name  VARCHAR(150) NOT NULL,
    section_code   UUID NOT NULL REFERENCES sections(code_sections) ON DELETE CASCADE,
    base_salary    NUMERIC(12, 2)
);

-- tabela funcionário
CREATE TABLE employees (
    code_employees UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    user_code      UUID REFERENCES users(code_users),                -- liga ao login
    code_card      VARCHAR(20),                                      -- bilhete de identidade
    first_name     VARCHAR(100) NOT NULL,
    middle_name    VARCHAR(100),
    last_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(150),
    phone          VARCHAR(50),
    province       VARCHAR(100),
    gender         gender_type NOT NULL,
    municipality   VARCHAR(100),
    neighborhood   VARCHAR(100),
    position_code  UUID REFERENCES positions(code_positions),
    section_code   UUID REFERENCES sections(code_sections),
    hire_date      DATE,
    is_active      BOOLEAN DEFAULT TRUE,
    image_path     TEXT,
    bio            TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Diretores da escola (geral e pedagógico)
ALTER TABLE schools ADD COLUMN director_code     UUID REFERENCES employees(code_employees);
ALTER TABLE schools ADD COLUMN ped_director_code UUID REFERENCES employees(code_employees);

-- ============================================================
-- DOMÍNIO: ACADÉMICO (níveis, cursos, anos letivos, matriz curricular)
-- ============================================================
CREATE TABLE education_levels ( -- classificação geral do nível de ensino
    code_education_levels UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level_education        SMALLINT NOT NULL,
    level_name              VARCHAR(100) NOT NULL             -- Ex: 7ª, 8ª, ... 12ª, 1º Ano
);

CREATE TABLE training_areas ( -- áreas de formação (útil para ensino superior e médio)
    code_training_areas UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code         UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name                VARCHAR(150) NOT NULL,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses ( -- cursos específicos dentro de uma área de formação
    code_courses        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code         UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    training_area_code  UUID NOT NULL REFERENCES training_areas(code_training_areas),
    name                VARCHAR(150) NOT NULL,
    duration_years      INT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic_years (
    code_academic_years UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code         UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    title_school_years  VARCHAR(100),
    year                VARCHAR(10) NOT NULL,
    start_date          DATE,
    end_date            DATE,
    is_active           BOOLEAN DEFAULT FALSE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (school_code, year)
);

CREATE TABLE matrix_grades (
    code_matrix_grades   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code          UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    course_code          UUID NOT NULL REFERENCES courses(code_courses),
    education_level_code UUID NOT NULL REFERENCES education_levels(code_education_levels),
    academic_year_code   UUID REFERENCES academic_years(code_academic_years),
    active               BOOLEAN DEFAULT TRUE,
    description          TEXT,
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subjects (
    code_subjects UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name          VARCHAR(150) NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE matrix_subjects (
    code_matrix_subjects UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code          UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    matrix_grade_code    UUID NOT NULL REFERENCES matrix_grades(code_matrix_grades) ON DELETE CASCADE,
    subject_code         UUID NOT NULL REFERENCES subjects(code_subjects) ON DELETE CASCADE,
    is_nuclear           BOOLEAN DEFAULT FALSE,
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (matrix_grade_code, subject_code)
);

CREATE TABLE rooms (
    code_rooms        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code       UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    room_number       SMALLINT,
    location          VARCHAR(255),
    data_location     JSONB,
    student_capacity  INT,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE periods (
    code_periods UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code  UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name         VARCHAR(50) NOT NULL                          -- Manhã, Tarde, Noite
);

CREATE TABLE classrooms (
    code_classrooms       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code           UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    academic_year_code    UUID NOT NULL REFERENCES academic_years(code_academic_years),
    course_code           UUID NOT NULL REFERENCES courses(code_courses),
    room_code             UUID REFERENCES rooms(code_rooms),
    education_level_code  UUID REFERENCES education_levels(code_education_levels),
    period_code           UUID REFERENCES periods(code_periods),
    name_classrooms       VARCHAR(50) UNIQUE NOT NULL,          -- Ex: "10ª A Manhã"
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: ALUNOS
-- ============================================================

CREATE TABLE students (
    code_students       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code         UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,    
    user_code           UUID REFERENCES users(code_users),
    first_name          VARCHAR(100) NOT NULL,
    middle_name         VARCHAR(100),
    last_name           VARCHAR(100) NOT NULL,
    birth_date          DATE,
    gender              VARCHAR(10),
    document_number     VARCHAR(50),
    phone               VARCHAR(50),
    province            VARCHAR(100),
    municipality        VARCHAR(100),
    neighborhood        VARCHAR(100),
    status              statusUser default "Active",
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(school_code, enrollment_number)
);


CREATE TABLE student_medical (
    code_student_medical UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_code         UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    allergies            TEXT,
    medications          TEXT,
    blood_type           VARCHAR(10),
    notes                TEXT
);

-- Encarregados de educação
CREATE TABLE guardians (
    code_guardians UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name           VARCHAR(200) NOT NULL,
    phone          VARCHAR(50),
    user_code           UUID REFERENCES users(code_users),
    code_card      VARCHAR(20),  -- bilhete de identidade
    photo          TEXT
);

CREATE TABLE student_guardians (
    student_code  UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    guardian_code UUID NOT NULL REFERENCES guardians(code_guardians) ON DELETE CASCADE,
    relation      VARCHAR(50) NOT NULL,                        -- Pai, Mãe, Tio...
    PRIMARY KEY (student_code, guardian_code)
);

-- Autorizados a levantar o aluno (creche)
CREATE TABLE authorized_pickups (
    code_authorized_pickups UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_code            UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    name                    VARCHAR(200) NOT NULL,
    phone                   VARCHAR(50),
    relation                VARCHAR(50)
);

CREATE TABLE enrollments (
    code_enrollments   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    enrollment_number  VARCHAR(50) NOT NULL,
    school_code        UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code       UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    academic_year_code UUID NOT NULL REFERENCES academic_years(code_academic_years),
    classroom_code     UUID REFERENCES classrooms(code_classrooms),
    enrolled_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_code, academic_year_code),  -- um aluno por ano letivo
    UNIQUE (school_code, enrollment_number)
);

CREATE TABLE teacher_subjects (
    code_teacher_subjects UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code           UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    employee_code         UUID NOT NULL REFERENCES employees(code_employees),
    subject_code          UUID NOT NULL REFERENCES subjects(code_subjects),
    classroom_code        UUID NOT NULL REFERENCES classrooms(code_classrooms),
    UNIQUE (employee_code, subject_code, classroom_code)
);

-- ============================================================
-- DOMÍNIO: NOTAS
-- ============================================================
CREATE TABLE grades (
    code_grades         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code         UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code        UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    subject_code        UUID NOT NULL REFERENCES subjects(code_subjects) ON DELETE CASCADE,
    classroom_code      UUID NOT NULL REFERENCES classrooms(code_classrooms) ON DELETE CASCADE,
    academic_year_code  UUID NOT NULL REFERENCES academic_years(code_academic_years),
    term                SMALLINT NOT NULL CHECK (term IN (1, 2, 3)),          -- Trimestre
    evaluation_type     VARCHAR(50) NOT NULL CHECK (evaluation_type IN (
                            'Prova do Professor',
                            'Prova Trimestral',
                            'Média das Avaliações Contínuas'
                        )),
    grade_value         NUMERIC(5, 2),
    recorded_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: FALTAS
-- ============================================================
CREATE TABLE student_attendance (
    code_student_attendance UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code             UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code            UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    subject_code            UUID NOT NULL REFERENCES subjects(code_subjects),
    classroom_code          UUID NOT NULL REFERENCES classrooms(code_classrooms),
    date                    DATE NOT NULL,
    justified               BOOLEAN DEFAULT FALSE
);

CREATE TABLE employee_attendance ( -- faltas dos professores/funcionários
    code_employee_attendance UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code              UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    employee_code            UUID NOT NULL REFERENCES employees(code_employees) ON DELETE CASCADE,
    subject_code             UUID REFERENCES subjects(code_subjects),
    classroom_code           UUID REFERENCES classrooms(code_classrooms),
    date                     DATE NOT NULL,
    description              TEXT,
    justified                BOOLEAN DEFAULT FALSE
);

-- ============================================================
-- DOMÍNIO: FINANCEIRO
-- ============================================================
CREATE TABLE services (
    code_services UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name          VARCHAR(200) NOT NULL,
    price         NUMERIC(12, 2) NOT NULL
);

CREATE TABLE price_tips (
    code_price_tips       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code           UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    course_code           UUID NOT NULL REFERENCES courses(code_courses),
    education_level_code  UUID NOT NULL REFERENCES education_levels(code_education_levels),
    price                 NUMERIC(12, 2) CHECK (price > 0)
);

CREATE TABLE tips (
    code_tips        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code      UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code     UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    classroom_code   UUID REFERENCES classrooms(code_classrooms),
    month_reference  DATE,
    amount           NUMERIC(10, 2),
    expire_date      DATE,
    status_tips      VARCHAR(20) CHECK (status_tips IN ('Pending', 'Paid', 'Late')),
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments_tips (
    code_payments UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code  UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    code_tips     UUID NOT NULL REFERENCES tips(code_tips),
    amount        NUMERIC(12, 2) NOT NULL,
    payment_date  DATE NOT NULL,
    method        VARCHAR(50) CHECK (method IN ('Dinheiro', 'Transferência', 'Multicaixa', 'Outro')),
    reference     VARCHAR(100),
    recorded_by   UUID REFERENCES employees(code_employees),  -- funcionário que processou o pagamento
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments_services (
    code_payments UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code  UUID NOT NULL REFERENCES students(code_students) ON DELETE CASCADE,
    service_code  UUID NOT NULL REFERENCES services(code_services),
    amount        NUMERIC(12, 2) NOT NULL,
    payment_date  DATE NOT NULL,
    method        VARCHAR(50) CHECK (method IN ('Dinheiro', 'Transferência', 'Multicaixa', 'Outro')),
    reference     VARCHAR(100),
    recorded_by   UUID REFERENCES employees(code_employees),  -- funcionário que processou o pagamento
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: BIBLIOTECA
-- ============================================================
CREATE TABLE book_categories (
    code_book_categories UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code          UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    name                 VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    code_books    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code   UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    title         VARCHAR(200) NOT NULL,
    publisher     VARCHAR(150),
    category_code UUID REFERENCES book_categories(code_book_categories),
    file_path     TEXT,
    thumb_path    TEXT,
    uploaded_by   UUID REFERENCES employees(code_employees),
    uploaded_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: DOCUMENTOS EMITIDOS
-- ============================================================
CREATE TABLE documents (
    code_documents UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code    UUID NOT NULL REFERENCES schools(code_schools) ON DELETE CASCADE,
    student_code   UUID REFERENCES students(code_students),
    document_type  VARCHAR(100) NOT NULL,
    issued_by      UUID REFERENCES employees(code_employees),
    file_path      VARCHAR(255),
    issued_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMÍNIO: AUDITORIA
-- ============================================================
CREATE TABLE audit_logs (
    code_audit_logs UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_code     UUID REFERENCES schools(code_schools),
    user_code       UUID REFERENCES users(code_users),
    table_name      VARCHAR(100) NOT NULL,
    record_code     UUID,
    action          VARCHAR(20) NOT NULL CHECK (action IN ('Adicionou', 'Actualizou', 'Eliminou')),
    old_data        JSONB,
    new_data        JSONB,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- CHAT
-- ============================================================
CREATE TABLE chats (
    code_chats        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_source       UUID REFERENCES users(code_users),
    user_destination  UUID REFERENCES users(code_users),
    school_code       UUID REFERENCES schools(code_schools),
    message           TEXT,
    is_read           BOOLEAN DEFAULT FALSE,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TRIGGERS: manter updated_at sempre atualizado
-- ============================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_employees_updated_at
    BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_academic_years_updated_at
    BEFORE UPDATE ON academic_years
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_matrix_grades_updated_at
    BEFORE UPDATE ON matrix_grades
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_matrix_subjects_updated_at
    BEFORE UPDATE ON matrix_subjects
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- ÍNDICES DE PERFORMANCE
-- ============================================================

-- Escola (todas as queries filtram por school_code)
CREATE INDEX idx_users_school             ON users(school_code);
CREATE INDEX idx_employees_school         ON employees(school_code);
CREATE INDEX idx_students_school          ON students(school_code);
CREATE INDEX idx_classrooms_school        ON classrooms(school_code);
CREATE INDEX idx_enrollments_school       ON enrollments(school_code);
CREATE INDEX idx_grades_school            ON grades(school_code);
CREATE INDEX idx_payments_tips_school     ON payments_tips(school_code);
CREATE INDEX idx_payments_services_school ON payments_services(school_code);
CREATE INDEX idx_attendance_school        ON student_attendance(school_code);
CREATE INDEX idx_audit_school             ON audit_logs(school_code);

-- Queries comuns
CREATE INDEX idx_grades_student           ON grades(student_code, academic_year_code);
CREATE INDEX idx_grades_term              ON grades(student_code, subject_code, term, academic_year_code);
CREATE INDEX idx_attendance_date          ON student_attendance(student_code, date);
CREATE INDEX idx_enrollments_year         ON enrollments(academic_year_code, classroom_code);
CREATE INDEX idx_payments_tips_student    ON payments_tips(student_code, payment_date);
CREATE INDEX idx_payments_services_student ON payments_services(student_code, payment_date);
CREATE INDEX idx_login_history_user       ON login_history(user_code, login_at);
CREATE INDEX idx_audit_table              ON audit_logs(table_name, record_code);

-- ============================================================
-- ROW LEVEL SECURITY (multi-escola)
-- Garante isolamento total de dados entre escolas
-- ============================================================
ALTER TABLE students           ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees          ENABLE ROW LEVEL SECURITY;
ALTER TABLE classrooms         ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades             ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments_tips      ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments_services  ENABLE ROW LEVEL SECURITY;
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
COMMENT ON TABLE tips                IS 'Propinas mensais devidas por aluno';
COMMENT ON TABLE payments_tips       IS 'Pagamentos de propinas';
COMMENT ON TABLE payments_services   IS 'Pagamentos de serviços diversos';
COMMENT ON TABLE audit_logs          IS 'Histórico completo de INSERT/UPDATE/DELETE';
