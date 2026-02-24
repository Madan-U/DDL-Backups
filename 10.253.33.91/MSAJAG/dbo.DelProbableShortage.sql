-- Object: PROCEDURE dbo.DelProbableShortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE Proc [dbo].[DelProbableShortage] ( @OptionFlag  int = 0) As                         
DeClare                         
@@Sett_No Varchar(7),                        
@@Sett_Type Varchar(2),                        
@@Party_Code Varchar(10),                        
@@Scrip_Cd Varchar(12),                        
@@ScripCode Varchar(12),                        
@@Series Varchar(3),                        
@@ScripName Varchar(50),                        
@@Isin varchar(12),                        
@@Exchg Varchar(3),                        
@@Qty int,                        
@@PQty int,                        
@@DQty int,                        
@@CQty int,                        
@@IQty int,                        
@@DpType Varchar(4),                        
@@DpId Varchar(8),                        
@@CltDpId Varchar(16),                        
@@POAFlag int,                         
@@Sec_PayIn DateTime,                        
@@Status Varchar(10),                        
@@SettCur cursor,                        
@@DelCur cursor                        
                        
select @@DQty = 0                         
select @@CQty = 0                         
select @@IQty = 0                         
Select @@Scrip_CD = '0'                        
                        
Select @@DpType = ''                        
Select @@DpId = ''                        
Select @@CltDpId = ''                        
Select @@POAFlag = 0                        
                  
CREATE TABLE #MTFACCOUNT
(
	CLTDPID_MTF	VARCHAR(16)
)

INSERT INTO #MTFACCOUNT
SELECT DPCLTNO FROM MSAJAG.DBO.DELIVERYDP
WHERE EXCHANGE = 'MTF' AND SEGMENT = 'MTF'
AND ACCOUNTTYPE = 'BEN'

INSERT INTO #MTFACCOUNT
SELECT DPCLTNO FROM BSEDB.DBO.DELIVERYDP
WHERE EXCHANGE = 'MTF' AND SEGMENT = 'MTF'
AND ACCOUNTTYPE = 'BEN'
      
Update DelCDSLBalance Set Party_Code = 'Party', totalBalance = FreeBal                 
              
Update DelCDSLBalance Set Party_Code = M.Party_Code From MultiCltId M                
Where M.CltDpNo = CltDpId                 
And DelCDSLBalance.DpId = M.DpId                
And Def = 1                         
              
Update DelCDSLBalance Set Party_Code = M.Party_Code From bsedb.dbo.MultiCltId M                
Where M.CltDpNo = CltDpId                 
And DelCDSLBalance.DpId = M.DpId                
And Def = 1 And DelCDSLBalance.Party_Code = 'Party'              
            
Delete From DelCDSLBalance Where Party_Code = 'Party'              
                        
Truncate Table DelPOAShortage                        
                        
Truncate Table DelPoaTemp_New                        
    
Select * Into #NSESett_Mst    
From Sett_Mst    
Where /*End_date <= GetDate() + 1 And Sec_PayIn + 1 >= GetDate()                       
And */Sett_Type NOT IN ('A','X')     
    
Select * Into #BSESett_Mst    
From BSEDB.DBO.Sett_Mst    
Where /*End_date <= GetDate() + 1 And Sec_PayIn + 1 >= GetDate()    
And */Sett_Type Not Like 'A%'    
    
 SELECT DISTINCT D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),      
 ISettQty = 0,IBenQty=0            
 Into #NSE_DelPayInMatch From #NSESett_Mst N, MultiIsIn M,DELIVERYCLT_GROSS_FLAG D Left Outer Join DelTrans c            
 On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type            
 And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series             
 And D.Party_Code = C.Party_Code And DrCr = 'C'             
 And Filler2 = 1 And ShareType <> 'AUCTION' 
