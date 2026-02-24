-- Object: PROCEDURE citrus_usr.NON_POA_hold
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE Proc [citrus_usr].[NON_POA_hold]
as 
select BOID , BBOCODE into #dp  from vw_nonpoaclient --where  [ACTIVATION DATE]='20/05/2020'
where bbocode <>'minor'

create index #s on #dp(BOID)


truncate table [citrus_usr].[Holding_Non_poa]

insert into [citrus_usr].[Holding_Non_poa]
Select hld_ac_code,HLD_ISIN_CODE,HLD_AC_POS,bbocode,HLD_HOLD_DATE
 from HoldingData h,#dp b where HLD_AC_CODE =boid

GO
