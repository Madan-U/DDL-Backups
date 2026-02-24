-- Object: PROCEDURE dbo.Brics_CombinedHolding
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc Brics_CombinedHolding
@STATUSID   VARCHAR(15),       
@STATUSNAME VARCHAR(25),    
@Transdate  datetime,   
@FROMPARTY  VARCHAR(10),      
@TOPARTY    VARCHAR(10),      
--@FROMSCRIP  VARCHAR(12),      
--@TOSCRIP    VARCHAR(12),      
@BRANCH     VARCHAR(10)
 --@FLAG       VARCHAR(1)
AS 


DECLARE @MAXDATE DATETIME 
Select @MAXDATE=max(sysdate) from bsedb.dbo.closing 
/*=================================================================================================    
-- CREATING HASH TABLE TO POPULATE THE HOLDING DATA FROM EACH SEGMENT   
=================================================================================================*/  
CREATE TABLE #DELPAYINMATCH    
(  
 	PARTY_CODE VARCHAR(12),  
	SHORT_NAME VARCHAR(100),  
        SCRIP_CD VARCHAR(12),    
        SCRIP_NAME VARCHAR(100),    
        CERTNO VARCHAR(12),    
        HOLD NUMERIC,    
        BSEHOLD NUMERIC,    
        COLLQTY NUMERIC,    
        CL_RATE NUMERIC (8,2),
	NSEQTY NUMERIC,
	BSEQTY NUMERIC,
	TOTALQTY NUMERIC,
	TOTALVALUE NUMERIC(18,2)      
)    
/*=================================================================================================    
MT Comments:  
        The report needs to be displayed at PARTY / SCRIP level.   
        Add From Party To Party as parameters and add the same in the   
                Where Condition for each query.  
        You will need to add the PARTY_CODE / PARTY_NAME in the table definition above  
        If you are planning to fire a separate query for each client then you will make more   
                visits to the database which will slow down your report.   
  
        General Recommendations regarding SQL queries:  
                Please use indendation as shown above OR adopt a method of your own to ensure that  
                        you write clean queries.   
                For Remarks (Description of SQL) use the method shown above   
                It is recommended that the SQL is written in UPPER CASE so that   
                        it makes it easy to read  
                Kindly include the WITH(NOLOCK) hint in Select Statements   
                        as it will improve performance  
=================================================================================================*/  
              
/*=================================================================================================    
-- NSE BEN QTY    
=================================================================================================*/  
        INSERT INTO #DELPAYINMATCH      
        SELECT   
  		C2.PARTY_CODE,  
  		C1.SHORT_NAME,  
                D.SCRIP_CD,  
                S1.SHORT_NAME,  
                CERTNO,  
                HOLD=ISNULL(SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END),0),  
                BSEHOLD=0,  
                COLLQTY=0,  
               	CL_RATE=0, NSEQTY=0,BSEQTY=0,TOTALQTY=0,0           
        FROM   
                MSAJAG.DBO.DELTRANS D WITH(NOLOCK),   
                MSAJAG.DBO.DELIVERYDP DP WITH(NOLOCK),  
                MSAJAG.DBO.SCRIP2 S2 WITH(NOLOCK),  
                MSAJAG.DBO.SCRIP1 S1 WITH(NOLOCK),  
  		MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK),  
  		MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK)            
        WHERE   
                FILLER2 = 1   
                AND DRCR = 'D'             
                AND DELIVERED = '0'   
                AND TRTYPE IN (904,909)   
                AND D.BDPID = DP.DPID             
                AND D.BCLTDPID = DP.DPCLTNO   
                AND DESCRIPTION NOT LIKE '%POOL%'             
                AND D.TRANSDATE<=@TRANSDATE + '23:59'   
                AND C2.PARTY_CODE BETWEEN @FromParty AND @ToParty   
                AND S1.CO_CODE=S2.CO_CODE   
                AND S2.SCRIP_CD=D.SCRIP_CD    
                AND S2.SERIES=D.SERIES    
  		AND C2.CL_CODE=C1.CL_CODE  
  		AND C2.PARTY_CODE=D.PARTY_CODE   
        GROUP BY   
                C2.PARTY_CODE,  
                CERTNO,  
                D.SCRIP_CD,  
                S1.SHORT_NAME,  
		C2.PARTY_CODE,
		C1.SHORT_NAME
       
