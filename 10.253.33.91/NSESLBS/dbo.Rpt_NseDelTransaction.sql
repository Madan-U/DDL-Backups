-- Object: PROCEDURE dbo.Rpt_NseDelTransaction
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelTransaction (  
@StatusId Varchar(15),@StatusName Varchar(25),@FromDate varchar(11),@ToDate Varchar(11),@Party_Code Varchar(10),@Scrip_Cd Varchar(12))  
AS  
IF @StatusId = 'broker'   
Begin  
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D, CLient1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
Union All  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D where D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
Union All   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno, D.DrCr,   
TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D, Client1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
union all  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno,  
D.DrCr,TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D where D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
ORDER BY D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.DrCr   
end   
IF @StatusId = 'branch'   
Begin  
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D, CLient1 C1, Client2 C2, branches br   where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59' and br.short_name = c1.trader and br.branch_cd = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
Union All  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D where D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
Union All   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno, D.DrCr,   
TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D, Client1 C1, Client2 C2, branches br   where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59' and br.short_name = c1.trader and br.branch_cd = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
union all  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno,  
D.DrCr,TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D where D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
ORDER BY D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.DrCr   
end   
IF @StatusId = 'subbroker'   
Begin  
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D, CLient1 C1, Client2 C2, subbrokers sb where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59' and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
Union All  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D where D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
Union All   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno, D.DrCr,   
TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D, Client1 C1, Client2 C2, subbrokers sb where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59' and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
union all  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno,  
D.DrCr,TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D where D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
ORDER BY D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.DrCr   
end   
IF @StatusId = 'trader'   
Begin  
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D, CLient1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59' and c1.trader = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
Union All  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D where D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
Union All   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno, D.DrCr,   
TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D, Client1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59' and c1.trader = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
union all  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno,  
D.DrCr,TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D where D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
ORDER BY D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.DrCr   
end   
IF @StatusId = 'client'   
Begin  
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D, CLient1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59' and d.party_code like @Party_Code + '%'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
Union All  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D where D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
Union All   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno, D.DrCr,   
TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D, Client1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59' and d.party_code like @Party_Code + '%'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
union all  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno,  
D.DrCr,TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D where D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
ORDER BY D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.DrCr   
end  
IF @StatusId = 'family'   
Begin  
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D, CLient1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59' and c1.family = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
Union All  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty,  
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId  
from deltrans D where D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1   
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
Union All   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno, D.DrCr,   
TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D, Client1 C1, Client2 C2 where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code   
and D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59' and c1.family = @statusname  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
union all  
select D.Party_Code,short_name=D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.TCode, D.Qty, Transno,  
D.DrCr,TransDate=TrDate,Reason='', certno=IsIn, SlipNo =0,DpType,CltDpNo=CltAccNo,DpId   
from demattrans D where D.trdate >= @FromDate and D.trdate <= @ToDate + ' 23:59:59'  
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd  
And Party_Code not in (Select Party_Code From Client2 Where Party_Code = D.Party_Code )  
ORDER BY D.Party_Code,D.scrip_cd, D.series, D.Sett_No, D.Sett_type, D.DrCr   
end

GO
