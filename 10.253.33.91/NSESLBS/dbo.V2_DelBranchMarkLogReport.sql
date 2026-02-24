-- Object: PROCEDURE dbo.V2_DelBranchMarkLogReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE       procedure [dbo].[V2_DelBranchMarkLogReport]      
(      
 @strStatus varchar(4),  
 @strHoldType varchar(4),  
 @fromParty varchar(10),  
 @ToParty varchar(10),  
 @strBranch varchar(10),  
 @strBroker varchar(10),  
 @strExchange varchar(3),  
 @strReqDate varchar(11),  
 @strAprDate varchar(11),
 @strDpType varchar(4),  
 @StatusId Varchar(15), 
 @StatusName Varchar(25)  
)      
as         
Select * From (      
  select  SrNo,Exchg,Party_Code, Long_Name,Branch_Cd,Sub_Broker,Scrip_CD, Series, CertNo, 
  CltDpId = (Case When Len(CltDpId) = 16 then CltDpId Else DpId+'-'+CltDpId End),Remark,      
  ReqQty,
  AprPledgeQty=(Case When @StatusName = 'broker' then
	(Case When AprPledgeQty > 0 Then AprPledgeQty Else ReqPledgeQty End)
	 Else 0 End),
  AprHoldQty=(Case When @StatusName <> 'broker' then
			(Case When AprHoldQty > 0 Then AprHoldQty Else ReqHoldQty End)
		Else (Case When AprFreeQty > 0 Then AprFreeQty Else ReqFreeQty End) End),		
  AprFreeQty=(Case When AprFreeQty > 0 Then AprFreeQty Else ReqFreeQty End),
  AprQty,PayQty,HoldType ,   
  (Case When ReqSubDate Like 'Jan  1 1900%' Then '' Else convert(varchar,ReqSubDate) End) ReqSubDate,ReqSubby,      
   (Case When ReqDate Like 'Jan  1 1900%' Then '' Else convert(varchar,ReqDate) End) ReqDate,  
  Reqby, (Case When AprDate Like 'Jan  1 1900%' Then '' Else convert(varchar,AprDate) End) AprDate,AprBY,
  HoldAmt=(Case When AprFreeQty > 0 Then AprFreeQty*Cl_Rate Else ReqFreeQty*Cl_Rate End),
   Apramt=(Case When AprFreeQty > 0 Then Apramt Else ReqAmt End),    
AprNSEFOAmount=(Case When AprFreeQty > 0 Then AprNSEFOAmount Else ReqNSEFOAmount End),
    ReqStatus=(Case When ReqStatus = 'REJ'     
      Then 'REJECTED'    
      When ReqStatus = 'APR' And PayQty = 0 And ProcessStatus = 'APR'    
      Then 'PAYOUT PENDING'    
      When ReqStatus = 'APR' And PayQty > 0 And ProcessStatus = 'APR'    
      Then 'PAYOUT GIVEN'    
      When ReqStatus = 'REQ' And ProcessStatus = 'APR'    
      Then 'PENDING FOR APPROVAL'    
      When ReqStatus = 'REQ' And ProcessStatus = 'REQ'    
      Then 'REQUESTED'    
      When ReqStatus = 'APR'     
      Then 'APPROVED'    
      When ReqStatus = 'NAT'     
      Then 'NO ACTION TAKEN'    
  End),
  BDpType
   From DelBranchMark_New d, DelBranchMark_settings s       
    where exchg = exchange And ProcessStatus = ProcessType  
    And ReqStatus <> ''    
    And BDpType Like (Case When @strDpType = 'ALL' Then '%' Else @strDpType End)
    union  all       
  select  SrNo,Exchg,Party_Code, Long_Name,Branch_Cd,Sub_Broker,Scrip_CD, Series, CertNo,
  CltDpId = (Case When Len(CltDpId) = 16 then CltDpId Else DpId+'-'+CltDpId End), Remark,      
  ReqQty,
  AprPledgeQty=(Case When @StatusName = 'broker' then
	(Case When AprPledgeQty > 0 Then AprPledgeQty Else ReqPledgeQty End)
	 Else 0 End),
  AprHoldQty=(Case When @StatusName <> 'broker' then
			(Case When AprHoldQty > 0 Then AprHoldQty Else ReqHoldQty End)
		Else (Case When AprFreeQty > 0 Then AprFreeQty Else ReqFreeQty End) End),		
  AprFreeQty=(Case When AprFreeQty > 0 Then AprFreeQty Else ReqFreeQty End),
  AprQty,PayQty,HoldType ,   
  (Case When ReqSubDate Like 'Jan  1 1900%' Then '' Else convert(varchar,ReqSubDate) End) ReqSubDate,ReqSubby,      
   (Case When ReqDate Like 'Jan  1 1900%' Then '' Else convert(varchar,ReqDate) End) ReqDate,  
  Reqby, (Case When AprDate Like 'Jan  1 1900%' Then '' Else convert(varchar,AprDate) End) AprDate,AprBY,
  HoldAmt=(Case When AprFreeQty > 0 Then AprFreeQty*Cl_Rate Else ReqFreeQty*Cl_Rate End),
   Apramt=(Case When AprFreeQty > 0 Then Apramt Else ReqAmt End),    
AprNSEFOAmount=(Case When AprFreeQty > 0 Then AprNSEFOAmount Else ReqNSEFOAmount End),    
    ReqStatus=(Case When ReqStatus = 'REJ'     
      Then 'REJECTED'    
      When ReqStatus = 'APR' And PayQty = 0 And ProcessStatus = 'APR'    
      Then 'PAYOUT NOT GIVEN'    
      When ReqStatus = 'APR' And PayQty > 0 And ProcessStatus = 'APR'    
      Then 'PAYOUT GIVEN'    
      When ReqStatus = 'REQ' And ProcessStatus = 'APR'    
      Then 'PENDING FOR APPROVAL'    
      When ReqStatus = 'REQ' And ProcessStatus = 'REQ'    
      Then 'REQUESTED'    
      When ReqStatus = 'APR'     
      Then 'APPROVED'    
      When ReqStatus = 'NAT'     
      Then 'NO ACTION TAKEN'    
  End), BDpType
   From DelBranchMark_New_log  d, DelBranchMark_settings s       
  where exchg = exchange And ProcessStatus = ProcessType And ReqStatus <> '' ) A    
  Where ReqStatus Like (Case When @strStatus = '1' Then 'REJECTED'    
                   When @strStatus = '2' Then 'PAYOUT PENDING'    
                   When @strStatus = '3' Then 'PAYOUT GIVEN'    
                   When @strStatus = '4' Then 'PENDING FOR APPROVAL'    
                   When @strStatus = '5' Then 'REQUESTED'    
                   When @strStatus = '6' Then 'APPROVED'    
                   When @strStatus = '7' Then 'NO ACTION TAKEN'    
                   When @strStatus = '8' Then 'PAYOUT NOT GIVEN'    
                   When @strStatus = '' Then '%'    
            Else ''    
       End)   
 and HoldType like  @strHoldType + '%'  
 and Party_code Between @fromParty and @ToParty  
 and Branch_Cd like  @strBranch   
 and Sub_Broker like  @strBroker  
 and Exchg like @strExchange + '%'  
 and ReqDate like @strReqDate + '%'  
 and AprDate like @strAprDate + '%'  
 and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)    
 and Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End) 
 And BDpType Like (Case When @strDpType = 'ALL' Then '%' Else @strDpType End)
 Order By Branch_Cd, Sub_Broker, Party_Code,Scrip_cd, Series, CertNo, SrNo

GO
