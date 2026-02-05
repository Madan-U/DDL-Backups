-- Object: PROCEDURE citrus_usr.PR_SELECT_TRXGEN
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--BEGIN TRAN 
--PR_SELECT_TRXGEN 'C2C*|~*C2P*|~*P2C*|~*','21/05/2009','21/05/2009',600005,'BN',2,'HO','','Y','*|~*','|*~|',''
--ROLLBACK 
--select * from freeze_unfreeze_dtls
CREATE PROCEDURE [citrus_usr].[PR_SELECT_TRXGEN]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCHNO VARCHAR(10),  
@PA_BATCHTYPE VARCHAR(2),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20), 
@PA_POOL_ACCTNO VARCHAR(16),  
@pa_broker_yn CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20), 
@pa_output VARCHAR(20) output  
)  
  
AS  
BEGIN   
DECLARE @@L_TRX_CD VARCHAR(5)  
,@L_QTY varchar(100)  
,@L_TOTQTY VARCHAR(100)   
,@L_SQL VARCHAR(8000)  
,@l_TRX_TAB varchar(8000)  
,@remainingstring varchar(8000)  
,@foundat int  
,@delimeter  varchar(50)  
,@currstring  varchar(500)  
,@delimeterlength int  
,@L_TOTQTY1   VARCHAR(100)   
,@L_TOTQTY2   VARCHAR(100)   
,@L_TOTQTY3   VARCHAR(100)   
,@L_TOTQTY4   VARCHAR(100)   
,@L_TOTQTY5   VARCHAR(100)   
,@L_TOTQTY6   VARCHAR(100)   
,@L_TOTQTY7   VARCHAR(100)   
,@L_TOTQTY8   VARCHAR(100)   
,@L_TOTQTY9   varchar(100)  
,@L_TOTQTY10  varchar(100)  
,@L_TOTQTY11  varchar(100)
,@L_TOTQTY12  varchar(100)
,@L_TOTQTY13  varchar(100)
,@L_TOTQTY14  varchar(100)
,@L_TOTQTY15  varchar(100)
,@L_TOTQTY16  varchar(100)
,@L_TOTQTY17  varchar(100)
,@L_TOTQTY18  varchar(100)
,@L_TOTQTY19  varchar(100)
,@L_TOTQTY20  varchar(100)
,@L_TOT904QTY varchar(100)
,@L_TOT905QTY varchar(100)
,@L_TOTQTY936 varchar(100)
,@L_TOTQTY937 varchar(100)
,@L_TOT_REC INT  
,@L_DPM_ID INT  
,@L_TRANS_TYPE VARCHAR(100)  
,@L_DPMDPID VARCHAR(100)  
,@l_slip_no_rmks_yn char(1)

select   @l_slip_no_rmks_yn  = BITRM_BIT_LOCATION from bitmap_ref_mstr where bitrm_parent_cd = 'SLIPNO_IN_RMKS' and bitrm_deleted_ind = 1
   

SELECT @L_DPM_ID = DPM_ID , @L_DPMDPID = DPM_DPID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1     
  
DECLARE @l_table Table(outfile varchar(8000),qty varchar(8000),trans_desc varchar(50),dptd_id bigint)  
  
SET @delimeter        = '%'+ @ROWDELIMITER + '%'  
SET @delimeterlength = LEN(@ROWDELIMITER)  
SET @remainingstring = @PA_TRX_TAB    
  
  WHILE @remainingstring <> ''  
  BEGIN  
  --  
    SET @foundat = 0  
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)  
    --  
    IF @foundat > 0  
    BEGIN  
    --  
      SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)  
      SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @currstring      = @remainingstring  
      SET @remainingstring = ''  
    --  
    END  
    --  
    IF @currstring <> ''  
    BEGIN  
    --

      SET @l_TRX_TAB =citrus_usr.fn_splitval(@currstring,1)  
      IF @pa_broker_yn = 'Y'
      BEGIN
      --
      
								
								If @PA_BATCHTYPE = 'BN' -- START OF NEW BATCH  
										BEGIN 
                                        
 
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDD'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '925'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
												WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																																										AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
												AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> '' 
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ space(7)
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ space(2)  
												+ Space(8)   
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)     
												+ CASE WHEN DPTD_Settlement_no <> '' THEN ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)   END  
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
												+ REPLICATE(0,2)   
												+ 'IN000026'--Isnull(dptd_counter_dp_id,SPACE(8))
                                                + space(9)   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(50)
												+ CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END 
												--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))
                                                + SPACE(25)     
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID) 
												LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR D4 ON  D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)  
											, DP_ACCT_MSTR D2   
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--     
										END   

										IF @L_TRX_TAB = 'C2C'  
										BEGIN   
										--        
print '1'

												SET @@L_TRX_CD = '904'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' and DPTD_DPAM_ID =  DPAM_ID
												AND DPAM_DPM_ID = @L_DPM_ID 
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
												ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)   
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10) 
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    )
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												--+ ISNULL(dptd_counter_dp_id,Space(16))   
												+ ISNULL(dptd_counter_dp_id,Space(8))
												+ ISNULL(dptd_counter_demat_acct_no,Space(8))
												+ Replicate(0,2)  
												+ SPACE(8)    
												+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls , @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID   
												FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   , DP_ACCT_MSTR D2   
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID           
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--  
										END   

										IF @L_TRX_TAB = 'P2C'  
										BEGIN   
										--  
