-- Object: PROCEDURE dbo.Rms_newproc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc Rms_newproc (@rmsdate Varchar(11), @fromparty Varchar(10), @toparty Varchar(10), @haircut Numeric(18,4), @optflag Int )      
As      
      
 Set @optflag = 1      
 Set Nocount On       
      
/*select @fromparty=min(party_code), @toparty=max(party_code) From Clientmaster*/      
      
Exec Rpt_grossexposurenew @fromparty,@toparty,@rmsdate,@rmsdate,'n','%','%'      
      
Exec Rpt_grossexposurenew @fromparty,@toparty,@rmsdate,@rmsdate,'w','%','%'      
      
Exec Bsedb.dbo.rpt_grossexposurenew @fromparty,@toparty,@rmsdate,@rmsdate,'d','%','%'      
      
Exec Bsedb.dbo.rpt_grossexposurenew @fromparty,@toparty,@rmsdate,@rmsdate,'c','%','%'      
      
 Exec Rms_newdebitstock @rmsdate,@fromparty,@toparty      
      
 Truncate Table Rmsallsegment_tmp      
      
 Insert Into Rmsallsegment_tmp       
 Select @rmsdate,branch_cd,'','',family,'',party_code,long_name,'nse',      
           0,0,0,0,0,0,0,isnull(credit_limit,0),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,@haircut,0,0,0,0,0,0,0,0,0,0,0,0,'all',0,area, Region      
 From Client1 C1 With(index(pk_client1),nolock), Client2 C2      
 Where Party_code Between @fromparty And @toparty      
 And C1.cl_code = C2.cl_code      
 Order By Party_code      
      
 Update Rmsallsegment_tmp       
 Set Category = Categoryname, Categorycode = Categoryid       
 From Rmsallsegment_tmp With(index(partycode),nolock), Account.dbo.acccategory M, Account.dbo.accountscategory C With(index(cat_clt),nolock)      
 Where C.category = M.categoryid       
 And C.cltcode = Party_code       
       
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-insert Clients In Rmsallsegment_temp','update Nse Ledger Balance',@rmsdate,getdate())        
      
 Update Rmsallsegment_tmp       
 Set Nb_ledger_voc_bal        = A.nb_ledger_voc_bal,      
      Nb_led_bill_bal               = A.nb_led_bill_bal_vdt + A.nb_led_bill_bal_edt,       
      Nb_ledger_eff_bal          = A.nb_ledger_eff_bal_vdt + A.nb_ledger_eff_bal_edt       
 From       
 (      
 Select L.cltcode,      
 Nb_ledger_voc_bal        =sum(case When L.drcr = 'd' Then -vamt Else Vamt End),      
 Nb_led_bill_bal_vdt       =sum(case When Vtyp Not In (15,21)       
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End),       
 Nb_led_bill_bal_edt       =sum(case When Vtyp In (15,21) And Edt <= @rmsdate + ' 23:59:59'      
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End),       
 Nb_ledger_eff_bal_vdt  =sum(case When Vtyp <> '2'      
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End),      
 Nb_ledger_eff_bal_edt  =sum(case When Vtyp = '2' And Edt <= @rmsdate + ' 23:59:59'      
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                  Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End)      
 From Account.dbo.ledger L With(index(partyvdt),nolock), Account.dbo.parameter, Account.dbo.acmast A With(index(accat),nolock)      
 Where Vdt <= @rmsdate + ' 23:59:59'      
 And Vdt >= Sdtcur       
 And Vdt <= Ldtcur       
 And Curyear = 1       
 And A.cltcode = L.cltcode       
 And A.accat <> 3      
 Group By L.cltcode       
 ) A       
 Where A.cltcode = Rmsallsegment_tmp.party_code      
 And Sauda_date Like @rmsdate + '%'       
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-update Nse Ledger Balance','update Bse Ledger Balance',@rmsdate,getdate())        
       
 Update Rmsallsegment_tmp       
 Set Nb_ledger_voc_bal = Rmsallsegment_tmp.nb_ledger_voc_bal + A.nb_ledger_voc_bal,      
      Nb_led_bill_bal        = Rmsallsegment_tmp.nb_led_bill_bal       + A.nb_led_bill_bal_vdt + A.nb_led_bill_bal_edt,       
      Nb_ledger_eff_bal   = Rmsallsegment_tmp.nb_ledger_eff_bal   + A.nb_ledger_eff_bal_vdt + A.nb_ledger_eff_bal_edt       
 From       
 (      
 Select L.cltcode,      
 Nb_ledger_voc_bal        =sum(case When L.drcr = 'd' Then -vamt Else Vamt End),      
 Nb_led_bill_bal_vdt       =sum(case When Vtyp Not In (15,21)       
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End),       
 Nb_led_bill_bal_edt       =sum(case When Vtyp In (15,21) And Edt <= @rmsdate + ' 23:59:59'      
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End),       
 Nb_ledger_eff_bal_vdt  =sum(case When Vtyp <> '2'      
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End),      
 Nb_ledger_eff_bal_edt  =sum(case When Vtyp = '2' And Edt <= @rmsdate + ' 23:59:59'      
                                                     Then (case When L.drcr = 'd'       
                                                                       Then -vamt       
                                                                       Else Vamt       
                                                              End)       
                                                     Else 0       
                                            End)      
 From Accountbse.dbo.ledger L With(index(partyvdt),nolock), Accountbse.dbo.parameter, Accountbse.dbo.acmast A With(index(accat),nolock)      
 Where Vdt <= @rmsdate + ' 23:59:59'      
 And Vdt >= Sdtcur       
 And Vdt <= Ldtcur       
 And Curyear = 1       
 And A.cltcode = L.cltcode       
 And A.accat <> 3      
 Group By L.cltcode       
 ) A       
 Where A.cltcode = Rmsallsegment_tmp.party_code      
 And Sauda_date Like @rmsdate + '%'       
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
      
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-update Bse Ledger Balance','update Nse Capital Segment Collateral',@rmsdate,getdate())        
      
 Update Rmsallsegment_tmp       
 Set Tot_collateral_nb = Effectivecoll,cash_deposit=actualcash,non_cash=actualnoncash       
 From Collateral With(index(partycode),nolock)      
 Where Trans_date Like @rmsdate + '%'       
 And Collateral.party_code = Rmsallsegment_tmp.party_code      
 And Collateral.segment = 'capital'       
 And Exchange = 'nse'      
 And Sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-update Nse Capital Segment Collateral','update Bse Capital Segment Collateral',@rmsdate,getdate())        
      
 Update Rmsallsegment_tmp       
 Set          Tot_collateral_nb =     Tot_collateral_nb + Effectivecoll,      
                Cash_deposit         =     Cash_deposit + Actualcash,       
                Non_cash                =     Non_cash + Actualnoncash       
 From Collateral With(index(partycode),nolock)      
 Where Trans_date Like @rmsdate + '%'       
 And Collateral.party_code = Rmsallsegment_tmp.party_code      
 And Collateral.segment = 'capital'       
 And Exchange = 'bse'      
 And Sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-update Bse Capital Segment Collateral','5 Update Queries Rmsallsegment_temp From Rms_newdebitstockview',@rmsdate,getdate())        
      
 /* Required To Put It In Flag - Optional */      
 If @optflag = 1       
                   Begin       
                         
                   Update Rmsallsegment_tmp Set N_prev_ge = Isnull(( Select Sum(prate+srate) From Cmbillvalan C      
                   Where C.sauda_date Like (select Left(convert(varchar,max(sauda_date),109),11)+'%' From Cmbillvalan      
                               Where Sauda_date < @rmsdate      
                            And Party_code = C.party_code)      
                                          And C.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'       
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_turnover = Totturn, N_trdturnover = Trdturn, N_delturnover = Delturn      
                   From ( Select C.party_code,totturn=isnull(sum(trdamt),0), Trdturn=isnull(sum(trdamt-delamt),0),       
                          Delturn=isnull(sum(delamt),0)       
                          From Cmbillvalan C Where C.sauda_date Like @rmsdate + '%'       
                          Group By Party_code ) A      
                   Where Sauda_date Like @rmsdate + '%' And A.party_code = Rmsallsegment_tmp.party_code      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_turnover = Totturn, B_trdturnover = Trdturn, B_delturnover = Delturn      
                   From ( Select C.party_code,totturn=isnull(sum(trdamt),0), Trdturn=isnull(sum(trdamt-delamt),0),       
                          Delturn=isnull(sum(delamt),0)       
                          From Bsedb.dbo.cmbillvalan C Where C.sauda_date Like @rmsdate + '%'       
                          Group By Party_code ) A      
                   Where Sauda_date Like @rmsdate + '%' And A.party_code = Rmsallsegment_tmp.party_code      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_prev_ge = Isnull(( Select Sum(prate+srate) From Bsedb.dbo.cmbillvalan C      
                   Where C.sauda_date Like (select Left(convert(varchar,max(sauda_date),109),11)+'%' From Bsedb.dbo.cmbillvalan      
                                 Where Sauda_date < @rmsdate      
                And Party_code = C.party_code )      
                                            And C.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'       
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Truncate Table Rmsmtom      
                   Insert Into Rmsmtom      
                   Select S.party_code,s.scrip_cd,s.series,nse_mtm=(sum(pqtytrd+pqtydel)*isnull(max(cl_rate),0)-sum(prate))+ (sum(srate)-sum(sqtytrd+sqtydel)*isnull(max(cl_rate),0)),      
                   Nsenet=sum(prate+srate),        
                   Currge=(case When Sum(case When S.sauda_date Like @rmsdate + '%' Then Pqtytrd+pqtydel Else 0 End) >      
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Sqtytrd+sqtydel Else 0 End)       
                                Then Sum(case When S.sauda_date Like @rmsdate + '%' Then Prate Else 0 End) -       
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Srate Else 0 End) Else 0 End)      
                         +(case When Sum(case When S.sauda_date Like @rmsdate + '%' Then Sqtytrd+sqtydel Else 0 End) >      
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Pqtytrd+pqtydel Else 0 End)       
                                Then Sum(case When S.sauda_date Like @rmsdate + '%' Then Srate Else 0 End) -       
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Prate Else 0 End) Else 0 End),      
                   Nsepur=(case When Sum(pqtytrd+pqtydel) > Sum(sqtytrd+sqtydel) Then Sum(prate)-sum(srate) Else 0 End),      
                   Nsesale=(case When Sum(sqtytrd+sqtydel) > Sum(pqtytrd+pqtydel) Then Sum(srate)-sum(prate) Else 0 End),      
                   Totalge=sum(prate)-sum(srate)       
                   From Sett_mst Sm, Rmsallsegment_tmp R,cmbillvalan S Left Outer Join Closing C      
                   On ( C.scrip_cd = S.scrip_cd And C.series = S.series And       
                   C.sysdate = ( Select Max(sysdate) From Closing Where Scrip_cd = C.scrip_cd And Series = C.series And       
                   Sysdate <= @rmsdate + ' 23:59:00'))      
                   Where S.sett_no = Sm.sett_no And S.sett_type = Sm.sett_type       
                   And S.sauda_date <= @rmsdate + ' 23:59:59' And Funds_payin > @rmsdate      
                   And S.party_code = R.party_code And R.sauda_date Like @rmsdate + '%'      
                   And R.party_code >= @fromparty And R.party_code <= @toparty      
                   Group By S.party_code,s.scrip_cd,s.series       
                         
                   Update Rmsallsegment_tmp Set N_mtm = Isnull((select Sum(nse_mtm) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_mtm_loss = Isnull((select Sum(nse_mtm) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code And Nse_mtm < 0),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_purch = Isnull((select Sum(nsepur) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_sales = Isnull((select Sum(nsesale) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
 Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_net = Isnull((select Sum(nsenet) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_current_ge = Isnull((select Sum(currge) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set N_id_exposure = Isnull((select Sum(totalge)-n_prev_ge From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Truncate Table Rmsmtom      
                   Insert Into Rmsmtom      
                   Select S.party_code,s.scrip_cd,s.series,      
                   Nse_mtm=(sum(pqtytrd+pqtydel)*isnull(max(cl_rate),0)-sum(prate)) + (sum(srate)-sum(sqtytrd+sqtydel)*isnull(max(cl_rate),0)),      
                   Nsenet=sum(prate+srate),        
                   Currge=(case When Sum(case When S.sauda_date Like @rmsdate + '%' Then Pqtytrd+pqtydel Else 0 End) >      
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Sqtytrd+sqtydel Else 0 End)       
                                Then Sum(case When S.sauda_date Like @rmsdate + '%' Then Prate Else 0 End) -       
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Srate Else 0 End) Else 0 End)      
                         +(case When Sum(case When S.sauda_date Like @rmsdate + '%' Then Sqtytrd+sqtydel Else 0 End) >      
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Pqtytrd+pqtydel Else 0 End)       
                                Then Sum(case When S.sauda_date Like @rmsdate + '%' Then Srate Else 0 End) -       
                                     Sum(case When S.sauda_date Like @rmsdate + '%' Then Prate Else 0 End) Else 0 End),      
                   Nsepur=(case When Sum(pqtytrd+pqtydel) > Sum(sqtytrd+sqtydel) Then Sum(prate)-sum(srate) Else 0 End),      
                   Nsesale=(case When Sum(sqtytrd+sqtydel) > Sum(pqtytrd+pqtydel) Then Sum(srate)-sum(prate) Else 0 End),      
                   Totalge=sum(prate)-sum(srate)      
                   From Bsedb.dbo.sett_mst Sm, Rmsallsegment_tmp R, Bsedb.dbo.cmbillvalan S Left Outer Join Bsedb.dbo.closing C      
                   On ( C.scrip_cd = S.scrip_cd And C.series = S.series And       
                   C.sysdate = ( Select Max(sysdate) From Bsedb.dbo.closing Where Scrip_cd = C.scrip_cd And Series = C.series And       
                   Sysdate <= @rmsdate + ' 23:59:00'))      
                   Where S.sett_no = Sm.sett_no And S.sett_type = Sm.sett_type       
                   And S.sauda_date <= @rmsdate + ' 23:59:59' And Funds_payin > @rmsdate      
                   And S.party_code = R.party_code And R.sauda_date Like @rmsdate + '%'      
                   And Tradetype Not Like 'sbf'      
                   And R.party_code >= @fromparty And R.party_code <= @toparty      
                   Group By S.party_code,s.scrip_cd,s.series,cl_rate       
                         
                   Update Rmsallsegment_tmp Set B_mtm = Isnull((select Sum(nse_mtm) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
             And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_mtm_loss = Isnull((select Sum(nse_mtm) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code And Nse_mtm < 0),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_purch = Isnull((select Sum(nsepur) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_sales = Isnull((select Sum(nsesale) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_net = Isnull((select Sum(nsenet) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_current_ge = Isnull((select Sum(currge) From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_id_exposure = Isnull((select Sum(totalge)-b_prev_ge From Rmsmtom Where Rmsmtom.party_code = Rmsallsegment_tmp.party_code ),0)      
                   Where Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
      
                   Update Rmsallsegment_tmp Set N_avm = Margin From (      
                   Select Party_code,margin=sum(margin) From (      
                   Select Party_code,scrip_cd,margin=sum(varmargin) From Tblgrossexpnewdetail      
                   Where Rundate Like @rmsdate +'%'      
                   Group By Party_code,scrip_cd,rate) A      
                   Group By Party_code ) B Where B.party_code = Rmsallsegment_tmp.party_code      
                   And Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                         
                   Update Rmsallsegment_tmp Set B_avm = Margin From (      
                   Select Party_code,margin=sum(margin) From (      
                   Select Party_code,scrip_cd,margin=sum(varmargin) From Bsedb.dbo.tblgrossexpnewdetail      
                   Where Rundate Like @rmsdate +'%'      
                   Group By Party_code,scrip_cd,rate) A      
                   Group By Party_code ) B Where B.party_code = Rmsallsegment_tmp.party_code      
                   And Sauda_date Like @rmsdate + '%'      
                   And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
 End       
 /* Required To Put It In Flag - Optional */      
       
 Update Rmsallsegment_tmp Set       
 Nsedebitvalue = Dnsedebitvalue,      
 Bsedebitvalue = Dbsedebitvalue,      
 Poavalue      = Dpoavalue,      
 Nsepayin      = Dnsepayin,      
 Bsepayin      = Dbsepayin      
 From       
 (      
 Select Party_code,      
 Dnsedebitvalue= Isnull(sum(debitqty*cl_rate),0),      
 Dbsedebitvalue= 0,      
 Dpoavalue     = Isnull(sum(poaqty*cl_rate),0),      
 Dnsepayin     = Isnull(sum(shrtqty*cl_rate),0),      
 Dbsepayin     = 0      
 From Rms_newdebitstockview       
 Group By Party_code       
 ) A       
 ,rmsallsegment_tmp With(index(partycode),nolock)      
 Where A.party_code = Rmsallsegment_tmp.party_code      
 And Rmsallsegment_tmp.sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
 Update Rmsallsegment_tmp Set       
 Stockn = Stocknvalue,      
 Stocky = Stockyvalue      
 From       
 (      
 Select Party_code,      
 Stockyvalue= Isnull(sum(case When Pledge <> 'y' Then Debitqty*cl_rate Else 0 End),0),      
 Stocknvalue= Isnull(sum(case When Pledge = 'y' Then Debitqty*cl_rate Else 0 End),0)      
 From Rms_newdebitstockview       
 Group By Party_code       
 ) A       
 ,rmsallsegment_tmp With(index(partycode),nolock)      
 Where A.party_code = Rmsallsegment_tmp.party_code      
 And Rmsallsegment_tmp.sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
 Update Rmsallsegment_tmp Set       
 Poolnse = Poolnvalue,      
 Poolbse = Poolbvalue      
 From       
 (      
 Select Party_code,      
 Poolnvalue= Isnull(sum(case When Branch_cd = 'nse' Then Payqty*cl_rate Else 0 End),0),      
 Poolbvalue= Isnull(sum(case When Branch_cd = 'bse' Then Payqty*cl_rate Else 0 End),0)      
 From Deldebitsummary Group By Party_code       
 ) A       
 ,rmsallsegment_tmp With(index(partycode),nolock)      
 Where A.party_code = Rmsallsegment_tmp.party_code      
 And Rmsallsegment_tmp.sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
 Update Rmsallsegment_tmp Set       
 Debitvalueafterhaircut = (dnsedebitvalue + Dbsedebitvalue) - ( (dnsedebitvalue + Dbsedebitvalue) * @haircut / 100 ) ,      
 Poaafterhaircut        = Dpoavalue - ( Dpoavalue *  @haircut / 100 ) ,      
 Payinafterhaircut      = ( Dnsepayin + Dbsepayin ) + (( Dnsepayin + Dbsepayin )* @haircut / 100 )       
 From       
 (      
 Select Party_code,      
 Dnsedebitvalue= Isnull(sum(debitqty*cl_rate),0),      
 Dbsedebitvalue= 0,      
 Dpoavalue     = Isnull(sum(poaqty*cl_rate),0),      
 Dnsepayin     = Isnull(sum(shrtqty*cl_rate),0),      
 Dbsepayin     = 0      
 From Rms_newdebitstockview Group By Party_code       
 ) A       
 ,rmsallsegment_tmp With(index(partycode),nolock)      
 Where A.party_code = Rmsallsegment_tmp.party_code      
 And Rmsallsegment_tmp.sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
 Update Rmsallsegment_tmp Set Nb_total_mtm = N_mtm + B_mtm, Mtm_losses = N_mtm_loss + B_mtm_loss,       
 Avm = N_avm + B_avm, Nb_day_purch = N_purch + B_purch, Nb_day_sales = N_sales + B_sales,       
 Nb_upto_day_exp = (n_purch + B_purch + N_sales + B_sales),      
 Nb_allowed = Tot_collateral_nb + Nb_ledger_eff_bal + Debitvalueafterhaircut + Poaafterhaircut - Payinafterhaircut - N_avm - B_avm ,       
 Nb_excess_short = Tot_collateral_nb + Nb_ledger_eff_bal + Debitvalueafterhaircut + Poaafterhaircut - Payinafterhaircut - N_avm - B_avm ,      
 Nb_total_currentge = N_current_ge + B_current_ge,      
 Nb_turnover = N_turnover + B_turnover ,      
 Margamt = Nb_ledger_voc_bal + Debitvalueafterhaircut + Poaafterhaircut + Tot_collateral_nb ,       
 Margper = (case When (debitvalueafterhaircut + Poaafterhaircut) > 0       
        Then ( Nb_ledger_voc_bal + Debitvalueafterhaircut + Poaafterhaircut + Tot_collateral_nb ) * 100 / (debitvalueafterhaircut + Poaafterhaircut)       
        Else 0       
          End),       
 Netmarg = Nb_ledger_voc_bal + Debitvalueafterhaircut + Poaafterhaircut + Tot_collateral_nb - Payinafterhaircut,      
 Netmargper = (case When (debitvalueafterhaircut + Poaafterhaircut + Payinafterhaircut) > 0       
      Then (nb_ledger_voc_bal + Debitvalueafterhaircut + Poaafterhaircut + Tot_collateral_nb - Payinafterhaircut)*100/(debitvalueafterhaircut + Poaafterhaircut + Payinafterhaircut)       
             Else 0       
        End)      
 From Rmsallsegment_tmp With(index(partycode),nolock)      
 Where Sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
      
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-5 Update Queries Rmsallsegment_temp From Rms_newdebitstockview','3 Update Queries Rmsallsegment_temp From Client1 And Client5',@rmsdate,getdate())        
      
 /* Required To Put It In Flag - Optional */      
 If @optflag = 1       
 Begin       
                 Update Rmsallsegment_tmp Set Totalavgturnover = Isnull((select Sum(nb_turnover)/isnull(count(nb_turnover),1) From Rmsallsegment_tmp  R Where       
                 R.party_code = Rmsallsegment_tmp.party_code And R.sauda_date <= @rmsdate + ' 23:59:59' And R.sauda_date >= Convert(datetime, @rmsdate) - 15) ,0)      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                       
                 Truncate Table Rmspercent       
                 Insert Into Rmspercent       
                 Select C.party_code,c.sauda_date,c.scrip_cd,c.series,      
                 Currentopenpurchase = (case When Sum(pqtydel) > 0 Then Sum(prate) Else 0 End ),      
                 Currentopensell = (case When Sum(sqtydel) > 0 Then Sum(srate) Else 0 End ),      
                 Scripwisecurrentgrossexp = Sum(prate) + Sum(srate),      
                 Maxcurrentgrossexposure = 0,      
                 Percentage = 0,''      
                 From Cmbillvalan C, Sett_mst S, Rmsallsegment_tmp R Where C.sett_no = S.sett_no And C.sett_type = S.sett_type      
                 And C.sauda_date <= @rmsdate + ' 23:59:59' And Funds_payin > @rmsdate      
                 And R.sauda_date Like @rmsdate + '%' And R.party_code = C.party_code      
                 And R.party_code >= @fromparty And R.party_code <= @toparty      
                 Group By C.party_code,c.sauda_date,scrip_cd,c.series      
                 Having ( Sum(pqtydel) > 0 Or Sum(sqtydel) > 0 )      
                       
                 Update Rmspercent Set Maxcurrentgrossexposure = ( Select Max(scripwisecurrentgrossexp) From Rmspercent R Where R.party_code = Rmspercent.party_code)      
                 Update Rmspercent Set Percentage =      
                  ( Select (case When Sum(scripwisecurrentgrossexp) > 0 Then Max(scripwisecurrentgrossexp)/sum(scripwisecurrentgrossexp) Else 0 End ) From Rmspercent R Where R.sauda_date = Rmspercent.sauda_date And R.party_code = Rmspercent.party_code )/
100                        
                       
                 Update Rmsallsegment_tmp Set Npercentscrip = Isnull((select Min(scrip_cd) From Rmspercent       
                 Where Scripwisecurrentgrossexp = Maxcurrentgrossexposure      
                 And Rmspercent.party_code = Rmsallsegment_tmp.party_code ),'')      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                       
                 Update Rmsallsegment_tmp Set Npercentseries = Isnull((select Min(series) From Rmspercent       
                 Where Scripwisecurrentgrossexp = Maxcurrentgrossexposure      
                 And Rmspercent.party_code = Rmsallsegment_tmp.party_code ),'')      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                       
                 Update Rmsallsegment_tmp Set Npercent = Isnull((select Min(percentage) From Rmspercent       
                 Where Scripwisecurrentgrossexp = Maxcurrentgrossexposure      
                 And Rmspercent.party_code = Rmsallsegment_tmp.party_code ),0)      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                       
                 Truncate Table Rmspercent       
                 Insert Into Rmspercent       
                 Select C.party_code,c.sauda_date,c.scrip_cd,c.series,      
                 Currentopenpurchase = (case When Sum(pqtydel) > 0 Then Sum(prate) Else 0 End ),      
                 Currentopensell = (case When Sum(sqtydel) > 0 Then Sum(srate) Else 0 End ),      
                 Scripwisecurrentgrossexp = Sum(prate) + Sum(srate),      
                 Maxcurrentgrossexposure = 0,      
                 Percentage = 0,''      
                 From Bsedb.dbo.cmbillvalan C, Bsedb.dbo.sett_mst S, Rmsallsegment_tmp R Where C.sett_no = S.sett_no And C.sett_type = S.sett_type      
                 And C.sauda_date <= @rmsdate + ' 23:59:59' And Funds_payin > @rmsdate      
                 And R.sauda_date Like @rmsdate + '%' And R.party_code = C.party_code      
                 And R.party_code >= @fromparty And R.party_code <= @toparty      
                 Group By C.party_code,c.sauda_date,scrip_cd,c.series      
                 Having ( Sum(pqtydel) > 0 Or Sum(sqtydel) > 0 )      
                       
                 Update Rmspercent Set Maxcurrentgrossexposure = ( Select Max(scripwisecurrentgrossexp) From Rmspercent R Where R.party_code = Rmspercent.party_code)      
                 Update Rmspercent Set Percentage =      
                 ( Select (case When Sum(scripwisecurrentgrossexp) > 0 Then Max(scripwisecurrentgrossexp)/sum(scripwisecurrentgrossexp) Else 0 End ) From Rmspercent R Where R.sauda_date = Rmspercent.sauda_date And R.party_code = Rmspercent.party_code )/100                           
                 Update Rmsallsegment_tmp Set Bpercentscrip = Isnull((select Min(scrip_cd) From Rmspercent       
                 Where Scripwisecurrentgrossexp = Maxcurrentgrossexposure      
                 And Rmspercent.party_code = Rmsallsegment_tmp.party_code And Rmspercent.sauda_date Like @rmsdate + '%'),'')      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                       
                 Update Rmsallsegment_tmp Set Bpercentseries = Isnull((select Min(series) From Rmspercent       
                 Where Scripwisecurrentgrossexp = Maxcurrentgrossexposure      
                 And Rmspercent.party_code = Rmsallsegment_tmp.party_code And Rmspercent.sauda_date Like @rmsdate + '%'),'')      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty      
                       
                 Update Rmsallsegment_tmp Set Bpercent = Isnull((select Min(percentage) From Rmspercent       
                 Where Scripwisecurrentgrossexp = Maxcurrentgrossexposure      
                 And Rmspercent.party_code = Rmsallsegment_tmp.party_code And Rmspercent.sauda_date Like @rmsdate + '%'),0)      
                 Where Sauda_date Like @rmsdate + '%'      
                 And Rmsallsegment_tmp.party_code >= @fromparty And Rmsallsegment_tmp.party_code <= @toparty       
 End       
 /* Required To Put It In Flag - Optional */      
       
 Update Rmsallsegment_tmp Set Sales_person = C1.trader, Trader=c1.trader,sub_broker=c1.sub_broker       
 From Rmsallsegment_tmp With(index(partycode),nolock), Client1 C1 With(index(pk_client1),nolock), Client2 C2       
 Where C1.cl_code = C2.cl_code       
 And C2.party_code = Rmsallsegment_tmp.party_code      
 And Sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
 Update Rmsallsegment_tmp Set Familyname = C1.long_name       
 From Rmsallsegment_tmp With(index(partycode),nolock), Client1 C1 With(index(pk_client1),nolock), Client2 C2       
 Where C1.cl_code = C2.cl_code       
 And C2.party_code = Rmsallsegment_tmp.family      
 And Sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
 Update Rmsallsegment_tmp Set Cust_executive = Isnull(approver,'')       
 From Rmsallsegment_tmp With(index(partycode),nolock), Client2 C2, Client5 C5 With(index(cl5),nolock)      
 Where C5.cl_code = C2.cl_code       
 And C2.party_code = Rmsallsegment_tmp.party_code      
 And Sauda_date Like @rmsdate + '%'      
 And Rmsallsegment_tmp.party_code Between @fromparty And @toparty      
       
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-3 Update Queries Rmsallsegment_temp From Client1 And Client5','delete Zero Balance From Rmsallsegment_temp',@rmsdate,getdate())        
      
 Delete From Rmsallsegment_tmp       
 Where Party_code In       
 (select Party_code From Rmsallsegment_tmp With(index(partycode),nolock) Where Sauda_date Like 'dec 30 2004' + '%'       
 And Tot_collateral_nb=0 And Cash_deposit=0 And Dep_fo=0 And Sec_dep_value=0 And       
 Sec_dep_percent=0 And Sec_dep_percent_value=0 And Non_cash=0 And Credit_limit=0       
 And N_mtm=0 And N_mtm_loss=0 And N_avm=0 And N_turnover=0 And N_purch=0 And N_sales=0       
 And N_net=0 And N_total_ge=0 And N_current_ge=0 And N_prev_ge=0 And N_id_exposure=0 And       
 B_mtm=0 And B_mtm_loss=0 And B_avm=0 And B_turnover=0 And B_purch=0 And B_sales=0 And B_net=0       
 And B_total_ge=0 And B_current_ge=0 And B_prev_ge=0 And B_id_exposure=0 And Amt_short=0 And       
 Nb_ledger_eff_bal=0 And Nb_ledger_voc_bal=0 And Fo_ledger_bal=0 And Total_ledger_bal=0 And       
 Nb_id_exposure=0 And Fo_id_exposure=0 And Nb_total_mtm=0 And Mtm_lossorzero=0 And Mtm_losses=0       
 And Avm=0 And Cash_var_margin=0 And Fo_mtm=0 And Fo_option_value=0 And Fo_span_margin=0       
 And Fo_open_risk=0 And Nb_day_purch=0 And Nb_day_sales=0 And Nb_upto_day_exp=0 And Nb_total_currentge=0       
 And Nb_allowed=0 And Fo_exp=0 And Fo_allow=0 And Nb_excess_short=0 And Fo_excess_short=0 And       
 Nb_turnover=0 And Fo_turnover = 0 And Nsedebitvalue = 0 And Bsedebitvalue = 0 And Poavalue = 0       
 And Nsepayin = 0 And Bsepayin = 0 And Margamt = 0 And Margper = 0 And Netmarg = 0 And Netmargper = 0)      
      
/*      
 Delete From Rmsallsegment_tmp Where Sauda_date Like @rmsdate + '%'       
 And Tot_collateral_nb=0 And Cash_deposit=0 And Dep_fo=0 And Sec_dep_value=0 And       
 Sec_dep_percent=0 And Sec_dep_percent_value=0 And Non_cash=0 And Credit_limit=0       
 And N_mtm=0 And N_mtm_loss=0 And N_avm=0 And N_turnover=0 And N_purch=0 And N_sales=0       
 And N_net=0 And N_total_ge=0 And N_current_ge=0 And N_prev_ge=0 And N_id_exposure=0 And       
 B_mtm=0 And B_mtm_loss=0 And B_avm=0 And B_turnover=0 And B_purch=0 And B_sales=0 And B_net=0       
 And B_total_ge=0 And B_current_ge=0 And B_prev_ge=0 And B_id_exposure=0 And Amt_short=0 And       
 Nb_ledger_eff_bal=0 And Nb_ledger_voc_bal=0 And Fo_ledger_bal=0 And Total_ledger_bal=0 And       
 Nb_id_exposure=0 And Fo_id_exposure=0 And Nb_total_mtm=0 And Mtm_lossorzero=0 And Mtm_losses=0       
 And Avm=0 And Cash_var_margin=0 And Fo_mtm=0 And Fo_option_value=0 And Fo_span_margin=0       
 And Fo_open_risk=0 And Nb_day_purch=0 And Nb_day_sales=0 And Nb_upto_day_exp=0 And Nb_total_currentge=0       
 And Nb_allowed=0 And Fo_exp=0 And Fo_allow=0 And Nb_excess_short=0 And Fo_excess_short=0 And       
 Nb_turnover=0 And Fo_turnover = 0 And Nsedebitvalue = 0 And Bsedebitvalue = 0 And Poavalue = 0       
 And Nsepayin = 0 And Bsepayin = 0 And Margamt = 0 And Margper = 0 And Netmarg = 0 And Netmargper = 0      
*/      
      
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-delete Zero Balance From Rmsallsegment_temp','delete From And Insert Into Rmsallsegment For The Date',@rmsdate,getdate())        
      
 Delete From Rmsallsegment Where Sauda_date Like @rmsdate + '%'      
 And Party_code >= @fromparty And Party_code <= @toparty      
       
 Insert Into Rmsallsegment      
 Select * From Rmsallsegment_tmp      
       
Insert Into Process_monitor Values ('rms','delivery','','rms_newproc','done-delete From And Insert Into Rmsallsegment For The Date','end-process Completed',@rmsdate,getdate())

GO
