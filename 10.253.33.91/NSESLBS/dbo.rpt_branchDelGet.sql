-- Object: PROCEDURE dbo.rpt_branchDelGet
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_branchDelGet    Script Date: 12/16/2003 2:31:43 PM ******/    
    
CREATE PROCEDURE rpt_branchDelGet    
@dematid varchar(2),    
@settno varchar(7),    
@settype varchar(3),    
@branch varchar(15)    
    
AS    

set transaction isolation level read uncommitted    
select 
      d.sett_no,
      d.sett_type,
      d.Scrip_cd,
      d.Series,
      GetFromNse=d.Qty,    
      givenNse= isnull(Sum(Case When DrCr = 'D' Then DT.qty Else 0 End),0),    
      RecievedNse=isnull(Sum(Case When DrCr = 'C' Then DT.qty Else 0 End),0),    
      Branch=C1.Branch_Cd    
from 
      Client1 C1 (nolock),
      Client2 C2 (nolock),
      DeliveryClt d  (nolock)
            Left Outer Join 
      DelTrans DT  (nolock)   
            On 
            (
                  DT.sett_no = d.sett_no 
                  and Dt.sett_type = d.sett_type 
                  and DT.scrip_cd = d.scrip_cd 
                  and Dt.series = d.series     
                  And filler2 = 1 
                  And D.Party_Code = DT.Party_Code 
            )    
where 
      d.party_code = c2.party_code 
      and c1.cl_code = c2.cl_code    
      and d.sett_no = @settno 
      and d.sett_type = @settype 
      and inout = 'I'     
      and c1.Branch_Cd like ltrim(@branch)+'%'     
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,D.Party_Code,D.Qty,C1.Branch_Cd    
Order By d.sett_no,d.sett_type,C1.Branch_Cd,D.Scrip_Cd,d.series

GO
