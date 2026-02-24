-- Object: PROCEDURE dbo.SubbrokerAccValanSett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.SubbrokerAccValanSett    Script Date: 12/26/2001 1:23:57 PM ******/
CREATE proc SubbrokerAccValanSett (@sett_no varchar(7),@sett_type varchar(2)) as

EXEC ACCsubALBMNEWMARGIN @sett_no,@sett_type 
EXEC ACCsubALBMOLDMARGIN @sett_no,@sett_type 

select * from Subbrokertempsettsum where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from Subbrokeroppalbm where sett_no = @sett_no  and sett_type = @sett_type 
union all
select * from SubbrokerPlusOneAlbm where sett_no = ( select min(sett_no) from sett_mst where sett_no > @sett_no  and sett_type = @sett_type )
and sett_type = @sett_type 
UNION ALL
SELECT CltCode=partipantcode,SELL_BUY=2,pamt=0,samt=SUM(FIXMARGIN+ADDMAR),sett_no,sett_type,BILLNO=0 FROM PARTYsubOLDMARGIN
where sett_no = @sett_no  and sett_type = @sett_type
GROUP BY PartiPantCode,SETT_NO,SETT_TYPE
UNION ALL
SELECT CltCode=partipantcode,SELL_BUY=1,pamt=SUM(FIXMARGIN+ADDMAR),samt=0,sett_no,sett_type,BILLNO=0 FROM PARTYsubNEWMARGIN
where sett_no = @sett_no  and sett_type = @sett_type
GROUP BY PartipantCode,SETT_NO,SETT_TYPE
ORDER BY CltCode

GO
