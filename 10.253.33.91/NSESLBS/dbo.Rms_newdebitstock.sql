-- Object: PROCEDURE dbo.Rms_newdebitstock
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rms_newdebitstock (@sauda_date Varchar(11), @fromparty Varchar(10), @toparty Varchar(10)) As                      
  
Truncate Table Deldebitsummary                       
  
Insert Into Deldebitsummary                      
Select Branch_cd='bse',d.party_code,long_name='',scrip_name='',d.scrip_cd,d.series,d.certno,debitqty=sum(d.qty),payqty=0,                      
Futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='1',sub_broker='',trader='','','n','all',0, HoldFlag = 'HOLD'    
From bsedb.dbo.deltrans D, bsedb.dbo.deliverydp Dp                       
Where Drcr = 'd' And Filler2 = 1 And Delivered = '0' And Bcltdpid = Dp.dpcltno                       
And Bdpid = Dp.dpid And Certno Like 'in%'                      
And Trtype <> 906 And Party_code <> 'broker'        
And Description not Like '%pool%'                   
and D.party_code >= @fromparty And D.party_code <= @toparty                      
Group By D.party_code,d.scrip_cd,d.series,d.certno                      
                      
/* Intersettlement Or Interbeneficiary Record Bse */                      
Insert Into Deldebitsummary                      
Select Branch_cd='bse',d.party_code,long_name='',scrip_name='',d.scrip_cd,d.series,d.certno,debitqty=sum(d.qty),payqty=0,                      
Futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='0',sub_broker='',trader='','','n','all',0, HoldFlag = 'HOLD'                       
From bsedb.dbo.deltrans D, bsedb.dbo.deliverydp Dp                      
Where Drcr = 'd' And Filler2 = 1 And Delivered = 'g' And Bcltdpid = Dp.dpcltno                       
And Bdpid = Dp.dpid And Certno Like 'in%'                      
And Trtype In (907,1000) And Party_code <> 'broker'                      
and D.party_code >= @fromparty And D.party_code <= @toparty                      
And Transdate >= @sauda_date                      
Group By D.party_code,d.scrip_cd,d.series,d.certno                      
                      
/* Pool Payout Value Of Bse */                      
Insert Into Deldebitsummary                      
Select Branch_cd='bse',d.party_code,long_name='',scrip_name='',d.scrip_cd,d.series,d.certno,debitqty=sum(d.qty),payqty=0,                      
Futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='1',sub_broker='',trader='','','n','all',0, HoldFlag = 'HOLD'                       
From bsedb.dbo.deltrans D, bsedb.dbo.deliverydp Dp                      
Where Drcr = 'd' And Filler2 = 1 And Delivered = '0' And Bcltdpid = Dp.dpcltno                       
And Bdpid = Dp.dpid And Certno Like 'in%'                      
And Trtype <> 906 And Description Like '%pool%' And Party_code <> 'broker'                      
and D.party_code >= @fromparty And D.party_code <= @toparty                      
Group By D.party_code,d.scrip_cd,d.series,d.certno                      
                      
Insert Into Deldebitsummary                      
Select Branch_cd='nse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,d.certno,debitqty=sum(d.qty),                      
Payqty=0,futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00 ,family='',familyname='1',sub_broker='',trader='','','n','all',0, HoldFlag = 'HOLD'                       
From msajag.dbo.deltrans D, msajag.dbo.deliverydp Dp                       
Where Drcr = 'd'                      
And Filler2 = 1 And Delivered = '0' And Bcltdpid = Dp.dpcltno And Bdpid = Dp.dpid                       
And Trtype <> 906 And Certno Like 'in%' And Party_code <> 'broker'                      
and D.party_code >= @fromparty And D.party_code <= @toparty          
And Description Not Like '%pool%'                 
Group By D.party_code,d.scrip_cd,d.scrip_cd,d.series,d.certno                      
                      
