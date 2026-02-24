-- Object: PROCEDURE dbo.InsDelBenUpdate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE Proc InsDelBenUpdate   
(  
@Party_Code Varchar(10),  
@Scrip_Cd Varchar(12),  
@Series Varchar(3),  
@ISett_No Varchar(7),  
@ISett_Type Varchar(2) ,
@DpType Varchar(4)
)  
  
As  
  
Update  DelTrans   
Set  DPType =D.DpType,  
 DPId = D.DPID,  
 CltDpid=D.DpCltNo,  
 Reason='Inter Benificiary'   
From  MSAJAG.DBO.Sett_Mst S,   
 MSAJAG.DBO.DeliveryDp D  
 , DelTrans With(Index(DelHold),NOLOCK)  
Where  S.Sett_No = ISett_No   
And  S.Sett_Type = ISett_Type   
And  TrType = 1000   
And  D.DpType = 'NSDL'   
And  Description Like '%POOL%'   
And  Delivered = '0'  
And  ISett_No = @ISett_No   
And  ISett_Type = @ISett_Type   
And  Party_Code = @Party_Code   
And  Scrip_CD = @Scrip_CD   
And  DelTrans.Series = @Series   
  
Update  DelTrans   
Set  DPType = D.DpType,  
 DPId = D.DPID,  
 CltDpid=D.DpCltNo,  
 Reason='Inter Exchange Benificiary'   
From  BSEDB.DBO.Sett_Mst S,   
 BSEDB.DBO.DeliveryDp D  
 ,DelTrans With(Index(DelHold),NOLOCK)  
Where  S.Sett_No = ISett_No   
And  S.Sett_Type = ISett_Type   
And  TrType = 1000   
And  D.DpType = 'NSDL'   
And  Description Like '%POOL%'   
And  Delivered = '0'   
And  ISett_No = @ISett_No   
And  ISett_Type = @ISett_Type   
And  Party_Code = @Party_Code   
And  Scrip_CD = @Scrip_CD   
And  DelTrans.Series = @Series   
/*  
Update  DelTrans   
Set  DPType ='CDSL',  
 DPId = M.DPID,  
 CltDpid=M.CltDpNo,  
 Reason='POA Inter Benificiary'   
From  BSEDB.DBO.MultiCltId M,    
 BSEDB.DBO.Sett_Mst S  
 ,DelTrans With(Index(DelHold),NOLOCK)  
Where  S.Sett_No = ISett_No   
And  S.Sett_Type = ISett_Type   
And  DelTrans.Party_Code = M.Party_Code   
And  Def = 1   
And  M.DpType = 'CDSL'   
And  TrType = 1000   
And  Delivered = '0'  
And  ISett_No = @ISett_No   
And  ISett_Type = @ISett_Type   
And  DelTrans.Party_Code = @Party_Code   
And  Scrip_CD = @Scrip_CD   
And  DelTrans.Series = @Series
*/

GO
