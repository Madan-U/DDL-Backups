-- Object: PROCEDURE dbo.rpt_FTpartydetails_bkp04062013
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure rpt_FTpartydetails_bkp04062013       
      
@partycode as varchar(20)      
          
as       
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
select cl2.cl_code,cl2.party_code,cl2.dummy1,        
turnover_tax =  (case when cl2.Turnover_tax=0 then 'N'        
   when cl2.Turnover_tax=1 then 'Y'        
  end),        
sebi_turn_tax =  (case when cl2.sebi_turn_tax=0 then 'N'        
   when cl2.sebi_turn_tax=1 then 'Y'        
  end),        
Service_chrg = (case when cl2.service_chrg=0 then 'Exclusive'        
   when cl2.service_chrg=1 then 'Incl in Brok'        
   when cl2.service_chrg=2 then 'Inclusive'        
  end),        
Insurance_Chrg = (case when cl2.Insurance_Chrg=0 then 'N'        
   when cl2.Insurance_Chrg =1 then 'Y'        
  end),        
Other_chrg =(case when cl2.Other_chrg=0 then 'N'        
   when cl2.Other_chrg=1 then 'Y'        
  end),        
cl2.table_no,cl2.sub_tableno,cl2.demat_tableno,cl2.p_to_p      
,cl2.Std_rate,cl2.demat_tableno,cl2.ALBMDelchrg,cl2.ALBMDelivery,cl2.AlbmCF_tableno,cl2.MF_tableno,cl2.SB_tableno,       
cl2.brok1_tableno,cl2.brok2_tableno,      
brok3_table_no= (case when cl2.brok3_tableno=0 then 'Treat as Brokerage'      
when cl2.brok3_tableno=1 then 'Treat as Charges' else 'Not Selected' end),      
dummy1= (case when cl2.dummy1=0 then 'Premium' when cl2.dummy1=1 then 'Strike'      
 when cl2.dummy1=2 then 'Strike + Premium'       
else   'Not Selected' end), cl2.Dummy2 ,      
      
brokernote= (case when cl2.brokernote=0 then 'N'        
   when cl2.brokernote=1 then 'Y'        
  end),        
brok_scheme = (case when cl2.brok_scheme=0 then 'Default'        
   when cl2.brok_scheme=1 then 'Max Logic (F/S) - Buy Side'        
   when cl2.brok_scheme=2 then 'Max Rate'      
   when cl2.brok_scheme=3 then 'Max Logic (F/S) - Sell Side'        
   when cl2.brok_scheme=4 then 'Flat Brokerage Default'        
   when cl2.brok_scheme=5 then 'Flat Brokerage (Max Logic) - Buy Side'        
   when cl2.brok_scheme=6 then 'Flat Brokerage (Max Logic) - Sell Side'        
  end),        
brok3_table_no= (case when cl2.brok3_tableno=0 then 'Treat as Brokerage'        
   when cl2.brok3_tableno=1 then 'Treat as Charges'        
  else        
   'Not Selected'        
  end),        
dummy1= (case when cl2.dummy1=0 then 'Premium'        
   when cl2.dummy1=1 then 'Strike'        
   when cl2.dummy1=2 then 'Strike + Premium'        
  else        
   'Not Selected'        
  end),        
cl2.Dummy2,        
cl1.long_name,cl1.l_address1,cl1.l_address2, cl1.l_address3,       
cl1.L_city,cl1.L_State,cl1.L_Nation,cl1.L_Zip,cl1.Fax,cl1.Res_Phone1, Res_Phone2, Off_Phone1, Off_Phone2, cl1.Email,        
cl1.Branch_cd,cl1.Cl_type,cl1.Cl_Status,cl1.Family,cl1.Sub_Broker,cl1.Mobile_Pager,cl1.pan_gir_no,cl1.trader,        
s1.name,b1.branch  ,      
conttype= (case when cl2.InsCont='S' then 'Scripwise'        
   when cl2.InsCont='O' then 'Orderwise'        
   when cl2.InsCont='N' then 'Normal'        
  else        
   'Not available'        
  end),      
participant = (case when cl1.Cl_type='INS' then cl2.BankId      
   else  ''       
                            end) ,       
      
custodian = (case when cl1.Cl_type='INS' then CL2.CLTDPNO      
   else  ''       
                            end) ,       
      
Printf = (case when cl2.Printf=0 then 'Print'        
   else        
                'Dont Print'        
              end) ,      
      
contprt = (case when cl2.Printf =0 then 'Detail Bill And Contract'        
   when cl2.Printf =1 then 'Dont Print Bill And Contract'        
   when cl2.Printf =2 then 'Summarised Contract and Detail Bill'        
   when cl2.Printf =3 then 'Summarised Bill and Detail Contract'        
   when cl2.Printf =4 then 'Both Summarised'        
  end) ,      
convert(varchar(11),c5.ActiveFrom) as ActiveFrom ,        
InactiveFrom = (case when convert(varchar(11),c5.InactiveFrom) ='Jan  1 1900' then 'N.A.'        
   else        
               convert(varchar(11),c5.InactiveFrom)      
              end),      
/*convert(varchar(11),c5.InactiveFrom)   as InactiveFrom,*/      
C5.Introducer,C5.Approver ,       
isnull(c5.Passportdtl,'') as Passportdtl, isnull(c5.PassportDateOfIssue,'') as PassportDateOfIssue,  isnull(c5.PassportPlaceOfIssue,'') as PassportPlaceOfIssue,  isnull(c5.PASSPORTEXPDATE,'') as PASSPORTEXPDATE,      
isnull(c5.Drivelicendtl,'') as Drivelicendtl, isnull(c5.LicenceNoDateOfIssue,'') as LicenceNoDateOfIssue, isnull(c5.LicenceNoPlaceOfIssue,'') as LicenceNoPlaceOfIssue, isnull(c5.DRIVEEXPDATE,'') as DRIVEEXPDATE,      
isnull(c5.Rationcarddtl,'') as Rationcarddtl, isnull(c5.RationCardDateOfIssue,'') as RationCardDateOfIssue, isnull(c5.RationCardPlaceOfIssue,'') as RationCardPlaceOfIssue,      
isnull(c5.VotersIDdtl,'') as VotersIDdtl, isnull(c5.VoterIdDateOfIssue,'') as VoterIdDateOfIssue, isnull(c5.VoterIdPlaceOfIssue,'') as VoterIdPlaceOfIssue,  
PayLocation = cl1.Gl_code      
      
from client2 cl2, client1 cl1 Left Outer Join Client5 C5 On ( C5.Cl_Code = cl1.Cl_Code ) ,      
subbrokers s1,branch b1      
where cl1.cl_code = cl2.cl_code        
and s1.sub_broker = cl1.sub_broker        
and cl2.party_code =@partycode      
and b1.branch_code = cl1.branch_cd

GO
