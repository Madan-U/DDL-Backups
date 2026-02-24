-- Object: PROCEDURE dbo.MARGINYEAREND
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE MARGINYEAREND
      @SDTCUR VARCHAR(11),
      @LDTCUR VARCHAR(11),
      @VTYP   SMALLINT,
      @VNO VARCHAR(12),
      @BOOKTYPE CHAR(2),
      @VDT    DATETIME

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE
      @@CLTCODE  AS VARCHAR(10),
      @@LNO      AS INT,
      @@RCURSOR  AS CURSOR

INSERT INTO 
      MARGINLEDGER
SELECT 
      @VTYP, 
      @VNO, 
      0, 
      (CASE WHEN T.BAL >= 0 THEN 'D' ELSE 'C' END), 
      @VDT, 
      ABS(T.BAL), 
      T.PARTY_CODE,
      T.EXCHANGE, 
      RTRIM(T.SEGMENT), 
      0, 
      '', 
      @BOOKTYPE, 
      T.MCLTCODE
FROM
      (SELECT 
            MCLTCODE, 
            EXCHANGE, 
            SEGMENT, 
            PARTY_CODE, 
            BAL=SUM( CASE WHEN UPPER(DRCR) = 'D' THEN AMOUNT ELSE -AMOUNT END)
      FROM 
            MARGINLEDGER 
      WHERE 
            VDT >= @SDTCUR + ' 00:00:00' 
            AND VDT <= @LDTCUR + ' 23:59:59'
      GROUP BY 
            MCLTCODE, 
            EXCHANGE, 
            SEGMENT, 
            PARTY_CODE) T


SET @@RCURSOR = CURSOR FOR
SELECT 
      L.CLTCODE, 
      LNO 
FROM 
      LEDGER L,
      ACMAST A 
WHERE 
      A.CLTCODE = L.CLTCODE
      AND VTYP = @VTYP 
      AND L.BOOKTYPE = @BOOKTYPE 
      AND VNO = @VNO
      AND A.ACCAT = '14'
ORDER BY 
      L.CLTCODE

      OPEN @@RCURSOR
      FETCH NEXT FROM @@RCURSOR 
      INTO @@CLTCODE, @@LNO
      
            WHILE @@FETCH_STATUS = 0
            BEGIN
               UPDATE 
                        MARGINLEDGER 
                  SET 
                        LNO = @@LNO 
                  WHERE 
                        VTYP = @VTYP 
                        AND BOOKTYPE = @BOOKTYPE 
                        AND VNO = @VNO 
                        AND MCLTCODE = @@CLTCODE
            
               FETCH NEXT FROM @@RCURSOR 
               INTO @@CLTCODE, @@LNO
            END
      
      CLOSE @@RCURSOR
      DEALLOCATE @@RCURSOR

/* FOR EFFECTIVE DATEWISE MARGIN O/P BALANCES */

UPDATE 
      MARGINLEDGER 
SET 
      SETT_NO = T.BAL
FROM
(
      SELECT 
            MCLTCODE, 
            EXCHANGE, 
            SEGMENT, 
            PARTY_CODE, 
            BAL=SUM( CASE WHEN UPPER(M.DRCR) = 'D' THEN AMOUNT ELSE -AMOUNT END)
      FROM 
            MARGINLEDGER M, 
            LEDGER L
      WHERE 
            M.VTYP = L.VTYP 
            AND M.BOOKTYPE = L.BOOKTYPE 
            AND M.VNO = L.VNO 
            AND M.LNO = L.LNO
            AND L.EDT >= @SDTCUR + ' 00:00:00' 
            AND L.EDT <= @LDTCUR +' 23:59:59'
      GROUP BY 
            MCLTCODE, 
            EXCHANGE, 
            SEGMENT, 
            PARTY_CODE
) T
WHERE 
      MARGINLEDGER.MCLTCODE = T.MCLTCODE 
      AND MARGINLEDGER.EXCHANGE = T.EXCHANGE 
      AND MARGINLEDGER.SEGMENT=T.SEGMENT
      AND MARGINLEDGER.PARTY_CODE = T.PARTY_CODE 
      AND MARGINLEDGER.VTYP = 18

GO
