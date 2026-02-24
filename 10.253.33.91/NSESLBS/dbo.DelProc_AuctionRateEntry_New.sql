-- Object: PROCEDURE dbo.DelProc_AuctionRateEntry_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc DelProc_AuctionRateEntry_New  
(        
@RefNo int,           
@Option varchar(20),        
@Sett_No varchar(11),        
@Sett_Type Varchar(3)        
)        
        
/*        
exec DelProc_AuctionRateEntry_New 120,'BOTH','2006022','N'        
*/        
        
as        
        
SET NOCOUNT ON  
  
Declare @@AucPer DECIMAL        
DECLARE @@REFNO INT        
DECLARE @AuctionFlag INT        
        
Select @@REFNO = RefNo, @@AucPer = IsNull(AuctionPer,0), @AuctionFlag = IsNull(AuctionFlag,0) From DelSegment         
        
Create Table #AucSettlement        
(        
 Scrip_cd varchar(24),        
 Series varchar(12),        
 Sett_no varchar(7),        
 sett_type varchar(3),        
 TradeQty int,        
 MarketRate money        
)        
        
IF @REFNO = 110 --NSE        
      BEGIN        
                  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
                  Insert into #AucSettlement        
                  Select         
                   Scrip_cd,         
                   Series,         
                   Sett_no,         
                   Sett_type,         
                   Tradeqty,         
                   MarketRate        
                  from         
                   MSAJAG.DBO.settlement        
                  where         
                   sett_no = @Sett_No        
                   and sett_type = @Sett_Type        
                   and party_code >= '00000000000'        
                   and party_code <= 'ZZZZZZZZZZZZ'        
                   and scrip_cd >= '0000000000'        
                   and scrip_cd <= 'ZZZZZZZZZZZZ'        
                   and TradeQty > 0        
      END        
      ELSE        
      BEGIN         
                  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
                  Insert into #AucSettlement        
                  Select         
                   Scrip_cd,         
                   Series,         
                   Sett_no,         
                   Sett_type,         
                   Tradeqty,         
                   MarketRate        
                  from         
                   BSEDB.DBO.settlement        
                  where         
                   sett_no = @Sett_No        
                   and sett_type = @Sett_Type        
                   and party_code >= '00000000000'        
                   and party_code <= 'ZZZZZZZZZZZZ'        
                   and scrip_cd >= '0000000000'        
                   and scrip_cd <= 'ZZZZZZZZZZZZ'        
                   and TradeQty > 0        
              
      END        
      
Create Index ClsIdx on #AucSettlement (Scrip_Cd, Series)      
        
Create Table #AucShort        
(        
 ScripName varchar(100),        
 Scrip_Cd varchar(24),        
 Series varchar(12),        
 Qty bigint        
)        
        
        
if @RefNo = 110 --NSe        
begin         
      if @Option = 'PAYIN'              
      begin        
            if @sett_type = 'W'        
            begin        
   set transaction isolation level read uncommitted      
                  insert into #AucShort        
                  SELECT         
                        SCRIPNAME = SCRIP_CD,        
                        SCRIP_CD,        
                        SERIES,        
                        QTY=SUM(CASE WHEN ISNULL(SELLSHORTAGE,0) > 0 THEN ISNULL(SELLSHORTAGE,0) ELSE 0 END)        
                  From DELAUCSHORT        
                  GROUP BY         
                        SCRIP_CD,        
                        SERIES        
                  Having SUM(CASE WHEN ISNULL(SELLSHORTAGE,0) > 0 THEN ISNULL(SELLSHORTAGE,0) ELSE 0 END) > 0         
            end -- SETTTYPE = W CONDITION        
            else        
            begin            
            set transaction isolation level read uncommitted                
                  insert into #AucShort        
                  select         
                        ScripName=Scrip_Cd,        
                        scrip_cd,        
           series,        
                        qty=sum(qty)         
                  from         
                        (        
                        SELECT         
                              party_code,        
                              SCRIP_CD,        
                       SERIES,        
                              QTY=(CASE WHEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) > 0        
                                               THEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) ELSE 0 END)         
      From         
                              DELAUCSHORT        
                        GROUP BY         
                              party_code,        
                              SCRIP_CD,        
                              SERIES         
                        Having (CASE WHEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) > 0        
                                           THEN  SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) ELSE 0 END) > 0          
                        ) A        
                  group by         
                        SCRIP_CD,        
                        SERIES        
            end -- SETTTYPE <> W CONDITION        
      end -- OPTION PAYIN         
      ELSE        
      BEGIN        
            IF @SETT_TYPE = 'W'        
            BEGIN        
            set transaction isolation level read uncommitted      
                  insert into #AucShort        
                  SELECT         
                        SCRIPNAME = SCRIP_CD,         
                        SCRIP_CD,        
                        SERIES,        
                        QTY=SUM(CASE WHEN ISNULL(SELLSHORTAGE,0) > 0 THEN ISNULL(SELLSHORTAGE,0) ELSE 0 END)        
                  From         
                        DELAUCSHORT        
                  GROUP BY         
                        SCRIP_CD,        
                        SERIES        
            END        
            ELSE        
            BEGIN        
            set transaction isolation level read uncommitted      
                  insert into #AucShort        
                  SELECT         
                        SCRIPNAME = SCRIP_CD,         
                        SCRIP_CD,        
                        SERIES,        
                        QTY=(CASE WHEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) > 0 THEN  SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) ELSE 0 END)        
                  From         
                        DELAUCSHORT        
                  GROUP BY         
                        SCRIP_CD,        
                        SERIES        
            END -- SETTTYPE <> W CONDITION        
      END -- OPTION BOTH        
