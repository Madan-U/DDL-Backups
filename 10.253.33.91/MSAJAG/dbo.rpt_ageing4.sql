-- Object: PROCEDURE dbo.rpt_ageing4
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ageing4    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_ageing4    Script Date: 01/04/1980 5:06:25 AM ******/



/* report :ageing
     file : ageing report
*/
/* calculates balances of all parties on a particular date */

     
CREATE PROCEDURE rpt_ageing4



@inputdt varchar(12),
@cltcode varchar (10)



as

 select l.cltcode , acname=isnull(l.acname,''),
  		Amount = ( select isnull(sum(round(vamt,2)),0) from rpt_ageingview where
		drcr = 'D' and cltcode = l.cltcode
  		and  vdt <= @inputdt + ' 23:59:59 ' ) -
		 (select isnull(sum(round(vamt,2)),0) from rpt_ageingview where drcr = 'C'
		and cltcode = l.cltcode and  vdt <= @inputdt +' 23:59:59 ')
  		From rpt_ageingview l where  vdt <= @inputdt +' 23:59:59 ' 
		and cltcode=@cltcode
  		group by l.Cltcode , l.acname
		order by  l.Cltcode , l.acname

GO
