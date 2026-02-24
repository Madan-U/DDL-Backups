-- Object: PROCEDURE dbo.rpt_ageing3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ageing3    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_ageing3    Script Date: 01/04/1980 5:06:25 AM ******/



/* report : ageing report 
    file : ageing report  
    calculates balance of a client on a particular date
*/
CREATE PROCEDURE rpt_ageing3

@openingentry varchar(12),
@inputdt varchar(12),
@cltcode varchar(10)


as
	 select l.cltcode , acname=isnull(l.acname,''),
  		Amount = ( select isnull(sum(round(vamt,2)),0) from rpt_ageingview where
		drcr = 'D' and cltcode = l.cltcode
  		and vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59 ' ) -
		 (select isnull(sum(round(vamt,2)),0) from rpt_ageingview where drcr = 'C'
		and cltcode = l.cltcode and  vdt >=@openingentry and  vdt <= @inputdt +' 23:59:59 '
		)
  		From rpt_ageingview l where  vdt >=@openingentry and vdt <= @inputdt +' 23:59:59 '
		and cltcode=@cltcode
  		group by l.Cltcode , l.acname
		order by  l.Cltcode , l.acname

GO