/*=================================================================================================    
MT Comments:  
        The report needs to be displayed at PARTY / SCRIP level.   
        But, the PARTY_CODE / PARTY_NAME is not in the SELECT clause.   
        To get the PARTY_NAME (LONG_NAME or SHORT_NAME) you will need to join   
                the CLIENT1 AND CLIENT2 (always from MSAJAG database) tables on the field CL_CODE.   
        The CLIENT2 table will in turn be joined to the DELTRANS table on the field PARTY_CODE  
=================================================================================================*/  
  
 Insert Into #DelPayInMatch      
 select   
  C2.PARTY_CODE,  
  C1.SHORT_NAME,  
  d.scrip_cd,  
  s1.short_name,  
  CertNo,  
  Hold=0,  
  bsehold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  collqty=0,  
  cl_rate=0,NSEQTY=0,BSEQTY=0,TOTALQTY=0,0           
 From   
  bsedb.dbo.DelTrans D WITH(NOLOCK),   
  DeliveryDp DP WITH(NOLOCK),  
  scrip1 s1 WITH(NOLOCK),  
  scrip2 s2 WITH(NOLOCK),  
  msajag.dbo.client1 c1 with (nolock),  
  msajag..client2 c2 with(nolock)            
 Where   
  Filler2 = 1   
  And DrCr = 'D'             
  And Delivered = '0'   
  And TrType in (904,909)   
  And D.BdpId = DP.DpId             
  And D.BCltDpId = DP.DpCltNo   
  And Description Not Like '%POOL%'             
  And D.Transdate<=@transdate + '23:59'    
  and c2.party_code BETWEEN @FromParty AND @ToParty   
  and s1.co_code=s2.co_code   
  and s2.bsecode=d.scrip_cd     
  and c2.cl_code=c1.cl_code  
  and c2.party_code=d.party_code  
   
 Group By   
  c2.Party_code,  
  CertNo,  
  d.scrip_cd,  
  s1.short_name,  
  c2.party_code,  
  c1.short_name                
/*=================================================================================================    
MT Comments:  
        The above query is fine and need not be modified           
=================================================================================================*/  
    
---COLL QTY         
 Insert Into #DelPayInMatch            
 select   
  c2.party_code,  
  c1.short_name,  
  s.scrip_cd,  
  s1.short_name,  
  CertNo=s.IsIn,  
  Hold=0,  
  bseHold=0,  
  COLLQty=Sum(Qty), 
  cl_rate=0,NSEQTY=0,BSEQTY=0,TOTALQTY=0,0             
 from   
  MSAJAG.DBO.COLLATERALDETAILS s WITH(NOLOCK),  
  client2 c2 WITH(NOLOCK),  
  msajag.dbo.scrip1 s1 WITH(NOLOCK),  
  msajag.dbo.scrip2 s2 WITH(NOLOCK),  
  msajag.dbo.client1 c1 with(nolock)  
     
  where   
  Effdate like @transdate     
  and c2.party_code=s.party_code   
  and s.party_code BETWEEN @FromParty AND @ToParty    
  and s1.co_code=s2.co_code   
  and s.scrip_cd=s2.scrip_cd    
  and s.series=s2.series     
  and c2.cl_code=c1.cl_code  
  and c2.party_code=s.party_code   
 Group By   
  s.scrip_Cd,  
  s.IsIn,  
  s1.short_name,  
  c2.party_code,  
  c1.short_name               
-- Having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0             
/*=================================================================================================    
MT Comments:  
        The above query is fine and need not be modified           
=================================================================================================*/  
Insert Into #DelPayInMatch       
  select d.party_code,C1.SHORT_NAME,D.SCRIP_CD,'',Mu.ISIN,0,0,0,0,NQTY=SUM(CASE WHEN D.INOUT='I' THEN -QTY ELSE QTY END),0,0,0  
         FROM         
         
      MSAJAG.DBO.SETT_MST M WITH (NOLOCK),    
      MSAJAG.DBO.DELIVERYCLT D WITH (NOLOCK),   
      msajag.dbo.scrip1 s1 WITH (NOLOCK),    
      MSAJAG.DBO.SCRIP2 S2 WITH (NOLOCK),  
       MSAJAG.DBO.CLIENT1 C1 WITH (NOLOCK),    
  MSAJAG.DBO.MULTIISIN MU
 WITH (NOLOCK)	
WHERE         
              m.start_date <= @transdate + '23:59'  and D.party_code BETWEEN @FROMPARTY AND @TOPARTY  
 and    m.funds_payin > @transdate      
 and m.sett_no=D.sett_no and m.sett_type=D.sett_type     
 and D.scrip_cd=s2.scrip_cd and D.series=s2.series     
 and s2.co_code=s1.co_code and c1.cl_code=d.party_code      
and mU.scrip_cd=d.scrip_cd AND MU.VALID=1 AND MU.SERIES=D.SERIES
group by D.party_code,D.scrip_cd,c1.short_name,MU.ISIN 
UNION ALL  
--Insert Into #DelPayInMatch       
select d.party_code,C1.SHORT_NAME,D.SCRIP_CD,'',Mu.ISIN,0,0,0,0,0,BQTY=SUM(CASE WHEN D.INOUT='I' THEN -QTY ELSE QTY END),0,0  
         FROM         
         
      BSEDB.DBO.SETT_MST M WITH (NOLOCK),    
      BSEDB.DBO.DELIVERYCLT D WITH (NOLOCK),   
      BSEDB.dbo.scrip1 s1 WITH (NOLOCK),    
      BSEDB.DBO.SCRIP2 S2 WITH (NOLOCK),  
      MSAJAG.DBO.CLIENT1 C1 WITH (NOLOCK) ,
	BSEDB.DBO.MULTIISIN MU WITH (NOLOCK)   

