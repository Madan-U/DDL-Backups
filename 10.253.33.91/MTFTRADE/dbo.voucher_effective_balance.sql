-- Object: PROCEDURE dbo.voucher_effective_balance
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------


--Exec voucher_effective_balance 'DEC  5 2017'

CREATE proc [dbo].[voucher_effective_balance] 
(  
@TODATE   VARCHAR (11)  
) 
AS BEGIN   

create table #CLIENTLOGIN1
(

	 [ENT_CODE]    [VARCHAR](25) NOT NULL,  
	 [PARTY_CODE]  [VARCHAR](10) NOT NULL 
 )

 INSERT INTO #CLIENTLOGIN1  
SELECT   PARTY_CODE, ENT_CODE 
FROM   MSAJAG..CLIENT_DETAILS C,   
CBO_TB_ENTITYMASTER E   
WHERE  PARTY_CODE IN ( select CLTCODE from OLDNEW)
--where ENT_CODE = PARTY_CODE
and ENT_CODE = PARTY_CODE
AND E.ENT_TYPE = 'CLIENT'   


----------go---------------------


  SELECT     
   PARTY_CODE,ENT_CODE,
   LEDBAL = SUM(VAMT),DRCR,BALFLAG = 1,LEDFLAG = 1     into #temp11
FROM     LEDGER L (NOLOCK),#CLIENTLOGIN1 M,PARAMETER P       
WHERE   @TODATE BETWEEN SDTCUR AND LDTCUR       
AND VDT >=SDTCUR AND VDT <= @TODATE  AND PARTY_CODE = CLTCODE       
GROUP BY DRCR,PARTY_CODE,ENT_CODE


  INSERT INTO #temp11     
 SELECT PARTY_CODE,ENT_CODE,LEDBAL = SUM(VAMT),DRCR,BALFLAG = 2,LEDFLAG = 1       
FROM     LEDGER L (NOLOCK),#CLIENTLOGIN1 M,PARAMETER P  
WHERE    VDT BETWEEN SDTCUR AND LDTCUR       
         AND PARTY_CODE = CLTCODE       
	GROUP BY DRCR ,party_code,ENT_CODE       


create table #data
	( seg varchar(10), 
	ENT_CODE varchar(20),
	LEDBAL money,
	CLTCODE varchar(20),
	BAL money)

insert #data (seg,ENT_CODE,LEDBAL)
 SELECT  'MTF' as seg ,ENT_CODE,       
LEDBAL = SUM(CASE  WHEN LEDFLAG = 1 AND BALFLAG = 1 THEN (CASE WHEN DRCR = 'D' THEN -LEDBAL       
ELSE LEDBAL END) ELSE 0 END)    FROM     #temp11      
GROUP BY ENT_CODE 


	

create table #temp
	(
	CL_CODE varchar(20),

	BAL_ money
	)
insert #temp (CL_CODE,BAL_)
exec effective_balance_new @TODATE

--delete from #temp where cl_code in (select ent_code from #data1) 

declare @VO int 
declare @eff int 
set @VO = (select count(1) from #data)
set @eff = (select count(1) from #temp)

--select @VO as count ,@eff as count
if @VO >= @eff

--select *  FROM #data a  left outer join  #temp b on a.ENT_CODE = b.CL_CODE order by  b.CL_CODE

--else

--select *  FROM #data a  right  outer  join  #temp b on a.ENT_CODE = b.CL_CODE order by  b.CL_CODE


update a set a.CLTCODE = b.CL_CODE,a.BAL =b.BAL_  FROM #data a  left outer join  #temp b on a.ENT_CODE = b.CL_CODE 

else 

select 'DATA NOT UPDATED.i.e. Voucher count is less than Effective code.'

--select *  FROM #data a  left outer join  #temp b on a.ENT_CODE = b.CL_CODE

--update a set a.CLTCODE = b.CL_CODE,a.BAL =b.BAL_ FROM #data a  left outer join  #temp b

--on a.ENT_CODE = b.CL_CODE

select seg as SEG,ENT_CODE as ENT_CODE_Voucher,ledbal,cltcode as  CLTCODE_effective,BAL   from #data
order by CLTCODE 


end

GO
