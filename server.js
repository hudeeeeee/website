const app = require('./app');
const pool = require('./src/config/database');

const PORT = process.env.PORT || 3000;

async function waitForDB(retries = 15, delay = 2000) {
  for (let i = 1; i <= retries; i++) {
    try {
      await pool.query('SELECT 1');
      return true;
    } catch (err) {
      console.log(`DB not ready (${i}/${retries}), retrying in ${delay / 1000}s...`);
      await new Promise(r => setTimeout(r, delay));
    }
  }
  return false;
}

async function start() {
  const ready = await waitForDB();
  if (!ready) {
    console.error('Could not connect to database after retries. Exiting.');
    process.exit(1);
  }
  console.log('Database connected');
  app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
  });
}

start();
