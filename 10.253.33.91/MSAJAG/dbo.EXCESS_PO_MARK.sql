-- Object: PROCEDURE dbo.EXCESS_PO_MARK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[EXCESS_PO_MARK]        
  
--(        
  
-- @STATUSID VARCHAR(25), @STATUSNAME VARCHAR(25),         
  
-- @FROMDATE VARCHAR(11), @TODATE VARCHAR(11),         
  
-- @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10),         
  
-- @REPORTFOR VARCHAR(10)        
  
--)          
AS        
select   
Exchg,HoldType,Party_Code,Long_Name,Branch_Cd,Sub_Broker,Scrip_CD,Series,  
CertNo,ReqFreeQty,ReqHoldQty,ReqPledgeQty,ReqProcessDate, Cl_Rate,ReqQty,ReqSubBy,ReqSubDate,   
ReqBy,ReqDate,AprFreeQty,AprHoldQty,AprPledgeQty,AprProcessDate,  
AprQty,AprBy,AprDate,ReqFlag,ReqStatus,ProcessStatus,Remark,PayQty,DpId,CltDpId,BDpType,GROUPCODE,PAYTYPE  
 from [AngelDemat].MSAJAG.DBO.DelBranchMark_New where ReqfreeQty < ReqQty  
--ReqProcessDate like getdate() and   
order by party_code

GO