end -- REFNO = 110 CONDITION        
        
        
        
        
        
if @RefNo = 120 --BSE        
begin         
      If @Option = 'PAYIN'        
      begin         
            If @sett_type = 'C'        
            BEGIN        
            set transaction isolation level read uncommitted      
                  insert into #AucShort        
                  SELECT         
                        SCRIPNAME=Scrip_cd,        
                        SCRIP_CD,        
                        SERIES,        
                        QTY=SUM(CASE WHEN ISNULL(SELLSHORTAGE,0) > 0 THEN ISNULL(SELLSHORTAGE,0) ELSE 0 END)        
                  From         
                        DELAUCSHORT         
                  GROUP BY         
                        SCRIP_CD,        
                        SERIES        
--                        ,SCRIPNAME        
                  Having SUM(CASE WHEN ISNULL(SELLSHORTAGE,0) > 0 THEN ISNULL(SELLSHORTAGE,0) ELSE 0 END) > 0         
            END        
            ELSE        
            BEGIN        
            set transaction isolation level read uncommitted      
                  insert into #AucShort        
                  select         
                        SCRIPNAME=Scrip_cd,        
                        scrip_cd,        
                        series,        
                        qty=sum(qty)         
                  from         
                        (        
             SELECT         
                              party_code,        
                              SCRIP_CD,        
                              SERIES,        
                              SCRIPNAME=SCRIP_cD,        
                              QTY=(CASE WHEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) > 0        
                                                THEN  SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) ELSE 0 END)         
                        From         
                      DELAUCSHORT        
                        GROUP BY         
                              party_code,        
                              SCRIP_CD,        
                              SERIES       
                              --,SCRIPNAME         
                        Having (CASE WHEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) > 0        
                              THEN  SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) ELSE 0 END) > 0          
                        ) A        
                  group by         
                        SCRIP_CD,        
                        SERIES       
                       --, SCRIPNAME        
            END -- SETTTYPE CONDITION        
      END         
      ELSE -- OPTION = PAYIN        
      BEGIN        
            If @sett_type = 'C'        
            begin        
            set transaction isolation level read uncommitted      
                  insert into #AucShort        
                  SELECT         
                        SCRIPNAME=Scrip_cd,        
                        SCRIP_CD,        
                        SERIES,        
                        QTY=SUM(CASE WHEN ISNULL(SELLSHORTAGE,0) > 0 THEN ISNULL(SELLSHORTAGE,0) ELSE 0 END)        
                  From         
                        DELAUCSHORT        
                  GROUP BY         
                        SCRIP_CD,        
                        SERIES  
--,                     SCRIPNAME        
            end        
            Else        
            begin        
            set transaction isolation level read uncommitted      
                  insert into #AucShort        
               SELECT         
                        SCRIPNAME=Scrip_cd,        
                        SCRIP_CD,        
                        SERIES,        
                        QTY=(CASE WHEN SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) > 0 THEN  SUM(SELLSHORTAGE)-SUM(BUYSHORTAGE) ELSE 0 END)        
                  From         
                        DELAUCSHORT        
                  GROUP BY         
                        SCRIP_CD,        
                        SERIES  
                        --,SCRIPNAME        
            End        
      End -- OPTION = PAYIN        
End --REFNO         
        
Create Index ClsIdx on #AucShort (Scrip_Cd, Series)      
        
If @AuctionFlag = 1        
Begin           
 Create Table #AucClosing_Today        
 (        
       ScripName varchar(100),        
       Scrip_Cd varchar(24),        
       Series varchar(12),        
       SettRate money        
 )        
