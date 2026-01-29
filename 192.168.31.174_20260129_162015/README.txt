DDL Extraction README
Server: 192.168.31.174
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.31.174_20260129_162015
Started: 2026-01-29T16:20:15.496683
Finished: 2026-01-29T16:20:29.647625
Elapsed seconds: 14.15

Databases processed: 7 (successful: 7, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 8
    elapsed_seconds: 3.22
    start_time: 2026-01-29T16:20:16.136497
    end_time: 2026-01-29T16:20:19.355599
    by_type:
        PK_UNIQUE: 3
        TABLE: 3
        PROCEDURE: 2

- DBA_Inventory:
    status: OK
    objects_written: 2
    elapsed_seconds: 1.89
    start_time: 2026-01-29T16:20:19.355618
    end_time: 2026-01-29T16:20:21.241874
    by_type:
        PROCEDURE: 1
        TABLE: 1

- DDL_Test_Lab:
    status: OK
    objects_written: 23
    elapsed_seconds: 1.74
    start_time: 2026-01-29T16:20:21.241888
    end_time: 2026-01-29T16:20:22.983277
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
    start_time: 2026-01-29T16:20:22.983292
    end_time: 2026-01-29T16:20:24.705211
    by_type:
        PK_UNIQUE: 8
        TABLE: 8
        PROCEDURE: 3

- DWDiagnostics:
    status: OK
    objects_written: 44
    elapsed_seconds: 1.53
    start_time: 2026-01-29T16:20:24.705222
    end_time: 2026-01-29T16:20:26.231140
    by_type:
        TABLE: 12
        PK_UNIQUE: 10
        VIEW: 10
        INDEX: 9
        PROCEDURE: 3

- DWQueue:
    status: OK
    objects_written: 21
    elapsed_seconds: 1.75
    start_time: 2026-01-29T16:20:26.231154
    end_time: 2026-01-29T16:20:27.979071
    by_type:
        PROCEDURE: 13
        INDEX: 5
        TABLE: 2
        PK_UNIQUE: 1

- InventoryDB:
    status: OK
    objects_written: 9
    elapsed_seconds: 1.67
    start_time: 2026-01-29T16:20:27.979082
    end_time: 2026-01-29T16:20:29.647007
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
