-- Object: PROCEDURE dbo.Angel_upd_ScripGroupwise_TO
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure [dbo].[Angel_upd_ScripGroupwise_TO](@sdate as varchar(11))    
as   
begin 
    set nocount on;
    set transaction isolation level read uncommitted 
    Select scripcode=nsesymbol,groupname=ltrim(rtrim(status)),Series=NSESeries 
    into #scrip 
    from [CSOKYC-6].general.dbo.scrip_master a (nolock) 
    where  nsesymbol is not null

    truncate table Angel_ScripGroupwise_TO    
    insert into Angel_ScripGroupwise_TO    
    select segment='NSECM',sauda_Date,party_code,NSECM_TO=sum(pamtdel+pamttrd+samtdel+samttrd),b.groupname     
    from msajag.dbo.cmbillvalan a (nolock),     
    #scrip b     
    where a.sauda_Date=@sdate and a.scrip_cd=b.scripcode collate Latin1_General_CI_AS    
    and a.billno <> '0' and contractno <> '0'    
    group by sauda_Date,party_code,b.groupname  
    set nocount off; 
end

GO