/* Intersettlement Or Interbeneficiary Record For Nse*/            
Insert Into Deldebitsummary                      
Select Branch_cd='nse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,d.certno,debitqty=sum(d.qty),                    Payqty=0,futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00 ,family='',familyname='0',sub_broker='',
trader='','','n','all',0, HoldFlag = 'HOLD'                       
From msajag.dbo.deltrans D, msajag.dbo.deliverydp Dp              
Where Drcr = 'd'                      
And Filler2 = 1 And Delivered = 'g' And Bcltdpid = Dp.dpcltno And Bdpid = Dp.dpid                       
And Trtype In (907,1000) And Certno Like 'in%' And Party_code <> 'broker'                      
and D.party_code >= @fromparty And D.party_code <= @toparty                      
And Transdate >=  @sauda_date                      
Group By D.party_code,d.scrip_cd,d.scrip_cd,d.series,d.certno                   
                      
/* Pool Payout Value Of Nse */                      
Insert Into Deldebitsummary                      
Select Branch_cd='nse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,d.certno,debitqty=sum(d.qty),                      
Payqty=0,futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00 ,family='',familyname='1',sub_broker='',trader='','','n','all',0, HoldFlag = 'HOLD'                        
From msajag.dbo.deltrans D, msajag.dbo.deliverydp Dp                      
Where Drcr = 'd' And Filler2 = 1 And Delivered = '0' And Bcltdpid = Dp.dpcltno And Bdpid = Dp.dpid                       
And Trtype <> 906 And Certno Like 'in%' And Description Like '%pool%'                      
and D.party_code >= @fromparty And D.party_code <= @toparty                      
And Party_code <> 'broker'                      
Group By D.party_code,d.scrip_cd,d.scrip_cd,d.series,d.certno                      
                      
/* Getting Payout From All Open Settlement From Nse */                      
Insert Into Deldebitsummary                      
Select Branch_cd='nse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,certno='',debitqty=sum(d.qty),                      
Payqty=0,futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00 ,family='',familyname='2',sub_broker='',trader='','' ,'n','all',0,HoldFlag = 'PAY'                       
From Deliveryclt D, Sett_mst S Where                       
S.sett_no = D.sett_no And S.sett_type = D.sett_type And Inout = 'o' And                      
Sec_payout > @sauda_date + ' 23:59:59' And D.sett_type Not In ('a','x','ad','ac')                      
And Start_date <=  @sauda_date + ' 23:59'                      
and D.party_code >= @fromparty And D.party_code <= @toparty                      
And Party_code <> 'broker'                      
Group By D.sett_no,d.sett_type,d.party_code,d.scrip_cd,d.series                      
                      
/* Getting Payout From All Open Settlement From Bse */                      
Insert Into Deldebitsummary                      
Select Branch_cd='bse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,certno='',debitqty=sum(d.qty),                      
Payqty=0,futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00 ,family='',familyname='2',sub_broker='',trader='','','n','all',0,HoldFlag = 'PAY'                                           
From Bsedb.dbo.deliveryclt D, Bsedb.dbo.sett_mst S                      
Where S.sett_no = D.sett_no And S.sett_type = D.sett_type And Inout = 'o' And                      
Sec_payout >  @sauda_date + ' 23:59:59' And D.sett_type Not In ('a','x','ad','ac')                      
And Start_date <=  @sauda_date + ' 23:59'                      
and D.party_code >= @fromparty And D.party_code <= @toparty                      
And Party_code <> 'broker'                      
Group By D.sett_no,d.sett_type,d.party_code,d.scrip_cd,d.scrip_cd,d.series                      

