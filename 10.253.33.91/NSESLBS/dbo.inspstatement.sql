-- Object: PROCEDURE dbo.inspstatement
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--use nsefo 

CREATE proc inspstatement as    
  
select Exchange, Segment, C.party_code, C1.Long_Name, scrip_cd, series, ISIn,   
BankDpId, Dp_Acc_Code, Qty, drCr,Trans_Code, Effdate, B_BankDpId, B_Dp_Acc_Code, Remarks   
 from msajag.dbo.C_SecuritiesMst C Left Outer Join ClientMaster C1   
On C.Party_Code = C1.Party_Code where EffDate <= 'dec 31 2049 23:59:59'   
and EffDate >= 'Jan  1 2004 00:00:00' and Active = 1 and Exchange like 'NSE%' and  
 Segment Like 'FUTURES%' and scrip_cd like '%' and Series like '%' and  
 C.Party_code like '%' and C.Party_Code <> 'Broker' 
ORDER by Exchange, Segment,EFFDATE,C.Party_Code, SCRIP_CD, SERIES, ISIN,Trans_Code  


--ec inspstatement

GO
