DDL Extraction README
Server: 192.168.31.174
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.31.174_20260128_193724
Started: 2026-01-28T19:37:24.215686
Finished: 2026-01-28T19:37:49.285265
Elapsed seconds: 25.07

Databases processed: 7 (successful: 7, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 8
    elapsed_seconds: 3.35
    start_time: 2026-01-28T19:37:24.907547
    end_time: 2026-01-28T19:37:28.290468
    by_type:
        PK_UNIQUE: 3
        TABLE: 3
        PROCEDURE: 2

- DBA_Inventory:
    status: OK
    objects_written: 2
    elapsed_seconds: 2.76
    start_time: 2026-01-28T19:37:28.291196
    end_time: 2026-01-28T19:37:31.050216
    by_type:
        PROCEDURE: 1
        TABLE: 1

- DDL_Test_Lab:
    status: OK
    objects_written: 23
    elapsed_seconds: 7.93
    start_time: 2026-01-28T19:37:31.050229
    end_time: 2026-01-28T19:37:38.983742
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
    elapsed_seconds: 3.21
    start_time: 2026-01-28T19:37:38.983781
    end_time: 2026-01-28T19:37:42.195818
    by_type:
        PK_UNIQUE: 8
        TABLE: 8
        PROCEDURE: 3

- DWDiagnostics:
    status: OK
    objects_written: 44
    elapsed_seconds: 2.78
    start_time: 2026-01-28T19:37:42.195857
    end_time: 2026-01-28T19:37:44.974393
    by_type:
        TABLE: 12
        PK_UNIQUE: 10
        VIEW: 10
        INDEX: 9
        PROCEDURE: 3

- DWQueue:
    status: OK
    objects_written: 21
    elapsed_seconds: 2.49
    start_time: 2026-01-28T19:37:44.974405
    end_time: 2026-01-28T19:37:47.460946
    by_type:
        PROCEDURE: 13
        INDEX: 5
        TABLE: 2
        PK_UNIQUE: 1

- InventoryDB:
    status: OK
    objects_written: 9
    elapsed_seconds: 1.82
    start_time: 2026-01-28T19:37:47.460958
    end_time: 2026-01-28T19:37:49.283262
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
