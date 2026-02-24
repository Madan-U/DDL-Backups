-- Object: PROCEDURE dbo.Rpt_deliveryCharges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_deliveryCharges (        
@StatusId Varchar(15),        
@StatusName Varchar(25),        
@fromDate Varchar(11),         
@toDate Varchar(11),         
@SlipType Varchar(2),        
@Branch Varchar(10) )        
As        
if @Branch = 'All' OR LEN(@BRANCH) = 0 
 Select @Branch = '%'        
        
select sett_type, sett_no,details =(case when trtype = 907  then isett_no + '-' + ISett_Type  when trtype in (904,905) Then (Case When dpid Like 'IN%' Then dpid + cltdpid  Else cltdpid End) Else '' end),      
dp.Party_Code, scrip_cd, TransDate = Convert(Varchar,TransDate,103), charge_scope, charge_type,         
Qty, scrip_closing_rate, Depos_fixed_charges, Flat_charge, min_charge, percentage_charge, totalcharges,         
InternalSlipType = (Case When InternalSlipType = 'IS' Then 'Inter Settlement'         
              When InternalSlipType = 'PO' Then 'Pay Out'         
              When InternalSlipType = 'BP' Then 'Bene to Pool'         
              When InternalSlipType = 'PB' Then 'Pool to Bene'         
              When InternalSlipType = 'OM' Then 'Off Market'         
              Else 'NONE'        
          End ),
Service_Tax        
from DeliveryDPChargesFinalAmount dp,client1 c1,client2 c2         
where c1.cl_code = c2.cl_code and c2.party_code = dp.party_code         
and dp.transdate >= @FromDate And dp.transdate <= @ToDate         
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @statusname else '%' End)        
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @statusname else '%' End)        
And C1.Trader Like (Case When @StatusId = 'trader' then @statusname else '%' End)        
And C1.Family Like (Case When @StatusId = 'family' then @statusname else '%' End)        
And C2.Party_Code Like (Case When @StatusId = 'client' then @statusname else '%' End)        
And C1.Branch_Cd Like @Branch        
And InternalSlipType Like @SlipType        
order by dp.party_code,InternalSlipType,Year(TransDate),Month(TransDate),Day(TransDate),Sett_No, Sett_Type

GO