PRINT @l_slip_no_rmks_yn
												SET @@L_TRX_CD = '904'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID 
									AND DPAM_DPM_ID = @L_DPM_ID 
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)  
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)    
												+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    ) 
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												--+ ISNULL(dptd_counter_dp_id,Space(16)) --Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_SBA_NO,SPACE(8)) ELSE SPACE(16) end    
												+ ISNULL(dptd_counter_dp_id,Space(8))
												+ ISNULL(Right(dptd_counter_demat_acct_no,8),Space(8))
												+ Replicate(0,2)  
												+ ISNULL(dptd_counter_cmbp_id,Space(8))--Space(8)            
												+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND =1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 


							--  
										END   
										IF @L_TRX_TAB = 'C2P'  
										BEGIN   
										--            

												SET @@L_TRX_CD = '904'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' 
												AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID 
												AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)     
												+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ Isnull(convert(varchar,dptd_other_settlement_no),Space(7))   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												--+ ISNULL(dptd_counter_dp_id,Space(16))--space(16)   
												+ ISNULL(ENTM_NAME3,'')
												+ ISNULL(dptd_counter_demat_acct_no,Space(8))
												+ Replicate(0,2)  
												+ ISNULL(dptd_counter_cmbp_id,space(8))-- other cmbp id should come            
												+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls    
												, @L_QTY  
												, @L_TRX_TAB  
																																										, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  , ENTITY_MSTR 
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
                                                AND D1.dptd_counter_cmbp_id = ENTM_SHORT_NAME
												AND D1.DPTD_OTHER_SETTLEMENT_TYPE  = CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_TRASTM_CD = @@L_TRX_CD  
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--   
										END   

										IF @L_TRX_TAB = 'ATO'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '907'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
												ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)  
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(2)  
												+ Space(8)   
												+ Case When LEN(D5.SETTM_TYPE)=2 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)    WHEN LEN(D5.SETTM_TYPE)=0 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)    WHEN LEN(D4.SETTM_TYPE)=1 THEN + RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)     END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ ISNULL(dptd_settlement_no,Space(7))--Space(7)   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ SPACE(16)   
												+ SPACE(2)   
												+ Isnull(convert(char(8),dptd_counter_cmbp_id),SPACE(8))  
												+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
																																										, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)  
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') <> ''
                                                order by dptd_lst_upd_dt 




							--   
										END   

										IF @L_TRX_TAB = 'IDO'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '912'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ space(7)
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)   
												+ Case when LEN(D5.SETTM_TYPE)=2 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)  WHEN LEN(D5.SETTM_TYPE)=0 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)  WHEN LEN(D5.SETTM_TYPE)=1 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)   END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ Isnull(dptd_settlement_no,space(7))   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_ACCT_NO,SPACE(8)) ELSE SPACE(16) end    
												+ Space(4)--SPACE(2)   
												+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD THEN Isnull(dptd_counter_cmbp_id,SPACE(8)) Else Space(8) End    
												+ Space(4)--Case when LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ Space(19)--ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
																																										, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND =1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--   
										END   

										IF @L_TRX_TAB = 'DO'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '906'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)   
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(2)   
												+ Space(8)   
												+ Case When LEN(D5.SETTM_TYPE)=2 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)  WHEN LEN(D5.SETTM_TYPE)=0 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)   WHEN LEN(D5.SETTM_TYPE)=1 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)   END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ SPACE(41) 
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(35),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(73) as DpmTrxDtls    
												, @L_QTY  
												, @L_TRX_TAB  
																																										, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
													WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 


							--   
										END   
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'DMT'  
																BEGIN   
																--  
																		SET @@L_TRX_CD = '901'  
																		SELECT @L_QTY = ABS(SUM(demrd_qty))FROM demat_request_mstr,demat_request_dtls,DP_ACCT_MSTR WHERE demrd_demrm_id = demrm_id and demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND ISNULL(DEMRM_STATUS,'P') = 'P' AND ISNULL(DEMRM_INTERNAL_REJ,'') = '' AND LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = '' AND DEMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and demrm_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																		AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																		
																		--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


																		Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																		SELECT  
																			'901'  
																		+ 'A'   
																		+ Space(14)--Space(7)   
																		+ ISNULL(D2.DPAM_SBA_NO,space(8))   
																		+ ISNULL(demrm_ISIN,space(12))    
																		+ ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),15,3,'L','0'),space(18))--ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),12,3,'L','0'),space(15))    
																		+ SPACE(83)--Space(68)    
																		+ ISNULL(convert(char(35),DEMRM_SLIP_SERIAL_NO),space(35))   --ISNULL(convert(char(20),DEMRM_SLIP_SERIAL_NO),space(20))   
																		+ Isnull(convert(char(50),demrm_id),space(50))   --Isnull(convert(char(35),demrm_id),space(35))   
                                                                        + space(50)   --Isnull(convert(char(35),demrm_id),space(35))   
                                                                        + case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(20),DEMRD_FOLIO_NO),space(20)) else space(20) end          -- NEW
                                                                        + case when DEMRD_DISTINCTIVE_NO_FR='M' then 'M' else space(1) end          -- NEW
																		+ case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(3),DEMRD_CERT_NO),space(3)) else space(3) end         -- NEW 
                                                                        + SPACE(36)--Space(73) 
																		 as DpmTrxDtls   
																		, @L_QTY  
																		, @L_TRX_TAB  
																		, DEMRM_ID  
																		FROM demat_request_mstr D1 ,DEMAT_REQUEST_DTLS D3, DP_ACCT_MSTR D2   
																		WHERE D1.demrm_DPAM_ID = D2.DPAM_ID AND D1.DEMRM_ID=D3.DEMRD_DEMRM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																		and D1.demrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND ISNULL(D1.DEMRM_STATUS,'P')    = 'P'   
																		AND	ISNULL(D1.DEMRM_INTERNAL_REJ,'') = '' 
																		AND LTRIM(RTRIM(ISNULL(D1.DEMRM_BATCH_NO,''))) = ''  
																		AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																		and demrm_deleted_ind = 1 AND DEMRD_DELETED_IND=1  
																		AND Dpam_DELETED_IND = 1  
                                                                        order by demrm_lst_upd_dt 
																--     
												END   
								--  
												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'RMT'  
												BEGIN   
												--  
														SET @@L_TRX_CD = '902'  
														SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,dp_acct_mstr WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  AND ISNULL(REMRM_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = '' AND REMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and remrm_deleted_ind = 1  AND DPAM_DELETED_IND = 1  
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
              and isnull(REMRM_REPURCHASE_FLG,'') <> 'Y'
														--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


														Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
														SELECT    
															'902'  
														+ 'A'   
														+ Space(7)    
														+ ISNULL(D2.DPAM_SBA_NO,'')   
														+ ISNULL(remrm_ISIN,'')    
														+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
													 + '00' 
														+ Space(8)
														+ Space(31)
														+ ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
														+ Space(19)           
														+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
														+ Isnull(convert(char(35),remrm_id),space(35))   
														+ Space(73)  
                                                        as DpmTrxDtls   
														, @L_QTY  
														, @L_TRX_TAB  
														, REMRM_ID  
														FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
														WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'  
														AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = '' 
														AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
														and remrm_deleted_ind = 1   
														and dpam_deleted_ind = 1   
              and isnull(REMRM_REPURCHASE_FLG,'') <> 'Y' 
              order by remrm_lst_upd_dt                                 
												--     
													END  

            IF LTRIM(RTRIM(@L_TRX_TAB)) = 'REPRMT'  
												BEGIN   
												--  
														SET @@L_TRX_CD = '900'  
														SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,dp_acct_mstr WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  AND ISNULL(REMRM_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = '' AND REMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and remrm_deleted_ind = 1  AND DPAM_DELETED_IND = 1  
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
              and isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
														--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


														Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
														SELECT    
															'900'  
														+ 'A'   
														+ Space(7)    
														+ ISNULL(D2.DPAM_SBA_NO,'')   
														+ ISNULL(remrm_ISIN,'')    
														+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
													 + '00' 
														+ Space(8)
														+ Space(31)
														+ ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
														+ Space(19)           
														+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
														+ Isnull(convert(char(35),remrm_id),space(35))   
														+ Space(73)  
                                                        as DpmTrxDtls   
														, @L_QTY  
														, @L_TRX_TAB  
														, REMRM_ID  
														FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
														WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'  
														AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = '' 
														AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
														and remrm_deleted_ind = 1   
														and dpam_deleted_ind = 1    
              and isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
              order by remrm_lst_upd_dt                                 
												--     
													END  
 

												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'P2P'  
												BEGIN   
												--  
														SET @@L_TRX_CD = '934'  
														SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
														AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
														--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

														Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
														SELECT   
															ISNULL(DPTD_TRASTM_CD,'')   
														+ 'A'   
														+ '0000000'   
														+ ISNULL(D2.DPAM_SBA_NO,'')   
														+ ISNULL(DPTD_ISIN,'')    
														+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
														+ '00'  
														+ Space(8)   
														+ Case When LEN(D5.SETTM_TYPE)=2 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)  WHEN LEN(D5.SETTM_TYPE)=0 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)  WHEN LEN(D4.SETTM_TYPE)=1 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)   END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
														+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
														+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
														+ Space(24)               
														+ Isnull(dptd_counter_cmbp_id,SPACE(8))   
														+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
														+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
														+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
														+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
														+ SPACE(88) as DpmTrxDtls    
														, @L_QTY  
														, @L_TRX_TAB  
														, DPTD_ID  
														FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
															WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
														AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
														AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
														AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
														AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
														AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
														AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
														AND D1.DPTD_DELETED_IND = 1   
														AND DPAM_DELETED_IND = 1                                   
														AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                        order by dptd_lst_upd_dt 
												--     
														END   

												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDDR'  
												BEGIN 
								SET @@L_TRX_CD = '926'  
								SELECT @L_QTY = ABS(SUM(DPTD_QTY)) FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
								WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
								AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
								AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
								AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
								AND DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
								--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


								Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
								SELECT   
									ISNULL(DPTD_TRASTM_CD,'')   
								+ 'A'   
								+ space(7)  
								+ ISNULL(D2.DPAM_SBA_NO,'')   
								+ ISNULL(DPTD_ISIN,'')    
								+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
								+ space(2)
								+ Space(8)   
								+ CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  WHEN LEN(D3.SETTM_TYPE)=0 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  WHEN LEN(D3.SETTM_TYPE)=1 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2) ELSE  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  END    
								+ CASE WHEN DPTD_Settlement_no<>'' THEN ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)  END --Space(7)   
								+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
								+ Space(6)   
								+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
								+ REPLICATE(0,2)    
								+ Isnull(dptd_counter_dp_id,SPACE(8))   
								+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
		                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                + CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END 
								+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))     
								+ SPACE(88) as DpmTrxDtls   
								, @L_QTY  
								, @L_TRX_TAB  
											, DPTD_ID  
								FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID)   
																									LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON  D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																									, DP_ACCT_MSTR D2 
								WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  


								AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
								AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
								AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
								AND D1.DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                order by dptd_lst_upd_dt 
												END  

												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2CR'  
												BEGIN 
								SET @@L_TRX_CD = '905'  
								SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
								WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
								AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
								AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
								AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
								AND DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
								--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


								Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
								SELECT    
									ISNULL(DPTD_TRASTM_CD,'')   
								+ 'A'   
								+ Space(7)   
								+ ISNULL(D2.DPAM_SBA_NO,'')   
								+ ISNULL(DPTD_ISIN,'')    
								+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
								+ Space(2)   
								+ Space(8)   
								+ CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  WHEN LEN(D3.SETTM_TYPE)=0 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  WHEN LEN(D3.SETTM_TYPE)=1 THEN  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  ELSE  RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)  END    
								+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
								+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
								+ Space(6)   
								+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
								+ Replicate(0,2)     
								+ SPACE(8)--Isnull(dptd_counter_dp_id,SPACE(8))   
								+ SPACE(9)--Case when LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1)  END    
								--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
								+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
		                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                + SPACE(88) as DpmTrxDtls   
								, @L_QTY  
								, @L_TRX_TAB  
											, DPTD_ID  
										FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID) , DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3  
								WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
								AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   				  
								AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
								AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
								AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
								AND D1.DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                               order by dptd_lst_upd_dt 
												END  

												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2PR'  
												BEGIN 
								SET @@L_TRX_CD = '905'  
								SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
								WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
								AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
								AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
								AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
								AND DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
								--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


								Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
								SELECT    
									ISNULL(DPTD_TRASTM_CD,'')   
								+ 'A'   
								+ Space(7)
								+ ISNULL(D2.DPAM_SBA_NO,'')   
								+ ISNULL(DPTD_ISIN,'')    
								+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
								+ Space(2)
								+ Space(8)   
								+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1) ELSE isnull(D3.SETTM_TYPE,SPACE(2)) END    
								+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
								+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
								+ Space(6)   
								+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
								+ Replicate(0,2)     
								+ Isnull(dptd_counter_dp_id,SPACE(8))  
																				+ Space(9)    
								--+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
								--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
								+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
		                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                + SPACE(88) as DpmTrxDtls   
								, @L_QTY  
								, @L_TRX_TAB  
											, DPTD_ID  
								FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3,SETTLEMENT_TYPE_MSTR D4  
								WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
								AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   
								AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
								AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
								AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
								AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
								AND D1.DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                order by dptd_lst_upd_dt 
												END    


										END  -- END OF NEW BATCH   



										If @PA_BATCHTYPE = 'BE' -- START OF EXISTING BATCH  
										BEGIN  

												
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDD'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '925'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
												WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
																																										AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
												AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
												AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												and dptd_deleted_ind = 1             
												AND DPAM_DELETED_IND = 1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') <> ''

												Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT   
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ space(7)   
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ space(2)  
												+ Space(8)   
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ CASE WHEN DPTD_Settlement_no<>'' THEN ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)   END
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
												+ REPLICATE(0,2)   
												+ 'IN000026'--Isnull(dptd_counter_dp_id,SPACE(8)) 
												+ SPACE(9)              
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(50) 
												+ CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END    
												+ SPACE(25) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID)  
											LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON  D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												, DP_ACCT_MSTR D2 
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 
							--     
										END   

										IF @L_TRX_TAB = 'C2C'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '904'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY)) FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN   
												CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND   
																																										CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND   
												DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND  
												DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and  
												ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
																																										AND Dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT   
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)      
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)  
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    )
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ ISNULL(dptd_counter_dp_id,Space(8))
												+ ISNULL(dptd_counter_demat_acct_no,Space(8))
												+ Replicate(0,2)  
												+ SPACE(8)    
												+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls , @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)  , DP_ACCT_MSTR D2   
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID            
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1    
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--  
										END   

										IF @L_TRX_TAB = 'P2C'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '904'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE   
												DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
												AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
												AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												and dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT   
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)  
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)      
												+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    ) 
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												--+ ISNULL(dptd_counter_dp_id,Space(16)) --Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_ACCT_NO,SPACE(8)) ELSE SPACE(16) end    
												+ ISNULL(dptd_counter_dp_id,Space(8))
												+ ISNULL(Right(dptd_counter_demat_acct_no,8),Space(8))
												+ Replicate(0,2)   
												+ ISNULL(dptd_counter_cmbp_id,Space(8)) --Space(8)            
												+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--  
										END   
										IF @L_TRX_TAB = 'C2P'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '904'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY)) FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE   
												DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
												AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
												AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND ISNULL(DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												and dptd_deleted_ind = 1 AND DPAM_DELETED_IND =1 
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT   
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)   
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)    
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1) ELSE ISNULL(D4.SETTM_TYPE,SPACE(2))   END    
												+ Isnull(convert(varchar,dptd_other_settlement_no),Space(7))   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												--+ ISNULL(dptd_counter_dp_id,Space(16))--space(16)
												+ ISNULL(ENTM_NAME3,'')
												+ ISNULL(dptd_counter_demat_acct_no,Space(8))   
												+ Replicate(0,2)    
												+ ISNULL(dptd_counter_cmbp_id,space(8))           
												+ Space(9)--ISNULL(dptd_counter_cmbp_id,space(8)) --ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls    
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  , ENTITY_MSTR
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
                                                AND  D1.dptd_counter_cmbp_id = ENTM_SHORT_NAME 
												AND D1.DPTD_OTHER_SETTLEMENT_TYPE  = CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_TRASTM_CD = @@L_TRX_CD  
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO 
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND =1   
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 

							--   
										END   

										IF @L_TRX_TAB = 'ATO'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '907'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR  
												WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD   
												AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																																										AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												and dptd_deleted_ind = 1 AND DPAM_DELETED_IND =1   
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT   
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7)  
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(2) 
												+ Space(8)   
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ ISNULL(dptd_settlement_no,Space(7))--Space(7)   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ SPACE(16)   
												+ SPACE(2)   
												+ Isnull(convert(char(8),dptd_counter_cmbp_id),SPACE(8))  
												+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
												+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)  
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO 
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND =1   
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                order by dptd_lst_upd_dt 



							--   
										END   

										IF @L_TRX_TAB = 'IDO'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '912'  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
												WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
												AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
												AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND ISNULL(DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												and dptd_deleted_ind = 1 AND DPAM_DELETED_IND =1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT  
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ space(7)   
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(10)   
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case when LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D5.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ Isnull(dptd_settlement_no,space(7))   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ Space(6)   
												+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_ACCT_NO,SPACE(8)) ELSE SPACE(16) end    
												+ Space(4)--SPACE(2)   
												+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD THEN Isnull(dptd_counter_cmbp_id,SPACE(8)) Else Space(8) End    
												+ Space(4)--Case when LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ Space(19)--ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(88) as DpmTrxDtls   
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
												WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
                                                              order by dptd_lst_upd_dt 

							--   
										END   

										IF @L_TRX_TAB = 'DO'  
										BEGIN   
										--  
												SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
												WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
												AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD   
												AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																																										AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												and dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL(DPTD_TRASTM_CD,'')   
												+ 'A'   
												+ Space(7) 
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ ISNULL(DPTD_ISIN,'')    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
												+ Space(2)  
												+ Space(8)   
												+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D5.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
												+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
												+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
												+ SPACE(41) 
												+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                + SPACE(73) as DpmTrxDtls    
												, @L_QTY  
												, @L_TRX_TAB  
												, DPTD_ID  
												FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
														WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
												--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
												AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
												AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
												AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
												AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO  
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND D1.DPTD_DELETED_IND = 1   
												AND DPAM_DELETED_IND = 1  
												AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
												order by dptd_lst_upd_dt 


							--   
										END   
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'DMT'  
																BEGIN   
																--  
																		SET @@L_TRX_CD = '901'  
																		SELECT @L_QTY = ABS(SUM(demrd_qty))FROM demat_request_mstr,demat_request_dtls,DP_ACCT_MSTR   
																						WHERE demrd_demrm_id = demrm_id and demrm_request_dt   
																						BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																						AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																						AND DEMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
																						AND ISNULL(DEMRM_STATUS,'P')    = 'P'
																						AND	ISNULL(DEMRM_INTERNAL_REJ,'') = ''    
																						AND LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = @PA_BATCHNO  
																						and demrm_deleted_ind = 1 AND DPAM_DELETED_IND =1 
																						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																		--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


																		Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																		SELECT  
																			'901'  
																		+ 'A'   
																		+ Space(14)--Space(7)   
																		+ ISNULL(D2.DPAM_SBA_NO,space(8))   
																		+ ISNULL(demrm_ISIN,space(12))    
																		+ ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),15,3,'L','0'),space(18))--ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),12,3,'L','0'),space(15))    
																		+ SPACE(83)--Space(68)    
																		+ ISNULL(convert(char(35),DEMRM_SLIP_SERIAL_NO),space(35))   --ISNULL(convert(char(20),DEMRM_SLIP_SERIAL_NO),space(20))   
																		+ Isnull(convert(char(50),demrm_id),space(50))   --Isnull(convert(char(35),demrm_id),space(35))   
                                                                        + space(50)   --Isnull(convert(char(35),demrm_id),space(35))   
                                                                        + case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(20),DEMRD_FOLIO_NO),space(20)) else space(20) end          -- NEW
                                                                        + case when DEMRD_DISTINCTIVE_NO_FR='M' then 'M' else space(1) end          -- NEW
																		+ case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(3),DEMRD_CERT_NO),space(3)) else space(3) end                                                                         + SPACE(36)--Space(73) 
																		 as DpmTrxDtls   
																		, @L_QTY  
																		, @L_TRX_TAB  
																		, DEMRM_ID  
																		FROM demat_request_mstr D1 ,DEMAT_REQUEST_DTLS D3, DP_ACCT_MSTR D2   
																		WHERE D1.demrm_DPAM_ID = D2.DPAM_ID AND D1.DEMRM_ID=D3.DEMRD_DEMRM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																		and D1.demrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND ISNULL(D1.DEMRM_STATUS,'P')    = 'P'   
																		AND	ISNULL(D1.DEMRM_INTERNAL_REJ,'') = '' 
																		AND LTRIM(RTRIM(ISNULL(D1.DEMRM_BATCH_NO,''))) = @PA_BATCHNO 
																		AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																		and demrm_deleted_ind = 1 AND DEMRD_DELETED_IND=1  
																		AND Dpam_DELETED_IND = 1  
                                                                        order by demrm_lst_upd_dt 

																--     
												END   
								--  
												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'RMT'  
												BEGIN   
												--  
														SET @@L_TRX_CD = '902'  
														SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,DP_ACCT_MSTR   
														WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
														AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND REMRM_DPAM_ID =  DPAM_ID   
														AND DPAM_DPM_ID = @L_DPM_ID   
														AND ISNULL(REMRM_STATUS,'P')    = 'P'   
														AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = @PA_BATCHNO  
														and remrm_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
              and  isnull(REMRM_REPURCHASE_FLG,'') <> 'Y'
														--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


														insert into @l_table (outfile,qty,trans_desc,dptd_id)   
														SELECT  
														'902'  
														+ 'A'   
														+ space(7)    
														+ ISNULL(D2.DPAM_SBA_NO,'')   
														+ ISNULL(remrm_ISIN,'')    
														+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
														 + '00' 
														+ Space(8)
														+ Space(31)
														+ ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
														+ Space(19)       
														+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
														+ Isnull(convert(char(35),remrm_id),space(35))   
														+ SPACE(73) as DpmTrxDtls   
														, @L_QTY  
														, @L_TRX_TAB  
														, REMRM_ID  
														FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
														WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
															and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'   
															AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = @PA_BATCHNO  
															AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															and remrm_deleted_ind = 1   
															AND DPAM_DELETED_IND  = 1  
               and  isnull(REMRM_REPURCHASE_FLG,'') <> 'Y'
															order by remrm_lst_upd_dt             

												--     
												END   

            IF LTRIM(RTRIM(@L_TRX_TAB)) = 'REPRMT'  
												BEGIN   
												--  
														SET @@L_TRX_CD = '900'  
														SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,DP_ACCT_MSTR   
														WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
														AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND REMRM_DPAM_ID =  DPAM_ID   
														AND DPAM_DPM_ID = @L_DPM_ID   
														AND ISNULL(REMRM_STATUS,'P')    = 'P'   
														AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = @PA_BATCHNO  
														and remrm_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
              and  isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
														--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


														insert into @l_table (outfile,qty,trans_desc,dptd_id)   
														SELECT  
														'900'  
														+ 'A'   
														+ space(7)    
														+ ISNULL(D2.DPAM_SBA_NO,'')   
														+ ISNULL(remrm_ISIN,'')    
														+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
														+ '00' 
														+ Space(8)
														+ Space(31)
														+ ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
														+ Space(19)       
														+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
														+ Isnull(convert(char(35),remrm_id),space(35))   
														+ SPACE(73) as DpmTrxDtls   
														, @L_QTY  
														, @L_TRX_TAB  
														, REMRM_ID  
														FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
														WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
															and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
															AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'   
															AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = @PA_BATCHNO  
															AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
															and remrm_deleted_ind = 1   
															AND DPAM_DELETED_IND  = 1  
               and  isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
															order by remrm_lst_upd_dt             

												--     
																				END   


												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'P2P'  
												BEGIN   
												--  
														SET @@L_TRX_CD = '934'                 
														SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
														WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
														AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD   
														AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
														AND ISNULL(DPTD_STATUS,'P')    = 'P'   
														AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
														and dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
														AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
													--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

																	Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
														SELECT   
															ISNULL(DPTD_TRASTM_CD,'')   
														+ 'A'   
														+ '0000000'   
														+ ISNULL(D2.DPAM_SBA_NO,'')   
														+ ISNULL(DPTD_ISIN,'')    
														+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
														+ '00'  
														+ Space(8)   
														+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
														+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
														+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
														+ Space(24)               
														+ Isnull(dptd_counter_cmbp_id,SPACE(8))   
														+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
														+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
														+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
														+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
														+ SPACE(88) as DpmTrxDtls    
														, @L_QTY  
														, @L_TRX_TAB  
														, DPTD_ID  
														FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
															WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
														AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
														AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
														AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
														AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
														AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
														AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
														AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
														AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
														AND D1.DPTD_DELETED_IND = 1   
														AND DPAM_DELETED_IND = 1  
														AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
														order by dptd_lst_upd_dt

												--     
														END   
												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDDR'  
												BEGIN 
							SET @@L_TRX_CD = '926'  
							SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
							WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
													AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
							AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
							AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
							AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
							and dptd_deleted_ind = 1             
							AND DPAM_DELETED_IND = 1  
							AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
							AND isnull(DPTD_BROKERBATCH_NO,'') <> ''

							Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
							SELECT 
								ISNULL(DPTD_TRASTM_CD,'')   
							+ 'A'   
							+ Space(7)    
							+ ISNULL(D2.DPAM_SBA_NO,'')   
							+ ISNULL(DPTD_ISIN,'')    
							+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
							+ Space(2)   
							+ Space(8)   
							+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1) ELSE isnull(D3.SETTM_TYPE,space(2))  END    
							+ CASE WHEN DPTD_Settlement_no<>'' THEN  ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)   END
							+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
							+ Space(6)   
							+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
							+ REPLICATE(0,2)  
							+ Isnull(dptd_counter_dp_id,SPACE(8))   
							+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						    + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                            + CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END 
							+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))     
							+ SPACE(88) as DpmTrxDtls   
							, @L_QTY  
							, @L_TRX_TAB  
							, DPTD_ID  
							FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID)
																					LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4  ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)    
																					, DP_ACCT_MSTR D2 
							WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
							AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
							AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
							AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
							AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO
							AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
							AND D1.DPTD_DELETED_IND = 1   
							AND DPAM_DELETED_IND = 1  
							AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
							order by dptd_lst_upd_dt
												END 

												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2CR'  
												BEGIN 
							SET @@L_TRX_CD = '905'  
							SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
							WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
													AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
							AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
							AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
							AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
							and dptd_deleted_ind = 1             
							AND DPAM_DELETED_IND = 1  
							AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
							AND isnull(DPTD_BROKERBATCH_NO,'') <> ''

							Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
							SELECT  
								ISNULL(DPTD_TRASTM_CD,'')   
							+ 'A'   
							+ Space(7)     
							+ ISNULL(D2.DPAM_SBA_NO,'')   
							+ ISNULL(DPTD_ISIN,'')    
							+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
							+ Space(2)     
							+ Space(8)   
							+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
							+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
							+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
							+ Space(6)   
							+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
							+ Replicate(0,2)    
							+ Isnull(dptd_counter_dp_id,SPACE(8)) 
																+ SPACE(9) 
							--+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
							--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7)) 
							+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
	                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                            + SPACE(88) as DpmTrxDtls   
							, @L_QTY  
							, @L_TRX_TAB  
							, DPTD_ID  
								FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID) , DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3 
								WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
								AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   				  
								AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
								AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
								AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
								AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
								AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
								AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
								AND D1.DPTD_DELETED_IND = 1   
								AND DPAM_DELETED_IND = 1  
								AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
								order by dptd_lst_upd_dt
												END 
												IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2PR'  
												BEGIN 
							SET @@L_TRX_CD = '905'  
							SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
							WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
													AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
							AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
							AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
							AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
							and dptd_deleted_ind = 1             
							AND DPAM_DELETED_IND = 1  
							AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
							AND isnull(DPTD_BROKERBATCH_NO,'') <> ''

							Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
							SELECT    
								ISNULL(DPTD_TRASTM_CD,'')   
							+ 'A'   
							+ Space(7)   
							+ ISNULL(D2.DPAM_SBA_NO,'')   
							+ ISNULL(DPTD_ISIN,'')    
							+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
							+ Space(2)    
							+ Space(8)   
							+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
							+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
							+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
							+ Space(6)   
							+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
							+ REPLICATE(0,2)   
							+ Isnull(dptd_counter_dp_id,SPACE(8))  
																+ SPACE(9)  
							--+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
							--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
							+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
	                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                            + SPACE(88) as DpmTrxDtls   
							, @L_QTY  
							, @L_TRX_TAB  
							, DPTD_ID  
							FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3,SETTLEMENT_TYPE_MSTR D4  
							WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
							AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   
							AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
							AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
							AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
							AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
							AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO
							AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
							AND D1.DPTD_DELETED_IND = 1   
							AND DPAM_DELETED_IND = 1  
							AND isnull(DPTD_BROKERBATCH_NO,'') <> ''
							order by dptd_lst_upd_dt
												END 



								END  -- END OF EXISTING BATCH              
						--
						END -- BROKER_YN
						ELSE IF @pa_broker_yn = 'N'
						BEGIN
						--

						  If @PA_BATCHTYPE = 'BN' -- START OF NEW BATCH  
																		BEGIN  


                                        IF LTRIM(RTRIM(@L_TRX_TAB)) = 'FRZ'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '936'  
												SELECT @L_QTY = ABS(SUM(fre_QTY))FROM freeze_Unfreeze_dtls ,DP_ACCT_MSTR  
												WHERE fre_Dpam_id =  DPAM_ID and  fre_dpmid = DPAM_DPM_ID AND DPAM_DPM_ID = @L_DPM_ID  
                                                AND fre_ACTION = 'F'  
												--AND ISNULL(fre_status,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,''))) = ''  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' 
												AND fre_deleted_ind = 1   
												AND DPAM_DELETED_IND = 1  
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL('936','')   
												+ 'A'   
												+'0000000'--instrunction id
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ convert(char(12),ISNULL(fre_Isin_code,''))      
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(fre_QTY)),12,3,'L','0'),space(15))    
												+ case when (fre_type = 'A' and fre_QTY = 0 and fre_Isin_code = '') then '01'
															when (fre_type = 'D' and fre_QTY = 0 and fre_Isin_code = '') then '02'
															when (fre_level = 'I') then '03'
															when (fre_level = 'Q') then '04'
                                                            when (fre_type =  'C' ) then '05' end
												+ Space(8)   
												+ case when ISNULL(convert(char(2),FRE_REQ_INT_BY),'')  = '01' then 'Request by Investor' 
                                                       when ISNULL(convert(char(2),FRE_REQ_INT_BY),'')  = '02' then 'Other Reasons'
													   when ISNULL(convert(char(2),FRE_REQ_INT_BY),'')  = '03' then 'Request by Stat Auth' end  
												+ space(7)
												+ '00000000'--ISNULL(convert(varchar,fre_Exec_date,112),'')    
												+ Space(6)   
												+ space(8)
												+ '00000000'
												+ space(19)
                                                + CONVERT(CHAR(20),fre_id)
						                        + space(35)
                                                + space(35)
												+ space(20)
                                                + space(18)
												, @L_QTY  
												, @L_TRX_TAB  
                                                , fre_id
												FROM freeze_Unfreeze_dtls D1 
											       , DP_ACCT_MSTR D2   
												WHERE D1.fre_Dpam_id = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND D1.fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.fre_ACTION = 'F' 
												--AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,''))) = '' 
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.fre_deleted_ind = 1  
												order by fre_lst_upd_dt  
												
												

							--     
										END   
                                        IF LTRIM(RTRIM(@L_TRX_TAB)) = 'UNFRZ'  
										BEGIN   
										--  
												SET @@L_TRX_CD = '937'  
												SELECT @L_QTY = ABS(SUM(fre_QTY))FROM freeze_Unfreeze_dtls ,DP_ACCT_MSTR  
												WHERE fre_Dpam_id =  DPAM_ID and  fre_dpmid = DPAM_DPM_ID AND DPAM_DPM_ID = @L_DPM_ID  
                                                AND fre_ACTION = 'U' 
												--AND ISNULL(fre_status,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,''))) = ''  
												AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
												AND fre_deleted_ind = 1   
												AND DPAM_DELETED_IND = 1  
                                                AND fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'
												--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


												insert into @l_table (outfile,qty,trans_desc,dptd_id)   
												SELECT    
													ISNULL('937','')   
												+ 'A'   
												+ convert(char(7),right(('0000000' + FRE_TRNS_NO),7))--instrunction id
												+ ISNULL(D2.DPAM_SBA_NO,'')   
												+ convert(char(12),ISNULL(fre_Isin_code,''))    
												+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(fre_QTY)),12,3,'L','0'),space(15))    
												+ case when (fre_type = 'A' and fre_QTY = 0 and fre_Isin_code = '') then '01'
															when (fre_type = 'D' and fre_QTY = 0 and fre_Isin_code = '') then '02'
															when (fre_level = 'I') then '03'
															when (fre_level = 'Q') then '04'
                                                            when (fre_type =  'C' ) then '05' end
												+ Space(8)   
												+ ISNULL(convert(char(2),FRE_REQ_INT_BY),'')    
												+ space(7)
												+ ISNULL(convert(varchar(8),fre_Exec_date,112),'')    
												+ Space(6)   
												+ space(8)
												+ '00000000'
												+ space(19)
                                                + CONVERT(CHAR(20),fre_id)
						                        + space(35)
                                                + space(35)
												+ space(20)
                                                + space(18)
												, @L_QTY  
												, @L_TRX_TAB  
                                                , fre_id
												FROM freeze_Unfreeze_dtls D1 
											       , DP_ACCT_MSTR D2   
												WHERE D1.fre_Dpam_id = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
												AND D1.fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
												AND D1.fre_ACTION = 'U' 
												--AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
												AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,''))) = '' 
												AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
												AND D1.fre_deleted_ind = 1 
												order by fre_lst_upd_dt  
												
												

							--     
										END   

																		IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDD'  
																		BEGIN   
																		--  
																				SET @@L_TRX_CD = '925'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
																				WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																																																		AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																				AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																					ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ space(7)
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ space(2)  
																				+ Space(8)   
																				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)     
																				+ CASE WHEN DPTD_Settlement_no <> '' THEN ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)   END  
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ Space(6)   
																				+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
																				+ REPLICATE(0,2)   
																				+ 'IN000026'--Isnull(dptd_counter_dp_id,SPACE(8))
                                                                                + space(9)   
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(50) 
																				+ CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END 
																				--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))     
                                                                                + SPACE(25)
																				, @L_QTY  
																				, @L_TRX_TAB  
																				, DPTD_ID  
																				FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID) 
																				LEFT OUTER JOIN  SETTLEMENT_TYPE_MSTR D4 ON  ISNULL(D1.DPTD_OTHER_SETTLEMENT_TYPE,'')=CONVERT(VARCHAR,D4.SETTM_ID)  
																			, DP_ACCT_MSTR D2   
																				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
																				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt
								
															--     
																		END   
								
																		IF @L_TRX_TAB = 'C2C'  
																		BEGIN   
																		--        
								
																				SET @@L_TRX_CD = '904'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' and DPTD_DPAM_ID =  DPAM_ID
																				AND DPAM_DPM_ID = @L_DPM_ID 
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																				Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																				ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ Space(7)   
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ Space(10) 
																				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,'00') WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,'00') WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,'0') + '0' ELSE ISNULL(D4.SETTM_TYPE,SPACE(2))  END    
																				+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    )
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ Space(6)   
																				--+ ISNULL(dptd_counter_dp_id,Space(16))   
																				+ ISNULL(dptd_counter_dp_id,Space(8))
																				+ ISNULL(dptd_counter_demat_acct_no,Space(8))
																				+ Replicate(0,2)  
																				+ SPACE(8)    
																				+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(88) as DpmTrxDtls , @L_QTY  
																				, @L_TRX_TAB  
																				, DPTD_ID   
																				FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   , DP_ACCT_MSTR D2   
																				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID           
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt 
								
															--  
																		END   
								
																		IF @L_TRX_TAB = 'P2C'  
																		BEGIN   
																		--  
								
																				SET @@L_TRX_CD = '904'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID 
																	AND DPAM_DPM_ID = @L_DPM_ID 
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																					ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ Space(7)  
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ Space(10)    
																				+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
																				+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    ) 
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ Space(6)   
																				--+ ISNULL(dptd_counter_dp_id,Space(16)) --Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_SBA_NO,SPACE(8)) ELSE SPACE(16) end    
																				+ ISNULL(dptd_counter_dp_id,Space(8))
																				+ ISNULL(Right(dptd_counter_demat_acct_no,8),Space(8))
																				+ Replicate(0,2)  
																				+ Space(8)            
																				+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(88) as DpmTrxDtls   
																				, @L_QTY  
																				, @L_TRX_TAB  
																				, DPTD_ID  
																				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  
																				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND =1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt 
								
								
															--  
																		END   
																		IF @L_TRX_TAB = 'C2P'  
																		BEGIN   
																		--            
								
																				SET @@L_TRX_CD = '904'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' 
																				AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID 
																				AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																					ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ Space(7)
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ Space(10)     
																				+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
																				+ Isnull(convert(varchar,dptd_other_settlement_no),Space(7))   
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ Space(6)   
																				--+ ISNULL(dptd_counter_dp_id,Space(16))--space(16)   
																				+ ISNULL(ENTM_NAME3,'')
																				+ ISNULL(dptd_counter_demat_acct_no,Space(8))
																				+ Replicate(0,2)  
																				+ ISNULL(dptd_counter_cmbp_id,space(8))-- other cmbp id should come            
																				+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(88) as DpmTrxDtls    
																				, @L_QTY  
																				, @L_TRX_TAB  
																																																		, DPTD_ID  
																				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4 , ENTITY_MSTR 
																				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																				AND D1.DPTD_OTHER_SETTLEMENT_TYPE  = CONVERT(VARCHAR,D4.SETTM_ID)   
                                                                                AND D1.dptd_counter_cmbp_id = ENTM_SHORT_NAME
																				AND D1.DPTD_TRASTM_CD = @@L_TRX_CD  
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt 
								
															--   
																		END   
								
																		IF @L_TRX_TAB = 'ATO'  
																		BEGIN   
																		--  
																				SET @@L_TRX_CD = '907'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																				ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ Space(7)  
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ Space(2)  
																				+ Space(8)   
																				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
																				+ ISNULL(dptd_settlement_no,Space(7))--Space(7)   
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ Space(6)   
																				+ SPACE(16)   
																				+ SPACE(2)   
																				+ Isnull(convert(char(8),dptd_counter_cmbp_id),SPACE(8))  
																				+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
																				+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(88) as DpmTrxDtls   
																				, @L_QTY  
																				, @L_TRX_TAB  
																																																		, DPTD_ID  
																				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
																				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																				AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)  
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND = 1  
								            AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt 
								
								
								
															--   
																		END   
								
																		IF @L_TRX_TAB = 'IDO'  
																		BEGIN   
																		--  
																				SET @@L_TRX_CD = '912'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																				Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																					ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ space(7)  
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ Space(10)   
																				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case when LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D5.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
																				+ Isnull(dptd_settlement_no,space(7))   
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ Space(6)   
																				+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_ACCT_NO,SPACE(8)) ELSE SPACE(16) end    
																				+ Space(4)--SPACE(2)   
																				+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD THEN Isnull(dptd_counter_cmbp_id,SPACE(8)) Else Space(8) End    
																				+ Space(4)--Case when LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1)  END    
																				+ Space(19)--ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(88) as DpmTrxDtls   
																				, @L_QTY  
																				, @L_TRX_TAB  
																																																		, DPTD_ID  
																				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
																				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																				--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND =1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt 
								
															--   
																		END   
								
																		IF @L_TRX_TAB = 'DO'  
																		BEGIN   
																		--  

																				SET @@L_TRX_CD = '906'  
																				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																				Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																				SELECT    
																					ISNULL(DPTD_TRASTM_CD,'')   
																				+ 'A'   
																				+ Space(7)   
																				+ ISNULL(D2.DPAM_SBA_NO,'')   
																				+ ISNULL(DPTD_ISIN,'')    
																				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																				+ Space(2)   
																				+ Space(8)   
																				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D5.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
																				+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
																				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																				+ SPACE(41)  
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																				+ SPACE(73) as DpmTrxDtls    
																				, @L_QTY  
																				, @L_TRX_TAB  
																																																		, DPTD_ID  
																				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
																					WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																				  
																				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
																				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																				AND D1.DPTD_DELETED_IND = 1   
																				AND DPAM_DELETED_IND = 1  
																				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																				order by dptd_lst_upd_dt 
								
								
								
															--   
																		END   
																		IF LTRIM(RTRIM(@L_TRX_TAB)) = 'DMT'  
																								BEGIN   
																								--  
																										SET @@L_TRX_CD = '901'  
																										SELECT @L_QTY = ABS(SUM(demrd_qty))FROM demat_request_mstr,demat_request_dtls,DP_ACCT_MSTR WHERE demrd_demrm_id = demrm_id and demrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND ISNULL(DEMRM_STATUS,'P') = 'P' AND ISNULL(DEMRM_INTERNAL_REJ,'') = '' AND LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = '' AND DEMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and demrm_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																										AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																										--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																										Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																										SELECT  
																											'901'  
																										+ 'A'   
																										+ Space(14)--Space(7)   
																										+ ISNULL(D2.DPAM_SBA_NO,space(8))   
																										+ ISNULL(demrm_ISIN,space(12))    
																										+ ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),15,3,'L','0'),space(18))--ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),12,3,'L','0'),space(15))    
																										+ SPACE(83)--Space(68)    
																										+ ISNULL(convert(char(35),DEMRM_SLIP_SERIAL_NO),space(35))   --ISNULL(convert(char(20),DEMRM_SLIP_SERIAL_NO),space(20))   
																										+ Isnull(convert(char(50),demrm_id),space(50))   --Isnull(convert(char(35),demrm_id),space(35))   
																										+ space(50)   --Isnull(convert(char(35),demrm_id),space(35))   
																										+ case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(20),DEMRD_FOLIO_NO),space(20)) else space(20) end          -- NEW
																										+ case when DEMRD_DISTINCTIVE_NO_FR='M' then 'M' else space(1) end          -- NEW
																										+ case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(3),DEMRD_CERT_NO),space(3)) else space(3) end 																										+ SPACE(36)--Space(73) 
																										 as DpmTrxDtls   
																										, @L_QTY  
																										, @L_TRX_TAB  
																										, DEMRM_ID  
																										FROM demat_request_mstr D1 ,DEMAT_REQUEST_DTLS D3, DP_ACCT_MSTR D2   
																										WHERE D1.demrm_DPAM_ID = D2.DPAM_ID AND D1.DEMRM_ID=D3.DEMRD_DEMRM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																										and D1.demrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																										AND ISNULL(D1.DEMRM_STATUS,'P')    = 'P'   
																										AND	ISNULL(D1.DEMRM_INTERNAL_REJ,'') = '' 
																										AND LTRIM(RTRIM(ISNULL(D1.DEMRM_BATCH_NO,''))) = ''  
																										AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																										and demrm_deleted_ind = 1 AND DEMRD_DELETED_IND=1  
																										AND Dpam_DELETED_IND = 1  
																										order by demrm_lst_upd_dt 
																								--     
																				END   
																--  
																				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'RMT'  
																				BEGIN   
																				--  
																						SET @@L_TRX_CD = '902'  
																						SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,dp_acct_mstr WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  AND ISNULL(REMRM_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = '' AND REMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and remrm_deleted_ind = 1  AND DPAM_DELETED_IND = 1  
																						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
                      and isnull(REMRM_REPURCHASE_FLG,'') <> 'Y'
																						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																						Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																						SELECT    
																							'902'  
																						+ 'A'   
																						+ Space(7)    
																						+ ISNULL(D2.DPAM_SBA_NO,'')   
																						+ ISNULL(remrm_ISIN,'')    
																						+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
																						 + '00' 
																						+ Space(8)
																						+ Space(31)
																						+ ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
																						+ Space(19)       
																						+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
																						+ Isnull(convert(char(35),remrm_id),space(35))   
																						+ SPACE(73) as DpmTrxDtls   
																						, @L_QTY  
																						, @L_TRX_TAB  
																						, REMRM_ID  
																						FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
																						WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																						AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'  
																						AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = '' 
																						AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																						and remrm_deleted_ind = 1   
																						and dpam_deleted_ind = 1
                      and isnull(REMRM_REPURCHASE_FLG,'') <> 'Y'
																						order by remrm_lst_upd_dt                                     
																				--     
																												END  
IF LTRIM(RTRIM(@L_TRX_TAB)) = 'REPRMT'  
																				BEGIN   
																				--  
																						SET @@L_TRX_CD = '900'  
																						SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,dp_acct_mstr WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  AND ISNULL(REMRM_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = '' AND REMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and remrm_deleted_ind = 1  AND DPAM_DELETED_IND = 1  
																						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
                       and isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
																						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																						Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																						SELECT    
																							'900'  
																						+ 'A'   
																						+ Space(7)    
																						+ ISNULL(D2.DPAM_SBA_NO,'')   
																						+ ISNULL(remrm_ISIN,'')    
																						+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
																						 + '00' 
																						+ Space(8)
																						+ Space(31)
																						+ ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
																						+ Space(19)       
																						+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
																						+ Isnull(convert(char(35),remrm_id),space(35))   
																						+ SPACE(73) as DpmTrxDtls   
																						, @L_QTY  
																						, @L_TRX_TAB  
																						, REMRM_ID  
																						FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
																						WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																						AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'  
																						AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = '' 
																						AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																						and remrm_deleted_ind = 1   
																						and dpam_deleted_ind = 1
                      and isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
																						order by remrm_lst_upd_dt                                     
																				--     
																												END  
 
								
																				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'P2P'  
																				BEGIN   
																				--  
																						SET @@L_TRX_CD = '934'  
																						SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = '' AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and dptd_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
																						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																						AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
																						Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																						SELECT   
																							ISNULL(DPTD_TRASTM_CD,'')   
																						+ 'A'   
																						+ '0000000'   
																						+ ISNULL(D2.DPAM_SBA_NO,'')   
																						+ ISNULL(DPTD_ISIN,'')    
																						+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																						+ '00'  
																						+ Space(8)   
																						+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
																						+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
																						+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																						+ Space(24)               
																						+ Isnull(dptd_counter_cmbp_id,SPACE(8))   
																						+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
																						+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
																						+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																						+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																						+ SPACE(88) as DpmTrxDtls    
																						, @L_QTY  
																						, @L_TRX_TAB  
																						, DPTD_ID  
																						FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
																							WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																						AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
																						AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																						AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																						AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																						AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																						AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = ''  
																						AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																						AND D1.DPTD_DELETED_IND = 1   
																						AND DPAM_DELETED_IND = 1                                   
																						AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																						order by dptd_lst_upd_dt     
																				--     
																						END   
								
																				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDDR'  
																				BEGIN 
																SET @@L_TRX_CD = '926'  
																SELECT @L_QTY = ABS(SUM(DPTD_QTY)) FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
																WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND DPTD_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT   
																	ISNULL(DPTD_TRASTM_CD,'')   
																+ 'A'   
																+ space(7)  
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(DPTD_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																+ space(2)
																+ Space(8)   
																+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)ELSE isnull(D3.SETTM_TYPE,space(2)) END    
																+ CASE WHEN DPTD_Settlement_no<>'' THEN ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)  END --Space(7)   
																+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																+ Space(6)   
																+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
																+ REPLICATE(0,2)    
																+ Isnull(dptd_counter_dp_id,SPACE(8))   
																+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																+ CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END 
																+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))     
																+ SPACE(88) as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																			, DPTD_ID  
																FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID)   
																																	LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON  D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																																	, DP_ACCT_MSTR D2 
																WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
								
								
																AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.DPTD_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																order by dptd_lst_upd_dt     
																				END  
								
																				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2CR'  
																				BEGIN 
																SET @@L_TRX_CD = '905'  
																SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
																WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND DPTD_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(DPTD_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7)   
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(DPTD_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																+ Space(2)   
																+ Space(8)   
																+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1) ELSE isnull(D3.SETTM_TYPE,space(2)) END    
																+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
																+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																+ Space(6)   
																+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
																+ Replicate(0,2)     
																+ SPACE(8)--Isnull(dptd_counter_dp_id,SPACE(8))   
																+ SPACE(9)--Case when LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1)  END    
																--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
																+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																+ SPACE(88) as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																			, DPTD_ID  
																		FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID) , DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3  
																WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   				  
																AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.DPTD_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																order by dptd_lst_upd_dt     
																				END  
								
																				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2PR'  
																				BEGIN 
																SET @@L_TRX_CD = '905'  
																SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS ,DP_ACCT_MSTR  
																WHERE DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND DPTD_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(DPTD_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7)
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(DPTD_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
																+ Space(2)
																+ Space(8)   
																+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1) ELSE isnull(D3.SETTM_TYPE,SPACE(2)) END    
																+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
																+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
																+ Space(6)   
																+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
																+ Replicate(0,2)     
																+ Isnull(dptd_counter_dp_id,SPACE(8))  
																												+ Space(9)    
																--+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
																--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
																+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
																+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
																+ SPACE(88) as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																			, DPTD_ID  
																FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3,SETTLEMENT_TYPE_MSTR D4  
																WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   
																AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
																AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
																AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
																AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.DPTD_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																order by dptd_lst_upd_dt     
																				END    

	IF LTRIM(RTRIM(@L_TRX_TAB)) = 'CPLDG'  
										BEGIN 

																SET @@L_TRX_CD = '908'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7)
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ '00'--Space(2) -- LOCK IN RELEASE CODE 
																+ Space(8) -- LOCK IN RELEASE DATE  
                                                                + SPACE(9) -- FILLER
																+ ISNULL(convert(varchar,PLDT_exec_dt,112),SPACE(8))    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ Space(2)  
																+ ISNULL(convert(varchar,PLDT_closure_dt,112),SPACE(8))   
																+ Space(9)   
                                                                + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
                                                                + CONVERT(CHAR(20),ISNULL(PLDT_AGREEMENT_NO,''))
																+ SPACE(18)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
																order by PLDT_UPDATED_DATE     
											END     

										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'HPLDG'  
										BEGIN 
																SET @@L_TRX_CD = '909'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7)
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ Space(2) -- LOCK IN RELEASE CODE 
																+ Space(8) -- LOCK IN RELEASE DATE  
                                                                + SPACE(9) -- FILLER
																+ ISNULL(convert(varchar,PLDT_CLOSURE_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ Space(19)     															
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
                                                                + CONVERT(CHAR(20),ISNULL(PLDT_AGREEMENT_NO,''))
																+ SPACE(18)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END     
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'PLDGINVK'  
										BEGIN 
																SET @@L_TRX_CD = '910'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- ORG ORDER REF NO
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ Space(33) -- FILLER  							  
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8)) 
																+ Space(19)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END     
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'PLDGCLSR'  
										BEGIN 
																SET @@L_TRX_CD = '911'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD IN ('911','999') --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																'911'  
																+ 'A'   
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(7),ABS(PLDT_SEQ_NO)),7,0,'L','0'),space(7))  -- ORG ORDER REF NO
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ CASE WHEN  PLDT_TRASTM_CD='999' THEN 'U' ELSE CASE WHEN @@L_TRX_CD='911' THEN 'N' ELSE 'U' END END -- CLOSURE TYPE
																+ Space(18) -- FILLER 
                                                                + ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')
                                                                + SPACE(6) -- FILLER  							  
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8)) 
																+ Space(19)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD IN ('911','999')  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END 	
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'PLDGCNF'  
										BEGIN 
																SET @@L_TRX_CD = '916'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ 'A' --ISNULL(PLDT_STATUS,'')
                                                                + SPACE(11) -- FILLER
                                                                + '0'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END 	
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'HYPOCNF'  
										BEGIN 
																SET @@L_TRX_CD = '917'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ ISNULL(PLDT_STATUS,'')
                                                                + SPACE(11) -- FILLER
                                                                + '0'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
											END 
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'CLSRCNF'  
										BEGIN 
																SET @@L_TRX_CD = '919'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(7),ABS(PLDT_SEQ_NO)),7,0,'L','0'),space(7))--Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ 'A' --convert(char(1),ISNULL(PLDT_STATUS,''))
                                                                + SPACE(11) -- FILLER
                                                                + '0000000'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
											END 
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'INKCNF'  
										BEGIN 
																SET @@L_TRX_CD = '918'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ ISNULL(PLDT_STATUS,'')
                                                                + SPACE(11) -- FILLER
                                                                + '0'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																AND ISNULL(D1.PLDT_STATUS,'P')    = 'P'   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																order by PLDT_UPDATED_DATE     
											END 	

								
								
	END  -- END OF NEW BATCH   
								
								
								
		If @PA_BATCHTYPE = 'BE' -- START OF EXISTING BATCH  
		BEGIN  
				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'FRZ'  
				BEGIN   
				--  
						SET @@L_TRX_CD = '936'  
						SELECT @L_QTY = ABS(SUM(fre_QTY))FROM freeze_Unfreeze_dtls ,DP_ACCT_MSTR  
						WHERE fre_Dpam_id =  DPAM_ID and  fre_dpmid = DPAM_DPM_ID AND DPAM_DPM_ID = @L_DPM_ID  
						AND fre_ACTION = 'F' 
						--AND ISNULL(fre_status,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,''))) = ''  
						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
						AND fre_deleted_ind = 1   
						AND DPAM_DELETED_IND = 1  
						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
                        AND fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'

						insert into @l_table (outfile,qty,trans_desc,dptd_id)   
						SELECT    
							ISNULL('936','')   
						+ 'A'   
						+ '0000000'--instrunction id
						+ ISNULL(D2.DPAM_SBA_NO,'')   
						+ convert(char(12),ISNULL(fre_Isin_code,''))  
						+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(fre_QTY)),12,3,'L','0'),space(15))    
						+ case when (fre_type = 'A' and fre_QTY = 0 and fre_Isin_code = '') then '01'
									when (fre_type = 'D' and fre_QTY = 0 and fre_Isin_code = '') then '02'
									when (fre_level = 'I') then '03'
									when (fre_level = 'Q') then '04'
									when (fre_type =  'C' ) then '05' end
						+ Space(8)   
						+ case when ISNULL(convert(char(2),FRE_REQ_INT_BY),'')  = '01' then 'Request by Investor' 
                               when ISNULL(convert(char(2),FRE_REQ_INT_BY),'')  = '02' then 'Other Reasons'
							   when ISNULL(convert(char(2),FRE_REQ_INT_BY),'')  = '03' then 'Request by Stat Auth' end				 
						+ space(7)
						+ '00000000'--ISNULL(convert(varchar,fre_Exec_date,112),'')       
						+ Space(6)   
						+ space(8)
						+ '00000000'
						+ space(19)
						+ CONVERT(CHAR(20),fre_id)
						+ space(35)
						+ space(35)
						+ space(20)
						+ space(18)
						, @L_QTY  
						, @L_TRX_TAB  
						, fre_id
						FROM freeze_Unfreeze_dtls D1 
						   , DP_ACCT_MSTR D2   
						WHERE D1.fre_Dpam_id = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
						AND D1.fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
						AND D1.fre_ACTION = 'F'  
						--AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,''))) = @PA_BATCHNO
						AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
						AND D1.fre_deleted_ind = 1   
						order by fre_lst_upd_dt 
						
						

	--     
				END   
				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'UNFRZ'  
				BEGIN   
				--  
						SET @@L_TRX_CD = '937'  
						SELECT @L_QTY = ABS(SUM(fre_QTY))FROM freeze_Unfreeze_dtls ,DP_ACCT_MSTR  
						WHERE fre_Dpam_id =  DPAM_ID and  fre_dpmid = DPAM_DPM_ID AND DPAM_DPM_ID = @L_DPM_ID  
						AND fre_ACTION = 'U' 
						--AND ISNULL(fre_status,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(FRE_BATCH_NO,''))) = ''  
						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
						AND fre_deleted_ind = 1   
						AND DPAM_DELETED_IND = 1  
						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
                        AND fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'

						insert into @l_table (outfile,qty,trans_desc,dptd_id)   
						SELECT    
							ISNULL('937','')   
						+ 'A'   
						+ convert(char(7),right(('0000000' + FRE_TRNS_NO),7))--instrunction id
						+ ISNULL(D2.DPAM_SBA_NO,'')   
						+ convert(char(12),ISNULL(fre_Isin_code,''))    
						+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(fre_QTY)),12,3,'L','0'),space(15))    
						+ case when (fre_type = 'A' and fre_QTY = 0 and fre_Isin_code = '') then '01'
									when (fre_type = 'D' and fre_QTY = 0 and fre_Isin_code = '') then '02'
									when (fre_level = 'I') then '03'
									when (fre_level = 'Q') then '04'
									when (fre_type =  'C' ) then '05' end
						+ Space(8)   
						+ ISNULL(convert(char(2),FRE_REQ_INT_BY),'')   
						+ space(7)
						+ ISNULL(convert(varchar(8),fre_Exec_date,112),'')      
						+ Space(6)   
						+ space(8)
						+ '00000000'
						+ space(19)
						+ CONVERT(CHAR(20),fre_id)
						+ space(35)
						+ space(35)
						+ space(20)
						+ space(18)
						, @L_QTY  
						, @L_TRX_TAB  
						, fre_id
						FROM freeze_Unfreeze_dtls D1 
						   , DP_ACCT_MSTR D2   
						WHERE D1.fre_Dpam_id = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
						AND D1.fre_lst_upd_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
						AND D1.fre_ACTION = 'U' 
						--AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(D1.FRE_BATCH_NO,''))) = @PA_BATCHNO
						AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
						AND D1.fre_deleted_ind = 1 
						order by fre_lst_upd_dt   
						
						

	--     
				END   

		IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDD'  
		BEGIN   
		--  
				SET @@L_TRX_CD = '925'  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
				WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
																																		AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
				AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
				AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				and dptd_deleted_ind = 1             
				AND DPAM_DELETED_IND = 1  
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''

				Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT   
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ space(7)   
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ space(2)  
				+ Space(8)   
				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
				+ CASE WHEN DPTD_Settlement_no<>'' THEN ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)   END
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ Space(6)   
				+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
				+ REPLICATE(0,2)   
				+ 'IN000026'--Isnull(dptd_counter_dp_id,SPACE(8)) 
				+ SPACE(9)              
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
                + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                + SPACE(50)
				+ CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END    
				+ SPACE(25) as DpmTrxDtls   
				, @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID)  
			LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON  D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
				, DP_ACCT_MSTR D2 
				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND = 1  
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				order by dptd_lst_upd_dt 
--     
		END   

		IF @L_TRX_TAB = 'C2C'  
		BEGIN   
		--  
				SET @@L_TRX_CD = '904'  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY)) FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE DPTD_REQUEST_DT BETWEEN   
				CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND   
																																		CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND   
				DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND  
				DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID and  
				ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
																																		AND Dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT   
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ Space(7)      
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ Space(10)  
				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
				+ CONVERT(CHAR(7),ISNULL(convert(varchar(7),dptd_settlement_no),'')    )
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ Space(6)   
				+ ISNULL(dptd_counter_dp_id,Space(8))
				+ ISNULL(dptd_counter_demat_acct_no,Space(8))
				+ Replicate(0,2)  
				+ SPACE(8)    
				+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
                + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                + SPACE(88) as DpmTrxDtls , @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)  , DP_ACCT_MSTR D2   
				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID            
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND = 1    
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
                order by dptd_lst_upd_dt 


