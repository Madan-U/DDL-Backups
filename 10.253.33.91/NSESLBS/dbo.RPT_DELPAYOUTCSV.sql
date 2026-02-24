-- Object: PROCEDURE dbo.RPT_DELPAYOUTCSV
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DELPAYOUTCSV    
AS      
  
DECLARE  
	  @RMNO VARCHAR(20),	  
      @SETTNO VARCHAR(7),      
      @SETTTYPE VARCHAR(2),      
      @PARTY_CODE VARCHAR(10),      
      @ISIN VARCHAR(12),   
      @DELMARKQTY INT,
	  @DPTYPE VARCHAR(4),
	  @DPID VARCHAR(8),
	  @CLTDPID VARCHAR(16),
	  @BDPTYPE VARCHAR(4),
	  @BDPID VARCHAR(8),
	  @BCLTDPID VARCHAR(16),
      @DELQTY INT,      
      @SNO NUMERIC,      
      @DELCUR CURSOR,      
      @DELQTYCUR CURSOR      
  
SET NOCOUNT ON      
SET @DELCUR = CURSOR FOR      
      SELECT
			RMNO,   
            SETT_NO,  
            SETT_TYPE,  
            PARTY_CODE,  
            CERTNO,  
            QTY,
			DPTYPE,
			DPID,
			CLTDPID,
			BDPTYPE,
			BDPID,
			BCLTDPID   
      FROM DELPAYOUTCSV WITH(NOLOCK)   
      WHERE PROCESSEDFLAG = 0 
      ORDER BY SETT_NO,  
            SETT_TYPE,  
            PARTY_CODE,  
            SCRIP_CD,  
            CERTNO,
			BDPTYPE,
			BDPID,
			BCLTDPID     
  
      OPEN @DELCUR      
      FETCH NEXT FROM @DELCUR 
	  INTO @RMNO,@SETTNO,@SETTTYPE,@PARTY_CODE,@ISIN,@DELMARKQTY,
      @DPTYPE,@DPID,@CLTDPID,@BDPTYPE,@BDPID,@BCLTDPID
      WHILE @@FETCH_STATUS = 0       
      BEGIN      
            SET @DELQTYCUR = CURSOR FOR      
                  SELECT   
                        ISNULL(SUM(QTY),0)   
                  FROM DELTRANS D WITH(NOLOCK)  
                  WHERE SETT_NO = @SETTNO   
                        AND SETT_TYPE = @SETTTYPE   
                        AND PARTY_CODE = @PARTY_CODE   
                        AND CERTNO = @ISIN   
                        AND FILLER2 = 1   
                        AND DRCR = 'D'   
                        AND TRTYPE IN (904, 909)  
						AND BDPTYPE = @BDPTYPE
                        AND BDPID = @BDPID  
                        AND BCLTDPID = @BCLTDPID
                        AND DELIVERED = '0'
						AND DPTYPE = @DPTYPE
                        AND DPID = @DPID  
                        AND CLTDPID = @CLTDPID
  
            OPEN @DELQTYCUR      
            FETCH NEXT FROM @DELQTYCUR INTO @DELQTY      
            IF @DELQTY <= @DELMARKQTY AND @DELQTY > 0       
            BEGIN      
                  UPDATE   
                        DELTRANS   
                        SET TRTYPE = 905, 
						REASON = 'PAY-OUT'   
                  WHERE SETT_NO = @SETTNO   
                        AND SETT_TYPE = @SETTTYPE   
                        AND PARTY_CODE = @PARTY_CODE   
                        AND CERTNO = @ISIN   
                        AND FILLER2 = 1   
                        AND DRCR = 'D'   
                        AND TRTYPE IN (904, 909)  
						AND BDPTYPE = @BDPTYPE
                        AND BDPID = @BDPID  
                        AND BCLTDPID = @BCLTDPID
                        AND DELIVERED = '0'
						AND DPTYPE = @DPTYPE
                        AND DPID = @DPID  
                        AND CLTDPID = @CLTDPID

                  UPDATE   
                        DELPAYOUTCSV   
                        SET PROCESSEDFLAG = 1, PROCESSEDDATE = GETDATE()  
                  WHERE RMNO = @RMNO 
            END      
            ELSE      
            BEGIN      
                  CLOSE @DELQTYCUR      
                  DEALLOCATE @DELQTYCUR      
                  SET @DELQTYCUR = CURSOR FOR       
                        SELECT   
                              SNO,  
                              QTY   
                        FROM DELTRANS D WITH(NOLOCK)  
                        WHERE SETT_NO = @SETTNO   
                        AND SETT_TYPE = @SETTTYPE   
                        AND PARTY_CODE = @PARTY_CODE   
                        AND CERTNO = @ISIN   
                        AND FILLER2 = 1   
                        AND DRCR = 'D'   
                        AND TRTYPE IN (904, 909)  
						AND BDPTYPE = @BDPTYPE
                        AND BDPID = @BDPID  
                        AND BCLTDPID = @BCLTDPID
                        AND DELIVERED = '0'
						AND DPTYPE = @DPTYPE
                        AND DPID = @DPID  
                        AND CLTDPID = @CLTDPID
  
                  OPEN @DELQTYCUR      
                  FETCH NEXT FROM @DELQTYCUR INTO @SNO,@DELQTY      
                  WHILE @@FETCH_STATUS = 0       
                  BEGIN      
                        IF @DELQTY <= @DELMARKQTY AND @DELMARKQTY > 0       
                        BEGIN      
                              UPDATE   
                                    DELTRANS   
                                    SET TRTYPE = 905, 
									REASON = 'PAY-OUT'    
                              WHERE SNO = @SNO   
                          
                              UPDATE   
									DELPAYOUTCSV   
									SET PROCESSEDFLAG = 1, PROCESSEDDATE = GETDATE()  
							  WHERE RMNO = @RMNO   
                          
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
                                    QTY = @DELMARKQTY, 
									REASON = 'PAY-OUT'    
                              WHERE SNO = @SNO   
                          
                              UPDATE   
									DELPAYOUTCSV   
									SET PROCESSEDFLAG = 1, PROCESSEDDATE = GETDATE()  
							  WHERE RMNO = @RMNO  
                          
                        SET @DELMARKQTY = 0          
                        END      
                  FETCH NEXT FROM @DELQTYCUR INTO @SNO,@DELQTY      
                  END      
            END      
  
            CLOSE @DELQTYCUR      
            DEALLOCATE @DELQTYCUR      
            FETCH NEXT FROM @DELCUR INTO 
			@RMNO,@SETTNO,@SETTTYPE,@PARTY_CODE,@ISIN,@DELMARKQTY,
            @DPTYPE,@DPID,@CLTDPID,@BDPTYPE,@BDPID,@BCLTDPID    
      END      
  
      CLOSE @DELCUR      
      DEALLOCATE @DELCUR

GO
