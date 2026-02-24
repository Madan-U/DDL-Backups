-- Object: PROCEDURE dbo.PROC_ALL_ACMASTFLAG_BSE
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_ALL_ACMASTFLAG_BSE] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))        
        
AS  --- EXEC PROC_ALL_REPORT_STATUS 'SEP 12 2022'        
    Select distinct Party_code into #T1 from ANGELBSECM.bsedb_ab.dbo.settlement with (nolock)  where Sauda_date >=cast(getdate() as date) 
select party_code from #T1 where party_code not in (select cltcode from account.dbo.acmast  with (nolock) )

GO
