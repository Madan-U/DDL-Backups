DDL Extraction README
Server: 192.168.31.174
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.31.174_20260128_190630
Started: 2026-01-28T19:06:30.433981
Finished: 2026-01-28T19:06:43.971348
Elapsed seconds: 13.54

Databases processed: 7 (successful: 7, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 8
    elapsed_seconds: 3.19
    start_time: 2026-01-28T19:06:30.952863
    end_time: 2026-01-28T19:06:34.148717
    by_type:
        PK_UNIQUE: 3
        TABLE: 3
        PROCEDURE: 2

- DBA_Inventory:
    status: OK
    objects_written: 2
    elapsed_seconds: 1.99
    start_time: 2026-01-28T19:06:34.148732
    end_time: 2026-01-28T19:06:36.141145
    by_type:
        PROCEDURE: 1
        TABLE: 1

- DDL_Test_Lab:
    status: OK
    objects_written: 23
    elapsed_seconds: 1.83
    start_time: 2026-01-28T19:06:36.141156
    end_time: 2026-01-28T19:06:37.967081
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
    elapsed_seconds: 1.65
    start_time: 2026-01-28T19:06:37.967101
    end_time: 2026-01-28T19:06:39.615777
    by_type:
        PK_UNIQUE: 8
        TABLE: 8
        PROCEDURE: 3

- DWDiagnostics:
    status: OK
    objects_written: 44
    elapsed_seconds: 1.71
    start_time: 2026-01-28T19:06:39.615791
    end_time: 2026-01-28T19:06:41.324783
    by_type:
        TABLE: 12
        PK_UNIQUE: 10
        VIEW: 10
        INDEX: 9
        PROCEDURE: 3

- DWQueue:
    status: OK
    objects_written: 21
    elapsed_seconds: 1.33
    start_time: 2026-01-28T19:06:41.324798
    end_time: 2026-01-28T19:06:42.656131
    by_type:
        PROCEDURE: 13
        INDEX: 5
        TABLE: 2
        PK_UNIQUE: 1

- InventoryDB:
    status: OK
    objects_written: 9
    elapsed_seconds: 1.31
    start_time: 2026-01-28T19:06:42.656145
    end_time: 2026-01-28T19:06:43.970450
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
