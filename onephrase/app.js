const express = require('express');
const fs = require('fs');
const app = express();
const port = 3000;

// Endpoint para obter uma linha aleatória do arquivo
app.get('/frase-aleatoria', (req, res) => {
  fs.readFile('frases.txt', 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ error: 'Erro ao ler o arquivo.' });
    }

    const lines = data.split('\n');
    const randomLine = lines[Math.floor(Math.random() * lines.length)];
    res.json({ frase: randomLine });
  });
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});