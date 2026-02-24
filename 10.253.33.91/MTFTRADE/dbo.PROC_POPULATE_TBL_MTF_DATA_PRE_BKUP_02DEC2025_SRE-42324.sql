-- Object: PROCEDURE dbo.PROC_POPULATE_TBL_MTF_DATA_PRE_BKUP_02DEC2025_SRE-42324
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE PROC [dbo].[PROC_POPULATE_TBL_MTF_DATA_PRE_BKUP_02DEC2025_SRE-42324] (@SAUDA_DATE DATETIME)
AS
    DECLARE @SDTCUR DATETIME;
    DECLARE @LDTCUR DATETIME;

    SET NOCOUNT ON;

    -- Get settlement period parameters for ledger calculations
    SELECT @SDTCUR = SDTCUR, @LDTCUR = LDTCUR
    FROM ACCOUNT.DBO.PARAMETER
    WHERE @SAUDA_DATE BETWEEN SDTCUR AND LDTCUR;

    -- Delete existing records for the date from TBL_MTF_DATA_PRE
    DELETE FROM TBL_MTF_DATA_PRE
    WHERE SAUDA_DATE = @SAUDA_DATE;

    -- Extract and aggregate MTF positions

        INSERT INTO TBL_MTF_DATA_PRE
        (
            SAUDA_DATE,
            PARTY_CODE,
            SCRIP_CD,
            SERIES,
            BSECODE,
            ISIN,
            QTY,
            MKTAMT,
            NETAMT,
            PROCESSDATE
        )
        SELECT
            @SAUDA_DATE AS SAUDA_DATE,
            PARTY_CODE,
            SCRIP_CD,
            SERIES,
            BSECODE,
            ISIN,
            SUM(QTY) AS QTY,
            SUM(MKTAMT) AS MKTAMT,
            SUM(NETAMT) AS NETAMT,
            GETDATE() AS PROCESSDATE
        FROM TBL_PRODUCT_POSITION
        WHERE SAUDA_DATE <= @SAUDA_DATE
            AND ADJUST_DATE > @SAUDA_DATE
            --AND Sell_Buy = 0
			AND Sell_Buy = 1
            AND QTY > 0
        GROUP BY
            PARTY_CODE,
            SCRIP_CD,
            SERIES,
            BSECODE,
            ISIN
        HAVING SUM(QTY) > 0;

        -- Load NSE closing prices for current trading day
        SELECT *
        INTO #NSE_CLOSING_P
        FROM MSAJAG.DBO.CLOSING
        WHERE SYSDATE >= @SAUDA_DATE
            AND SYSDATE <= @SAUDA_DATE + ' 23:59';

        -- Load BSE closing prices for current trading day
        SELECT *
        INTO #BSE_CLOSING_P
        FROM AngelBSECM.BSEDB_AB.DBO.CLOSING
        WHERE SYSDATE >= @SAUDA_DATE
            AND SYSDATE <= @SAUDA_DATE + ' 23:59';

        CREATE INDEX #NCLOSING ON #NSE_CLOSING_P (SCRIP_CD, SERIES);
        CREATE INDEX #BCLOSING ON #BSE_CLOSING_P (SCRIP_CD);

        -- Update TDAY_CLOSING_PRICE from NSE closing (EQ, BE, BZ series)
        UPDATE TBL_MTF_DATA_PRE
        SET TDAY_CLOSING_PRICE = C.CL_RATE
        FROM #NSE_CLOSING_P C
        WHERE TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE
            AND TBL_MTF_DATA_PRE.SCRIP_CD = C.SCRIP_CD
            AND TBL_MTF_DATA_PRE.SERIES IN ('EQ', 'BE', 'BZ')
            AND C.SERIES IN ('EQ', 'BE', 'BZ')
            AND TBL_MTF_DATA_PRE.TDAY_CLOSING_PRICE = 0;

        -- Update TDAY_CLOSING_PRICE from NSE closing (other series)
        UPDATE TBL_MTF_DATA_PRE
        SET TDAY_CLOSING_PRICE = C.CL_RATE
        FROM #NSE_CLOSING_P C
        WHERE TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE
            AND TBL_MTF_DATA_PRE.SCRIP_CD = C.SCRIP_CD
            AND TBL_MTF_DATA_PRE.SERIES = C.SERIES
            AND C.SERIES NOT IN ('EQ', 'BE', 'BZ')
            AND TBL_MTF_DATA_PRE.TDAY_CLOSING_PRICE = 0;

        -- Update TDAY_CLOSING_PRICE from BSE closing
        UPDATE TBL_MTF_DATA_PRE
        SET TDAY_CLOSING_PRICE = C.CL_RATE
        FROM #BSE_CLOSING_P C
        WHERE TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE
            AND TBL_MTF_DATA_PRE.BSECODE = C.SCRIP_CD
            AND TBL_MTF_DATA_PRE.TDAY_CLOSING_PRICE = 0;

        -- Clean up temp tables
        DROP TABLE #NSE_CLOSING_P;
        DROP TABLE #BSE_CLOSING_P;

        -- Update FNOFLAG for F&O approved securities
        -- Create temp table with scrip margin data and F&O flag
        -- FOFLAG will identify securities with actual F&O futures contracts
        SELECT
            *,
            FOFLAG = 0
        INTO #B_TBLSCRIPMARGIN
        FROM TBLSCRIPMARGIN
        WHERE @SAUDA_DATE BETWEEN FROM_DATE AND TO_DATE;

        CREATE CLUSTERED INDEX IDXDT ON #B_TBLSCRIPMARGIN (ISIN);

        -- Mark securities with active F&O futures contracts
        -- FOFLAG = 1: Securities with actual futures contracts available (not just master list)
        UPDATE #B_TBLSCRIPMARGIN
        SET FOFLAG = 1
        FROM ANGELFO.NSEFO.DBO.FOSCRIP2 F
        WHERE F.SYMBOL = #B_TBLSCRIPMARGIN.SCRIP_CD
            AND F.EXPIRYDATE >= @SAUDA_DATE
            AND INST_TYPE LIKE 'FUT%';

        -- Update FNOFLAG in TBL_MTF_DATA_PRE for F&O securities
        -- FNOFLAG is based on FOFLAG (actual F&O futures check), not ACTIVEFLAG
        UPDATE TBL_MTF_DATA_PRE
        SET FNOFLAG = 1
        FROM #B_TBLSCRIPMARGIN
        WHERE TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE
            AND #B_TBLSCRIPMARGIN.ISIN = TBL_MTF_DATA_PRE.ISIN
            AND #B_TBLSCRIPMARGIN.FOFLAG = 1;

        -- Update HAIRCUT based on VaR
        DECLARE @PREV_DATE_NEW VARCHAR(11);

        -- Get previous trading date for VaR
        SELECT @PREV_DATE_NEW = LEFT(ISNULL(MAX(RECDATE), @SAUDA_DATE), 11)
        FROM MSAJAG.DBO.VARCONTROL
        WHERE RECDATE < @SAUDA_DATE;

        -- Load NSE VaR data
        SELECT V.*
        INTO #B_NSE_VAR
        FROM MSAJAG.DBO.VARDETAIL V,
            MSAJAG.DBO.VARCONTROL C
        WHERE C.RECDATE >= @PREV_DATE_NEW
            AND C.RECDATE <= @PREV_DATE_NEW + ' 23:59'
            AND C.DETAILKEY = V.DETAILKEY
            AND SERIES IN ('EQ', 'BE', 'BZ')
            AND ISIN IN (SELECT DISTINCT ISIN FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE);

        -- Load BSE VaR data
        SELECT V.*
        INTO #B_BSE_VAR
        FROM AngelBSECM.BSEDB_AB.DBO.VARDETAIL V
        WHERE V.FDATE >= @PREV_DATE_NEW
            AND V.FDATE <= @PREV_DATE_NEW + ' 23:59'
            AND ISIN IN (SELECT DISTINCT ISIN FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE);

        CREATE CLUSTERED INDEX #NISIN ON #B_NSE_VAR (ISIN);
        CREATE CLUSTERED INDEX #BISIN ON #B_BSE_VAR (ISIN);

        -- Update HAIRCUT from NSE VaR (using APPVAR only)
        UPDATE TBL_MTF_DATA_PRE
        SET HAIRCUT = M.APPVAR
        FROM #B_NSE_VAR M,
            #B_TBLSCRIPMARGIN T
        WHERE M.ISIN = TBL_MTF_DATA_PRE.ISIN
            AND M.ISIN = T.ISIN
            AND TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE
            AND TBL_MTF_DATA_PRE.HAIRCUT = 0;

        -- Update HAIRCUT from BSE VaR (using MARGIN only)
        UPDATE TBL_MTF_DATA_PRE
        SET HAIRCUT = M.MARGIN
        FROM #B_BSE_VAR M,
            #B_TBLSCRIPMARGIN T
        WHERE M.ISIN = TBL_MTF_DATA_PRE.ISIN
            AND M.ISIN = T.ISIN
            AND TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE
            AND TBL_MTF_DATA_PRE.HAIRCUT = 0;

        -- Set 100% haircut for non-F&O securities
        UPDATE TBL_MTF_DATA_PRE
        SET HAIRCUT = 100
        WHERE SAUDA_DATE = @SAUDA_DATE
            AND FNOFLAG = 0;

        -- Clean up temp tables
        DROP TABLE #B_NSE_VAR;
        DROP TABLE #B_BSE_VAR;
        DROP TABLE #B_TBLSCRIPMARGIN;

        -- Calculate MTF_REQ: (NETAMT * HAIRCUT / 100)
        UPDATE TBL_MTF_DATA_PRE
        SET MTF_REQ = (NETAMT * HAIRCUT / 100)
        WHERE SAUDA_DATE = @SAUDA_DATE;

        -- Calculate CMLEDBAL (Cash Market Ledger Balance)
        -- Create temp table for ledger balances
        CREATE TABLE #B_LEDBAL (CLTCODE VARCHAR(10), VDTLEDBAL NUMERIC(18,4));

        -- Query NSE ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ACCOUNT.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query NSE ledger for future-dated entries
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'D' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ACCOUNT.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT <= @SAUDA_DATE
              AND L.EDT > @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query BSE ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query BSE ledger for future-dated entries
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'D' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT <= @SAUDA_DATE
              AND L.EDT > @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Update CMLEDBAL in TBL_MTF_DATA_PRE
        UPDATE TBL_MTF_DATA_PRE
        SET CMLEDBAL = VDTLEDBAL
        FROM (SELECT CLTCODE, VDTLEDBAL = SUM(VDTLEDBAL) FROM #B_LEDBAL GROUP BY CLTCODE) A
        WHERE CLTCODE = PARTY_CODE
              AND SAUDA_DATE = @SAUDA_DATE;

        -- Calculate MTFLEDBAL (MTF Ledger Balance)
        TRUNCATE TABLE #B_LEDBAL;

        -- Query local MTF ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Update MTFLEDBAL in TBL_MTF_DATA_PRE
        UPDATE TBL_MTF_DATA_PRE
        SET MTFLEDBAL = VDTLEDBAL
        FROM (SELECT CLTCODE, VDTLEDBAL = SUM(VDTLEDBAL) FROM #B_LEDBAL GROUP BY CLTCODE) A
        WHERE CLTCODE = PARTY_CODE
              AND SAUDA_DATE = @SAUDA_DATE;

        -- Calculate FOLEDBAL (F&O Ledger Balance)
        TRUNCATE TABLE #B_LEDBAL;

        -- Query NSE F&O ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query NSE F&O ledger for future-dated entries
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'D' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT >= GETDATE() - 10
              AND L.VDT <= @SAUDA_DATE
              AND L.EDT > @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query Currency F&O ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query Currency F&O ledger for future-dated entries
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'D' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT <= @SAUDA_DATE
              AND L.EDT > @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query NCDEX ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query NCDEX ledger for future-dated entries
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'D' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT <= @SAUDA_DATE
              AND L.EDT > @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query MCX ledger for current settlement period
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'C' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT BETWEEN @SDTCUR AND @LDTCUR
              AND L.VDT <= @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Query MCX ledger for future-dated entries
        INSERT INTO #B_LEDBAL
        SELECT L.CLTCODE,
               VDTLEDBAL = SUM(CASE
                                   WHEN DRCR = 'D' THEN VAMT
                                   ELSE -VAMT
                               END)
        FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L,
             (SELECT DISTINCT PARTY_CODE FROM TBL_MTF_DATA_PRE WHERE SAUDA_DATE = @SAUDA_DATE) M
        WHERE L.VDT <= @SAUDA_DATE
              AND L.EDT > @SAUDA_DATE + ' 23:59:59'
              AND L.CLTCODE = M.PARTY_CODE
        GROUP BY L.CLTCODE;

        -- Update FOLEDBAL in TBL_MTF_DATA_PRE
        UPDATE TBL_MTF_DATA_PRE
        SET FOLEDBAL = VDTLEDBAL
        FROM (SELECT CLTCODE, VDTLEDBAL = SUM(VDTLEDBAL) FROM #B_LEDBAL GROUP BY CLTCODE) A
        WHERE CLTCODE = PARTY_CODE
              AND SAUDA_DATE = @SAUDA_DATE;

        -- Clean up temp table
        DROP TABLE #B_LEDBAL;

        -- Calculate FOMARGIN (F&O Margin)
        -- Source 1: NSE F&O Margin
        UPDATE TBL_MTF_DATA_PRE
        SET FOMARGIN = C.TOTALMARGIN
        FROM ANGELFO.NSEFO.DBO.FOMARGINNEW C
        WHERE MDATE = (SELECT MAX(MDATE)
                       FROM ANGELFO.NSEFO.DBO.FOMARGINNEW C1
                       WHERE C1.MDATE <= @SAUDA_DATE + ' 23:59')
              AND C.PARTY_CODE = TBL_MTF_DATA_PRE.PARTY_CODE
              AND TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE;

        -- Source 2: NSE Currency F&O Margin
        UPDATE TBL_MTF_DATA_PRE
        SET FOMARGIN = FOMARGIN + C.TOTALMARGIN
        FROM ANGELFO.NSECURFO.DBO.FOMARGINNEW C
        WHERE MDATE = (SELECT MAX(MDATE)
                       FROM ANGELFO.NSECURFO.DBO.FOMARGINNEW C1
                       WHERE C1.MDATE <= @SAUDA_DATE + ' 23:59')
              AND C.PARTY_CODE = TBL_MTF_DATA_PRE.PARTY_CODE
              AND TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE;

        -- Source 3: MCX Commodity Margin
        UPDATE TBL_MTF_DATA_PRE
        SET FOMARGIN = FOMARGIN + C.TOTALMARGIN
        FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW C
        WHERE MDATE = (SELECT MAX(MDATE)
                       FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW C1
                       WHERE C1.MDATE <= @SAUDA_DATE + ' 23:59')
              AND C.PARTY_CODE = TBL_MTF_DATA_PRE.PARTY_CODE
              AND TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE;

        -- Source 4: NCDEX Commodity Margin
        UPDATE TBL_MTF_DATA_PRE
        SET FOMARGIN = FOMARGIN + C.TOTALMARGIN
        FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW C
        WHERE MDATE = (SELECT MAX(MDATE)
                       FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW C1
                       WHERE C1.MDATE <= @SAUDA_DATE + ' 23:59')
              AND C.PARTY_CODE = TBL_MTF_DATA_PRE.PARTY_CODE
              AND TBL_MTF_DATA_PRE.SAUDA_DATE = @SAUDA_DATE;

GO
