-- Object: PROCEDURE dbo.Rpt_ftpartydetails_UK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure Rpt_ftpartydetails_UK       
      
@partycode As Varchar(20)      
As       
set transaction isolation level read uncommitted  
Select Cl2.cl_code,      
 Cl2.party_code,      
 Cl2.dummy1,        
 T.turnover_tax/* =  (case When Cl2.turnover_tax=0 Then 'n' When Cl2.turnover_tax=1 Then 'y' End)  */,      
 Sebi_turn_tax = T.sebiturn_tax /* =  (case When Cl2.sebi_turn_tax=0 Then 'n' When Cl2.sebi_turn_tax=1 Then 'y' End)  */,      
 Service_chrg = (case When Cl2.service_chrg=0 Then 'exclusive'      
    When Cl2.service_chrg=1 Then 'incl In Brok'        
    When Cl2.service_chrg=2 Then 'inclusive'      
 End),        
 T.insurance_chrg/* = (case When Cl2.insurance_chrg=0 Then 'n' When Cl2.insurance_chrg =1 Then 'y' End)  */,      
 T.other_chrg/* =(case When Cl2.other_chrg=0 Then 'n' When Cl2.other_chrg=1 Then 'y' End)*/,      
 Cl2.table_no,      
 /*cbs.table_no,*/      
 Cl2.sub_tableno,      
 /*sub_tableno = Cbs.table_no *//*?????????????*/      
 Cl2.demat_tableno,      
 Cl2.p_to_p,      
 Cl2.std_rate,      
 Cl2.demat_tableno,      
 Cl2.albmdelchrg,       
 Cl2.albmdelivery,      
 Cl2.albmcf_tableno,      
 Cl2.mf_tableno,      
 Cl2.sb_tableno,       
 Cl2.brok1_tableno,      
 Cl2.brok2_tableno,      
 Brok3_table_no= (case When Cl2.brok3_tableno=0 Then 'treat As Brokerage'when Cl2.brok3_tableno=1 Then 'treat As Charges' Else 'not Selected' End),      
 Dummy1= (case When Cl2.dummy1=0 Then 'premium' When Cl2.dummy1=1 Then 'strike' When Cl2.dummy1=2 Then 'strike + Premium' Else 'not Selected' End),      
 Cl2.dummy2,      
 Brokernote = T.broker_note /*= (case When Cl2.brokernote=0 Then 'n' When Cl2.brokernote=1 Then 'y' End)  */,      
 Brok_scheme = (case When Cl2.brok_scheme=0 Then 'default'        
  When Cl2.brok_scheme=1 Then 'max Logic (f/s) - Buy Side'        
  When Cl2.brok_scheme=2 Then 'max Rate'      
  When Cl2.brok_scheme=3 Then 'max Logic (f/s) - Sell Side'        
  When Cl2.brok_scheme=4 Then 'flat Brokerage Default'        
  When Cl2.brok_scheme=5 Then 'flat Brokerage (max Logic) - Buy Side'        
  When Cl2.brok_scheme=6 Then 'flat Brokerage (max Logic) - Sell Side'        
 End),        
 Brok3_table_no= (case When Cl2.brok3_tableno=0 Then 'treat As Brokerage' When Cl2.brok3_tableno=1 Then 'treat As Charges' Else 'not Selected' End),        
 Dummy1= (case When Cl2.dummy1=0 Then 'premium' When Cl2.dummy1=1 Then 'strike' When Cl2.dummy1=2 Then 'strike + Premium' Else 'not Selected' End),      
 Cl2.dummy2,        
 Cl1.long_name,cl1.l_address1,cl1.l_address2, Cl1.l_address3,       
 Cl1.l_city,cl1.l_state,cl1.l_nation,cl1.l_zip,cl1.fax,cl1.res_phone1, Res_phone2, Off_phone1, Off_phone2, Cl1.email,        
 Cl1.branch_cd,cl1.cl_type,cl1.cl_status,cl1.family,cl1.sub_broker,cl1.mobile_pager,cl1.pan_gir_no,cl1.trader,        
 S1.name,b1.branch,      
 Conttype= (case When Cl2.inscont='s' Then 'scripwise' When Cl2.inscont='o' Then 'orderwise' When Cl2.inscont='n' Then 'normal' Else 'not Available' End),      
 Participant = (case When Cl1.cl_type='ins' Then Cl2.bankid Else  '' End),      
 Custodian = (case When Cl1.cl_type='ins' Then Cl2.cltdpno Else '' End),      
 Printf = (case When Cl2.printf=0 Then 'print' Else 'dont Print' End),      
 Contprt = (case When Cl2.printf =0 Then 'detail Bill And Contract'      
  When Cl2.printf =1 Then 'dont Print Bill And Contract'        
  When Cl2.printf =2 Then 'summarised Contract And Detail Bill'        
  When Cl2.printf =3 Then 'summarised Bill And Detail Contract'        
  When Cl2.printf =4 Then 'both Summarised'        
 End),      
 Convert(varchar(11),c5.activefrom) As Activefrom,        
 Inactivefrom = (case When Convert(varchar(11),c5.inactivefrom) ='jan  1 1900' Then 'n.a.' Else Convert(varchar(11),c5.inactivefrom) End),      
 /*convert(varchar(11),c5.inactivefrom)   As Inactivefrom,*/      
 C5.introducer,      
 C5.approver,      
 Scheme_type=cl1.cl_type,      
 Trade_type = 'nrm' ,  
s1.phone1,  
 s1.phone2    
 From      
  Client2 Cl2 (nolock), Client1 Cl1 Left Outer Join Client5 C5  (nolock) On ( C5.cl_code = Cl1.cl_code ) ,      
  Subbrokers S1 (nolock),branch B1 (nolock), Taxes T     (nolock)  
  Where Cl1.cl_code = Cl2.cl_code      
  And Cl2.tran_cat = T.trans_cat      
  And S1.sub_broker = Cl1.sub_broker        
  And Cl2.party_code =@partycode      
  And B1.branch_code = Cl1.branch_cd      
  And C5.InActiveFrom > getdate()

GO
