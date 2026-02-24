-- Object: PROCEDURE dbo.Rpt_NSEDelBranchMark
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_NSEDELBRANCHMARK    
(
      @SETTNO VARCHAR(7),    
      @SETTTYPE VARCHAR(2),    
      @PARTY_CODE VARCHAR(10),    
      @ISIN VARCHAR(12)    
)

AS    

DECLARE     
      @DELMARKQTY INT,    
      @DELQTY INT,    
      @SNO NUMERIC,    
      @DELCUR CURSOR,    
      @DELQTYCUR CURSOR    

SET NOCOUNT ON    
SET @DELCUR = CURSOR FOR    
      SELECT 
            SETT_NO,
            SETT_TYPE,
            PARTY_CODE,
            CERTNO,
            DELMARKQTY=DELMARKQTY-PAYOUTGIVEN 
      FROM DELBRANCHMARK WITH(NOLOCK) 
      WHERE PARTY_CODE = @PARTY_CODE 
            AND CERTNO = @ISIN 
            AND SETT_NO = @SETTNO 
            AND SETT_TYPE = @SETTTYPE 
            AND APROVED = 1 
            AND DELMARKQTY-PAYOUTGIVEN > 0 
      ORDER BY SETT_NO,
            SETT_TYPE,
            PARTY_CODE,
            SCRIP_CD,
            SERIES,
            CERTNO 

      OPEN @DELCUR    
      FETCH NEXT FROM @DELCUR INTO @SETTNO,@SETTTYPE,@PARTY_CODE,@ISIN,@DELMARKQTY    
      WHILE @@FETCH_STATUS = 0     
      BEGIN    
            SET @DELQTYCUR = CURSOR FOR    
                  SELECT 
                        ISNULL(SUM(QTY),0) 
                  FROM DELTRANS D WITH(NOLOCK), 
                        DELIVERYDP DP WITH(NOLOCK) 
                  WHERE PARTY_CODE = @PARTY_CODE 
                        AND CERTNO = @ISIN 
                        AND SETT_NO = @SETTNO 
                        AND SETT_TYPE = @SETTTYPE 
                        AND FILLER2 = 1 
                        AND DRCR = 'D' 
                        AND TRTYPE = 904 
                        AND D.BDPID = DP.DPID 
                        AND D.BCLTDPID = DP.DPCLTNO 
                        AND DESCRIPTION NOT LIKE '%PLEDGE%' 
                        AND DELIVERED = '0' 

            OPEN @DELQTYCUR    
            FETCH NEXT FROM @DELQTYCUR INTO @DELQTY    
            IF @DELQTY <= @DELMARKQTY AND @DELQTY > 0     
            BEGIN    
                  UPDATE 
                        DELTRANS 
                        SET TRTYPE = 905 
                  FROM DELIVERYDP DP 
                  WHERE PARTY_CODE = @PARTY_CODE 
                        AND CERTNO = @ISIN 
                        AND SETT_NO = @SETTNO 
                        AND SETT_TYPE = @SETTTYPE 
                        AND FILLER2 = 1 
                        AND DRCR = 'D' 
                        AND TRTYPE = 904 
                        AND BDPID = DP.DPID 
                        AND BCLTDPID = DP.DPCLTNO 
                        AND DESCRIPTION NOT LIKE '%PLEDGE%' 
                        AND DELIVERED = '0' 
                  UPDATE 
                        DELBRANCHMARK 
                        SET PAYOUTGIVEN = PAYOUTGIVEN + @DELQTY 
                  WHERE APROVED = 1 
                        AND DELMARKQTY-PAYOUTGIVEN > 0 
                        AND PARTY_CODE = @PARTY_CODE 
                        AND CERTNO = @ISIN 
                        AND SETT_NO = @SETTNO 
                        AND SETT_TYPE = @SETTTYPE 
            END    
            ELSE    
            BEGIN    
                  CLOSE @DELQTYCUR    
                  DEALLOCATE @DELQTYCUR    
                  SET @DELQTYCUR = CURSOR FOR     
                        SELECT 
                              D.SNO,
                              QTY 
                        FROM DELTRANS D WITH(NOLOCK), 
                              DELIVERYDP DP WITH(NOLOCK) 
                        WHERE PARTY_CODE = @PARTY_CODE 
                              AND CERTNO = @ISIN 
                              AND SETT_NO = @SETTNO 
                              AND SETT_TYPE = @SETTTYPE 
                              AND FILLER2 = 1 
                              AND DRCR = 'D' 
                              AND TRTYPE = 904 
                              AND BDPID = DP.DPID 
                              AND BCLTDPID = DP.DPCLTNO 
                              AND DESCRIPTION NOT LIKE '%PLEDGE%' 
                              AND DELIVERED = '0' 

                  OPEN @DELQTYCUR    
                  FETCH NEXT FROM @DELQTYCUR INTO @SNO,@DELQTY    
                  WHILE @@FETCH_STATUS = 0     
                  BEGIN    
                        IF @DELQTY <= @DELMARKQTY AND @DELMARKQTY > 0     
                        BEGIN    
                              UPDATE 
                                    DELTRANS 
                                    SET TRTYPE = 905 
                              WHERE SNO = @SNO 
                        
                              UPDATE 
                                    DELBRANCHMARK 
                                    SET PAYOUTGIVEN = PAYOUTGIVEN + @DELQTY 
                              WHERE APROVED = 1 
                                    AND DELMARKQTY-PAYOUTGIVEN > 0 
                                    AND PARTY_CODE = @PARTY_CODE 
                                    AND CERTNO = @ISIN 
                                    AND SETT_NO = @SETTNO 
                                    AND SETT_TYPE = @SETTTYPE 
                        
                        SET @DELMARKQTY = @DELMARKQTY - @DELQTY    
                        END    
                        ELSE IF @DELMARKQTY > 0     
                        BEGIN    
                              INSERT 
                              INTO DELTRANS 
                              SELECT 
                                    SETT_NO,
                                    SETT_TYPE,
                                    REFNO,
                                    TCODE,
                                    TRTYPE,
                                    PARTY_CODE,
                                    SCRIP_CD,
                                    SERIES,
                                    QTY=@DELQTY-@DELMARKQTY, 
                                    FROMNO,
                                    TONO,
                                    CERTNO,
                                    FOLIONO,
                                    HOLDERNAME,
                                    REASON,
                                    DRCR,
                                    DELIVERED,
                                    ORGQTY,
                                    DPTYPE,
                                    DPID,
                                    CLTDPID, 
                                    BRANCHCD,
                                    PARTIPANTCODE,
                                    SLIPNO,
                                    BATCHNO,
                                    ISETT_NO,
                                    ISETT_TYPE,
                                    SHARETYPE,
                                    TRANSDATE, 
                                    FILLER1,
                                    FILLER2,
                                    FILLER3,
                                    BDPTYPE,
                                    BDPID,
                                    BCLTDPID,
                                    FILLER4,
                                    FILLER5 
                              FROM DELTRANS WITH(NOLOCK)
                              WHERE SNO = @SNO 
                        
                              UPDATE 
                                    DELTRANS 
                                    SET TRTYPE = 905, 
                                    QTY = @DELMARKQTY 
                              WHERE SNO = @SNO 
                        
                              UPDATE 
                                    DELBRANCHMARK 
                                    SET PAYOUTGIVEN = PAYOUTGIVEN + @DELMARKQTY 
                              WHERE APROVED = 1 
                                    AND DELMARKQTY-PAYOUTGIVEN > 0 
                                    AND PARTY_CODE = @PARTY_CODE 
                                    AND CERTNO = @ISIN 
                                    AND SETT_NO = @SETTNO 
                                    AND SETT_TYPE = @SETTTYPE 
                        
                        SET @DELMARKQTY = 0        
                        END    
                  FETCH NEXT FROM @DELQTYCUR INTO @SNO,@DELQTY    
                  END    
            END    

            CLOSE @DELQTYCUR    
            DEALLOCATE @DELQTYCUR    
            FETCH NEXT FROM @DELCUR INTO @SETTNO,@SETTTYPE,@PARTY_CODE,@ISIN,@DELMARKQTY    
      END    

      CLOSE @DELCUR    
      DEALLOCATE @DELCUR

GO
