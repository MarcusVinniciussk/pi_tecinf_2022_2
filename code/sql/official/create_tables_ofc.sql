-- Tabelas Modelo Secundárias
-- Modelo: representa algo que EXISTE no mundo real
-- Secundária: NÃO TEM chave estrangeira /
-- ENVIA chave estrangeira para tabela(s) modelo PRIMÁRIA(S)

CREATE TABLE necessidades (
    id_necessidade VARCHAR PRIMARY KEY,
    cid VARCHAR(15) NOT NULL, 
    descricao_simples VARCHAR(255) NOT NULL,
    descricao_tecnica VARCHAR NOT NULL
);

CREATE TABLE "responsaveis" (
  "id_responsavel" varchar PRIMARY KEY,
  "nome_responsavel" varchar(80) NOT NULL,
  "cpf_responsavel" char(11) UNIQUE NOT NULL,
  "email_responsavel" varchar(40) NOT NULL,
  "telefone_responsavel" bigint NOT NULL,
  "data_criacao" timestamptz,
  "data_ultima_alteracao" timestamptz,
  "data_exclusao" timestamptz
);

CREATE TABLE cursos (
  id_curso varchar PRIMARY KEY,
  descricao_curso varchar(255) NOT NULL,
  turno varchar(15) NOT NULL CHECK (turno IN ('Matutino', 'Vespertino', 'Noturno')),
  modalidade varchar NOT NULL CHECK (modalidade IN ('Iniciação', 'Capacitação', 'Qualificação',
    'Aperfeiçoamento', 'Técnico', 'Superior - Licenciatura', 'Superior - Bacharel', 'Superior - Tecnologia',
    'Pós Graduação Lato Sensu - Especialização', 'Pós-Graduação Stricto Sensu - Mestrado', 'Pós-Graduação Stricto Sensu - Doutorado')),
  eixo_dpto varchar NOT NULL,
  unidade_campus varchar(50) NOT NULL,
  semestral boolean DEFAULT true, 
  presencial boolean DEFAULT true
);

CREATE TABLE tutores (
	id_tutor varchar PRIMARY KEY,
	cpf_tutor char(11) UNIQUE NOT NULL,
	nome_tutor varchar(100) NOT NULL,
	email_tutor varchar(50) NOT NULL,
	telefone_tutor bigint NOT NULL,
	cargo varchar NOT NULL,
	formacao varchar(50) not null
);

-- Tabelas Modelo Primárias
-- Modelo: representa algo que EXISTE no mundo real
-- Primária: RECEBE chave estrangeira de tabela(s) 
-- modelo SECUNDÁRIA(S);
-- ENVIA chave estrangeira para tabela(s) 
-- FATO e/ou tabela(s) RELAÇÃO;

CREATE TABLE "alunos" (
  "id_aluno" varchar PRIMARY KEY,
  "fk_responsavel" varchar NOT NULL REFERENCES responsaveis (id_responsavel),
  "cpf_aluno" char(11) NOT NULL UNIQUE,
  "nome_aluno" varchar(80) NOT NULL,
  "nome_social_aluno" varchar(80),
  "email_aluno" varchar(40),
  "telefone_aluno" bigint NOT NULL,
  "data_nascimento" date NOT NULL,
  "genero" varchar(1) CHECK (genero in('M', 'F')),
  "prioridade" char(1) NOT NULL CHECK (prioridade in('A', 'M', 'B')),
  "inicio_atendimento" date NOT NULL,
  "fim_atendimento" date
);

-- Tabelas Fato
-- Fato: representa algo que ACONTECE (tem local, data e/ou horário)
-- RECEBE chave estrangeira de tabela(s) modelo PRIMÁRIA(S)

CREATE TABLE acoes_educacionais (
    id_acao varchar PRIMARY KEY,
    fk_aluno varchar NOT NULL REFERENCES alunos (id_aluno),
    fk_tutor varchar NOT NULL REFERENCES tutores (id_tutor),
    descricao_acao varchar NOT NULL,
    data_solicitacao date DEFAULT CURRENT_DATE,
    data_conclusao date DEFAULT CURRENT_DATE
);

create table horarios (
	id_horario varchar(11) primary key,
	hora_inicio time NOT null,
	hora_fim time NOT NULL,
	dia_semana varchar(20), check ( 
		dia_semana in ('Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 
		'Quinta-Feira', 'Sexta-Feira', 'Sábado')
	)
);

-- Tabelas Relação
-- Relação: Representa um relacionamento N:N (muitos para muitos)
-- RECEBE chave estrangeira de tabela(s) FATO e/ou tabela(s) PRIMÁRIA(S)

-- Implícitas: só carregam as chaves estrangeiras das tabelas de origem
CREATE TABLE alunos_necessidades (
    fk_aluno VARCHAR REFERENCES alunos(id_aluno),
    fk_necessidade VARCHAR REFERENCES necessidades(id_necessidade)
);

CREATE TABLE tutores_horarios (
    fk_tutor VARCHAR(10) NOT NULL,
    fk_horario VARCHAR(10) NOT NULL,
    FOREIGN KEY (fk_tutor) REFERENCES tutores(id_tutor),
    FOREIGN KEY (fk_horario) REFERENCES horarios(id_horario)
);

-- Explícitas: carregam outros atributos além das chaves estrangeiras
create table alunos_cursos (
	matricula varchar primary key,
	situacao varchar not null,
	fk_aluno varchar not null,
	fk_curso varchar not null,
	foreign key (fk_aluno) references alunos(id_aluno),
	foreign key (fk_curso) references cursos(id_curso),
  "data_criacao" timestamptz,
  "data_ultima_alteracao" timestamptz,
  "data_exclusao" timestamptz
);