Insert Into Deldebitsummary                          
Select Branch_Cd='BSE',D.Party_Code,Long_Name='',Scrip_Name=D.Scrip_Cd,D.Scrip_cd,D.Series,CertNo='',                          
DebitQty=Sum(D.Qty),PayQty=0,FutQty=0,ShrtQty=0,LedBal=0,EffBal=0,Cash=0,NonCash=0,Cl_Rate=1.00,    
family='',familyname='2',sub_broker='',trader='','' ,'n','all',0,HoldFlag = 'PAY'             
from BSEDB.DBO.DelTrans D With(Index(DelHold)), BSEDB.DBO.Sett_mst S, BSEDB.DBO.Sett_mst A                           
where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type                           
And A.Sec_PayOut > @sauda_date + ' 23:59'                          
And S.Sett_No = A.Sett_No And A.Sett_Type = (Case When S.Sett_Type = 'D' Then 'AD' Else 'AC' End)                           
And D.Party_Code >= @fromparty And D.Party_Code <= @toparty                     
and D.Sett_Type Not In ('AD','AC','A','X')                          
And D.DrCr = 'D' And ShareType = 'AUCTION' And Filler2 = 1                           
And TrType = 904                          
Group By D.Sett_no, D.Sett_Type, D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series                          
                          
set transaction isolation level read uncommitted                            
Insert Into Deldebitsummary                          
Select Branch_Cd='NSE',D.Party_Code,Long_Name='',Scrip_Name=D.Scrip_Cd,D.Scrip_cd,D.Series,CertNo='',                          
DebitQty=Sum(D.Qty),PayQty=0,FutQty=0,ShrtQty=0,LedBal=0,EffBal=0,Cash=0,NonCash=0,Cl_Rate=1.00,    
family='',familyname='2',sub_broker='',trader='','' ,'n','all',0,HoldFlag = 'PAY'               
from Msajag.DBO.DelTrans D With(Index(DelHold)), Msajag.DBO.Sett_mst S,  Msajag.DBO.Sett_mst A                           
where S.Sett_No = D.Sett_No And S.Sett_Type = D.Sett_Type                           
And A.Sec_PayOut > @sauda_date + ' 23:59:59'                          
And S.Sett_No = A.Sett_No And A.Sett_Type = (Case When S.Sett_Type = 'N' Then 'A' Else 'X' End)                           
And D.Party_Code >= @fromparty And D.Party_Code <= @toparty                           
and D.Sett_Type Not In ('AD','AC','A','X')                          
And D.DrCr = 'D' And ShareType = 'AUCTION' And Filler2 = 1                           
And TrType = 904                          
Group By D.Sett_no, D.Sett_Type, D.Party_Code,D.Scrip_Cd,D.Scrip_Cd,D.Series
                   
/*                      
Insert Into Deldebitsummary                      
Select Branch_cd='nse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,certno=m.isin,debitqty=0,                      
Payqty=0,futqty=0,shrtqty=d.qty-sum(isnull(de.qty,0)),ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='3',sub_broker='',trader='','','n'                    
From Sett_mst S, Multiisin M, Msajag.dbo.deliveryclt D Left Outer Join msajag.dbo.deltrans De                       
On ( De.sett_no = D.sett_no And De.sett_type = D.sett_type And De.scrip_cd = D.scrip_cd                       
     And De.series = D.series And De.party_code = D.party_code And Drcr = 'c' And Filler2 = 1 )                      
Where D.inout = 'i' And D.qty > 0 And M.scrip_cd = D.scrip_cd And M.series = D.series And Valid = 1                       
And D.sett_no = S.sett_no And D.sett_type = S.sett_type                       
And Sec_payout >  @sauda_date + ' 23:59:59' And D.sett_type Not In ('a','x','ad','ac')                      
And Start_date <=  @sauda_date + ' 23:59'                      
Group By D.sett_no,d.sett_type,d.party_code,d.scrip_cd,d.series,m.isin,d.qty                       
Having D.qty > Sum(isnull(de.qty,0))                      
*/                      
                      
Insert Into Deldebitsummary                      
Select Branch_cd='nse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,certno='',debitqty=0,                      
Payqty=0,futqty=0,shrtqty=d.qty-sum(isnull(de.qty,0)),ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='3',sub_broker='',trader='','','n','all',0,HoldFlag = 'SHRT'                       
From Sett_mst S, Msajag.dbo.deliveryclt D Left Outer Join msajag.dbo.deltrans De                       
On ( De.sett_no = D.sett_no And De.sett_type = D.sett_type And De.scrip_cd = D.scrip_cd                       
     And De.series = D.series And De.party_code = D.party_code And Drcr = 'c' And Filler2 = 1 )                      
