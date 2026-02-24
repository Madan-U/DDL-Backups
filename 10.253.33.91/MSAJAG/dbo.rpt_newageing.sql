-- Object: PROCEDURE dbo.rpt_newageing
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_newageing    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_newageing    Script Date: 01/04/1980 5:06:27 AM ******/



CREATE proc rpt_newageing

@openingentry datetime,
@backdate datetime,
@inputdt datetime

as

if @openingentry <> '' 
begin
 		select distinct l.cltcode , acname=isnull(l.acname,''), 
  		Amount = ( select isnull(sum(vamt),0) from rpt_ageingview  where drcr = 'D' and cltcode = l.cltcode 
  		and vdt >= @openingentry and vdt <= @backdate + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from rpt_ageingview  where drcr = 'C' and cltcode = l.cltcode and  vdt >=@openingentry and  vdt <= @backdate + ' 23:59:59') 
		,flag='backdate'
  		From rpt_ageingview l where  vdt >= @openingentry and vdt <= @backdate + ' 23:59:59'  
  		group by l.Cltcode , l.acname
		union all
		 select l.cltcode , acname=isnull(l.acname,''), 
  		Amount = ( select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'D' and cltcode = l.cltcode 
  		and vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'C' and cltcode = l.cltcode and vdt >= @openingentry  
		and vdt <= @inputdt + ' 23:59:59') 
		,flag='inputdate'
  		From rpt_ageingview l where   vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59'  
  		group by l.Cltcode , l.acname 
		order by  l.Cltcode , l.acname ,flag
end
else
begin
		 select distinct l.cltcode , acname=isnull(l.acname,''), 
  		Amount = ( select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'D' and cltcode = l.cltcode 
  		and vdt <= @backdate + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from rpt_ageingview  where drcr = 'C' and cltcode = l.cltcode and  vdt <= @backdate + ' 23:59:59') 
		,flag='backdate'
  		From rpt_ageingview l where   vdt <= @backdate + ' 23:59:59'  
  		group by l.Cltcode , l.acname
		
		union all
		 select l.cltcode , acname=isnull(l.acname,''), 
  		Amount = ( select isnull(sum(vamt),0) from rpt_ageingview where drcr = 'D' and cltcode = l.cltcode 
  		and vdt <= @inputdt + ' 23:59:59') - 
 		 (select isnull(sum(vamt),0) from rpt_ageingview  where drcr = 'C' and cltcode = l.cltcode and  vdt <= @inputdt + ' 23:59:59') 
		,flag='inputdate'
  		From rpt_ageingview  l where   vdt <= @inputdt + ' 23:59:59'  
  		group by l.Cltcode , l.acname 
		order by  l.Cltcode , l.acname, flag
end

GO
