const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors());
app.use(express.json());

let pool;

async function iniciarBanco() {
  for (let i = 0; i < 30; i++) {
    try {
      pool = mysql.createPool({
        host: process.env.DB_HOST || 'db',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || 'root123',
        database: process.env.DB_NAME || 'livraria',
        waitForConnections: true
      });
      await pool.query(`CREATE TABLE IF NOT EXISTS livros (
        id INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(255) NOT NULL,
        autor VARCHAR(255) NOT NULL,
        preco DECIMAL(10,2) NOT NULL,
        estoque INT NOT NULL
      )`);
      console.log('Banco conectado');
      return;
    } catch (e) {
      console.log('Aguardando o MySQL...');
      await new Promise(r => setTimeout(r, 3000));
    }
  }
  process.exit(1);
}

app.post('/livro', async (req, res) => {
  const { titulo, autor, preco, estoque } = req.body;
  if (!titulo || !autor || preco === undefined || estoque === undefined) {
    return res.status(400).json({ erro: 'Preencha todos os campos' });
  }
  await pool.query(
    'INSERT INTO livros (titulo, autor, preco, estoque) VALUES (?, ?, ?, ?)',
    [titulo, autor, preco, estoque]
  );
  res.status(201).json({ mensagem: 'Livro cadastrado' });
});

app.get('/livros', async (req, res) => {
  const [linhas] = await pool.query('SELECT * FROM livros');
  res.json(linhas);
});

iniciarBanco().then(() => {
  app.listen(3000, '0.0.0.0', () => console.log('API na porta 3000'));
});
