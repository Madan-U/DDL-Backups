-- Object: PROCEDURE dbo.Fill_PartyBalances
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Procedure  [dbo].[Fill_PartyBalances]          
@fromparty varchar(10),                      
@toparty varchar(10),                       
@opendate varchar(11),                      
@fromdt varchar(11),                      
@todate varchar(11),             
@IntRateCr money,          
@IntRateDr money          
          
                      
as                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                 
                
declare                       
@balcur as cursor,                      
@baldate as datetime,                      
@enddateNew as datetime,                      
@enddate as datetime,   
@enddateN as datetime,   
@Newdate as Varchar(11)            
                     
Declare @CltcodeTmp as Varchar(11),            
    @VAmtTmp as money,            
    @VAmtTmp1 as money,            
    @intSrno Int,             
    @CltcodeTmp1 as varchar(11),            
    @IntrestCursorTmp as Cursor            
            
set nocount on                      
            
            
Delete TBL_REPORT_INTEREST_MARGIN Where BalanceDate between @fromdt  and @todate  + ' 23:59:59'           
  and CltCode Between @fromparty and @toparty          
Truncate Table  TBl_RptDate           
            
select @baldate = @fromdt --+ ' 23:59'                      
select @enddate = @todate --+ ' 23:59:59'                      
select @enddateN = @todate + ' 23:59:59'                      
select @enddateNew = dateadd(day,1,@baldate)                       
                      
insert into TBL_REPORT_INTEREST_MARGIN            
Select  CltCode,BalanceDate,sum(VAmt) VAmt, 0,0,SUM(MAMT) MAMT, 0, 0,@IntRateDr,@IntRateDr          
      From             
   (            
                      
    Select l.cltcode, left(convert(Varchar,VDT,109),11) BalanceDate ,sum( case when upper(drcr) = 'D' then vamt else -vamt end) Vamt, 0 MAMT              
    from ledger l, acmast a where vdt >= @fromDt and vdt <= @enddateN            
    and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty and vtyp in ('2','3')              
    AND NOT ( VTYP = '8' AND L.BOOKTYPE = '02' )                       
    group by l.cltcode, left(convert(Varchar,VDT,109),11)                  
            
    union all                
            
    select l.cltcode,left(convert(Varchar,EDT,109),11) BalanceDate,sum( case when upper(drcr) = 'D' then vamt else -vamt end) VAmt , 0 MAMT              
    from ledger l, acmast a where edt >= @fromDt and edt <= @enddateN                 
    and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty and vtyp not in ('2','3','18')                
    AND NOT ( VTYP = '8' AND L.BOOKTYPE = '02' )                       
    group by l.cltcode , left(convert(Varchar,EDT,109),11)             
            
    union all                  
            
    select l.cltcode,@fromdt BalanceDate,sum( case when upper(drcr) = 'D' then vamt else -vamt end) VAmt , 0 MAMT             
    from ledger l, acmast a where vdt >= @opendate and vdt < @fromDt            
    and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty and vtyp in ('2','3')             
    AND NOT ( VTYP = '8' AND L.BOOKTYPE = '02' )                 
    group by l.cltcode             
            
            
    union all                  
            
    select l.cltcode,@fromdt BalanceDate,sum( case when upper(drcr) = 'D' then vamt else -vamt end) VAmt, 0 MAMT              
    from ledger l, acmast a where edt >= @opendate and edt < @fromDt            
    and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty and vtyp not in ('2','3','18')              
    AND NOT ( VTYP = '8' AND L.BOOKTYPE = '02' )                 
    group by l.cltcode             
            
            
    union all              
            
    select l.cltcode,@fromdt BalanceDate,sum( case when upper(drcr) = 'D' then vamt else -vamt end) VAmt  , 0 MAMT                       
    from ledger l, acmast a where Edt >= @opendate and Edt <= @fromDt            
    and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty and vtyp = '18'            
    AND NOT ( VTYP = '8' AND L.BOOKTYPE = '02' )                 
    group by l.cltcode             
        
union all              
            
    select l.cltcode,@fromdt BalanceDate,sum( case when upper(drcr) = 'C' then vamt else -vamt end) VAmt , 0 MAMT                         
    from ledger l, acmast a where Edt >= @opendate and vdt < @opendate        
    and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty         
 /*BELOW MENTIONED CONDITION ADDED LATER*/      
 AND VTYP NOT IN (2, 3)      
 /*-------------------------------------*/      
    AND NOT ( VTYP = '8' AND L.BOOKTYPE = '02' )                 
    group by l.cltcode  

/* MARGIN LEDGER LOGIC INCLUDED */
  UNION ALL            
    
  SELECT L.PARTY_CODE CLTCODE,           
  (CASE WHEN CONVERT(DATETIME,LEFT(CONVERT(VARCHAR,VDT,109),11)) <  CONVERT(DATETIME,@FROMDT) THEN @FROMDT ELSE LEFT(CONVERT(VARCHAR,VDT,109),11) END) BALANCEDATE ,              
  0 VAMT, SUM( CASE WHEN UPPER(DRCR) = 'D' THEN AMOUNT ELSE -AMOUNT END) MAMT              
  FROM MARGINLEDGER L, ACMAST A WHERE VDT >= @fromDt AND VDT <= @enddateN              
  AND L.PARTY_CODE = A.CLTCODE AND A.ACCAT = 4 AND A.CLTCODE >= @FROMPARTY AND A.CLTCODE <= @TOPARTY              
  GROUP BY L.PARTY_CODE, (CASE WHEN CONVERT(DATETIME,LEFT(CONVERT(VARCHAR,VDT,109),11)) <  CONVERT(DATETIME,@FROMDT) THEN @FROMDT ELSE LEFT(CONVERT(VARCHAR,VDT,109),11) END)            
/* MARGIN LEDGER LOGIC INCLUDED */
            
   ) Ldgr            
   group by cltcode,  BalanceDate            
            
