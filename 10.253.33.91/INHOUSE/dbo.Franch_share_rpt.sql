-- Object: PROCEDURE dbo.Franch_share_rpt
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


    
CREATE Procedure [dbo].[Franch_share_rpt](@fdate as varchar(11))        
As        
     
set nocount on        
declare @acdate as varchar(25)          
select @acdate='Apr  1 '+          
(case when substring(@fdate,1,3) in ('Jan','Feb','Mar')           
then convert(varchar(4),substring(@fdate,8,4)-1) else convert(varchar(4),substring(@fdate,8,4)) end)+' 00:00:00'          
 --print @acdate          
        
select y.vdt,x.cltcode,balance=sum(case when upper(drcr)='D' then x.vamt else x.vamt*-1 end) ,segment='ACDLCM'          
from ( select vdt,cltcode,drcr,vamt from AngelNseCM.account.dbo.ledger          
where vdt >= @acdate and vdt <=convert(datetime,@fdate+' 23:59:59') and cltcode in(select glcode from Franch_GL_grp where segment='ACDLCM') and vamt <> 0           
) X,
(select vdt=mdate from cal_full where mdate >= @fdate and mdate <= convert(datetime,@fdate+' 23:59:59')) y ,
(select glcode from Franch_GL_grp where  segment='ACDLCM') z
where  convert(Datetime,convert(varchar(11),x.vdt,100)) <= y.vdt and x.cltcode=z.glcode 
group by y.vdt,x.cltcode      
set nocount off

GO
