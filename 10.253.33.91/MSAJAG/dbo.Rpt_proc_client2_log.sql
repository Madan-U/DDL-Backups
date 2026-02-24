-- Object: PROCEDURE dbo.Rpt_proc_client2_log
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_proc_client2_log    Script Date: 01/15/2005 1:44:14 Pm ******/  
  
/*proc To Writew Log Of Activities In The Client2/client5 Table*/  
/*called From The Add/edit Client Asp Page*/  
/*written By Shyam.*/  
  
Create   Procedure  
  
Rpt_proc_client2_log  
  
@cl_code Varchar (10),  
@party_code Varchar (10),  
  
@script_name Varchar (500),  
@session_id Varchar (30),  
@local_addr Varchar (20),  
@remote_addr Varchar (20),  
@remote_host Varchar (50),  
--@request_method Varchar (20),  
--@content_type Varchar (50),  
--@content_length Int,  
@status_name Varchar (50),  
@user_name Varchar (100),  
--@module Varchar (50),  
@action Varchar (100)  
  
As  
  
Insert Into  
 Client2_log  
  Select  
   C2.cl_code,   
   C2.exchange,   
   C2.tran_cat,   
   C2.scrip_cat,   
   C2.party_code,   
   C2.table_no,   
   C2.sub_tableno,   
   C2.margin,   
   C2.turnover_tax,   
   C2.sebi_turn_tax,   
   C2.insurance_chrg,   
   C2.service_chrg,   
   C2.std_rate,   
   C2.p_to_p,   
   C2.exposure_lim,   
   C2.demat_tableno,   
   C2.bankid,   
   C2.cltdpno,   
   C2.printf,   
   C2.albmdelchrg,   
   C2.albmdelivery,   
   C2.albmcf_tableno,   
   C2.mf_tableno,   
   C2.sb_tableno,   
   C2.brok1_tableno,   
   C2.brok2_tableno,   
   C2.brok3_tableno,   
   C2.brokernote,   
   C2.other_chrg,   
   C2.brok_scheme,   
   C2.contcharge,   
   C2.mincontamt,   
   C2.addledgerbal,   
   C2.dummy1,   
   C2.dummy2,   
   C2.inscont,   
   C2.sertaxmethod,   
   C2.dummy6,   
   C2.dummy7,   
   C2.dummy8,   
   C2.dummy9,   
   C2.dummy10,   
   C5.activefrom,   
   C5.inactivefrom,   
   Dpf.debitflag,   
   Dpf.interflag,   
   @script_name,   
   @session_id,   
   @local_addr,   
   @remote_addr,   
   @remote_host,   
--   @request_method,   
--   @content_type,   
--   @content_length,   
   @status_name,   
   @user_name,   
--   Getdate(),   
   Left(convert(varchar, Getdate(), 109), 50),   
--   @module,   
   @action   
  From  
   Client2 C2, Client5 C5, Delpartyflag Dpf  
  Where  
   C2.cl_code = C5.cl_code And  
   C2.cl_code = Dpf.party_code And  
   C2.cl_code = @cl_code And   
   C2.party_code = @party_code

GO
