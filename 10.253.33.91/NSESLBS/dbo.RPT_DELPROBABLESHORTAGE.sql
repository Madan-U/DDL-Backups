-- Object: PROCEDURE dbo.RPT_DELPROBABLESHORTAGE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DELPROBABLESHORTAGE(
@STATUSID VARCHAR(20),
@STATUSNAME VARCHAR(25),
@FROMDATE VARCHAR(11), 
@TODATE VARCHAR(11), 
@FROMPARTY VARCHAR(10),
@TOPARTY VARCHAR(10),
@BRANCH VARCHAR(10)
) AS

Select * Into #DelPOAShortage
From ENCSRV1.MSAJAG.DBO.DelPOAShortage d
Where D.Party_code >= @FromParty and D.Party_Code <= @ToParty

Select c1.cl_status, D.Sett_No,D.Sett_Type, dummy10, D.Party_Code,
C1.Long_Name,ScripName,Scrip_Cd,D.Series,Qty,IsIn,Exchg,ScripCode,
ShortQty=ToRecQty-Balance,DpID,CltDpId,POAFlag,YY=Year(D.Start_Date),
mm=Month(D.Start_Date),Status, c1.branch_cd, PayIn=Convert(Varchar,Sec_PayIn,103),
case when POAFlag=1 then 'POA' else '' end POA ,c1.trader, c1.sub_broker,
CL_RATE = CONVERT(NUMERIC(18,4),0), SHRT_VAL = CONVERT(NUMERIC(18,4),0), COLLQTY = 0, 
DEBITFLAG = CONVERT(VARCHAR(50),'')
INTO #DELPOA From Client1 C1, Client2 C2, BSEDB.DBO.Sett_Mst S, #DelPOAShortage D 
Where C1.Cl_code = C2.Cl_Code and C2.Party_Code = D.Party_code 
And D.Party_code >= @FromParty and D.Party_Code <= @ToParty
And ToRecQty > Balance And C1.Branch_Cd Like @Branch 
and D.Sett_Type not in ('A','X','AC','AD') And Exchg = 'BSE' 
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type  
and Sec_PayIn >= @FromDate And Sec_PayIn <= @ToDate + ' 23:59' 
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
                        'BROKER'          
                  End)       

INSERT INTO #DELPOA
Select c1.cl_status, D.Sett_No,D.Sett_Type, dummy10, D.Party_Code,
C1.Long_Name,ScripName,Scrip_Cd,D.Series,Qty,IsIn,Exchg,ScripCode,
ShortQty=ToRecQty-Balance,DpID,CltDpId,POAFlag,YY=Year(D.Start_Date),
mm=Month(D.Start_Date),Status, c1.branch_cd, PayIn=Convert(Varchar,Sec_PayIn,103),
case when POAFlag=1 then 'POA' else '' end POA ,c1.trader, c1.sub_broker,
CL_RATE = CONVERT(NUMERIC(18,4),0), SHRT_VAL = CONVERT(NUMERIC(18,4),0), 
COLLQTY = 0, DEBITFLAG = CONVERT(VARCHAR(50),'')
From Client1 C1, Client2 C2, MSAJAG.DBO.Sett_Mst S, #DelPOAShortage D
Where C1.Cl_code = C2.Cl_Code and C2.Party_Code = D.Party_code 
And D.Party_code >= @FromParty and D.Party_Code <= @ToParty
And ToRecQty > Balance And C1.Branch_Cd Like @Branch 
and D.Sett_Type not in ('A','X','AC','AD') And Exchg = 'NSE' 
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type  
and Sec_PayIn >= @FromDate And Sec_PayIn <= @ToDate + ' 23:59' 
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
                        'BROKER'          
                  End)  

      SELECT     
            Scrip_Cd,     
            Series='EQ',     
            Cl_Rate,     
            SysDate     
      INTO #NSE_LatestClosing     
      FROM Closing C WITH(NOLOCK)    
      WHERE SYSDATE =     
            (    
                  SELECT     
                        MAX(SYSDATE)     
                  FROM Closing WITH(NOLOCK)     
    WHERE SCRIP_CD = C.SCRIP_CD      
                        And C.SERIES In ('BE', 'EQ')    
            )    
      And SERIES In ('BE', 'EQ')    
    
      INSERT INTO #NSE_LatestClosing     
      SELECT     
            Scrip_Cd,     
            Series,     
            Cl_Rate,     
            SysDate     
      FROM Closing C WITH(NOLOCK)    
      WHERE SYSDATE =     
            (    
                  SELECT     
                        MAX(SYSDATE)     
                  FROM Closing WITH(NOLOCK)     
                  WHERE SCRIP_CD = C.SCRIP_CD      
                        And SERIES = C.SERIES     
            )    
      And SERIES Not In ('BE', 'EQ')    
      
      SELECT     
            Scrip_Cd,     
            Series,     
            Cl_Rate,     
            SysDate     
      INTO #BSE_LatestClosing     
      FROM BSEDB.DBO.Closing C WITH(NOLOCK)    
      WHERE SYSDATE =     
            (    
                  SELECT     
                        MAX(SYSDATE)     
                  FROM BSEDB.DBO.Closing WITH(NOLOCK)     
                  WHERE SCRIP_CD = C.SCRIP_CD      
                        And SERIES = C.SERIES    
            )     

      UPDATE #DELPOA 
      Set     
            Cl_Rate = C.Cl_Rate,
	    SHRT_VAL = SHORTQTY * C.CL_RATE	     
      From     
            #NSE_LatestClosing C     
      Where       
            C.Scrip_Cd = #DELPOA.Scrip_Cd                
            And C.Series = (Case When #DELPOA.Series In ('EQ', 'BE') Then 'EQ' Else #DELPOA.Series End)    
            And #DELPOA.Exchg = 'NSE'    

      Update     
            #DELPOA     
      Set     
            Cl_Rate = C.Cl_Rate,
	    SHRT_VAL = SHORTQTY * C.CL_RATE     
      From     
            #BSE_LatestClosing C     
      Where                 
            C.Scrip_Cd = #DELPOA.Scrip_Cd                
      	    And C.Series = #DELPOA.Series       
            And #DELPOA.Exchg = 'BSE'  

UPDATE #DELPOA SET DEBITFLAG = (CASE WHEN P.DEBITFLAG = 0 THEN 'CHECK DEBIT'
				     WHEN P.DEBITFLAG = 1 THEN 'ALWAYS PAYOUT'	
				     ELSE 'TRANSFER TO BEN' 
				END)
FROM DELPARTYFLAG P
WHERE P.PARTY_CODE = #DELPOA.PARTY_CODE

UPDATE #DELPOA SET COLLQTY = C.COLLQTY
FROM (Select Party_Code, IsIn, COLLQTY = isnull(Sum(Case When DrCr = 'C' Then Qty Else -Qty End),0)
from msajag.dbo.c_securitiesmst where party_code <> 'broker'
group by Party_Code, IsIn
having isnull(Sum(Case When DrCr = 'C' Then Qty Else -Qty End),0) > 0) c
Where c.Party_Code = #DELPOA.Party_Code And c.isin = #DELPOA.ISIN

SELECT * FROM #DELPOA 
Order By branch_cd, sub_broker, trader, Party_Code,Exchg Desc, Sett_No, Sett_Type, ScripName 

Drop Table #DelPOAShortage
Drop Table #DELPOA
Drop Table #NSE_LatestClosing
Drop Table #BSE_LatestClosing

GO