Where D.inout = 'i' And D.qty > 0                       
And D.sett_no = S.sett_no And D.sett_type = S.sett_type                       
And Sec_payout >  @sauda_date + ' 23:59:59' And D.sett_type Not In ('a','x','ad','ac')                      
And Start_date <=  @sauda_date + ' 23:59'     
and D.party_code >= @fromparty And D.party_code <= @toparty                 
Group By D.sett_no,d.sett_type,d.party_code,d.scrip_cd,d.series,d.qty                       
Having D.qty > Sum(isnull(de.qty,0))                      
                      
Update Deldebitsummary Set Certno = M.isin From Bsedb.dbo.multiisin M Where M.scrip_cd = Deldebitsummary.scrip_cd                      
And Valid = 1 And Certno = ''                       
                      
Update Deldebitsummary Set Certno = M.isin From Multiisin M Where M.scrip_cd = Deldebitsummary.scrip_cd                      
And M.series = Deldebitsummary.series And Valid = 1 And Certno = ''                       
                      
Update Deldebitsummary Set Certno = M.isin From Multiisin M Where M.scrip_cd = Deldebitsummary.scrip_cd                      
And Valid = 1 And Certno = ''                       
                      
/* Getting Shortages From All Open Settlement From Bse */                      
Insert Into Deldebitsummary                      
Select Branch_cd='bse',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,certno=m.isin,debitqty=0,                      
Payqty=0,futqty=0,shrtqty=d.qty-sum(isnull(de.qty,0)),ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='3',sub_broker='',trader='','','n','all',0,HoldFlag = 'SHRT'                                           
From Bsedb.dbo.sett_mst S, Bsedb.dbo.multiisin M, Bsedb.dbo.deliveryclt D Left Outer Join bsedb.dbo.deltrans De                       
On ( De.sett_no = D.sett_no And De.sett_type = D.sett_type And De.scrip_cd = D.scrip_cd                       
     And De.series = D.series And De.party_code = D.party_code And Drcr = 'c' And Filler2 = 1 )                      
Where D.inout = 'i' And D.qty > 0                       
And M.scrip_cd = D.scrip_cd And M.series = D.series And Valid = 1                       
And D.sett_no = S.sett_no And D.sett_type = S.sett_type                       
And Sec_payout >  @sauda_date  + ' 23:59:59' And D.sett_type Not In ('a','x','ad','ac')                      
And Start_date <=  @sauda_date + ' 23:59'                      
and D.party_code >= @fromparty And D.party_code <= @toparty              
Group By D.sett_no,d.sett_type,d.party_code,d.scrip_cd,d.scrip_cd,d.series,m.isin,d.qty                      
Having D.qty > Sum(isnull(de.qty,0))                      
                  
Update DelCDSLBalance Set Party_Code = 'Party'                      
                      
Update DelCDSLBalance Set Party_Code = M.Party_Code                             
From MultiCltId M                            
Where CltDpId = M.CltDpNo And DelCDSLBalance.DpId = M.DpID                             
And Def = 1                             
                            
Update DelCDSLBalance Set Party_Code = M.Party_Code                             
From BSEDB.DBO.MultiCltId M                            
Where CltDpId = M.CltDpNo And DelCDSLBalance.DpId = M.DpID                             
And Def = 1                             
                            
Update DelCDSLBalance Set Scrip_Cd = M.Scrip_Cd, Series = M.Series                             
From MultiIsIn M Where M.IsIn = DelCDSLBalance.IsIn       
                            
Update DelCDSLBalance Set Scrip_Cd = M.Scrip_Cd, Series = M.Series                             
From BSEDB.DBO.MultiIsIn M Where M.IsIn = DelCDSLBalance.IsIn       
And DelCDSLBalance.Scrip_CD = 'Scrip'       
                  