while @baldate <= @enddate            
 begin            
   Insert Into TBl_RptDate values (@baldate,@@spid)            
    select @baldate = dateadd(day,1,@baldate)                       
 end            
            
Insert into TBL_REPORT_INTEREST_MARGIN            
 Select          
-- CltCode, Rpt_Date + ' 00:00', 0, 0, 0,@IntRateCr, @IntRateDr          
   CLTCODE, RPT_DATE + ' 00:00', 0, 0, 0,0, 0, 0, @INTRATECR, @INTRATEDR
 From           
  AcMast A, TBl_RptDate            
 Where          
   A.AcCat = 4 And ProgId = @@spid             
  And CltCode Not In (            
      Select           
       CltCode           
      From           
       TBL_REPORT_INTEREST_MARGIN T            
      Where           
       T.CltCode = A.CltCode            
       And CltCode Between @FromParty And @toParty            
       And BalanceDate between @fromdt  and @todate            
       And Left(Convert(VarChar,BalanceDate,109),11) = Left(Convert(VarChar,Rpt_Date,109),11) )            
  And A.CltCode Between @FromParty And @toParty            
            
Set @CltcodeTmp1 =  ''            
Set @VAmtTmp1 = 0            
            
 Update           
  TBL_REPORT_INTEREST_MARGIN           
 Set           
  Balance = IsNull(T.Bal,0)           
 From             
  (Select           
   t.CltCode,           
   Bal=IsNull(Sum(t.Vamt),0),           
   T1.BalanceDate          
   From           
   TBL_REPORT_INTEREST_MARGIN t,           
   TBL_REPORT_INTEREST_MARGIN t1            
  Where           
   T.BalanceDate <= t1.BalanceDate            
   and t.cltcode = t1.cltcode           
   And t.CltCode Between @FromParty And @toParty            
   And T.BalanceDate between @fromdt  and @todate            
  Group By           
   t.cltCode,          
   T1.BalanceDate ) T            
 Where           
 TBL_REPORT_INTEREST_MARGIN.CltCode = T.Cltcode            
 and TBL_REPORT_INTEREST_MARGIN.BalanceDate = T.BalanceDate            
 And T.CltCode Between @FromParty And @toParty            
 And T.BalanceDate between @fromdt  and @todate            
            
          
              
              
Update             
 TBL_REPORT_INTEREST_MARGIN          
Set            
 Interest = Round((Balance * @IntRateDr / 100)/ 365,2)          
where          
 Balance > 0            
 And CltCode Between @FromParty And @toParty            
 And BalanceDate between @fromdt  and @todate            
          
          
Update             
 TBL_REPORT_INTEREST_MARGIN          
Set            
 Interest = Round((Balance * @IntRateCr / 100)/ 365,2)          
where          
 Balance < 0            
 And CltCode Between @FromParty And @toParty            
 And BalanceDate between @fromdt  and @todate

GO
