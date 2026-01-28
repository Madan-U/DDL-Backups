DDL Extraction README
Server: 192.168.31.174
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.31.174_20260128_190414
Started: 2026-01-28T19:04:14.992555
Finished: 2026-01-28T19:04:29.680998
Elapsed seconds: 14.69

Databases processed: 7 (successful: 7, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 8
    elapsed_seconds: 3.26
    start_time: 2026-01-28T19:04:15.615644
    end_time: 2026-01-28T19:04:18.874278
    by_type:
        PK_UNIQUE: 3
        TABLE: 3
        PROCEDURE: 2

- DBA_Inventory:
    status: OK
    objects_written: 2
    elapsed_seconds: 2.68
    start_time: 2026-01-28T19:04:18.874302
    end_time: 2026-01-28T19:04:21.559216
    by_type:
        PROCEDURE: 1
        TABLE: 1

- DDL_Test_Lab:
    status: OK
    objects_written: 23
    elapsed_seconds: 1.55
    start_time: 2026-01-28T19:04:21.559231
    end_time: 2026-01-28T19:04:23.112520
    by_type:
        PK_UNIQUE: 6
        TABLE: 5
        INDEX: 4
        FOREIGN_KEY: 3
        PROCEDURE: 2
        FUNCTION: 1
        TRIGGER: 1
        VIEW: 1

- DWConfiguration:
    status: OK
    objects_written: 19
    elapsed_seconds: 1.72
    start_time: 2026-01-28T19:04:23.112531
    end_time: 2026-01-28T19:04:24.834514
    by_type:
        PK_UNIQUE: 8
        TABLE: 8
        PROCEDURE: 3

- DWDiagnostics:
    status: OK
    objects_written: 44
    elapsed_seconds: 1.68
    start_time: 2026-01-28T19:04:24.834529
    end_time: 2026-01-28T19:04:26.513837
    by_type:
        TABLE: 12
        PK_UNIQUE: 10
        VIEW: 10
        INDEX: 9
        PROCEDURE: 3

- DWQueue:
    status: OK
    objects_written: 21
    elapsed_seconds: 1.6
    start_time: 2026-01-28T19:04:26.513853
    end_time: 2026-01-28T19:04:28.110323
    by_type:
        PROCEDURE: 13
        INDEX: 5
        TABLE: 2
        PK_UNIQUE: 1

- InventoryDB:
    status: OK
    objects_written: 9
    elapsed_seconds: 1.57
    start_time: 2026-01-28T19:04:28.110334
    end_time: 2026-01-28T19:04:29.679558
    by_type:
        INDEX: 5
        CHECK: 2
        PK_UNIQUE: 1
        TABLE: 1

Server totals (by object type):
--------------------------------
TABLE: 32
PK_UNIQUE: 29
PROCEDURE: 24
INDEX: 23
VIEW: 11
FOREIGN_KEY: 3
CHECK: 2
FUNCTION: 1
TRIGGER: 1

Total objects extracted: 126

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\SQL_Monitoring\central_logs