--  
		END   

		IF @L_TRX_TAB = 'P2C'  
		BEGIN   
		--  
				SET @@L_TRX_CD = '904'  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE   
				DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
				AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
				AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
				AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				and dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT   
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ Space(7)  
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ Space(10)      
				+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
				+ ISNULL(convert(varchar,dptd_settlement_no,112),Space(7))     
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ Space(6)   
				--+ ISNULL(dptd_counter_dp_id,Space(16)) --Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_ACCT_NO,SPACE(8)) ELSE SPACE(16) end    
				+ ISNULL(dptd_counter_dp_id,Space(8))
				+ ISNULL(Right(dptd_counter_demat_acct_no,8),Space(8))
				+ Replicate(0,2)   
				+ Space(8)            
				+ Space(9)--ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
				+ SPACE(88) as DpmTrxDtls   
				, @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  
				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND = 1  
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				order by dptd_lst_upd_dt 

--  
		END   
		IF @L_TRX_TAB = 'C2P'  
		BEGIN   
		--  
				SET @@L_TRX_CD = '904'  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY)) FROM DP_TRX_DTLS,DP_ACCT_MSTR WHERE   
				DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
				AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
				AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
				AND ISNULL(DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				and dptd_deleted_ind = 1 AND DPAM_DELETED_IND =1 
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT   
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ Space(7)   
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ Space(10)    
				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D4.SETTM_TYPE)=2 THEN ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'')  WHEN LEN(D4.SETTM_TYPE)=0 THEN RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) WHEN LEN(D4.SETTM_TYPE)=1 THEN RIGHT( '0' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) + '0' ELSE ISNULL(D4.SETTM_TYPE,SPACE(2))   END    
				+ Isnull(convert(varchar,dptd_other_settlement_no),Space(7))   
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ Space(6)   
				--+ ISNULL(dptd_counter_dp_id,Space(16))--space(16)
				+ ISNULL(ENTM_NAME3,'')
				+ ISNULL(dptd_counter_demat_acct_no,Space(8))   
				+ Replicate(0,2)    
				+ ISNULL(dptd_counter_cmbp_id,space(8))           
				+ Space(9)--ISNULL(dptd_counter_cmbp_id,space(8)) --ISNULL(D1.DPTD_other_SETTLEMENT_NO,SPACE(7))   
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
                + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                + SPACE(88) as DpmTrxDtls    
				, @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4  , ENTITY_MSTR
				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
                AND D1.dptd_counter_cmbp_id = ENTM_SHORT_NAME
				AND D1.DPTD_OTHER_SETTLEMENT_TYPE  = CONVERT(VARCHAR,D4.SETTM_ID)   
				AND D1.DPTD_TRASTM_CD = @@L_TRX_CD  
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO 
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND =1   
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				order by dptd_lst_upd_dt 

