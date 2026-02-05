-- Object: PROCEDURE citrus_usr.getdateforcomplience
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[getdateforcomplience] (@Pa_out datetime out)   
as    
select case when day(getdate()) between 1 and 15 then convert(varchar(11),dbo.LastMonthDay (dateadd(m,-1,getdate())),103)
when day(getdate()) between 15 and 31 then  convert(varchar(11),dateadd(dd,14,DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()))-1),getdate()) ),103)    
end

GO
