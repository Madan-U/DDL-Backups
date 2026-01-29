DDL Extraction README
Server: 192.168.31.174
Output folder: C:\SQL_Monitoring\ddl_exports\192.168.31.174_20260129_164255
Started: 2026-01-29T16:42:55.138620
Finished: 2026-01-29T16:43:08.114386
Elapsed seconds: 12.98

Databases processed: 7 (successful: 7, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 8
    elapsed_seconds: 2.15
    start_time: 2026-01-29T16:42:55.641085
    end_time: 2026-01-29T16:42:57.794576
    by_type:
        PK_UNIQUE: 3
        TABLE: 3
        PROCEDURE: 2

- DBA_Inventory:
    status: OK
    objects_written: 2
    elapsed_seconds: 2.09
    start_time: 2026-01-29T16:42:57.794594
    end_time: 2026-01-29T16:42:59.883667
    by_type:
        PROCEDURE: 1
        TABLE: 1

- DDL_Test_Lab:
    status: OK
    objects_written: 23
    elapsed_seconds: 2.05
    start_time: 2026-01-29T16:42:59.883688
    end_time: 2026-01-29T16:43:01.932142
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
    elapsed_seconds: 1.93
    start_time: 2026-01-29T16:43:01.932153
    end_time: 2026-01-29T16:43:03.858165
    by_type:
        PK_UNIQUE: 8
        TABLE: 8
        PROCEDURE: 3

- DWDiagnostics:
    status: OK
    objects_written: 44
    elapsed_seconds: 1.46
    start_time: 2026-01-29T16:43:03.858173
    end_time: 2026-01-29T16:43:05.318459
    by_type:
        TABLE: 12
        PK_UNIQUE: 10
        VIEW: 10
        INDEX: 9
        PROCEDURE: 3

- DWQueue:
    status: OK
    objects_written: 21
    elapsed_seconds: 1.56
    start_time: 2026-01-29T16:43:05.318469
    end_time: 2026-01-29T16:43:06.879349
    by_type:
        PROCEDURE: 13
        INDEX: 5
        TABLE: 2
        PK_UNIQUE: 1

- InventoryDB:
    status: OK
    objects_written: 9
    elapsed_seconds: 1.23
    start_time: 2026-01-29T16:43:06.879359
    end_time: 2026-01-29T16:43:08.113818
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
