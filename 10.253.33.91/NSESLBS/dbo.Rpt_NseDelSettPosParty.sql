-- Object: PROCEDURE dbo.Rpt_NseDelSettPosParty
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelSettPosParty     
(@StatusId Varchar(15),@StatusName Varchar(25),@SettNo Varchar(7),@Sett_Type Varchar(2))    
As    

Select *, Scripname = Convert(Varchar(50), '') Into #Del From DeliveryClt
Where sett_no = @SettNo and sett_type = @Sett_Type     

Update #Del set ScripName=Left(S1.Short_Name,50)
From Scrip1 S1, Scrip2 S2 
Where S1.Co_Code = S2.Co_Code 
and S1.series = s2.series 
and S2.Scrip_Cd = #Del.Scrip_cd 
and #Del.series = s2.series    

select D.Party_Code,C1.Long_Name,ScripName,D.Scrip_Cd,D.Series,
ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end )     
from #Del D, Client2 C2, Client1 C1
Where sett_no = @SettNo and sett_type = @Sett_Type     
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
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
Order By D.Party_Code,C1.Long_Name,ScripName

GO
