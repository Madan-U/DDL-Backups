-- Object: PROCEDURE dbo.Rpt_DelPayOutLog
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Rpt_DelPayOutLog   
  
@tSDate varchar(11),  
@strcmbExchange varchar(4),  
@tFrom_Party varchar(16),  
@tTo_Party varchar(16)   
  
as  
  
Set transaction isolation level read uncommitted   
Select D.Party_code Party_code ,C1.Long_Name Long_Name, D.Scrip_cd Scrip_cd ,   
       D.Series Series ,CertNo CertNo,Sum(DebitQty) DebitQty,S1.short_name Scripname,
       c1.L_ADDRESS1,c1.L_ADDRESS2,c1.L_ADDRESS3,c1.l_city,c1.L_ZIP  
 from  DelPayOutLog D ,client1 c1, client2 c2 ,Scrip1 S1 , Scrip2 S2  
 Where RunDate = (Select Max(RunDate) From DelPayOutLog D1   
                  Where convert(Varchar(11),RunDate,103) <=  @tSDate   
                  And D.Party_code = D1.Party_Code And D.Exchange = D1.Exchange)   
 And DebitQty > 0   
 And c1.cl_code = c2.cl_code   
 And D.party_code = c2.party_code   
 And S1.co_code = S2.co_code  
 And S1.Series = S2.Series  
 And D.Scrip_cd = S2.Scrip_cd  
 And D.series = s2.series  
 And D.Exchange = @strcmbExchange   
 And  D.Party_code between @tFrom_Party And @tTo_Party  
  Group BY D.Scrip_cd,D.Party_code,D.Series,CertNo,C1.Long_Name ,
           S1.short_name ,c1.L_ADDRESS1,c1.L_ADDRESS2,c1.L_ADDRESS3,c1.l_city,c1.L_ZIP 
 Order by 1

GO
