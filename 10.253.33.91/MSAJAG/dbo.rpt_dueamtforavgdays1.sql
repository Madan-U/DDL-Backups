-- Object: PROCEDURE dbo.rpt_dueamtforavgdays1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------









/*  written by shilpa  on  20  the sept  to calcutate clientcode , the balance on input date and the  final amount=sum(balamt*Nodays)*/
/*   changed by shilpa on 22 sept */

CREATE proc rpt_dueamtforavgdays1

@openingentry datetime,
@inputdt datetime,
@cltcode varchar(12)

as

if @openingentry <> ' ' 
begin
 		 select Finalamt=(select isnull(sum(balamt*actNodays),0) from rpt_ageingview where   vdt >= @openingentry  and vdt <= @inputdt + ' 23:59:59'  and cltcode=@cltcode ),
  		Amount = ( select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'D' and cltcode =@cltcode 
  		and vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'C' and cltcode = @cltcode  and vdt >= @openingentry  
		and vdt <= @inputdt + ' 23:59:59') 
		
  		
end
else
begin
		 select  Finalamt=(select isnull(sum(balamt*actNodays),0) from rpt_ageingview where  vdt <= @inputdt + ' 23:59:59'  and cltcode=@cltcode),
  		Amount = ( select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'D' and cltcode = @cltcode 
  		and vdt <= @inputdt + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from rpt_ageingview  where drcr = 'C' and cltcode = @cltcode  and  vdt <= @inputdt + ' 23:59:59') 
		
  		
end

GO
