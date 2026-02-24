-- Object: FUNCTION citrus_usr.Fn_get_nextamc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

-----select citrus_usr.Fn_get_nextamc('Jan  7 2008','f','12')



CREATE  function citrus_usr.Fn_get_nextamc

(

@pa_amcdate datetime ,

@pa_baseon varchar (100),

@pa_billint numeric 

)





returns datetime 

begin 



declare @l_dt datetime, @l_amcdate datetime 

set @l_dt = getdate ()

if @pa_baseon = 'F'

BEGIN 

set @l_amcdate = @pa_amcdate 



while @l_dt > @l_amcdate 

begin 



set @l_amcdate = dateadd(MM,@pa_billint,@l_amcdate)

end

END 

if @pa_baseon = 'AMCPRO'

BEGIN 

set @l_amcdate = 'aPR 01 '+CONVERT(VARCHAR,YEAR (GETDATE())-1 )



while @l_dt > @l_amcdate 

begin 



set @l_amcdate = dateadd(yy,1,@l_amcdate)

end

END







return @l_amcdate

end

GO
