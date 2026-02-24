-- Object: PROCEDURE dbo.ACC_GENVNO_NEW
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[ACC_GENVNO_NEW] 
           @VDT      VARCHAR(11),
           @VTYP     SMALLINT,
           @BOOKTYPE VARCHAR(2),
           @SDTCUR   VARCHAR(11),
           @LDTCUR   VARCHAR(11),
           @NOREC    INT  = 0
                            
AS
  DECLARE  @@VOUDT    AS DATETIME,
           @@MAXVNO   AS NUMERIC(12,0),
           @@VNOFLAG  AS TINYINT,
           @@VNO      AS VARCHAR(12),
           @@RCNT     AS INT
                         
  SET XACT_ABORT ON
  
  BEGIN TRANSACTION
  
  IF @NOREC = 0
    BEGIN
      SELECT @NOREC = @NOREC + 1
    END
    
  SELECT @SDTCUR = CONVERT(VARCHAR(11),SDTCUR,109),
         @LDTCUR = CONVERT(VARCHAR(11),LDTCUR,109),
         @@VNOFLAG = VNOFLAG,
         @@VOUDT = (SELECT CONVERT(DATETIME,@VDT))
  FROM   PARAMETER
  WHERE  @VDT BETWEEN SDTCUR AND LDTCUR
                                 
  IF @@VNOFLAG = 0 -- YEARLY
    BEGIN
      SELECT @@MAXVNO = ISNULL(MAX(CONVERT(NUMERIC,LASTVNO)),0)
      FROM   LASTVNO WITH (TABLOCKX ,HOLDLOCK)
      WHERE  VTYP = @VTYP
             AND BOOKTYPE = @BOOKTYPE
             AND VDT >= @SDTCUR + ' 00:00:00'
             AND VDT <= @LDTCUR + ' 23:59'
      
      IF @@MAXVNO = 0
        BEGIN
          SELECT @@VNO = RIGHT(RTRIM(@SDTCUR),4) + '00000001'
        END
      ELSE
        BEGIN
          SELECT @@VNO = RTRIM(CONVERT(VARCHAR,@@MAXVNO + 1))
        END
      
      SELECT @@RCNT = (SELECT COUNT(* )
                       FROM   LASTVNO
                       WHERE  VTYP = @VTYP
                              AND BOOKTYPE = @BOOKTYPE
                              AND VDT >= @SDTCUR + ' 00:00:00'
                              AND VDT <= @LDTCUR + ' 23:59')
    END
  ELSE
    IF @@VNOFLAG = 1 -- DAILY
      BEGIN
        SELECT @@MAXVNO = ISNULL(MAX(CONVERT(NUMERIC,LASTVNO)),0)
        FROM   LASTVNO WITH (TABLOCKX ,HOLDLOCK)
        WHERE  VTYP = @VTYP
               AND BOOKTYPE = @BOOKTYPE
               AND VDT LIKE @VDT + '%'
        
        IF @@MAXVNO = 0
          BEGIN
            SELECT @@VNO = (SELECT CONVERT(VARCHAR,YEAR(@@VOUDT)) + RIGHT('0' + LTRIM(CONVERT(VARCHAR,MONTH(@@VOUDT))),
                                                                          2) + RIGHT('00' + LTRIM(CONVERT(VARCHAR,DAY(@@VOUDT))),
                                                                                     2)) + '0001'
          END
        ELSE
		IF LEFT(@@maxvno,8) <> LEFT(@@maxvno + 1,8) AND LEFT(@@maxvno,4) = CONVERT(VARCHAR,YEAR(@@voudt)) 
          BEGIN
            SELECT @@vno = (SELECT LEFT(CONVERT(VARCHAR,YEAR(@@voudt)),1) + RIGHT(CONVERT(VARCHAR,YEAR(@@voudt)),2) + RIGHT('0' + LTRIM(CONVERT(VARCHAR,MONTH(@@voudt))),
                                                                          2) + RIGHT('00' + LTRIM(CONVERT(VARCHAR,DAY(@@voudt))),
                                                                                     2)) + '10000'
          END 
          ELSE 
          BEGIN 
			IF LEFT(@@maxvno,8) <> LEFT(@@maxvno + @NOREC,8) AND LEFT(@@maxvno,4) = CONVERT(VARCHAR,YEAR(@@voudt)) 
			  BEGIN
				SELECT @@vno = (SELECT LEFT(CONVERT(VARCHAR,YEAR(@@voudt)),1) + RIGHT(CONVERT(VARCHAR,YEAR(@@voudt)),2) + RIGHT('0' + LTRIM(CONVERT(VARCHAR,MONTH(@@voudt))),
																			  2) + RIGHT('00' + LTRIM(CONVERT(VARCHAR,DAY(@@voudt))),
																						 2)) + '0' + CONVERT(VARCHAR,CONVERT(INT,RIGHT(@@maxvno,4)) + 1)
			  END 
			  ELSE 
				BEGIN
				  SELECT @@vno = RTRIM(CONVERT(VARCHAR,@@maxvno + 1))
				END
            END 

        SELECT @@RCNT = (SELECT COUNT(* )
                         FROM   LASTVNO
                         WHERE  VTYP = @VTYP
                                AND BOOKTYPE = @BOOKTYPE
                                AND VDT >= @SDTCUR + ' 00:00:00'
                                AND VDT LIKE @VDT + '%')
      END
    ELSE
      IF @@VNOFLAG = 2 -- MONTHLY
        BEGIN
          SELECT @@MAXVNO = ISNULL(MAX(CONVERT(NUMERIC,LASTVNO)),0)
          FROM   LASTVNO WITH (TABLOCKX ,HOLDLOCK)
          WHERE  VTYP = @VTYP
                 AND BOOKTYPE = @BOOKTYPE
                 AND YEAR(VDT) = YEAR(@@VOUDT)
                 AND MONTH(VDT) = MONTH(@@VOUDT)
          
          IF @@MAXVNO = 0
            BEGIN
              SELECT @@VNO = (SELECT CONVERT(VARCHAR,YEAR(@@VOUDT)) + RIGHT('0' + LTRIM(CONVERT(VARCHAR,MONTH(@@VOUDT))),
                                                                            2)) + '000001'
            END
          ELSE
            BEGIN
              SELECT @@VNO = RTRIM(CONVERT(VARCHAR,@@MAXVNO + 1))
            END
          
          SELECT @@RCNT = (SELECT COUNT(* )
                           FROM   LASTVNO
                           WHERE  VTYP = @VTYP
                                  AND BOOKTYPE = @BOOKTYPE
                                  AND YEAR(VDT) = YEAR(@@VOUDT)
                                  AND MONTH(VDT) = MONTH(@@VOUDT))
        END
  
  IF @@RCNT = 0
    BEGIN
      INSERT INTO LASTVNO
      VALUES     (@VTYP,
                  @BOOKTYPE,
                  @VDT,
                  CONVERT(VARCHAR(12),CONVERT(NUMERIC(12),@@VNO) + @NOREC - 1))
    END
  ELSE
    BEGIN
      IF @@VNOFLAG = 0 -- YEARLY
        BEGIN
          UPDATE LASTVNO WITH (TABLOCKX ,HOLDLOCK)
          SET    LASTVNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC(12),@@VNO) + @NOREC - 1)
          WHERE  VTYP = @VTYP
                 AND BOOKTYPE = @BOOKTYPE
                 AND VDT >= @SDTCUR + ' 00:00:00'
                 AND VDT <= @LDTCUR + ' 23:59'
        END
      ELSE
        IF @@VNOFLAG = 1 -- DAILY
          BEGIN
            UPDATE LASTVNO WITH (TABLOCKX ,HOLDLOCK)
            SET    LASTVNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC(12),@@VNO) + @NOREC - 1)
            WHERE  VTYP = @VTYP
                   AND BOOKTYPE = @BOOKTYPE
                   AND VDT LIKE @VDT + '%'
          END
        ELSE
          IF @@VNOFLAG = 2 -- MONTHLY 
            BEGIN
              UPDATE LASTVNO WITH (TABLOCKX ,HOLDLOCK)
              SET    LASTVNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC(12),@@VNO) + @NOREC - 1)
              WHERE  VTYP = @VTYP
                     AND BOOKTYPE = @BOOKTYPE
                     AND YEAR(VDT) = YEAR(@VDT)
                     AND MONTH(VDT) = MONTH(@VDT)
            END
    END
    
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      
      SELECT VNO = ''
    END
  ELSE
    BEGIN
      COMMIT TRANSACTION
      
      SELECT VNO = @@VNO
    END

GO
