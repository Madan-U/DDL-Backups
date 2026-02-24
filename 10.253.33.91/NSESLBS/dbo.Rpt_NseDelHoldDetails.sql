-- Object: PROCEDURE dbo.Rpt_NseDelHoldDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelHoldDetails (  
@StatusId Varchar(15),@StatusName Varchar(25),@HoldDate varchar(11),@SettNo Varchar(7),@Sett_Type Varchar(10),@Scrip_Cd Varchar(12),@Series varchar(3),@BDpID Varchar(8),@BCltDpID Varchar(16))  
AS 
Select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd , 
series, certno, Qty, TransNo=foliono, DrCr, TransDate, Reason,CltDpId,DpID 
from DelTrans D,
Client1 C1,Client2 C2
where sett_no = @settno and sett_Type = @sett_Type 
and scrip_cd = @scrip_Cd and series = @series
and BDpId = @BDpId and BCltDpId = @BCltDpId   
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
And Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType In(904,905,909)
And ShareType <> 'AUCTION'
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
ORDER BY D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr

GO