--   
		END   

		IF @L_TRX_TAB = 'ATO'  
		BEGIN   
		--  
				SET @@L_TRX_CD = '907'  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR  
				WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD   
				AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
				AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																																		AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				and dptd_deleted_ind = 1 AND DPAM_DELETED_IND =1   
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT   
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ Space(7)  
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ Space(2) 
				+ Space(8)   
				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
				+ ISNULL(dptd_settlement_no,Space(7))--Space(7)   
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ Space(6)   
				+ SPACE(16)   
				+ SPACE(2)   
				+ Isnull(convert(char(8),dptd_counter_cmbp_id),SPACE(8))  
				+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
				+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
				+ SPACE(88) as DpmTrxDtls   
				, @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
				AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)  
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO 
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND =1   
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				order by dptd_lst_upd_dt 



--   
		END   

		IF @L_TRX_TAB = 'IDO'  
		BEGIN   
		--  
				SET @@L_TRX_CD = '912'  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
				WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'  
				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
				AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
				AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
				AND ISNULL(DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				and dptd_deleted_ind = 1 AND DPAM_DELETED_IND =1  
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

				Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT  
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ space(7)   
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ Space(10)   
				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case when LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D5.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
				+ Isnull(dptd_settlement_no,space(7))   
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ Space(6)   
				+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_demat_acct_no,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id+D2.DPAM_ACCT_NO,SPACE(8)) ELSE SPACE(16) end    
				+ Space(4)--SPACE(2)   
				+ Space(4)--Case when DPTD_TRASTM_CD=@@L_TRX_CD then Isnull(dptd_counter_dp_id,SPACE(16)) WHEN DPTD_TRASTM_CD=@@L_TRX_CD THEN Isnull(dptd_counter_cmbp_id,SPACE(8)) Else Space(8) End    
				+ Space(4)--Case when LEN(D4.SETTM_TYPE)=2 THEN isnull(D4.SETTM_TYPE,space(2)) WHEN LEN(D4.SETTM_TYPE)=0 THEN ISNULL(D4.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D4.SETTM_TYPE,space(1)) + SPACE(1)  END    
				+ Space(19)--ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
                + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                + SPACE(88) as DpmTrxDtls   
				, @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
				WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
				--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND = 1  
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				order by dptd_lst_upd_dt 