END  
        
Create Table #AucClosing        
(        
      ScripName varchar(100),        
      Scrip_Cd varchar(24),        
      Series varchar(12),        
      Cl_Rate money        
)        
      
If @AuctionFlag <> 1        
Begin           
-----------------------------------        
-- NOW GETTING CLOSING RATES --        
-----------------------------------        
      IF @REFNO=110 --NSE        
      BEGIN        
            set transaction isolation level read uncommitted      
            insert into #AucClosing        
            select         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series,        
             Cl_Rate = Isnull(Max(cl_rate),0)         
            from         
             #AucShort A,         
             sett_mst d,        
             MSAJAG.DBO.closing c         
            WHERE d.start_date <= c.sysdate         
              and d.sec_payout >= c.sysdate     
              and d.sett_no = @Sett_No         
              and d.sett_type = @Sett_Type        
         	AND c.Scrip_cd = a.scrip_Cd        
              and c.Series = a.series        
            group by         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series        
      END        
      ELSE        
      BEGIN      
           set transaction isolation level read uncommitted        
            insert into #AucClosing        
            select         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series,        
             Cl_Rate = Isnull(Max(cl_rate),0)         
            from         
             #AucShort A,         
             sett_mst d,        
             BSEDB.DBO.closing c  
            WHERE        
              d.start_date <= c.sysdate         
              and d.sec_payout >= c.sysdate         
              and d.sett_no = @Sett_No         
              and d.sett_type = @Sett_Type        
              AND c.Scrip_cd = a.scrip_Cd        
              and c.Series = a.series        
            group by         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series        
      END              
END  
ELSE  
BEGIN  
      IF @REFNO=110 --NSE        
      BEGIN        
            set transaction isolation level read uncommitted      
            insert into #AucClosing        
            select         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series,        
             Cl_Rate = Isnull(Max(cl_rate),0)         
            from         
             #AucShort A,         
             sett_mst d,        
             MSAJAG.DBO.closing c         
            WHERE Left(Convert(Varchar,d.sec_payout,109),11) = Left(Convert(Varchar,c.sysdate,109),11)  
              and d.sett_no = @Sett_No         
              and d.sett_type = @Sett_Type        
              AND c.Scrip_cd = a.scrip_Cd        
              and c.Series = a.series        
            group by         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series        
      END        
      ELSE        
      BEGIN      
           set transaction isolation level read uncommitted        
            insert into #AucClosing        
            select         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series,        
             Cl_Rate = Isnull(Max(cl_rate),0)         
            from         
             #AucShort A,         
             sett_mst d,        
             BSEDB.DBO.closing c  
            WHERE Left(Convert(Varchar,d.sec_payout,109),11) = Left(Convert(Varchar,c.sysdate,109),11)  
              and d.sett_no = @Sett_No         
              and d.sett_type = @Sett_Type        
              AND c.Scrip_cd = a.scrip_Cd        
              and c.Series = a.series        
            group by         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series        
      END              
END  
  
If @AuctionFlag = 1         
BEGIN  
      IF @REFNO=110 --NSE        
      BEGIN        
            set transaction isolation level read uncommitted      
            insert into #AucClosing_Today        
            select         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series,        
             Cl_Rate = Isnull(Max(cl_rate),0)         
            from         
             #AucShort A,         
             sett_mst d,        
             MSAJAG.DBO.closing c         
            WHERE Left(Convert(Varchar,d.Start_Date,109),11) = Left(Convert(Varchar,c.sysdate,109),11)  
              and d.sett_no = @Sett_No         
              and d.sett_type = @Sett_Type        
              AND c.Scrip_cd = a.scrip_Cd        
              and c.Series = a.series        
            group by         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series        
      END        
      ELSE        
      BEGIN   
           set transaction isolation level read uncommitted        
            insert into #AucClosing_Today        
            select         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series,        
             Cl_Rate = Isnull(Max(cl_rate),0)         
            from         
             #AucShort A,         
             sett_mst d,        
             BSEDB.DBO.closing c  
            WHERE Left(Convert(Varchar,d.Start_Date,109),11) = Left(Convert(Varchar,c.sysdate,109),11)  
              and d.sett_no = @Sett_No         
              and d.sett_type = @Sett_Type        
              AND c.Scrip_cd = a.scrip_Cd        
              and c.Series = a.series        
            group by         
             A.ScripName,         
             A.Scrip_Cd,         
             A.Series        
      END              
END  
  
