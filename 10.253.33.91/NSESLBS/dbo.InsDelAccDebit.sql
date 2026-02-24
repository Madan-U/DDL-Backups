-- Object: PROCEDURE dbo.InsDelAccDebit
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDelAccDebit(@FPartyCode Varchar(10),@TPartyCode Varchar(10)) AS   
select D.Scrip_cd,D.Series,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId,CertNo,  
Qty=sum(qty),delivered,bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,Cl_Rate=IsNull(Cl_Rate,0),Exchg = 'NSE'   
from MSajag.DBO.Client1 c1,MSajag.DBO.client2 c2,DelAccBalance A,DeliveryDp DP, MSajag.DBO.DelTrans D Left Outer Join MSajag.DBO.Closing C  
On ( D.Scrip_Cd = C.Scrip_CD And D.Series = C.Series And SysDate = (Select Max(Sysdate) From MSajag.DBO.Closing Where Scrip_Cd = C.Scrip_CD And Series = C.Series ))   
where D.Party_Code >= @FPartyCode and D.Party_Code <= @TPartyCode and DrCr = 'D' And TrType <> 906 and D.Party_code = C2.Party_code   
and C1.Cl_Code = c2.Cl_Code and filler2= 1 And A.CltCode = D.Party_Code And Delivered = '0'  
And DP.DpType = D.BDpType And DP.DpCltNo = D.BCltDpId And DP.DpId = D.BDpId And Description not like '%POOL%'  
Group by D.Scrip_cd,D.Series,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId, CertNo, delivered,  
bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,delivered,Cl_Rate   
Union All   
select Scrip_Cd=S2.Scrip_Cd,Series=D.Scrip_Cd,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId,CertNo,  
Qty=sum(qty),delivered,bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,Cl_Rate=IsNull(C.Cl_Rate,0),Exchg = 'BSE'   
from BSEDB.DBO.Client1 c1,BSEDB.DBO.client2 c2,DelAccBalance A,DeliveryDp DP, BseDb.DBO.MultiIsIn M, Scrip2 S2,BSEDB.DBO.DelTrans D Left Outer Join BSEDB.DBO.Closing C   
On ( D.Scrip_Cd = C.Scrip_CD And D.Series = C.Series And SysDate = (Select Max(Sysdate) From BSEDB.DBO.Closing Where Scrip_Cd = C.Scrip_CD And Series = C.Series ))   
where D.Party_Code >= @FPartyCode and D.Party_Code <= @TPartyCode and DrCr = 'D' And TrType <> 906 and D.Party_code = C2.Party_code   
and C1.Cl_Code = c2.Cl_Code and filler2= 1 And A.CltCode = D.Party_Code And M.IsIn = D.Certno And D.Scrip_Cd = S2.BseCode   
And DP.DpType = D.BDpType And DP.DpCltNo = D.BCltDpId And DP.DpId = D.BDpId And Description not like '%POOL%' And Delivered = '0'  
Group by D.Scrip_cd,S2.Scrip_Cd,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId, CertNo, delivered,   
bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,delivered,C.Cl_Rate  
order by C1.Long_Name,1,3

GO