--   
		END   

		IF @L_TRX_TAB = 'DO'  
		BEGIN   
		--  
				SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
				WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
				AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD   
				AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
				AND ISNULL(DPTD_STATUS,'P')    = 'P'   
																																		AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				and dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
				AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

				insert into @l_table (outfile,qty,trans_desc,dptd_id)   
				SELECT    
					ISNULL(DPTD_TRASTM_CD,'')   
				+ 'A'   
				+ Space(7) 
				+ ISNULL(D2.DPAM_SBA_NO,'')   
				+ ISNULL(DPTD_ISIN,'')    
				+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
				+ Space(2)  
				+ Space(8)   
				+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D5.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
				+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
				+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
				+ SPACE(41)  
				+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
                + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                + SPACE(88) as DpmTrxDtls    
				, @L_QTY  
				, @L_TRX_TAB  
				, DPTD_ID  
				FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D5  
						WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
				--AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
				AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
				AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
				AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
				AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
				AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
				AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO  
				AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
				AND D1.DPTD_DELETED_IND = 1   
				AND DPAM_DELETED_IND = 1  
				AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
				order by dptd_lst_upd_dt 



--   
		END   
		IF LTRIM(RTRIM(@L_TRX_TAB)) = 'DMT'  
								BEGIN   
								--  
										SET @@L_TRX_CD = '901'  
										SELECT @L_QTY = ABS(SUM(demrd_qty))FROM demat_request_mstr,demat_request_dtls,DP_ACCT_MSTR   
														WHERE demrd_demrm_id = demrm_id and demrm_request_dt   
														BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
														AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
														AND DEMRM_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
														AND ISNULL(DEMRM_STATUS,'P')    = 'P' 
														AND	ISNULL(DEMRM_INTERNAL_REJ,'') = ''   
														AND LTRIM(RTRIM(ISNULL(DEMRM_BATCH_NO,''))) = @PA_BATCHNO  
														and demrm_deleted_ind = 1 AND DPAM_DELETED_IND =1 
														AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
										--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


										Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
										SELECT  
																			'901'  
																		+ 'A'   
																		+ Space(14)--Space(7)   
																		+ ISNULL(D2.DPAM_SBA_NO,space(8))   
																		+ ISNULL(demrm_ISIN,space(12))    
																		+ ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),15,3,'L','0'),space(18))--ISNULL(citrus_usr.FN_FORMATSTR(ABS(demrM_QTY),12,3,'L','0'),space(15))    
																		+ SPACE(83)--Space(68)    
																		+ ISNULL(convert(char(35),DEMRM_SLIP_SERIAL_NO),space(35))   --ISNULL(convert(char(20),DEMRM_SLIP_SERIAL_NO),space(20))   
																		+ Isnull(convert(char(50),demrm_id),space(50))   --Isnull(convert(char(35),demrm_id),space(35))   
                                                                        + space(50)   --Isnull(convert(char(35),demrm_id),space(35))   
                                                                        + case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(20),DEMRD_FOLIO_NO),space(20)) else space(20) end          -- NEW
                                                                        + case when DEMRD_DISTINCTIVE_NO_FR='M' then 'M' else space(1) end          -- NEW
																		+ case when DEMRD_DISTINCTIVE_NO_FR='M' then isnull(convert(CHAR(3),DEMRD_CERT_NO),space(3)) else space(3) end                                                                         + SPACE(36)--Space(73) 
																		 as DpmTrxDtls   
																		, @L_QTY  
																		, @L_TRX_TAB  
																		, DEMRM_ID  
																		FROM demat_request_mstr D1 ,DEMAT_REQUEST_DTLS D3, DP_ACCT_MSTR D2   
																		WHERE D1.demrm_DPAM_ID = D2.DPAM_ID AND D1.DEMRM_ID=D3.DEMRD_DEMRM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																		and D1.demrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																		AND ISNULL(D1.DEMRM_STATUS,'P')    = 'P'   
																		AND	ISNULL(D1.DEMRM_INTERNAL_REJ,'') = '' 
																		AND LTRIM(RTRIM(ISNULL(D1.DEMRM_BATCH_NO,''))) = @PA_BATCHNO  
																		AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																		and demrm_deleted_ind = 1 AND DEMRD_DELETED_IND=1  
																		AND Dpam_DELETED_IND = 1  
                                                                        order by demrm_lst_upd_dt 

								--     
				END   
