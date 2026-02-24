-- Object: PROCEDURE dbo.MimansaUpAngelClientDpHolding
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE Procedure [dbo].[MimansaUpAngelClientDpHolding]
As
Truncate table  MimansaAngelClientDpHolding
 
Insert into MimansaAngelClientDpHolding
Select
       Party_code = CM_BLSAVINGCD,
       ISIN = HLD_ISIN_CODE,
       HoldQty = Floor(HLD_AC_POS),
       Scripname = COMP_NAME ,
       Reportdate = GETDATE(), 
       HoldingAccountCode = HLD_AC_CODE,  
       HoldingType =
                     case
                           when poa.DPID is NULL THEN
                                  'NON-NBFC'
                           else
                                  (
                                         case
                                                when HLD_AC_CODE = poa.DPID + poa.DPAccountNo THEN
                                                       'NBFC'
                                                ELSE
                                                       'NON-NBFC'
                                                END   
                                  )
                           end,-- Added by Mukesh on Oct 4 2013 
       syn.hld_ac_type,-- Added BY Prasanna On Feb 19 2014
       1.subcm_description, --a1.bt_description, -- Added BY Prasanna On Feb 19 2014 to include holding type
       ClosingPrice=Cast('0' as money),
       ClosingDate=cast('' as smalldatetime)
From
        
       dmat.citrus_usr.VW_PARTY_HOLDING syn WITH(NOLOCK)
      
Left Outer Join [172.31.16.57].NBFC.DBO.ANG_NBFCCLIENTS Poa with(nolock)
    on syn.CM_BLSAVINGCD = poa.ClientCode  and poa.AccountType = 'POA' 
       left outer join
       DMAT.citrus_usr.BENEFICIARY_TYPE a1 on syn.hld_ac_type=a1.subcm_cd  
 order by CM_BLSAVINGCD
 
 
Select
       Cpcl.isin,
       close_price = close_price,
       Rate_Date = left(convert(varchar,Mcl.Rate_Date,109),11)
into #temp_DPClosingPrice 
from  
 DMAT.citrus_usr.Vw_Isin_Rate_Master Cpcl WITH(NOLOCK),
( Select Distinct isin ,Rate_Date = Max(Rate_Date) from DMAT.citrus_usr.Vw_Isin_Rate_Master  WITH(NOLOCK)--[196.1.115.199].synergy.dbo.Vw_Isin_Rate_Master
  Group by isin ) Mcl 
Where 
Cpcl.isin = Mcl.isin 
And 
CpCl.Rate_Date = Mcl.Rate_Date
 
update MimansaAngelClientDpHolding set ClosingPrice =a1.close_price , ClosingDate=a1.Rate_Date
from #temp_DPClosingPrice a1
where MimansaAngelClientDpHolding.isin=a1.isin

GO
