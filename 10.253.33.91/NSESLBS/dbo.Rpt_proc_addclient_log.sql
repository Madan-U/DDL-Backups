-- Object: PROCEDURE dbo.Rpt_proc_addclient_log
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_proc_addclient_log    Script Date: 01/15/2005 1:44:06 Pm ******/  
  
Create  Procedure Rpt_proc_addclient_log  
  
 @partycode Varchar(10),  
 @viewtype Varchar(20),  
 @datefrom Datetime,  
 @dateto Datetime  
  
As  
  
 Print @datefrom  
 Print @dateto  
  
 Declare @reccount Int  
  
-- Set @viewtype = 'most_recent_change'  
-- Set @partycode = 'test10'  
-- Set @partycode = 'test18'  
  
 If Upper(ltrim(rtrim(@viewtype))) = 'most_recent_change'  
  Begin  /*if Upper(ltrim(rtrim(@viewtype))) = 'most_recent_change'*/  
   Select @reccount = Count(party_code) From Client2_log Where Party_code = @partycode  
   Print @reccount  
   
   If @reccount > 1  
    Begin  /*if @reccount > 1*/  
     Select  
      Top 2  
       Tran_cat As Transaction_category,   
       Scrip_cat As Auction,   
       Party_code As Party_code,   
       Table_no As Trading_table_no,   
       Sub_tableno As Del_table_no,   
       Margin As Margin,   
       Turnover_tax As Transaction_charges_flag,   
       Sebi_turn_tax As Sebi_fees_flag,   
       Insurance_chrg As Insurance_charges_flag,   
       Service_chrg As Service_tax_flag,   
       Std_rate As Futurebrokerage,   
       /*p_to_p As 0 ,*/  
       /*exposure_lim As 0 ,*/  
       Demat_tableno As Demat_table_no,   
       Bankid As Participant_code,   
       Cltdpno As Custodian_code,   
       Printf As Print_option,   
       /*albmdelchrg As 0 ,*/  
       Albmdelivery As Option_carry_forward,   
       /*albmcf_tableno As 0 ,*/  
       Mf_tableno As Future_carry_forward,   
       /*sb_tableno As 0 ,*/  
       Brok1_tableno As Future_final_day_brokerage,   
       Brok2_tableno As Option_brokerage,   
       Brok3_tableno As Carry_forward_flag,   
       Brokernote As Stamp_duty_flag,   
       Other_chrg As Other_charges_flag,   
       Brok_scheme As Brok_scheme,   
       Contcharge As Cont_charge_flag,   
       Mincontamt As Min_cont_amt,   
       /*addledgerbal As 0 ,*/  
       Dummy1 As Brokerage_applicable,   
       Dummy2 As Option_excercise,   
       Inscont As Inst_contract,   
       Sertaxmethod As Service_tax_method,   
       Dummy6 As Clearing,   
       Dummy7 As Reporting_style,   
       Dummy8 As Sbu,   
       Dummy9 As Relmgr,   
       Dummy10 As Group_code,   
       Convert(varchar, Activefrom, 109) As Active_from,   
       Convert(varchar, Inactivefrom, 109) As Inactive_from,   
       Debitbalflag As Debitbal_flag,   
       Intersettflag As Intersett_flag,   
       Logfld_statusname As Logfld_statusname,  
       Logfld_username As Logfld_username,   
       Logfld_when_109,   
       Logfld_action  
     From  
      Client2_log  
     Where  
      Party_code = @partycode  
     Order By  
      Logfld_when_109 Desc  
    End /*if @reccount > 1*/  
   
   Else /*if @reccount > 1*/  
   
    Begin  /*else Of  If @reccount > 1*/  
     Select  
      Top 1  
       Tran_cat As Transaction_category,   
       Scrip_cat As Auction,   
       Party_code As Party_code,   
       Table_no As Trading_table_no,   
       Sub_tableno As Del_table_no,   
       Margin As Margin,   
       Turnover_tax As Transaction_charges_flag,   
       Sebi_turn_tax As Sebi_fees_flag,   
       Insurance_chrg As Insurance_charges_flag,   
       Service_chrg As Service_tax_flag,   
       Std_rate As Futurebrokerage,   
       /*p_to_p As 0 ,*/  
       /*exposure_lim As 0 ,*/  
       Demat_tableno As Demat_table_no,   
       Bankid As Participant_code,   
       Cltdpno As Custodian_code,   
       Printf As Print_option,   
       /*albmdelchrg As 0 ,*/  
       Albmdelivery As Option_carry_forward,   
       /*albmcf_tableno As 0 ,*/  
       Mf_tableno As Future_carry_forward,   
       /*sb_tableno As 0 ,*/  
       Brok1_tableno As Future_final_day_brokerage,   
       Brok2_tableno As Option_brokerage,   
       Brok3_tableno As Carry_forward_flag,   
       Brokernote As Stamp_duty_flag,   
       Other_chrg As Other_charges_flag,   
       Brok_scheme As Brok_scheme,   
       Contcharge As Cont_charge_flag,   
       Mincontamt As Min_cont_amt,   
       /*addledgerbal As 0 ,*/  
       Dummy1 As Brokerage_applicable,   
       Dummy2 As Option_excercise,   
       Inscont As Inst_contract,   
       Sertaxmethod As Service_tax_method,   
       Dummy6 As Clearing,   
       Dummy7 As Reporting_style,   
       Dummy8 As Sbu,   
       Dummy9 As Relmgr,   
       Dummy10 As Group_code,   
       Convert(varchar, Activefrom, 109) As Active_from,   
       Convert(varchar, Inactivefrom, 109) As Inactive_from,   
       Debitbalflag As Debitbal_flag,   
       Intersettflag As Intersett_flag,   
       Logfld_statusname As Logfld_statusname,  
       Logfld_username As Logfld_username,   
       Logfld_when_109,   
       Logfld_action   
     From  
      Client2_log  
     Where  
      Party_code = @partycode  
     Order By  
      Logfld_when_109 Desc  
    End  /*else Of  If @reccount > 1*/  
  End  /*if Upper(ltrim(rtrim(@viewtype))) = 'most_recent_change'*/  
  
 If Upper(ltrim(rtrim(@viewtype))) = 'for_a_date'  
  Begin  /*if Upper(ltrim(rtrim(@viewtype))) = 'for_a_date'*/  
   Select  
    Tran_cat As Transaction_category,   
    Scrip_cat As Auction,   
    Party_code As Party_code,   
    Table_no As Trading_table_no,   
    Sub_tableno As Del_table_no,   
    Margin As Margin,   
    Turnover_tax As Transaction_charges_flag,   
    Sebi_turn_tax As Sebi_fees_flag,   
    Insurance_chrg As Insurance_charges_flag,   
    Service_chrg As Service_tax_flag,   
    Std_rate As Futurebrokerage,   
    /*p_to_p As 0 ,*/  
    /*exposure_lim As 0 ,*/  
    Demat_tableno As Demat_table_no,   
    Bankid As Participant_code,   
    Cltdpno As Custodian_code,   
    Printf As Print_option,   
    /*albmdelchrg As 0 ,*/  
    Albmdelivery As Option_carry_forward,   
    /*albmcf_tableno As 0 ,*/  
    Mf_tableno As Future_carry_forward,   
    /*sb_tableno As 0 ,*/  
    Brok1_tableno As Future_final_day_brokerage,   
    Brok2_tableno As Option_brokerage,   
    Brok3_tableno As Carry_forward_flag,   
    Brokernote As Stamp_duty_flag,   
    Other_chrg As Other_charges_flag,   
    Brok_scheme As Brok_scheme,   
    Contcharge As Cont_charge_flag,   
    Mincontamt As Min_cont_amt,   
    /*addledgerbal As 0 ,*/  
    Dummy1 As Brokerage_applicable,   
    Dummy2 As Option_excercise,   
    Inscont As Inst_contract,   
    Sertaxmethod As Service_tax_method,   
    Dummy6 As Clearing,   
    Dummy7 As Reporting_style,   
    Dummy8 As Sbu,   
    Dummy9 As Relmgr,   
    Dummy10 As Group_code,   
    Convert(varchar, Activefrom, 109) As Active_from,   
    Convert(varchar, Inactivefrom, 109) As Inactive_from,   
    Debitbalflag As Debitbal_flag,   
    Intersettflag As Intersett_flag,   
    Logfld_statusname As Logfld_statusname,  
    Logfld_username As Logfld_username,   
    Logfld_when_109,   
    Logfld_action   
   From  
    Client2_log  
   Where  
    Party_code = @partycode  And  
    Logfld_when_109 Like Left(convert(varchar, @datefrom, 109), 11) + '%'  
   Order By  
    Logfld_when_109 Desc  
  End  /*if Upper(ltrim(rtrim(@viewtype))) = 'for_a_date'*/  
  
 If Upper(ltrim(rtrim(@viewtype))) = 'for_a_period'  
  Begin  /*if Upper(ltrim(rtrim(@viewtype))) = 'for_a_period'*/  
   Select  
    Tran_cat As Transaction_category,   
    Scrip_cat As Auction,   
    Party_code As Party_code,   
    Table_no As Trading_table_no,   
    Sub_tableno As Del_table_no,   
    Margin As Margin,   
    Turnover_tax As Transaction_charges_flag,   
    Sebi_turn_tax As Sebi_fees_flag,   
    Insurance_chrg As Insurance_charges_flag,   
    Service_chrg As Service_tax_flag,   
    Std_rate As Futurebrokerage,   
    /*p_to_p As 0 ,*/  
    /*exposure_lim As 0 ,*/  
    Demat_tableno As Demat_table_no,   
    Bankid As Participant_code,   
    Cltdpno As Custodian_code,   
    Printf As Print_option,   
    /*albmdelchrg As 0 ,*/  
    Albmdelivery As Option_carry_forward,   
    /*albmcf_tableno As 0 ,*/  
    Mf_tableno As Future_carry_forward,   
    /*sb_tableno As 0 ,*/  
    Brok1_tableno As Future_final_day_brokerage,   
    Brok2_tableno As Option_brokerage,   
    Brok3_tableno As Carry_forward_flag,   
    Brokernote As Stamp_duty_flag,   
    Other_chrg As Other_charges_flag,   
    Brok_scheme As Brok_scheme,   
    Contcharge As Cont_charge_flag,   
    Mincontamt As Min_cont_amt,   
    /*addledgerbal As 0 ,*/  
    Dummy1 As Brokerage_applicable,   
    Dummy2 As Option_excercise,   
    Inscont As Inst_contract,   
    Sertaxmethod As Service_tax_method,   
    Dummy6 As Clearing,   
    Dummy7 As Reporting_style,   
    Dummy8 As Sbu,   
    Dummy9 As Relmgr,   
    Dummy10 As Group_code,   
    Convert(varchar, Activefrom, 109) As Active_from,   
    Convert(varchar, Inactivefrom, 109) As Inactive_from,   
    Debitbalflag As Debitbal_flag,   
    Intersettflag As Intersett_flag,   
    Logfld_statusname As Logfld_statusname,  
    Logfld_username As Logfld_username,   
    Logfld_when_109,   
    Logfld_action   
   From  
    Client2_log  
   Where  
    Party_code = @partycode  And  
    Logfld_when_109 >= @datefrom And  
    Logfld_when_109 <= @dateto + ' 23:59:59'  
   Order By  
    Logfld_when_109 Desc  
  End  /*if Upper(ltrim(rtrim(@viewtype))) = 'for_a_period'*/

GO