AND CLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT) )            
 Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1            
 And N.Sett_No = D.Sett_No    
 And N.Sett_Type = D.Sett_Type   
 AND ISNULL(I_ISIN,'') = '' AND D.FLAG = 'N'
 Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn            
 Having D.Qty > 0     
 
 insert Into #NSE_DelPayInMatch 
 select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=i_IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),      
 ISettQty = 0,IBenQty=0            
 From #NSESett_Mst N,DELIVERYCLT_GROSS_FLAG D Left Outer Join DelTrans c            
 On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type            
 And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series             
 And D.Party_Code = C.Party_Code And DrCr = 'C'             
 And Filler2 = 1 And ShareType <> 'AUCTION'  
 AND CLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT) )            
 Where Inout = 'I'       
 And N.Sett_No = D.Sett_No    
 And N.Sett_Type = D.Sett_Type    
 AND ISNULL(I_ISIN,'') <> '' AND D.FLAG = 'N'
 Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,i_IsIn            
 Having D.Qty > 0   
    
Insert into #NSE_DelPayInMatch    
 Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,      
 ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),      
 IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End)      
 From MSAJAG.DBO.DelTrans D, #NSESett_Mst S    
 Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000) and certno <> 'AUCTION'            
 And D.ISett_No = S.Sett_No    
 And D.ISett_Type = S.Sett_Type  
 AND BCLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT)  
 Group by ISett_No,ISett_Type,Party_Code,CertNo    
    
Insert into #NSE_DelPayInMatch    
 Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,      
 ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),      
 IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End)      
 From BSEDB.DBO.DelTrans D, #NSESett_Mst S    
 Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000) and certno <> 'AUCTION'            
 And D.ISett_No = S.Sett_No    
 And D.ISett_Type = S.Sett_Type     
 AND BCLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT) 
 Group by ISett_No,ISett_Type,Party_Code,CertNo    
    
 select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=i_IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),      
 ISettQty = 0,IBenQty=0            
 Into #BSE_DelPayInMatch From #BSESett_Mst N, BSEDB.DBO.DELIVERYCLT_GROSS_FLAG D Left Outer Join BSEDB.DBO.DelTrans c            
 On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type            
 And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series             
 And D.Party_Code = C.Party_Code And DrCr = 'C'             
 And Filler2 = 1 And ShareType <> 'AUCTION'  
 AND CLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT)  )            
 Where Inout = 'I'           
 And N.Sett_No = D.Sett_No    
 And N.Sett_Type = D.Sett_Type   
 AND ISNULL(I_ISIN,'') <> '' AND D.FLAG = 'N'
 Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,i_IsIn            
 Having D.Qty > 0     

 insert Into #BSE_DelPayInMatch 
 SELECT DISTINCT D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),      
 ISettQty = 0,IBenQty=0            
 From #BSESett_Mst N, BSEDB.DBO.MultiIsIn M, BSEDB.DBO.DELIVERYCLT_GROSS_FLAG D Left Outer Join BSEDB.DBO.DelTrans c            
 On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type            
 And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series             
 And D.Party_Code = C.Party_Code And DrCr = 'C'             
 And Filler2 = 1 And ShareType <> 'AUCTION'  
 AND CLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT) )            
 Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1            
 And N.Sett_No = D.Sett_No    
And N.Sett_Type = D.Sett_Type  
 AND ISNULL(I_ISIN,'') = '' AND D.FLAG = 'N'  
 Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn            
 Having D.Qty > 0  
    
Insert into #BSE_DelPayInMatch    
 Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,      
 ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),      
 IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End)      
 From MSAJAG.DBO.DelTrans D, #BSESett_Mst S    
 Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000) and certno <> 'AUCTION'            
 And D.ISett_No = S.Sett_No    
 And D.ISett_Type = S.Sett_Type  
 AND BCLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT)    
 Group by ISett_No,ISett_Type,Party_Code,CertNo    
    
