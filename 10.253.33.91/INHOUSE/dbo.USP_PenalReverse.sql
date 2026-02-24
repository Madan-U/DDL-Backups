-- Object: PROCEDURE dbo.USP_PenalReverse
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE PROCEDURE Usp_penalreverse 
AS 
    SET nocount ON 

    DECLARE @FromDate AS DATETIME, 
            @ToDate   AS DATETIME 

    SELECT @FromDate = sdtcur 
    FROM   account.dbo.parameter 
    WHERE  sdtnxt = (SELECT sdtcur 
                     FROM   account.dbo.parameter 
                     WHERE  sdtcur <= Getdate() 
                            AND ldtcur >= Getdate()) 

    SET @ToDate=CONVERT(DATETIME, CONVERT(VARCHAR(10), Getdate(), 101) 
                                  + ' 23:59:59') 

    SELECT vno, 
           vtyp 
    INTO   #bb 
    FROM   account.dbo.ledger WITH (nolock) 
    WHERE  cltcode = '560001' 
           AND vdt >= @FromDate 
           AND vdt <= @ToDate 
           AND drcr = 'D' 
           AND vtyp = 8 

    CREATE CLUSTERED INDEX idxvno 
      ON #bb (vno, vtyp) 

    TRUNCATE TABLE penalrev_table 

    INSERT INTO penalrev_table 
                (revdate, 
                 party_code, 
                 revamount) 
    SELECT vdt=CONVERT(DATETIME, CONVERT(VARCHAR(11), vdt)), 
           cltcode, 
           Vamt=Sum(vamt) 
    FROM   (SELECT a.vdt, 
                   a.cltcode, 
                   a.vamt 
            FROM   account.dbo.ledger a WITH (nolock) 
                   INNER JOIN #bb b 
                           ON a.vno = b.vno 
                              AND a.vtyp = b.vtyp 
                              /* and vdt>=@FromDate and vdt <=@ToDate */ 
                              AND drcr = 'C') X 
    GROUP  BY CONVERT(DATETIME, CONVERT(VARCHAR(11), vdt)), 
              cltcode 

    SET nocount OFF

GO