--  
				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'RMT'  
				BEGIN   
				--  
						SET @@L_TRX_CD = '902'  
						SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,DP_ACCT_MSTR   
						WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
						AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND REMRM_DPAM_ID =  DPAM_ID   
						AND DPAM_DPM_ID = @L_DPM_ID   
						AND ISNULL(REMRM_STATUS,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = @PA_BATCHNO  
						and remrm_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
      and isnull(REMRM_REPURCHASE_FLG,'') <> 'Y'
						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


						insert into @l_table (outfile,qty,trans_desc,dptd_id)   
						SELECT  
						'902'  
						+ 'A'   
						+ space(7)    
						+ ISNULL(D2.DPAM_SBA_NO,'')   
						+ ISNULL(remrm_ISIN,'')    
						+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
                        + '00' 
                        + Space(8)
                        + Space(31)
                        + ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
                        + Space(19)     
						+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
						+ Isnull(convert(char(35),remrm_id),space(35))   
						+ SPACE(73) as DpmTrxDtls   
						, @L_QTY  
						, @L_TRX_TAB  
						, REMRM_ID  
						FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
						WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
							and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
							AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'   
							AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = @PA_BATCHNO  
							AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
							and remrm_deleted_ind = 1   
							AND DPAM_DELETED_IND  = 1 
      and isnull(REMRM_REPURCHASE_FLG,'') <> 'Y' 
						order by REMRM_lst_upd_dt             

				--     
												END  

IF LTRIM(RTRIM(@L_TRX_TAB)) = 'REPRMT'  
				BEGIN   
				--  
						SET @@L_TRX_CD = '900'  
						SELECT @L_QTY = ABS(SUM(remrm_qty))FROM remat_request_mstr,DP_ACCT_MSTR   
						WHERE remrm_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
						AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND REMRM_DPAM_ID =  DPAM_ID   
						AND DPAM_DPM_ID = @L_DPM_ID   
						AND ISNULL(REMRM_STATUS,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(REMRM_BATCH_NO,''))) = @PA_BATCHNO  
						and remrm_deleted_ind = 1 AND DPAM_DELETED_IND = 1  
						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
      and isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
						--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  


						insert into @l_table (outfile,qty,trans_desc,dptd_id)   
						SELECT  
						'900'  
						+ 'A'   
						+ space(7)    
						+ ISNULL(D2.DPAM_SBA_NO,'')   
						+ ISNULL(remrm_ISIN,'')    
						+ ISNULL(citrus_usr.FN_FORMATSTR(substring(convert(char(15),ABS(remrm_QTY)),1,len(convert(char(15),remrm_QTY))-2),12,3,'L','0'),space(15))    
                        + '00' 
                        + Space(8)
                        + Space(31)
                        + ISNULL(citrus_usr.FN_FORMATSTR(REMRM_CERTIFICATE_NO,8,0,'L','0'),'00000000') 
                        + Space(19)     
						+ ISNULL(convert(char(20),REMRM_SLIP_SERIAL_NO),space(20))   
						+ Isnull(convert(char(35),remrm_id),space(35))   
						+ SPACE(73) as DpmTrxDtls   
						, @L_QTY  
						, @L_TRX_TAB  
						, REMRM_ID  
						FROM remat_request_mstr D1, DP_ACCT_MSTR D2   
						WHERE D1.remrm_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
							and D1.remrm_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
							AND ISNULL(D1.REMRM_STATUS,'P')    = 'P'   
							AND LTRIM(RTRIM(ISNULL(D1.REMRM_BATCH_NO,''))) = @PA_BATCHNO  
							AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
							and remrm_deleted_ind = 1   
							AND DPAM_DELETED_IND  = 1  
       and isnull(REMRM_REPURCHASE_FLG,'') = 'Y'
						order by REMRM_lst_upd_dt             

				--     
				END  
 

				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'P2P'  
				BEGIN   
				--  
						SET @@L_TRX_CD = '934'                 
						SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
						WHERE DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
						AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD   
						AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB AND DPTD_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
						AND ISNULL(DPTD_STATUS,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
						and dptd_deleted_ind = 1 AND DPAM_DELETED_IND=1  
						AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
						AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
					--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  

						Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
						SELECT   
							ISNULL(DPTD_TRASTM_CD,'')   
						+ 'A'   
						+ '0000000'   
						+ ISNULL(D2.DPAM_SBA_NO,'')   
						+ ISNULL(DPTD_ISIN,'')    
						+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
						+ '00'  
						+ Space(8)   
						+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D5.SETTM_TYPE)),'') ,2)--Case When LEN(D5.SETTM_TYPE)=2 THEN isnull(D5.SETTM_TYPE,space(2)) WHEN LEN(D5.SETTM_TYPE)=0 THEN ISNULL(D5.SETTM_TYPE,SPACE(2)) WHEN LEN(D4.SETTM_TYPE)=1 THEN isnull(D5.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END  --SPACE(2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
						+ ISNULL(dptd_settlement_no,Space(7)) --Space(7)   
						+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
						+ Space(24)               
						+ Isnull(dptd_counter_cmbp_id,SPACE(8))   
						+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
						+ ISNULL(D1.DPTD_OTHER_SETTLEMENT_NO,SPACE(7))   
						+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                        + SPACE(88) as DpmTrxDtls    
						, @L_QTY  
						, @L_TRX_TAB  
						, DPTD_ID  
						FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D4,SETTLEMENT_TYPE_MSTR D5  
							WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
						AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
						AND D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D5.SETTM_ID)   
						AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
						AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
						AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
						AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
						AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
						AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
						AND D1.DPTD_DELETED_IND = 1   
						AND DPAM_DELETED_IND = 1  
						AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
						order by dptd_lst_upd_dt 


				--     
						END   
				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'IDDR'  
				BEGIN 
SET @@L_TRX_CD = '926'  
SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
					AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
and dptd_deleted_ind = 1             
AND DPAM_DELETED_IND = 1  
AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''

Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
SELECT 
ISNULL(DPTD_TRASTM_CD,'')   
+ 'A'   
+ Space(7)    
+ ISNULL(D2.DPAM_SBA_NO,'')   
+ ISNULL(DPTD_ISIN,'')    
+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
+ Space(2)   
+ Space(8)   
+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1) ELSE isnull(D3.SETTM_TYPE,space(2))  END    
+ CASE WHEN DPTD_Settlement_no<>'' THEN  ISNULL(DPTD_Settlement_no,Space(7)) ELSE Space(7)   END
+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
+ Space(6)   
+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
+ REPLICATE(0,2)  
+ Isnull(dptd_counter_dp_id,SPACE(8))   
+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
+ CASE WHEN (LEN(ISNULL(D4.SETTM_TYPE_CDSL,'')) = 6 AND ISNULL(DPTD_OTHER_SETTLEMENT_NO,'') <> '') THEN  citrus_usr.FN_FORMATSTR(D4.SETTM_TYPE_CDSL+D1.DPTD_OTHER_SETTLEMENT_NO,13,0,'R','') ELSE REPLICATE(0,13) END 
+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))     
+ SPACE(88) as DpmTrxDtls   
, @L_QTY  
, @L_TRX_TAB  
, DPTD_ID  
FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D3 ON D1.DPTD_MKT_TYPE=CONVERT(VARCHAR,D3.SETTM_ID)
													LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4  ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)    
													, DP_ACCT_MSTR D2 
WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO
AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
AND D1.DPTD_DELETED_IND = 1   
AND DPAM_DELETED_IND = 1  
AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
order by dptd_lst_upd_dt 
				END 

				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2CR'  
				BEGIN 
