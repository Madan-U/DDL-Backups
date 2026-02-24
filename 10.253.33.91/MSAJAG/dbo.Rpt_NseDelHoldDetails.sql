-- Object: PROCEDURE dbo.Rpt_NseDelHoldDetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_NseDelHoldDetails (
@StatusId Varchar(15),@StatusName Varchar(25),@HoldDate varchar(11),@SettNo Varchar(7),@Sett_Type Varchar(10),@Scrip_Cd Varchar(12),@Series varchar(3),@BDpID Varchar(8),@BCltDpID Varchar(16))
AS
if @statusid = 'broker'
begin
select Sett_No, Sett_type, TCode, Party_Code, D.scrip_cd , series, certno, Qty, TransNo, DrCr, TransDate,Reason,CltDpId,DpID 
from DelHold D where D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and transdate <= @HoldDate + ' 23:59:59'  And DrCr = 'D' 
and BDpId = @BDpId and BCltDpId = @BCltDpId 
Union All 
select Sett_No, Sett_type, TCode, Party_Code, D.scrip_cd, series,certno=D.isin, Qty, Transno, DrCr, TransDate=TrDate,Reason='Excess',
CltDpId=CltAccNo,DpID from demattrans D where D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and trdate <= @HoldDate + ' 23:59:59' And DrCr = 'C' 
and BDpId = @BDpId and BCltAccNo = @BCltDpId 
ORDER BY D.Scrip_CD,Sett_No, Sett_type, Party_Code, DrCr 
end
if @statusid = 'branch'
begin
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd , series, certno, Qty, TransNo, DrCr, TransDate,Reason,CltDpId,DpID 
from DelHold D, Client1 C1,Client2 C2, branches br  
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and transdate <= @HoldDate + ' 23:59:59'  And DrCr = 'D' 
and BDpId = @BDpId and BCltDpId = @BCltDpId 
and br.short_name = c1.trader and br.branch_cd = @statusname
Union All 
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd, series,certno=D.isin, Qty, Transno, DrCr, TransDate=TrDate,Reason='Excess',
CltDpId=CltAccNo,DpID from demattrans D , Client1 C1, Client2 C2, branches br   
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and trdate <= @HoldDate + ' 23:59:59' And DrCr = 'C' 
and BDpId = @BDpId and BCltAccNo = @BCltDpId 
and br.short_name = c1.trader and br.branch_cd = @statusname
ORDER BY D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr 
end
if @statusid = 'subbroker'
begin
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd , series, certno, Qty, TransNo, DrCr, TransDate,Reason,CltDpId,DpID 
from DelHold D, Client1 C1,Client2 C2, subbrokers sb 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and transdate <= @HoldDate + ' 23:59:59'  And DrCr = 'D' 
and BDpId = @BDpId and BCltDpId = @BCltDpId 
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
Union All 
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd, series,certno=D.isin, Qty, Transno, DrCr, TransDate=TrDate,Reason='Excess',
CltDpId=CltAccNo,DpID from demattrans D , Client1 C1, Client2 C2, subbrokers sb 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and trdate <= @HoldDate + ' 23:59:59' And DrCr = 'C' 
and BDpId = @BDpId and BCltAccNo = @BCltDpId 
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
ORDER BY D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr 
end
if @statusid = 'trader'
begin
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd , series, certno, Qty, TransNo, DrCr, TransDate,Reason,CltDpId,DpID 
from DelHold D, Client1 C1,Client2 C2 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and transdate <= @HoldDate + ' 23:59:59'  And DrCr = 'D' 
and BDpId = @BDpId and BCltDpId = @BCltDpId 
and c1.trader = @statusname
Union All 
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd, series,certno=D.isin, Qty, Transno, DrCr, TransDate=TrDate,Reason='Excess',
CltDpId=CltAccNo,DpID from demattrans D , Client1 C1, Client2 C2 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and trdate <= @HoldDate + ' 23:59:59' And DrCr = 'C' 
and BDpId = @BDpId and BCltAccNo = @BCltDpId 
and c1.trader = @statusname
ORDER BY D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr 
end
if @statusid = 'client'
begin
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd , series, certno, Qty, TransNo, DrCr, TransDate,Reason,CltDpId,DpID 
from DelHold D, Client1 C1,Client2 C2 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and transdate <= @HoldDate + ' 23:59:59'  And DrCr = 'D' 
and BDpId = @BDpId and BCltDpId = @BCltDpId 
and c2.party_code = @statusname
Union All 
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd, series,certno=D.isin, Qty, Transno, DrCr, TransDate=TrDate,Reason='Excess',
CltDpId=CltAccNo,DpID from demattrans D , Client1 C1, Client2 C2 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and trdate <= @HoldDate + ' 23:59:59' And DrCr = 'C' 
and BDpId = @BDpId and BCltAccNo = @BCltDpId 
and c2.party_code = @statusname
ORDER BY D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr 
end
if @statusid = 'family'
begin
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd , series, certno, Qty, TransNo, DrCr, TransDate,Reason,CltDpId,DpID 
from DelHold D, Client1 C1,Client2 C2 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and transdate <= @HoldDate + ' 23:59:59'  And DrCr = 'D' 
and BDpId = @BDpId and BCltDpId = @BCltDpId 
and c1.family = @statusname
Union All 
select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd, series,certno=D.isin, Qty, Transno, DrCr, TransDate=TrDate,Reason='Excess',
CltDpId=CltAccNo,DpID from demattrans D , Client1 C1, Client2 C2 
where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And
D.scrip_cd = @Scrip_Cd and D.series= @Series and sett_no = @SettNo and sett_type = @Sett_Type
and trdate <= @HoldDate + ' 23:59:59' And DrCr = 'C' 
and BDpId = @BDpId and BCltAccNo = @BCltDpId 
and c1.family = @statusname
ORDER BY D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr 
end

GO
