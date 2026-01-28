DDL Extraction README
Server: 192.168.45.128
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.45.128_20260128_193749
Started: 2026-01-28T19:37:49.319909
Finished: 2026-01-28T19:37:49.515724
Elapsed seconds: 0.18

Databases processed: 0 (successful: 0, failures: 1)

Per-database details:
---------------------
Server totals (by object type):
--------------------------------
<no objects extracted>

Total objects extracted: 0

Failures summary:
-----------------
- SERVER: ('28000', "[28000] [Microsoft][ODBC Driver 17 for SQL Server][SQL Server]Login failed for user 'sa'. (18456) (SQLDriverConnect); [28000] [Microsoft][ODBC Driver 17 for SQL Server][SQL Server]Login failed for user 'sa'. (18456)")

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\SQL_Monitoring\central_logs