Insert into #BSE_DelPayInMatch    
 Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,      
 ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),      
 IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End)      
 From BSEDB.DBO.DelTrans D, #BSESett_Mst S    
 Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000) and certno <> 'AUCTION'            
 And D.ISett_No = S.Sett_No    
 And D.ISett_Type = S.Sett_Type 
 AND BCLTDPID NOT IN (SELECT CLTDPID_MTF FROM #MTFACCOUNT)     
 Group by ISett_No,ISett_Type,Party_Code,CertNo    
    
Insert Into DelPoaTemp_New                        
select R.Sett_No,R.Sett_Type,R.Party_Code,ScripName=M.Scrip_Cd,M.Scrip_Cd,M.Series,Qty=Sum(DelQty-RecQty-ISettQty-IBenQty),M.IsIn,                        
Exchg='NSE',Sec_PayIn,Status = ( Case When Sec_PayOut < GetDate() Then 'Confirm' Else 'Probable' End ), '', ''              
from #NSE_DelPayInMatch R, #NSESett_Mst S , MultiIsin M                        
Where S.Sett_no = R.Sett_no And S.Sett_Type = R.Sett_Type                         
And End_date <= GetDate() + 1 And Sec_PayIn + 1 >= GetDate()                         
And M.IsIn = R.CertNo                        
And S.Sett_Type NOT IN ('A','X')                        
Group by R.Sett_No,R.Sett_Type,R.Party_Code,M.Scrip_Cd,M.Series,M.IsIn,Sec_PayIn,Sec_PayIn, Sec_PayOut                        
Having Sum(DelQty-RecQty-ISettQty-IBenQty) > 0                         
 
Insert Into DelPoaTemp_New                        
select R.Sett_No,R.Sett_Type,R.Party_Code,ScripName=S2.Scrip_Cd,M.Scrip_Cd,M.Series,Qty=Sum(DelQty-RecQty-ISettQty-IBenQty),M.IsIn,                        
Exchg='BSE',Sec_PayIn,Status = ( Case When Sec_PayOut < GetDate() Then 'Confirm' Else 'Probable' End ), '', ''                       
from #BSE_DelPayInMatch R, #BSESett_Mst S , BSEDB.DBO.MultiIsin M, BSEDB.DBO.Scrip2 S2                        
Where S.Sett_no = R.Sett_no And S.Sett_Type = R.Sett_Type        
And End_date <= GetDate() + 1 And Sec_PayIn + 1 >= GetDate()        
And M.IsIn = R.CertNo And S2.BseCode = M.Scrip_Cd                        
And S.Sett_Type Not Like 'A%'                        
Group by R.Sett_No,R.Sett_Type,R.Party_Code,S2.Scrip_cd,M.Scrip_Cd,M.Series,M.IsIn,Sec_PayIn,Sec_PayIn, Sec_PayOut                        
Having Sum(DelQty-RecQty-ISettQty-IBenQty) > 0                  
              
UPDATE DelPoaTemp_New SET SCRIPNAME = M.SCRIP_CD, SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES
FROM DELIVERYCLT_GROSS_FLAG M
WHERE M.SETT_NO = DelPoaTemp_New.SETT_NO
AND M.SETT_TYPE = DelPoaTemp_New.SETT_TYPE
AND M.PARTY_CODE = DelPoaTemp_New.PARTY_CODE
AND M.I_ISIN = DelPoaTemp_New.ISIN

UPDATE DelPoaTemp_New SET SCRIPNAME = M.SCRIP_CD, SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES
FROM BSEDB.DBO.DELIVERYCLT_GROSS_FLAG M
WHERE M.SETT_NO = DelPoaTemp_New.SETT_NO
AND M.SETT_TYPE = DelPoaTemp_New.SETT_TYPE
AND M.PARTY_CODE = DelPoaTemp_New.PARTY_CODE
AND M.I_ISIN = DelPoaTemp_New.ISIN
	          
UPDATE DelPoaTemp_New SET SCRIPNAME = S2.SCRIP_CD
FROM BSEDB.DBO.SCRIP2 S2
WHERE S2.BSECODE = DelPoaTemp_New.SCRIP_CD
AND Exchg = 'BSE'

Update DelPoaTemp_New Set CltDpId = M.CltDpNo,              
DpId = M.DpId From MultiCltId M                
Where DelPoaTemp_New.Party_Code = M.Party_Code           
And Def = 1              
            
Update DelPoaTemp_New Set CltDpId = M.CltDpNo,              
DpId = M.DpId From bsedb.dbo.MultiCltId M                
Where DelPoaTemp_New.Party_Code = M.Party_Code               
And Def = 1             
        
if @OptionFlag = 0         
begin        
 Set @@SettCur = Cursor for                        
 Select Sett_No,Sett_Type,Party_Code,ScripName,Scrip_Cd,Series,Qty,IsIn,Exchg,Start_Date,Status, DpId, CltDpId From DelPoaTemp_New                        
 Order BY DpId, CltDpId, isin, Start_Date, Exchg        
 Open @@SettCur                        
 Fetch Next From @@SettCur Into @@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,@@Sec_PayIn,@@Status,@@DpId,@@CltDpId              
 While @@Fetch_Status = 0                         
 Begin                        
                         
  Select @@PQty = @@Qty                         
  if @@PQty > 0                        
  Begin                        
   Select @@DQty = 0                         
   Set @@DelCur = Cursor For                        
   Select TotalBalance From MSajag.DBO.DelCDSLBalance Where IsIn = @@IsIn                         
   And DpId = @@DpId And CltDpId = @@CltDpId And @@Status <> 'Confirm'                        
   Open @@DelCur                        
   Fetch Next From @@DelCur into @@DQty                        
                         
   if @@DQty >= @@PQty                         
   Begin                        
    insert into DelPOAShortage Values (@@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,'0',@@PQty,@@DQty,@@DpType,@@DpId,@@CltDpId,@@POAFlag,@@Sec_PayIn,@@Status)                        
   Update MSajag.DBO.DelCDSLBalance Set TotalBalance = @@DQty - @@PQty Where IsIn = @@IsIn                         
   And DpId = @@DpId And CltDpId = @@CltDpId                      
   End                        
   Else                        
   Begin                        
    insert into DelPOAShortage Values (@@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,'0',@@PQty,@@DQty,@@DpType,@@DpId,@@CltDpId,@@POAFlag,@@Sec_PayIn,@@Status)                        
    Update MSajag.DBO.DelCDSLBalance Set TotalBalance = 0 Where IsIn = @@IsIn                         
    And DpId = @@DpId And CltDpId = @@CltDpId                      
   End                        
   Close @@DelCur                          
  End                         
  Fetch Next From @@SettCur into @@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,@@Sec_PayIn,@@Status,@@DpId,@@CltDpId                        
 End                        
End        
Else        
Begin        
 insert into DelPOAShortage        
 Select Sett_No,Sett_Type,Party_Code,ScripName,Scrip_Cd,Series,Qty,IsIn,Exchg,ScripCode='0',        
 ToRecQty=Qty,Balance=Qty,DpType='',DpId,CltDpId,POAFlag=0,Start_Date,Status        
 From DelPoaTemp_New        
 Where Status = 'Probable'        
 And DpId <> ''        
End        
        
Update DelPOAShortage Set POAFlag = 1, DpType = M.DpType From MultiCltId M Where Def = 1 And DelPoaShortage.Party_Code = M.Party_Code                         
And Exchg = 'NSE' and DelPOAShortage.DpId = M.DpId and DelPOAShortage.CltDpID = M.CltDpNo                        
                        
Update DelPOAShortage Set POAFlag = 1, DpType = M.DpType From BSEDB.DBO.MultiCltId M Where Def = 1 And DelPoaShortage.Party_Code = M.Party_Code                         
And Exchg = 'BSE'  and DelPOAShortage.DpId = M.DpId and DelPOAShortage.CltDpID = M.CltDpNo                 
                        
update DelPOAShortage Set  sett_type = 'D' where  sett_type = 'C'

GO