SET @@L_TRX_CD = '905'  
SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
					AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
and dptd_deleted_ind = 1             
AND DPAM_DELETED_IND = 1  
AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''

Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
SELECT  
ISNULL(DPTD_TRASTM_CD,'')   
+ 'A'   
+ Space(7)     
+ ISNULL(D2.DPAM_SBA_NO,'')   
+ ISNULL(DPTD_ISIN,'')    
+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
+ Space(2)     
+ Space(8)   
+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
+ Space(6)   
+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
+ Replicate(0,2)    
+ Isnull(dptd_counter_dp_id,SPACE(8)) 
								+ SPACE(9) 
--+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7)) 
+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
+ SPACE(88) as DpmTrxDtls   
, @L_QTY  
, @L_TRX_TAB  
, DPTD_ID  
FROM DP_TRX_DTLS D1 LEFT OUTER JOIN SETTLEMENT_TYPE_MSTR D4 ON D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID) , DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3 
WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   				  
AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
AND ISNULL(D1.DPTD_STATUS,'P')    = 'P'   
AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = '' 
AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
AND D1.DPTD_DELETED_IND = 1   
AND DPAM_DELETED_IND = 1  
AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
order by dptd_lst_upd_dt 
				END 
				IF LTRIM(RTRIM(@L_TRX_TAB)) = 'C2PR'  
				BEGIN 
SET @@L_TRX_CD = '905'  
SELECT @L_QTY = ABS(SUM(DPTD_QTY))FROM DP_TRX_DTLS,DP_ACCT_MSTR   
WHERE DPTD_DPAM_ID = DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID   
					AND DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
AND DPTD_TRASTM_CD = @@L_TRX_CD AND DPTD_INTERNAL_TRASTM = @L_TRX_TAB   
AND ISNULL(DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(DPTD_BATCH_NO,''))) = @PA_BATCHNO  
and dptd_deleted_ind = 1             
AND DPAM_DELETED_IND = 1  
AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''

Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
SELECT    
ISNULL(DPTD_TRASTM_CD,'')   
+ 'A'   
+ Space(7)   
+ ISNULL(D2.DPAM_SBA_NO,'')   
+ ISNULL(DPTD_ISIN,'')    
+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(DPTD_QTY)),12,3,'L','0'),space(15))    
+ Space(2)    
+ Space(8)   
+ RIGHT( '00' + ISNULL(LTRIM(RTRIM(D3.SETTM_TYPE)),'') ,2)--CASE WHEN LEN(D3.SETTM_TYPE)=2 THEN isnull(D3.SETTM_TYPE,space(2)) WHEN LEN(D3.SETTM_TYPE)=0 THEN ISNULL(D3.SETTM_TYPE,SPACE(2)) WHEN LEN(D3.SETTM_TYPE)=1 THEN isnull(D3.SETTM_TYPE,space(1)) + SPACE(1)  END    
+ ISNULL(DPTD_Settlement_no,Space(7))--Space(7)   
+ ISNULL(convert(varchar,dptd_execution_dt,112),'')    
+ Space(6)   
+ Isnull(dptd_counter_demat_acct_no,SPACE(16))   
+ REPLICATE(0,2)   
+ Isnull(dptd_counter_dp_id,SPACE(8))  
								+ SPACE(9)  
--+RIGHT( '00' + ISNULL(LTRIM(RTRIM(D4.SETTM_TYPE)),'') ,2) 
--+ ISNULL(D1.DPTD_SETTLEMENT_NO,SPACE(7))   
+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) end --Isnull(dptd_internal_ref_no,space(20))     
+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(dptd_internal_ref_no,'')) else CONVERT(CHAR(20),ISNULL(DPTD_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))

+ SPACE(88) as DpmTrxDtls   
, @L_QTY  
, @L_TRX_TAB  
, DPTD_ID  
FROM DP_TRX_DTLS D1, DP_ACCT_MSTR D2 ,SETTLEMENT_TYPE_MSTR D3,SETTLEMENT_TYPE_MSTR D4  
WHERE D1.DPTD_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
AND D1.DPTD_MKT_TYPE=D3.SETTM_ID   
AND D1.DPTD_OTHER_SETTLEMENT_TYPE=CONVERT(VARCHAR,D4.SETTM_ID)   
AND D1.DPTD_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
AND D1.DPTD_TRASTM_CD=@@L_TRX_CD  
AND D1.DPTD_INTERNAL_TRASTM = @L_TRX_TAB  
AND ISNULL(D1.DPTD_STATUS,'P')    = 'P' AND LTRIM(RTRIM(ISNULL(D1.DPTD_BATCH_NO,''))) = @PA_BATCHNO
AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END  
AND D1.DPTD_DELETED_IND = 1   
AND DPAM_DELETED_IND = 1  
AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
order by dptd_lst_upd_dt 
				END 

IF LTRIM(RTRIM(@L_TRX_TAB)) = 'CPLDG'  
										BEGIN 
																SET @@L_TRX_CD = '908'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																  
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7)
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ '00'--Space(2) -- LOCK IN RELEASE CODE 
																+ Space(8) -- LOCK IN RELEASE DATE  
                                                                + SPACE(9) -- FILLER
																+ ISNULL(convert(varchar,PLDT_CLOSURE_dt,112),SPACE(8))    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))  																
																+ Space(2)  
																+ ISNULL(convert(varchar,PLDT_closure_dt,112),SPACE(8))   
																+ Space(9)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
                                                                + CONVERT(CHAR(20),ISNULL(PLDT_AGREEMENT_NO,''))
																+ SPACE(18)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																ORDER BY PLDT_UPDATED_DATE 
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END     

										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'HPLDG'  
										BEGIN 
																SET @@L_TRX_CD = '909'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7)
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ Space(2) -- LOCK IN RELEASE CODE 
																+ Space(8) -- LOCK IN RELEASE DATE  
                                                                + SPACE(9) -- FILLER
																+ ISNULL(convert(varchar,PLDT_CLOSURE_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8)) 												    
																+ Space(19)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
                                                                + CONVERT(CHAR(20),ISNULL(PLDT_AGREEMENT_NO,''))
																+ SPACE(18)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																   
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1 
																ORDER BY PLDT_UPDATED_DATE  
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END     
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'PLDGINVK'  
										BEGIN 
																SET @@L_TRX_CD = '910'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																  
																AND LTRIM(RTRIM(ISNULL(PLDT_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- ORG ORDER REF NO
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ Space(33) -- FILLER  							  
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8)) 
																+ Space(19)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																ORDER BY PLDT_UPDATED_DATE 
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END     
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'PLDGCLSR'  
										BEGIN 
																SET @@L_TRX_CD = '911'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD IN ('911','999') --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND LTRIM(RTRIM(ISNULL(PLDT_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(7),ABS(PLDT_SEQ_NO)),7,0,'L','0'),space(7))--Space(7) -- ORG ORDER REF NO
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ CASE WHEN  PLDT_TRASTM_CD='999' THEN 'U' ELSE CASE WHEN @@L_TRX_CD='911' THEN 'N' ELSE 'U' END END -- CLOSURE TYPE
																+ Space(18) -- FILLER 
                                                                + ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')
                                                                + SPACE(6) -- FILLER  							  
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8)) 
																+ Space(19)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD IN ('911','999')  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'')= '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																ORDER BY PLDT_UPDATED_DATE 
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END 	
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'PLDGCNF'  
										BEGIN 
																SET @@L_TRX_CD = '916'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND LTRIM(RTRIM(ISNULL(PLDT_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ 'A'--ISNULL(PLDT_STATUS,'')
                                                                + SPACE(11) -- FILLER
                                                                + '0'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1
																ORDER BY PLDT_UPDATED_DATE   
																--AND isnull(DPTD_BROKER_INTERNAL_REF_NO,'') = ''
											END 	
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'HYPOCNF'  
										BEGIN 
																SET @@L_TRX_CD = '917'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND LTRIM(RTRIM(ISNULL(PLDT_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ ISNULL(PLDT_STATUS,'')
                                                                + SPACE(11) -- FILLER
                                                                + '0'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																ORDER BY PLDT_UPDATED_DATE 
											END 
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'CLSRCNF'  
										BEGIN 
																SET @@L_TRX_CD = '919'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																 
																AND ISNULL(PLDT_BATCH_NO,'') = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(7),ABS(PLDT_SEQ_NO)),7,0,'L','0'),space(7))--Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ 'A' --convert(char(1),ISNULL(PLDT_STATUS,''))
                                                                + SPACE(11) -- FILLER
                                                                + '0000000'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																ORDER BY PLDT_UPDATED_DATE 
											END 
										IF LTRIM(RTRIM(@L_TRX_TAB)) = 'INKCNF'  
										BEGIN 
																SET @@L_TRX_CD = '918'  
																SELECT @L_QTY = ABS(SUM(PLDT_QTY))FROM NSDL_PLEDGE_DTLS ,DP_ACCT_MSTR  
																WHERE PLDT_DPAM_ID =  DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																						AND PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00'   
																AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   
																AND PLDT_TRASTM_CD = @@L_TRX_CD --AND PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND LTRIM(RTRIM(ISNULL(PLDT_BATCH_NO,''))) = ''  
																AND DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
																AND PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																
																--SELECT @L_TOTQTY = SUM(DPTD_QTY)FROM DP_TRX_DTLS WHERE DPTD_REQUEST_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59' AND DPTD_TRASTM_CD = @@L_TRX_CD  
								
								
																Insert into @l_table (outfile,qty,trans_desc,dptd_id)   
																SELECT    
																	ISNULL(PLDT_TRASTM_CD,'')   
																+ 'A'   
																+ Space(7) -- PLEDGE TRANSACTION ID
																+ ISNULL(D2.DPAM_SBA_NO,'')   
																+ ISNULL(PLDT_ISIN,'')    
																+ ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(15),ABS(PLDT_QTY)),12,3,'L','0'),space(15))    
																+ ISNULL(PLDT_STATUS,'')
                                                                + SPACE(11) -- FILLER
                                                                + '0'
																+ ISNULL(convert(varchar,PLDT_EXEC_dt,112),'')    
																+ Space(6)   
                                                                + Isnull(PLDT_PLEDGEE_DPID,SPACE(8))
																+ Isnull(PLDT_PLEDGEE_demat_acct_no,SPACE(8))   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 1' ELSE REPLICATE(0,4) END   
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 2' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 3' ELSE REPLICATE(0,4) END 
																+ CASE  WHEN ISNULL(PLDT_STATUS,'')='R' THEN 'REJECTION CODE REASON 4' ELSE REPLICATE(0,4) END 
																+ Space(3)    
    															+ case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(20),ISNULL(PLDT_SLIP_NO,''))         else CONVERT(CHAR(20),ISNULL(PLDT_ID,'')) end --Isnull(dptd_internal_ref_no,space(20))     
						                                        + case when @l_slip_no_rmks_yn = '1' then CONVERT(CHAR(35),ISNULL(PLDT_ID,'')) else CONVERT(CHAR(35),ISNULL(PLDT_SLIP_NO,'')) end --convert(char(20),ISNULL(DPTD_SLIP_NO,''))
                                                				+ SPACE(35)                                                                
																+ SPACE(38)
																as DpmTrxDtls   
																, @L_QTY  
																, @L_TRX_TAB  
																, PLDT_ID  
																FROM NSDL_PLEDGE_DTLS D1, DP_ACCT_MSTR D2 
																WHERE D1.PLDT_DPAM_ID = D2.DPAM_ID AND DPAM_DPM_ID = @L_DPM_ID  
																
																AND D1.PLDT_REQUEST_DT BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
																AND D1.PLDT_TRASTM_CD=@@L_TRX_CD  
																--AND D1.PLDT_INTERNAL_TRASTM = @L_TRX_TAB  
																
																AND ISNULL(D1.PLDT_BATCH_NO,'') = '' 
																AND D2.DPAM_SBA_NO LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO)) = '' THEN '%' ELSE @PA_POOL_ACCTNO  END 
																AND D1.PLDT_DELETED_IND = 1   
																AND DPAM_DELETED_IND = 1  
																ORDER BY PLDT_UPDATED_DATE 
											END 						

								
								
								END  -- END OF EXISTING BATCH  
						--
						END--broker_yn
  
    --  
  
    END  
  --  
  END  
