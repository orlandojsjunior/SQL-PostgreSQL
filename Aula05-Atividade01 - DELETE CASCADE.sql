-- Nesta aula aprenderemos algumas opções de restrição de chave estrangeira, e para isso precisamos conferir como está o nosso sistema.

SELECT
    *
FROM
    ALUNO;

SELECT
    *
FROM
    ALUNO_CURSO;

SELECT
    *
FROM
    CURSO;

/*
Consultando cada tabela, notamos que temos quatro alunos em "aluno", 
três cursos no banco "curso" e quatro matrículas na tabela "aluno_curso". 
Como não definimos nossas restrições, se tentarmos excluir um dado dessas tabelas, 
aparecerá uma mensagem de erro. Por exemplo, ao inserirmos o comando DELETE FROM aluno WHERE id = 1; 
não conseguimos apagar os dados do Diogo, porque seu registro está associado a um curso na tabela "aluno_curso".
*/

DELETE FROM ALUNO
WHERE
    ID = 1;

/*
Precisamos descobrir uma maneira para quando deletarmos o registro do aluno, 
também apagarmos sua matrícula. Para isso, analisaremos a chave estrangeira no nosso código de criação da tabela.
*/

CREATE TABLE ALUNO_CURSO (
    ALUNO_ID INTEGER,
    CURSO_ID INTEGER,
    PRIMARY KEY (ALUNO_ID, CURSO_ID),
    FOREIGN KEY (ALUNO_ID) REFERENCES ALUNO (ID),
    FOREIGN KEY (CURSO_ID) REFERENCES CURSO (ID)
);

/*

Quando criamos a nossa FOREIGN KEY, o padrão dela é o comando ON DELETE RETRICT, ou seja, 
a chave estrangeira restringe o apagamento de dados que estão em duas tabelas. 
Ao trocarmos para ON DELETE CASCADE , sempre que apagarmos um dado de um banco, 
o registro será apagado de todas as tabelas que o contém, ou seja, quando apagarmos o dado do aluno, 
ele também será excluído do curso.

*/

-- Escreveremos DROP TABLE aluno_curso para apagar a tabela existente e criá-la com essa nova função.

DROP TABLE ALUNO_CURSO;

CREATE TABLE ALUNO_CURSO (
    ALUNO_ID INTEGER,
    CURSO_ID INTEGER,
    PRIMARY KEY (ALUNO_ID, CURSO_ID),
    FOREIGN KEY (ALUNO_ID) REFERENCES ALUNO (ID) ON DELETE CASCADE,
    FOREIGN KEY (CURSO_ID) REFERENCES CURSO (ID)
);

-- Como recriamos a tabela, temos que registrar as matrículas para testarmos o funcionamento do DELETE CASCADE.

INSERT INTO ALUNO_CURSO (
    ALUNO_ID,
    CURSO_ID
) VALUES (
    1,
    1
);

INSERT INTO ALUNO_CURSO (
    ALUNO_ID,
    CURSO_ID
) VALUES (
    2,
    1
);

INSERT INTO ALUNO_CURSO (
    ALUNO_ID,
    CURSO_ID
) VALUES (
    3,
    1
);

INSERT INTO ALUNO_CURSO (
    ALUNO_ID,
    CURSO_ID
) VALUES (
    1,
    3
);

-- Executando a query com join da aula passada, confirmaremos, através dos nomes, a matrícula dos alunos.

SELECT aluno.nome as "Nome do Aluno",
       curso.nome as "Nome do Curso"
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id


/*
Agora podemos executar DELETE FROM aluno WHERE id = 1 
e teremos uma mensagem de sucesso ao invés do aviso de erro. Ao codarmos novamente a query, notaremos que os registros do 
Diogo não aparecem. Consultando a tabela "aluno" com SELECT * FROM aluno ,	confirmamos que os dados do Diogo foram apagados e, 
da mesma forma, consultando a tabela "aluno_curso", veremos que não tem a matrícula do aluno com "id = 1".
*/

SELECT * FROM aluno

DELETE FROM aluno WHERE id = 1 
	
-- Essa é a funcionalidade do DELETE ON CASCADE junto à chave estrangeira. Na próxima aula aprenderemos como fazer esse mesmo processo a partir do comando UPDATE.