WHERE         
              m.start_date <= @transdate + '23:59' and D.party_code BETWEEN @FROMPARTY AND @TOPARTY  
 and  m.funds_payin > @transdate      
 and m.sett_no=D.sett_no and m.sett_type=D.sett_type     
 and D.scrip_cd=s2.BSECODE and s2.co_code=s1.co_code and c1.cl_code=d.party_code      
and d.scrip_cd=mu.scrip_cd AND MU.VALID=1
group by D.party_code,D.scrip_cd,c1.short_name,MU.ISIN   
    

        UPDATE   
                #DELPAYINMATCH   
        SET   
                CL_RATE=ISNULL(C.CL_RATE,0)   
        FROM   
                BSEDB.DBO.CLOSING C,  
                SCRIP2 S2,#DELPAYINMATCH R,  
                BSEDB.DBO.MULTIISIN M     
        WHERE   
                C.SYSDATE LIKE @MAXDATE  
                AND M.SCRIP_CD=C.SCRIP_CD   
                AND C.SCRIP_CD=S2.BSECODE  
                AND M.ISIN=R.CERTNO  
    
  
   	UPDATE   
                #DELPAYINMATCH   
        SET   
                SCRIP_CD=S2.SCRIP_CD  
        FROM   
                BSEDB.DBO.MULTIISIN M,#DELPAYINMATCH R,   
                SCRIP2 S2,SCRIP1 S1    
        WHERE   
                
                R.SCRIP_CD=M.SCRIP_CD  
		AND M.SCRIP_CD=S2.BSECODE   
		AND S2.CO_CODE=S1.CO_CODE  
		AND M.VALID=1   
                  
  
/*=================================================================================================    
MT Comments:  
        The above update query is fine.   
        Also write another Update Query to Update the Scrip Code based on the ISIN number   
        from the BSEDB.DBO.MULTIISIN table.   
        This will ensure that all the records have the same Scrip Code.   
        In the BSEDB.DBO.MULTIISIN table there are multiple records for each SCRIP CODE.  
        But, for every SCRIP CODE there will be only one record with the VALID flag set as 1.  
        Please use the VALID = 1 condition while updating.   
=================================================================================================*/  
        SELECT   
                PARTY_CODE,   
		--TOTALVALUE=SUM(CL_RATE*(HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY))
		TOTALVALUE=SUM((HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY))
	        INTO #DELPAYINMATCH1	
	FROM   
                #DELPAYINMATCH   
        GROUP BY   
                PARTY_CODE  
        --HAVING SUM(CL_RATE*(HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY))>0  
     

        SELECT   
                D.PARTY_CODE,   
                SHORT_NAME,   
                SCRIP_CD,  
                CERTNO,   
                SHORT_NAME = MAX(SHORT_NAME), -- This has been done as the Scrip Name might be different in different segments.  
                HOLD = SUM(HOLD),  
                BSEHOLD = SUM(BSEHOLD),  
                COLLQTY = SUM(COLLQTY),  
                CL_RATE,
		NSEQTY =SUM(NSEQTY),
		BSEQTY= sum(BSEQTY),
		SUM(HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY)AS TOTALQTY,
		--TOTALVALUE=SUM(CL_RATE*(HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY))
		TOTALVALUE=SUM((HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY))
        FROM   
                #DELPAYINMATCH  D,  
		#DELPAYINMATCH1 D1
	WHERE 
		D.PARTY_CODE = D1.PARTY_CODE
        GROUP BY   
                D.PARTY_CODE,  
                CERTNO,  
                SCRIP_CD,   
                CERTNO,   
                CL_RATE,
		SHORT_NAME   
        HAVING SUM(HOLD+BSEHOLD+COLLQTY+NSEQTY+BSEQTY)>0 

	ORDER BY 
		D.PARTY_CODE,
		D.TOTALVALUE DESC
	


/*
	SELECT 
		D.*
	FROM
		#DELPAYINMATCH	D,
		#DELPAYINMATCH1 D1
	WHERE 
		D.PARTY_CODE = D1.PARTY_CODE
	
	ORDER BY 
		D1.TOTALVALUE DESC,
		D.PARTY_CODE 
*/

/*=================================================================================================    
MT Comments:  
        Please refrain from writing queries "SELECT * FROM" statements.   
        Instead write the statement with each individual field name in the SELECT block.   
          
        NOTE:   
        In the first three queries above there may be more than one record inserted for   
        a SCRIP / CLIENT combination.   
        To ensure that a single row is displayed for each SCRIP / CLIENT combination:  
                use the modified select statement above.   
=================================================================================================*/  
drop table #delpayinmatch
drop table #delpayinmatch1
  
/*select c2.party_code,c1.short_name,c1.trader,c1.sub_broker,c1.family  
from client2 c2,client1 c1  
where c1.cl_code=c2.cl_code*/

GO
