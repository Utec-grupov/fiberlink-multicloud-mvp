// db.js — Conexión a SQL Server con credenciales desde Azure Key Vault
//
// Variables de entorno requeridas:
//   KEY_VAULT_URI        -> ej. https://mi-vault.vault.azure.net/
//   SQL_SERVER_SECRET     -> nombre del secreto con el host del servidor (default: "sql-server")
//   SQL_DATABASE_SECRET   -> nombre del secreto con la base de datos   (default: "sql-database")
//   SQL_USER_SECRET       -> nombre del secreto con el usuario         (default: "sql-user")
//   SQL_PASSWORD_SECRET   -> nombre del secreto con la contraseña      (default: "sql-password")
//
// Autenticación contra Key Vault: DefaultAzureCredential.
// En Azure Container Apps esto usa la Managed Identity asignada al Container App
// (no requiere client secret). En local, cae a `az login` / variables AZURE_*.
//
// Requiere una Access Policy o RBAC role ("Key Vault Secrets User") sobre el
// Managed Identity del Container App para poder leer los secretos.

const sql = require('mssql');
const { DefaultAzureCredential } = require('@azure/identity');
const { SecretClient } = require('@azure/keyvault-secrets');

const KEY_VAULT_URI = process.env.KEY_VAULT_URI;

if (!KEY_VAULT_URI) {
  console.error('FATAL: la variable de entorno KEY_VAULT_URI no está definida.');
}

const credential = new DefaultAzureCredential({
  managedIdentityClientId: process.env.AZURE_CLIENT_ID
});
const secretClient = KEY_VAULT_URI ? new SecretClient(KEY_VAULT_URI, credential) : null;

async function getSecret(secretName) {
  const secret = await secretClient.getSecret(secretName);
  return secret.value;
}

// Cachea la promesa del pool para no reconectar en cada request.
let poolPromise = null;

async function buildConfig() {
  const [server, database, user, password] = await Promise.all([
    getSecret(process.env.SQL_SERVER_SECRET || 'sql-server'),
    getSecret(process.env.SQL_DATABASE_SECRET || 'sql-database'),
    getSecret(process.env.SQL_USER_SECRET || 'sql-user'),
    getSecret(process.env.SQL_PASSWORD_SECRET || 'sql-password'),
  ]);

  return {
    server,
    database,
    user,
    password,
    options: {
      encrypt: true, // requerido por Azure SQL
      trustServerCertificate: false,
    },
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000,
    },
    connectionTimeout: 15000,
    requestTimeout: 15000,
  };
}

/**
 * Devuelve un pool de conexión ya conectado, reutilizando la instancia
 * entre invocaciones. Si la conexión previa fue cerrada o falló, la
 * reconstruye.
 */
async function getPool() {
  if (!KEY_VAULT_URI) {
    throw new Error('KEY_VAULT_URI no está configurado.');
  }

  if (!poolPromise) {
    poolPromise = buildConfig()
      .then((config) => new sql.ConnectionPool(config).connect())
      .catch((err) => {
        // Si falla, limpiamos la promesa cacheada para reintentar en el próximo request.
        poolPromise = null;
        throw err;
      });
  }

  try {
    const pool = await poolPromise;
    if (!pool.connected && !pool.connecting) {
      poolPromise = null;
      return getPool();
    }
    return pool;
  } catch (err) {
    poolPromise = null;
    throw err;
  }
}

module.exports = { getPool, sql };