--UPDATE PART START FOR BATCH NEW

           SELECT @L_TOT_REC = COUNT(DPTD_ID) FROM @l_table  
		   IF @L_TOT_REC > 0   
			   BEGIN   
			   UPDATE D SET DPTD_BATCH_NO = @PA_BATCHNO FROM DP_TRX_DTLS D,@l_table T   
			   WHERE D.DPTD_ID = T.DPTD_ID AND T.trans_desc NOT IN ('DMT','RMT')  
			   UPDATE D SET DEMRM_BATCH_NO = @PA_BATCHNO FROM DEMAT_REQUEST_MSTR D,@l_table T   
			   WHERE D.DEMRM_ID = T.DPTD_ID AND T.trans_desc = 'DMT'  
			   UPDATE D SET REMRM_BATCH_NO = @PA_BATCHNO FROM REMAT_REQUEST_MSTR D,@l_table T   
			   WHERE D.REMRM_ID = T.DPTD_ID AND T.trans_desc = 'RMT'  
      UPDATE D SET REMRM_BATCH_NO = @PA_BATCHNO FROM REMAT_REQUEST_MSTR D,@l_table T   
			   WHERE D.REMRM_ID = T.DPTD_ID AND T.trans_desc = 'REPRMT'  

			   UPDATE D SET FRE_BATCH_NO = @PA_BATCHNO FROM freeze_Unfreeze_dtls D,@l_table T   
			   WHERE D.fre_id = T.DPTD_ID AND T.trans_desc = 'UNFRZ' 
 
			   UPDATE D SET FRE_BATCH_NO = @PA_BATCHNO FROM freeze_Unfreeze_dtls D,@l_table T   
			   WHERE D.fre_id = T.DPTD_ID AND T.trans_desc = 'FRZ' 

			   UPDATE D SET PLDT_BATCH_NO = @PA_BATCHNO FROM nsdl_pledge_dtls D,@l_table T   
			   WHERE D.PLDT_ID = T.DPTD_ID AND T.trans_desc = 'CPLDG' 
			
			   UPDATE D SET PLDT_BATCH_NO = @PA_BATCHNO FROM nsdl_pledge_dtls D,@l_table T   
			   WHERE D.PLDT_ID = T.DPTD_ID AND T.trans_desc = 'PLDGINVK' 

			   UPDATE D SET PLDT_BATCH_NO = @PA_BATCHNO FROM nsdl_pledge_dtls D,@l_table T   
			   WHERE D.PLDT_ID = T.DPTD_ID AND T.trans_desc = 'PLDGCLSR' 

			   UPDATE D SET PLDT_BATCH_NO = @PA_BATCHNO FROM nsdl_pledge_dtls D,@l_table T   
			   WHERE D.PLDT_ID = T.DPTD_ID AND T.trans_desc = 'PLDGCNF'	

			   UPDATE D SET PLDT_BATCH_NO = @PA_BATCHNO FROM nsdl_pledge_dtls D,@l_table T   
			   WHERE D.PLDT_ID = T.DPTD_ID AND T.trans_desc = 'HYPOCNF'

			   UPDATE D SET PLDT_BATCH_NO = @PA_BATCHNO FROM nsdl_pledge_dtls D,@l_table T   
			   WHERE D.PLDT_ID = T.DPTD_ID AND T.trans_desc = 'CLSRCNF'
	  
			   UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCHNO) + 1))       
			   WHERE BITRM_PARENT_CD ='NSDL_BTCH_TRX_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
	                                    

			   SELECT @L_TRANS_TYPE = coalesce(@L_TRANS_TYPE + ',', '') +  trans_desc  
					  from @l_table Group by trans_desc       
	           
				IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR WHERE BATCHN_NO  = @PA_BATCHNO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1 AND BATCHN_TYPE='T')  
				BEGIN  
					 INSERT INTO BATCHNO_NSDL_MSTR                                       
					 (    
					  BATCHN_DPM_ID,  
					  BATCHN_NO,  
					  BATCHN_RECORDS ,           
					  BATCHN_TRANS_TYPE,
					  BATCHN_FILEGEN_DT,   
					  BATCHN_TYPE,  
					  BATCHN_STATUS,  
					  BATCHN_CREATED_BY,  
					  BATCHN_CREATED_DT ,  
					  BATCHN_DELETED_IND  
					 )  
					 VALUES  
					 (  
					  @L_DPM_ID,  
					  @PA_BATCHNO,  
					  @L_TOT_REC,  
					  @L_TRANS_TYPE,
					  CONVERT(VARCHAR, getdate(),109),  
					  'T',  
					  case when @L_TRANS_TYPE in ('FRZ','UNFRZ') then  'A' else 'P' end ,  
					  @PA_LOGINNAME,  
					  GETDATE(),  
					  1  
					 )  
				 END   
				END   

--UPDATE PART END FOR BATCH NEW

  --C2C*|~*P2C*|~*C2P*|~*IDD*|~*ATO*|~*IDO*|~*DO*|~* 
    
      SELECT @L_TOTQTY936  =QTY FROM @l_table  WHERE trans_desc = '936'   --904
      SELECT @L_TOTQTY937  =QTY FROM @l_table  WHERE trans_desc = '937'   --904
      SELECT @L_TOTQTY1  =QTY FROM @l_table  WHERE trans_desc = 'C2C'   --904
      SELECT @L_TOTQTY2  =QTY FROM @l_table  WHERE trans_desc = 'P2C'   --904
      SELECT @L_TOTQTY3  =QTY FROM @l_table  WHERE trans_desc = 'C2P'   --904
      SELECT @L_TOTQTY4  =QTY FROM @l_table  WHERE trans_desc = 'IDD'   
      SELECT @L_TOTQTY5  =QTY FROM @l_table  WHERE trans_desc = 'ATO'   --907
      SELECT @L_TOTQTY6  =QTY FROM @l_table  WHERE trans_desc = 'IDO'   
      SELECT @L_TOTQTY7  =QTY FROM @l_table  WHERE trans_desc = 'DO'  
      SELECT @L_TOTQTY8  =QTY FROM @l_table  WHERE trans_desc = 'P2P'  
      SELECT @L_TOTQTY9  =QTY FROM @l_table  WHERE trans_desc = 'DMT'  
      SELECT @L_TOTQTY10 =QTY FROM @l_table  WHERE trans_desc = 'RMT'  
      SELECT @L_TOTQTY11 =QTY FROM @l_table  WHERE trans_desc = 'IDDR' 
	  SELECT @L_TOTQTY12 =QTY FROM @l_table  WHERE trans_desc = 'C2CR' --905
	  SELECT @L_TOTQTY13 =QTY FROM @l_table  WHERE trans_desc = 'C2PR' --905
      SELECT @L_TOTQTY14 =QTY FROM @l_table  WHERE trans_desc = 'CPLDG' --908 
      SELECT @L_TOTQTY15 =QTY FROM @l_table  WHERE trans_desc = 'PLDGINVK' --910
      SELECT @L_TOTQTY16 =QTY FROM @l_table  WHERE trans_desc = 'PLDGCLSR' --911
	  SELECT @L_TOTQTY17 =QTY FROM @l_table  WHERE trans_desc = 'PLDGCNF'  --916
	  SELECT @L_TOTQTY18 =QTY FROM @l_table  WHERE trans_desc = 'HYPOCNF' -- 917
	  SELECT @L_TOTQTY19 =QTY FROM @l_table  WHERE trans_desc = 'CLSRCNF' -- 919
   SELECT @L_TOTQTY20 =QTY FROM @l_table  WHERE trans_desc = 'REPRMT' -- 919
	
      SELECT @L_TOTQTY  = CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY1,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY2,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY3,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY4,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY5,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY6,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY7,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY8,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY9,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY10,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY11,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY12,'0'))   
                        + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY13,'0')) 
						+ CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY14,'0'))  
						+ CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY15,'0')) 
						+ CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY16,'0')) 
						+ CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY17,'0')) 
						+ CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY18,'0'))
						+ CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY19,'0'))
	     + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY20,'0'))

      SELECT @L_TOT904QTY =  CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY1,'0'))   
                           + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY2,'0'))   
                           + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY3,'0')) 
 
      SELECT @L_TOT905QTY =  CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY12,'0'))   
                           + CONVERT(NUMERIC(18,3),ISNULL(@L_TOTQTY13,'0'))   
                         
 
        IF LTRIM(RTRIM(@L_TRX_TAB)) = 'DMT'
        BEGIN

				        SELECT outfile  DPMTRXDTLS FROM @L_TABLE   
						UNION     
						select '99'    
						 + REPLICATE(0,6)  
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOTQTY9,15,3,'L','0'),REPLICATE(0,18))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY10,1,len(convert(varchar(18),@L_TOTQTY10))-2),15,3,'L','0'),REPLICATE(0,18))   
						+ space(15)--REPLICATE(0,15)  
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOT904QTY,15,3,'L','0') ,REPLICATE(0,18))--ISNULL(CITRUS_USR.FN_FORMATSTR(substring((@L_TOTQTY1),1,len(convert(varchar(15),(@L_TOTQTY1)))-2),12,3,'L','0'),REPLICATE(0,15)) -- 904 DFP  
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOT905QTY,15,3,'L','0') ,REPLICATE(0,18))--ISNULL(CITRUS_USR.FN_FORMATSTR(substring((@L_TOT904QTY),1,len(convert(varchar(15),(@L_TOT904QTY)))-2),12,3,'L','0'),REPLICATE(0,15)) -- 905 RFP  
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY7,1,len(convert(varchar(18),@L_TOTQTY7))-2),15,3,'L','0'),REPLICATE(0,18))   
						--+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY8,1,len(convert(varchar(15),@L_TOTQTY5))-2),12,3,'L','0'),REPLICATE(0,15))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY5,1,len(convert(varchar(18),@L_TOTQTY5))-2),15,3,'L','0'),REPLICATE(0,18))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY14,1,len(convert(varchar(18),@L_TOTQTY14))-2),15,3,'L','0'),REPLICATE(0,18))    
						+ REPLICATE(0,18) --Hypothecation Instruction Total Qty 
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY15,1,len(convert(varchar(18),@L_TOTQTY15))-2),15,3,'L','0'),REPLICATE(0,18))    
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY16,1,len(convert(varchar(18),@L_TOTQTY16))-2),15,3,'L','0'),REPLICATE(0,18))    
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY6,1,len(convert(varchar(18),@L_TOTQTY6))-2),15,3,'L','0'),REPLICATE(0,18))   
						--new+ REPLICATE(0,18)
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY8,1,len(convert(varchar(18),@L_TOTQTY8))-2),15,3,'L','0'),REPLICATE(0,18))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY4,1,len(convert(varchar(18),@L_TOTQTY4))-2),15,3,'L','0'),REPLICATE(0,18))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY11,1,len(convert(varchar(18),@L_TOTQTY11))-2),15,3,'L','0'),REPLICATE(0,18))   
						
						+ REPLICATE(0,18) -- 934 should come
						+ REPLICATE(0,18) -- 935 should come
						+ REPLICATE(0,18) -- qty for future
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY20,1,len(convert(varchar(18),@L_TOTQTY20))-2),15,3,'L','0'),REPLICATE(0,18))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY936,1,len(convert(varchar(18),@L_TOTQTY936))-2),15,3,'L','0'),REPLICATE(0,18))   
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY937,1,len(convert(varchar(18),@L_TOTQTY937))-2),15,3,'L','0'),REPLICATE(0,18))   
						--+ REPLICATE(0,36)
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY17,1,len(convert(varchar(18),@L_TOTQTY17))-2),15,3,'L','0'),REPLICATE(0,18))    
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY18,1,len(convert(varchar(18),@L_TOTQTY18))-2),15,3,'L','0'),REPLICATE(0,18))    
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY19,1,len(convert(varchar(18),@L_TOTQTY19))-2),15,3,'L','0'),REPLICATE(0,18))    
						--+ REPLICATE(0,195)
						+ SPACE(30)
						--+ REPLICATE(0,8)
						+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOTQTY,15,3,'L','0') ,REPLICATE(0,18)) DPMTRXDTLS   
        END
        ELSE
        BEGIN

				SELECT outfile  DPMTRXDTLS FROM @L_TABLE   
				UNION     
				select '99'    
				+ REPLICATE(0,6)  
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOTQTY9,12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY10,1,len(convert(varchar(15),@L_TOTQTY10))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ REPLICATE(0,15)  
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOT904QTY,12,3,'L','0') ,REPLICATE(0,15))--ISNULL(CITRUS_USR.FN_FORMATSTR(substring((@L_TOTQTY1),1,len(convert(varchar(15),(@L_TOTQTY1)))-2),12,3,'L','0'),REPLICATE(0,15)) -- 904 DFP  
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOT905QTY,12,3,'L','0') ,REPLICATE(0,15))--ISNULL(CITRUS_USR.FN_FORMATSTR(substring((@L_TOT904QTY),1,len(convert(varchar(15),(@L_TOT904QTY)))-2),12,3,'L','0'),REPLICATE(0,15)) -- 905 RFP  
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY7,1,len(convert(varchar(15),@L_TOTQTY7))-2),12,3,'L','0'),REPLICATE(0,15))   
				--+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY8,1,len(convert(varchar(15),@L_TOTQTY5))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY5,1,len(convert(varchar(15),@L_TOTQTY5))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY14,1,len(convert(varchar(15),@L_TOTQTY14))-2),12,3,'L','0'),REPLICATE(0,15))    
				+ REPLICATE(0,15)
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY15,1,len(convert(varchar(15),@L_TOTQTY15))-2),12,3,'L','0'),REPLICATE(0,15))    
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY16,1,len(convert(varchar(15),@L_TOTQTY16))-2),12,3,'L','0'),REPLICATE(0,15))    
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY6,1,len(convert(varchar(15),@L_TOTQTY6))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ REPLICATE(0,15)
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY4,1,len(convert(varchar(15),@L_TOTQTY4))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY11,1,len(convert(varchar(15),@L_TOTQTY11))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY8,1,len(convert(varchar(15),@L_TOTQTY8))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ REPLICATE(0,15) -- 935 should come
				+ REPLICATE(0,30)
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY20,1,len(convert(varchar(15),@L_TOTQTY20))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY936,1,len(convert(varchar(15),@L_TOTQTY936))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY937,1,len(convert(varchar(15),@L_TOTQTY937))-2),12,3,'L','0'),REPLICATE(0,15))   
				+ REPLICATE(0,30)
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY17,1,len(convert(varchar(15),@L_TOTQTY17))-2),12,3,'L','0'),REPLICATE(0,15))    
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY18,1,len(convert(varchar(15),@L_TOTQTY18))-2),12,3,'L','0'),REPLICATE(0,15))    
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(substring(@L_TOTQTY19,1,len(convert(varchar(15),@L_TOTQTY19))-2),12,3,'L','0'),REPLICATE(0,15))    
				+ REPLICATE(0,195)
				+ SPACE(30)
				--+ REPLICATE(0,8)
				+ ISNULL(CITRUS_USR.FN_FORMATSTR(@L_TOTQTY,12,3,'L','0') ,REPLICATE(0,15)) DPMTRXDTLS   
        END
      

          
          
  
END

GO