Delete From DelCDSLBalance Where Party_Code = 'Party'                   
                  
Insert Into Deldebitsummary                      
Select Branch_cd='POA',d.party_code,long_name='',scrip_name=d.scrip_cd,d.scrip_cd,d.series,isin,debitqty=FreeBal,                      
Payqty=0,futqty=0,shrtqty=0,ledbal=0,effbal=0,cash=0,noncash=0,cl_rate=1.00,family='',familyname='3',sub_broker='',trader='','','n','all',0,HoldFlag = 'POA'    
From DelCDSLBalance D                  
WHERE D.party_code >= @fromparty And D.party_code <= @toparty
          
Update Deldebitsummary Set Pledge = Isnull(track,'n')                      
From Scrip2 S2 Where S2.scrip_cd = Deldebitsummary.scrip_cd                      
And S2.series = Deldebitsummary.series                      
                      
Update Deldebitsummary Set Pledge = Track                       
From Bsedb.dbo.scrip2 S2 Where S2.BSECODe = Deldebitsummary.scrip_cd                      
And S2.series = Deldebitsummary.series                      
          
Update Deldebitsummary Set Cl_rate = 0                       
                      
Update Deldebitsummary Set Scrip_cd = M.scrip_cd, Series = M.series                       
From Bsedb.dbo.multiisin M Where M.isin = Deldebitsummary.certno                       
AND Deldebitsummary.SCRIP_CD = ''      
                      
Update Deldebitsummary Set Cl_rate = C.cl_rate From Bsedb.dbo.closing C Where                       
Sysdate = (Select Max(SysDate) From Bsedb.dbo.closing C1 Where C1.scrip_cd = Deldebitsummary.scrip_cd                
And Sysdate <= @sauda_date + ' 23:59' )                
And C.scrip_cd = Deldebitsummary.scrip_cd                      
                      
Update Deldebitsummary Set Long_name = C1.Long_Name, Family = C1.Family            
From Client_Details C1            
Where C1.Party_Code = Deldebitsummary.Party_Code            
            
Update Deldebitsummary Set Cl_rate = C.cl_rate From Closing C Where                       
Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = Deldebitsummary.scrip_cd                      
And Deldebitsummary.series In ('eq','be') 
AND C1.series In ('eq','be')                       
And Sysdate <= @sauda_date + ' 23:59' )                
And C.scrip_cd = Deldebitsummary.scrip_cd                      
And Deldebitsummary.series In ('eq','be')                      
AND C.series In ('eq','be') 
And Deldebitsummary.cl_rate = 0                       
                      
Update Deldebitsummary Set Cl_rate = C.cl_rate From Closing C Where                       
Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = Deldebitsummary.scrip_cd                      
And C.Series = Deldebitsummary.Series                
And Sysdate <= @sauda_date + ' 23:59' )                
And C.scrip_cd = Deldebitsummary.scrip_cd                      
And C.Series = Deldebitsummary.Series                
And Deldebitsummary.cl_rate = 0                       
          
Update Deldebitsummary Set Scrip_name = S2.scrip_cd      
From BSEDB..Scrip2 S2            
Where BseCode = Deldebitsummary.Scrip_cd            
And Exchange = 'BSE'            
                      
Update Deldebitsummary Set Category = Categoryname, Categorycode = Categoryid From Account.dbo.acccategory M,  Account.dbo.accountscategory C                      
Where C.category = M.categoryid And C.cltcode = Party_code                       
                      
Delete From Deldebitsummarynew Where Rundate Like @sauda_date + '%'                      
And Party_code >= @fromparty And Party_code <= @toparty                      
                      
Insert Into  Deldebitsummarynew                       
Select Branch_cd,party_code,long_name,scrip_name,scrip_cd,series,certno,debitqty,payqty,futqty,shrtqty,ledbal,effbal,cash,noncash,cl_rate,family,familyname,sub_broker,trader,approver,pledge,@sauda_date,category,categorycode,HoldFlag From  Deldebitsummary

GO
