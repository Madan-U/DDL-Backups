-- Object: PROCEDURE citrus_usr.PR_BULK_DPC9_SP
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--F:\bulk dpc9\cLEARING_mEMBER_aCCOUNT\08DPC9U.300172
--exec PR_BULK_DPC9 'CDSL','HO','BULK','C:\basis\08DPC9U.444758', '*|~*', '|*~|'  , ''
--TMP_DPC9_CDSL_TRX_MSTR
--TMP_DPC9_CDSL_TRX_HLDG
--create table TMP_dpc9_SOURCE (details varchar(8000))
create PROC [citrus_usr].[PR_BULK_DPC9_SP]
(@PA_EXCH          VARCHAR(20)    
,@PA_LOGIN_NAME    VARCHAR(20)    
,@PA_MODE          VARCHAR(10)                                    
,@PA_DB_SOURCE     VARCHAR(250)    
,@ROWDELIMITER     CHAR(4) =     '*|~*'      
,@COLDELIMITER     CHAR(4) =     '|*~|'      
,@PA_ERRMSG        VARCHAR(8000) OUTPUT)
AS
BEGIN 

  IF @PA_MODE = 'BULK'  
  BEGIN  
  --  
       DECLARE @@L_COUNT INTEGER  
       truncate table TMP_dpc9_SOURCE  
  
       DECLARE @@SSQL VARCHAR(8000)  
       SET @@SSQL ='BULK INSERT TMP_dpc9_SOURCE FROM ''' + @PA_DB_SOURCE + ''' WITH   
       (  
           FIELDTERMINATOR = ''\n'',  
           ROWTERMINATOR = ''\n''  
  
       )'  
  
       EXEC(@@SSQL)  
  --
  END 
--drop table #TMP_DPC9
    CREATE TABLE #TMP_DPC9
	(
		ID             INT IDENTITY(1,1) NOT NULL, 
		ORG_DETAILS    VARCHAR(8000), 
		MOD_DETAILS    VARCHAR(800), 
		ISIN           VARCHAR(50),
		BOID           VARCHAR(16) , target_set_no varchar(50)
	)

	CREATE CLUSTERED INDEX [indx_id] ON [dbo].[#TMP_DPC9] 
	(
		[ID] ASC, ISIN,BOID 
	)


	  DELETE FROM TMP_dpc9_SOURCE 
      WHERE  details NOT LIKE '01%'
         AND details NOT LIKE '02%'
         AND details NOT LIKE '04%'
         AND details NOT LIKE '07%'


      
  INSERT INTO #TMP_DPC9 
  SELECT ORG_DETAILS = DETAILS,
		 DETAILS = case when left(DETAILS,2) = '04' then replace(substring(details,1,len(details)-1),citrus_usr.fn_splitval_by(DETAILS,7,'~'),'') else DETAILS end , 
         ISIN = (CASE 
                   WHEN DETAILS LIKE '02%' THEN  citrus_usr.fn_splitval_by(DETAILS,2,'~')  + '~' + citrus_usr.fn_splitval_by(DETAILS,3,'~')
                   ELSE ''
                 END),
		 BOID = (CASE WHEN DETAILS LIKE '01%' THEN SUBSTRING(DETAILS,10,16) ELSE '' END), target_set_no  = citrus_usr.fn_splitval_by(DETAILS,7,'~')
  FROM   TMP_dpc9_SOURCE 

	UPDATE #TMP_DPC9 
	SET    #TMP_DPC9.MOD_DETAILS = #TMP_DPC9.MOD_DETAILS +  T.ISIN 
	FROM   (SELECT ID, 
				ISIN
				FROM   #TMP_DPC9
				WHERE  ISIN <> '') T 
	WHERE  T.ID = (SELECT TOP 1 ID
					FROM   #TMP_DPC9 S
					WHERE  S.ID < #TMP_DPC9.ID
					AND S.ISIN <> ''
					ORDER BY 1 DESC)
	         AND (left(#TMP_DPC9.MOD_DETAILS,2) = '04')



DECLARE @c_access_cursor CURSOR  
declare @l_id numeric
, @l_boid varchar(16)
, @c_id numeric
, @c_boid varchar(16)

set  @l_id = 0
set  @l_boid = ''

select id, BOID into #TEST_TMP_DPC9  from #TMP_DPC9 where BOID <> ''

SET    @c_access_cursor =  CURSOR fast_forward FOR      
select id, BOID from #TEST_TMP_DPC9 where BOID <> '' order by id


OPEN @c_access_cursor      
 FETCH NEXT FROM @c_access_cursor INTO @c_id , @c_boid 

	WHILE @@fetch_status = 0      
	BEGIN      
	-- 
      --select boid , @l_boid  from TEST_TMP_DPC9  where id between @l_id  and @c_id and boid  = ''

      update  #TMP_DPC9  set boid = @l_boid where id between @l_id  and @c_id and boid  = ''

      set @l_id = @c_id 
      set @l_boid = @c_boid 

      FETCH NEXT FROM @c_access_cursor INTO @c_id , @c_boid 

    --
    END

 CLOSE      @c_access_cursor      
 DEALLOCATE @c_access_cursor      

 update  #TMP_DPC9  set boid = @l_boid  where id > @l_id  and boid  = ''




UPDATE #TMP_DPC9 
SET    #TMP_DPC9.MOD_DETAILS = #TMP_DPC9.MOD_DETAILS + '~' + #TMP_DPC9.BOID + '~' + target_set_no
where  left(#TMP_DPC9.MOD_DETAILS,2) = '04'


UPDATE #TMP_DPC9 
SET    #TMP_DPC9.MOD_DETAILS = #TMP_DPC9.MOD_DETAILS + '~' + #TMP_DPC9.BOID 
where  left(#TMP_DPC9.MOD_DETAILS,2) = '07'




/*
 TMPDPC9_TRX_DT = ClsDate.GetFormatedDate(TMPDPC9ARR(1), "DD-MM-YYYY")
                    If TMPDPC9ARR(3) = "C" Then
                        TMPDPC9_TRX_CD = "2246"
                    Else
                        TMPDPC9_TRX_CD = "2277"
                    End If

TMPDPC9_TRX_DESC = TMPDPC9ARR(2)
TMPDPC9_TRX_DESC_ARR = Split(ReplaceSpaces(TMPDPC9_TRX_DESC), ColDelimeter)
04~07-02-2007~OVERDUE-CR From 1203270000093862~C~100.000~100.000~INE402A01010~SHAW WALLACE & CO~1203270000093877
*/
CREATE TABLE #TMP_DPC9_CDSL_TRX_MSTR(
	[TMPDPC9_ID] [numeric](18, 0) NULL,
	[TMPDPC9_BOID] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_BONM] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_ISIN] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_ISIN_SHRT_DESC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_OPNG_BAL] [numeric](18, 5) NULL,
	[TMPDPC9_TRX_DT] [datetime] NULL,
	[TMPDPC9_TRX_CD] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_TRX_DESC] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_DP_INTREFNO] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_SRC_DPID] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_OPERATOR_ID] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_TRX_SEQNO] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_DR_QTY] [numeric](18, 0) NULL,
	[TMPDPC9_CR_QTY] [numeric](18, 0) NULL,
	[TMPDPC9_TRX_NO] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_TRX_TYPE_DESC] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_CTRBOID] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_CTRDPID] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_CTRCMBPID] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_SETTNO] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_SETTTYP] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_EXCH_ID] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_TOT_CLSNG_BAL] [numeric](18, 0) NULL,
	[TMPDPC9_DPAM_ID] [numeric](10, 0) NULL,
	[TMPDPC9_DPM_ID] [numeric](10, 0) NULL,
	[TMPDPC9_SETTID_02] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_SETTID_04] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_CTR_SETTID] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

insert into #TMP_DPC9_CDSL_TRX_MSTR
(TMPDPC9_ID,TMPDPC9_BOID,TMPDPC9_BONM,TMPDPC9_ISIN
,TMPDPC9_ISIN_SHRT_DESC,TMPDPC9_OPNG_BAL,TMPDPC9_TRX_DT
,TMPDPC9_TRX_CD,TMPDPC9_TRX_DESC,TMPDPC9_DP_INTREFNO
,TMPDPC9_SRC_DPID,TMPDPC9_OPERATOR_ID,TMPDPC9_TRX_SEQNO
,TMPDPC9_DR_QTY,TMPDPC9_CR_QTY
,TMPDPC9_TRX_NO
,TMPDPC9_TRX_TYPE_DESC
,TMPDPC9_CTRBOID
,TMPDPC9_CTRDPID
,TMPDPC9_CTRCMBPID
,TMPDPC9_SETTNO
,TMPDPC9_SETTTYP
,TMPDPC9_EXCH_ID
,TMPDPC9_TOT_CLSNG_BAL,TMPDPC9_DPAM_ID
,TMPDPC9_DPM_ID,TMPDPC9_SETTID_02,TMPDPC9_SETTID_04
,TMPDPC9_CTR_SETTID)
select 1 TMPDPC9_ID, citrus_usr.fn_splitval_by(mod_details,9,'~') TMPDPC9_BOID, citrus_usr.fn_splitval_by(mod_details,9,'~') TMPDPC9_BONM, citrus_usr.fn_splitval_by(mod_details,7,'~') TMPDPC9_ISIN
,citrus_usr.fn_splitval_by(mod_details,8,'~') TMPDPC9_ISIN_SHRT_DESC
,case when citrus_usr.fn_splitval_by(mod_details,4,'~') ='C' then convert(numeric(18,3),citrus_usr.fn_splitval_by(mod_details,6,'~')) - convert(numeric(18,3),citrus_usr.fn_splitval_by(mod_details,5,'~')) 
      else convert(numeric(18,3),citrus_usr.fn_splitval_by(mod_details,5,'~')) + convert(numeric(18,3),citrus_usr.fn_splitval_by(mod_details,6,'~')) end TMPDPC9_OPNG_BAL ,convert(datetime,citrus_usr.fn_splitval_by(mod_details,2,'~'),103) TMPDPC9_TRX_DT
,case when citrus_usr.fn_splitval_by(mod_details,4,'~') ='C' then '2246' else '2277' end TMPDPC9_TRX_CD,citrus_usr.fn_splitval_by(mod_details,3,'~') TMPDPC9_TRX_DESC ,'' TMPDPC9_DP_INTREFNO
,'' TMPDPC9_SRC_DPID,'' TMPDPC9_OPERATOR_ID,'' TMPDPC9_TRX_SEQNO
,case when citrus_usr.fn_splitval_by(mod_details,4,'~') = 'D'  then convert(numeric(18,3),citrus_usr.fn_splitval_by(mod_details,5,'~')) else 0 end TMPDPC9_DR_QTY,case when citrus_usr.fn_splitval_by(mod_details,4,'~') = 'C'  then convert(numeric(18,3),citrus_usr.fn_splitval_by(mod_details,5,'~')) else 0 end  TMPDPC9_CR_QTY
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EARMARK-CR', 'EARMARK-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EP-CR', 'EP-DR') then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),3) = 'TXN' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'ID-EARMARK-CR' then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),3) = 'TXN' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'INITIAL' then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),3) = 'TXN' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('INTDEP-CR', 'INTDEP-DR') then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),3) = 'TXN' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('INTDEP-EARMARK-DR') then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),3) = 'TXN' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OF-CR', 'OF-DR')  then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),2) = 'TX' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'SETTLEMENT-DR' then right(citrus_usr.fn_splitval_by(mod_details,3,'~'),6)
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BONUS' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH' then case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') in ('CR','DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),7,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL' then case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') in ('CR','DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),7,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('DEMAT','REMAT') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'CORPORATE' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'CA-' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|') 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'SEC' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'CONFISCATE' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),2,':') 
else '' end  TMPDPC9_TRX_NO
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EARMARK-CR', 'EARMARK-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EP-CR', 'EP-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'ID-EARMARK-CR' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'INITIAL' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') + 'PUBLIC OFFERING'
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('INTDEP-CR', 'INTDEP-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('INTDEP-EARMARK-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OF-CR', 'OF-DR')  then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('SETTLEMENT-DR' ,'SETTLEMENT-CR')  then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BONUS' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL-CR' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL-DR' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH' then case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') = 'CR' then 'BSECH-CR' when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') = 'DR' then 'BSECH-DR' end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL' then case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') = 'CR' then 'NSCCL-CR' when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|') = 'DR' then 'NSCCL-CR' end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('DEMAT','REMAT') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'CORPORATE' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'CA-' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'SEC' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'TRANSFER' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'TRANSMISSION' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'PLEDGE' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'UNPLEDGE' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OVERDUE-DR', 'OVERDUE-CR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'SPLIT' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'CONFISCATE' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|')
else '' end TMPDPC9_TRX_TYPE_DESC
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EP-CR', 'EP-DR') then case when left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),4) = 'CtBo' then  citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|'),2,':') else citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|') end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OF-CR', 'OF-DR')  then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'TRANSFER' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'TRANSMISSION' then case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|') = 'Db' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|') else '' end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'PLEDGE' then citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|'),2,':')
else '' end TMPDPC9_CTRBOID
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('INTDEP-CR', 'INTDEP-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OF-CR', 'OF-DR')  then left(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),8)
else '' end TMPDPC9_CTRDPID
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('INTDEP-CR', 'INTDEP-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('BSECH-CR','BSECH','NSCCL-CR','NSCCL-DR','NSCCL')  then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),2,'|')
else '' end TMPDPC9_CTRCMBPID
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EARMARK-CR', 'EARMARK-DR') then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),'NO')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EP-CR', 'EP-DR') then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),'NO')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OF-CR', 'OF-DR')  then case when isnumeric(citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(mod_details,3,'~'),4,':'))= 1 then right(citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(mod_details,3,'~'),4,':'),7) end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('SETTLEMENT-DR' ,'SETTLEMENT-CR')  and citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|') <> '' then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),'NO')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH-CR' then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|'),'NO')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL-CR' then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|'),'NO')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH' then citrus_usr.fn_fetch_set_dtls('11',citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),'NO')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL' then citrus_usr.fn_fetch_set_dtls('12',citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),'NO')
else '' end   TMPDPC9_SETTNO
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EARMARK-CR', 'EARMARK-DR') then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),'TYPE')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EP-CR', 'EP-DR') then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),'TYPE')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('OF-CR', 'OF-DR')  then case when isnumeric(citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(mod_details,3,'~'),4,':'))= 1 then left(citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(mod_details,3,'~'),4,':'),6) else left(citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by(mod_details,3,'~'),4,':'),1) end 
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('SETTLEMENT-DR' ,'SETTLEMENT-CR')  then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),'TYPE')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH-CR' then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|'),'TYPE')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL-CR' then citrus_usr.fn_fetch_set_dtls(citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|'),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),6,'|'),'TYPE')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH' then citrus_usr.fn_fetch_set_dtls('11',citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),'TYPE')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL' then citrus_usr.fn_fetch_set_dtls('12',citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),4,'|'),'TYPE')
else '' end  TMPDPC9_SETTTYP
,case when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EARMARK-CR', 'EARMARK-DR') then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('EP-CR', 'EP-DR') then right(citrus_usr.fn_splitval_by(mod_details,3,'~'),2)
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') in ('SETTLEMENT-DR' ,'SETTLEMENT-CR')  then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),5,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH-CR' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL-CR' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL-DR' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),3,'|')
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'BSECH' then '11'
when citrus_usr.fn_splitval_by(replace(citrus_usr.fn_splitval_by(mod_details,3,'~'),' ','|'),1,'|') = 'NSCCL' then '12'
else '' end TMPDPC9_EXCH_ID
,'0' TMPDPC9_TOT_CLSNG_BAL,'0' TMPDPC9_DPAM_ID
,'0' TMPDPC9_DPM_ID
, '' --citrus_usr.fn_splitval_by(mod_details,4,'~') TMPDPC9_SETTID_02
, '' --citrus_usr.fn_splitval_by(mod_details,7,'~') TMPDPC9_SETTID_04
, '' --citrus_usr.fn_splitval_by(mod_details,8,'~') TMPDPC9_CTR_SETTID
 from #TMP_DPC9 where mod_details like '04%'


CREATE TABLE #TMP_DPC9_CDSL_TRX_HLDG(
	[TMPDPC9_HLDG_BOID] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_HLDG_BONM] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_HLDG_ISIN] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_HLDG_ISIN_SHRT_DESC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_HLDG_TRX_DT] [datetime] NULL,
	[TMPDPC9_HLDG_CURR_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_SAFEKEEP_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_PLEDGE_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_FREE_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_LOCKEDIN_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_EARMARKED_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_LEND_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_AVL_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_BORROW_QTY] [numeric](13, 3) NULL,
	[TMPDPC9_HLDG_DPM_ID] [numeric](10, 0) NULL,
	[TMPDPC9_HLDG_DPAM_ID] [numeric](10, 0) NULL,
	[TMPDPC9_HLDG_SETTID_02] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_HLDG_SETTID_04] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TMPDPC9_HLDG_CTR_SETTID] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

insert into #TMP_DPC9_CDSL_TRX_HLDG
(TMPDPC9_HLDG_BOID
,TMPDPC9_HLDG_BONM
,TMPDPC9_HLDG_ISIN
,TMPDPC9_HLDG_ISIN_SHRT_DESC
,TMPDPC9_HLDG_TRX_DT
,TMPDPC9_HLDG_CURR_QTY
,TMPDPC9_HLDG_SAFEKEEP_QTY
,TMPDPC9_HLDG_PLEDGE_QTY
,TMPDPC9_HLDG_FREE_QTY
,TMPDPC9_HLDG_LOCKEDIN_QTY
,TMPDPC9_HLDG_EARMARKED_QTY
,TMPDPC9_HLDG_LEND_QTY
,TMPDPC9_HLDG_AVL_QTY
,TMPDPC9_HLDG_BORROW_QTY
,TMPDPC9_HLDG_DPM_ID
,TMPDPC9_HLDG_DPAM_ID
,TMPDPC9_HLDG_SETTID_02
,TMPDPC9_HLDG_SETTID_04
,TMPDPC9_HLDG_CTR_SETTID
)
select TMPDPC9_BOID , TMPDPC9_BONM , TMPDPC9_ISIN , TMPDPC9_ISIN_SHRT_DESC , tmpdpc9_trx_dt 
, citrus_usr.fn_splitval_by(mod_details,4,'~')
, citrus_usr.fn_splitval_by(mod_details,5,'~')
, citrus_usr.fn_splitval_by(mod_details,6,'~')
, citrus_usr.fn_splitval_by(mod_details,7,'~')
, citrus_usr.fn_splitval_by(mod_details,8,'~')
, citrus_usr.fn_splitval_by(mod_details,9,'~')
, citrus_usr.fn_splitval_by(mod_details,10,'~')
, citrus_usr.fn_splitval_by(mod_details,11,'~')
, citrus_usr.fn_splitval_by(mod_details,12,'~')

,0
,0
,''
,''
,'' from #TMP_DPC9_CDSL_TRX_MSTR , #TMP_DPC9 
where citrus_usr.fn_splitval_by(mod_details,15,'~')  = TMPDPC9_BOID 
and   citrus_usr.fn_splitval_by(mod_details,2,'~')   = TMPDPC9_ISIN 
and   left(#TMP_DPC9.MOD_DETAILS,2) = '07'
group by TMPDPC9_BOID , TMPDPC9_BONM , TMPDPC9_ISIN , TMPDPC9_ISIN_SHRT_DESC , tmpdpc9_trx_dt, mod_details





DECLARE @c_access_cursor1 CURSOR  
declare @l_trx_dt  datetime
declare @l_dpmdpid varchar(20)
declare @l_counter numeric
set @l_counter = 100000
select @l_dpmdpid= dpm_dpid from dp_mstr where dpm_excsm_id = default_dp and dpm_deleted_ind = 1 and left(dpm_dpid ,2) <> 'IN'
 SET    @c_access_cursor1 =  CURSOR fast_forward FOR      
 select distinct TMPDPC9_TRX_DT from #TMP_DPC9_CDSL_TRX_MSTR order by TMPDPC9_TRX_DT
 
print @l_dpmdpid 

 OPEN @c_access_cursor1      
 FETCH NEXT FROM @c_access_cursor1 INTO @l_trx_dt 


	WHILE @@fetch_status = 0      
	BEGIN      
	-- 

       truncate table TMP_DPC9_CDSL_TRX_MSTR
       truncate table TMP_DPC9_CDSL_TRX_HLDG

       insert into TMP_DPC9_CDSL_TRX_MSTR
       select * from #TMP_DPC9_CDSL_TRX_MSTR where TMPDPC9_TRX_DT = @l_trx_dt


       insert into TMP_DPC9_CDSL_TRX_HLDG
       select * from #TMP_DPC9_CDSL_TRX_HLDG where TMPDPC9_HLDG_TRX_DT = @l_trx_dt

print @l_trx_dt
       exec [pr_ins_upd_dpc9] 'HO',@l_dpmdpid,@l_counter,'N'
 FETCH NEXT FROM @c_access_cursor1 INTO @l_trx_dt 
       set @l_counter = @l_counter + 1

    --
    END

 CLOSE      @c_access_cursor1      
 DEALLOCATE @c_access_cursor1      

--
END

GO
