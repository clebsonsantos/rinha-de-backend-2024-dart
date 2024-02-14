CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL
);

INSERT INTO clientes (nome, limite, saldo)
VALUES
  ('o barato sai caro', 1000 * 100, 0),
  ('zan corp ltda', 800 * 100, 0),
  ('les cruders', 10000 * 100, 0),
  ('padaria joia de cocaia', 100000 * 100, 0),
  ('kid mais', 5000 * 100, 0);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(id),
    valor DECIMAL NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('c', 'd')) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);