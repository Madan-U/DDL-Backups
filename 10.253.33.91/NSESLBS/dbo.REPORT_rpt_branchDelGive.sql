-- Object: PROCEDURE dbo.REPORT_rpt_branchDelGive
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE proc REPORT_rpt_branchDelGive

@dematid varchar(2),
@settno varchar(7),
@settype varchar(3),
@branch varchar(15)

AS

select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=d.Qty,
 givenNse= isnull(Sum(Case When DrCr = 'D' Then DT.qty Else 0 End),0),
 RecievedNse=isnull(Sum(Case When DrCr = 'C' Then DT.qty Else 0 End),0),
 ScripName=d.Series,Branch=C1.Branch_Cd
 from Client1_Report C1,Client2_Report C2,DeliveryClt_Report d Left Outer Join DelTrans_Report DT
 On (DT.sett_no = d.sett_no and Dt.sett_type = d.sett_type and 
 DT.scrip_cd = d.scrip_cd and Dt.series = d.series and DrCr = 'D'
 And filler2 = 1 And D.Party_Code = Dt.Party_Code )
 where d.party_code = c2.party_code and c2.cl_code = c1.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and inout = 'O' 
 and c1.branch_cd like ltrim(@branch)+'%'  
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,D.Qty,D.Party_Code,C1.Branch_Cd
 Order By d.sett_no,d.sett_type,C1.Branch_Cd,d.scrip_cd,d.series

GO
