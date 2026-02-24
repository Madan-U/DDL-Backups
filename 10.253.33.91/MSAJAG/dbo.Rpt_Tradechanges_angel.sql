-- Object: PROCEDURE dbo.Rpt_Tradechanges_angel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_Tradechanges_angel (@Sauda_date Varchar(11))          
As          
Select @Sauda_date = Ltrim(Rtrim(@Sauda_date))          
If Len(@Sauda_date) = 10           
Begin          
          Set @Sauda_date = STUFF(@Sauda_date, 4, 1,'  ')          
End          
          
/*          
Select wrong_code = Branch_id,correct_code = Party_code,Settlement.Scrip_cd,Symbol = S2.Scrip_cd ,           
Tradeqty,Marketrate ,order_no from settlement ,Scrip2 S2           
where sauda_date like @Sauda_date  + '%'          
and branch_id <> party_code and auctionpart = '0'           
and User_Id not in(select UserId from termparty)           
and s2.Bsecode = Settlement.Scrip_cd           
and trade_no not like '%C%'           
Order by Branch_id,party_code,Settlement.Scrip_cd          
*/          
    
/*          
Select distinct wrong_code = Branch_id,correct_code = Party_code,--Settlement.Scrip_cd,        
Symbol = S2.Scrip_cd ,           
Tradeqty,Marketrate ,order_no from settlement ,Scrip2 S2           
where sauda_date like @Sauda_date  + '%'          
and branch_id <> party_code and sett_type not in ('A','X') /*and User_Id not in(select UserId from termparty)*/           
and s2.Scrip_cd = Settlement.Scrip_cd and isnumeric(trade_no)=1          
--Order by Branch_id,party_code,Settlement.Scrip_cd          
*/    
    
Select wrong_code = Branch_id,correct_code =Party_code,    
Symbol =Scrip_cd,Tradeqty,sell_buy,Marketrate,order_no,user_id into #t     
from settlement where sauda_date like @Sauda_date  + '%'           
and branch_id <> party_code and sett_type not in ('A','X')    
    
  
select wrong_code,x.branch_cd as WBranch_cd,correct_code,y.branch_cd as CBranch_cd,symbol,tradeqty,sell_buy,Marketrate,order_no,user_id from   
(  
select #t.*,b.branch_cd from #t   
left outer join   
client_details b on   
#t.wrong_code = b.party_code  
)x  
left outer join  
(select * from client_details) y  
on x.correct_code = y.party_code

GO