-----------------------------------        
-- NOW GETTING SETTLMT RATES --        
-----------------------------------        
set transaction isolation level read uncommitted        
select         
B.ScripName,        
B.Scrip_Cd,         
B.Series,         
B.Qty,        
SettRate = Isnull(Sum(a.TradeQty*a.Marketrate)/Sum(a.TradeQty),0)         
Into #AucSett        
from          
#AucShort B        
left outer join         
 #AucSettlement  A          
  on        
  (        
   a.scrip_cd = b.scrip_cd        
   and a.series = b.series        
  )        
Group by         
B.ScripName,         
B.scrip_cd,         
B.series,         
B.Qty        
  
Create Index ClsIdx on #AucSett (Scrip_Cd, Series)      
        
-----------------------------------        
-- NOW GETTING AuC VALUATION  --        
-----------------------------------        
            set transaction isolation level read uncommitted        
      select         
      a.Scrip_cd,        
      a.series,         
      ProRate = isnull(b.ProRate, 0),        
      ExRate = isnull(b.ExRate,0),        
      Penalty = isnull(B.Penalty,0),        
      FinRate = isnull(b.Finrate,0)        
       into #AucValuation        
      from         
       #AucShort a        
       left outer join        
        DelAucScrip b (NOLOCK)        
         on         
         (        
          b.sett_no = @Sett_No        
          and b.sett_type = @Sett_Type        
          and a.scrip_cd = b.scrip_cd        
          and a.series = b.series        
         )        
        
      
Create Index ClsIdx on #AucValuation (Scrip_Cd, Series)      
        
If @AuctionFlag <> 1         
Begin         
 Drop Table #AucSettlement        
        
 -----------------------------------        
 -- NOW GETTING FINAL OUTPUT   --        
 -----------------------------------        
         
 set transaction isolation level read uncommitted      
 SELECT         
       A.SCRIPNAME,         
       A.SCRIP_CD,         
       A.SERIES,         
       A.QTY,        
       CL_RATE = ISNULL(C.CL_RATE,0),        
       MKTRATE = IsNull(S.SETTRATE,0) ,   
       TRRATE = IsNull(S.SETTRATE,0) ,        
       PRORATE = isnull(V.PRORATE,0),        
         EXRate = isnull(V.ExRate,0),        
       Penalty = isnull(V.Penalty,0),        
       FinRate = isnull(V.Finrate,0)        
 FROM        
  #AUCSHORT A        
  LEFT OUTER JOIN         
   #AucClosing c        
    ON (        
       A.SCRIP_CD = c.SCRIP_CD        
       AND A.SERIES = c.SERIES        
      )        
  LEFT OUTER JOIN         
   #AucSett S        
  
    ON (        
       A.SCRIP_CD = s.SCRIP_CD        
       AND A.SERIES = s.SERIES        
      )        
  LEFT OUTER JOIN         
   #AucValuation V        
    ON (        
       A.SCRIP_CD = V.SCRIP_CD        
       AND A.SERIES = V.SERIES        
      )        
          
 ORDER BY 1             
End  
Else  
Begin  
 set transaction isolation level read uncommitted      
 SELECT         
       A.SCRIPNAME,         
     A.SCRIP_CD,         
       A.SERIES,         
       A.QTY,        
       CL_RATE = ISNULL(C.CL_RATE,0),        
       MKTRATE = IsNull(M.SETTRATE,0) ,   
       TRRATE = IsNull(S.SETTRATE,0) ,        
       PRORATE = isnull(V.PRORATE,0),        
       EXRate = isnull(V.ExRate,0),        
       Penalty = isnull(V.Penalty,0),        
       FinRate = isnull(V.Finrate,0)        
 FROM        
  #AUCSHORT A        
  LEFT OUTER JOIN         
   #AucClosing c        
    ON (        
       A.SCRIP_CD = c.SCRIP_CD        
       AND A.SERIES = c.SERIES        
      )        
  LEFT OUTER JOIN         
   #AucClosing_Today S        
    ON (        
       A.SCRIP_CD = s.SCRIP_CD        
       AND A.SERIES = s.SERIES        
      )        
  LEFT OUTER JOIN         
   #AucValuation V        
    ON (        
       A.SCRIP_CD = V.SCRIP_CD        
       AND A.SERIES = V.SERIES        
      )        
  LEFT OUTER JOIN         
   #AucSett M        
  
    ON (        
       A.SCRIP_CD = M.SCRIP_CD        
       AND A.SERIES = M.SERIES        
      )                
 ORDER BY 1       
  
 Drop Table #AucClosing_Today        
End  
  
  
SET NOCOUNT OFF

GO
