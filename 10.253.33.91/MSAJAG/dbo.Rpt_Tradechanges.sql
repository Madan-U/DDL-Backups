-- Object: PROCEDURE dbo.Rpt_Tradechanges
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--stored procedure to view changes in nse cash
CREATE  Proc Rpt_Tradechanges (@Sauda_date Varchar(11))
As
Select @Sauda_date = Ltrim(Rtrim(@Sauda_date))
If Len(@Sauda_date) = 10 
Begin
          Set @Sauda_date = STUFF(@Sauda_date, 4, 1,'  ')
End

Select  [Wrong Code] = Branch_id,[Correct Code] = Party_code, Symbol = Scrip_cd, 
Tradeqty,Marketrate,[Order No] = order_no
from settlement where sauda_Date like @Sauda_date + '%' and 
user_Id not in( Select Userid from termparty)
and party_code <> branch_id and auctionpart = 'N'
Order by Branch_id,Party_code,Scrip_cd,order_no

GO
