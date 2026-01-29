DDL Extraction README
Server: 192.168.45.128
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.45.128_20260129_164308
Started: 2026-01-29T16:43:08.115652
Finished: 2026-01-29T16:43:39.346462
Elapsed seconds: 31.23

Databases processed: 0 (successful: 0, failures: 1)

Per-database details:
---------------------
Server totals (by object type):
--------------------------------
<no objects extracted>

Total objects extracted: 0

Failures summary:
-----------------
- SERVER: ('08001', '[08001] [Microsoft][ODBC Driver 17 for SQL Server]Named Pipes Provider: Could not open a connection to SQL Server [64].  (64) (SQLDriverConnect); [08001] [Microsoft][ODBC Driver 17 for SQL Server]Login timeout expired (0); [08001] [Microsoft][ODBC Driver 17 for SQL Server]A network-related or instance-specific error has occurred while establishing a connection to SQL Server. Server is not found or not accessible. Check if instance name is correct and if SQL Server is configured to allow remote connections. For more information see SQL Server Books Online. (64)')

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\SQL_Monitoring\central_logs
