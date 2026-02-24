-- Object: PROCEDURE dbo.C_addseccursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure C_addseccursor (@exchange Varchar(3), @segment Varchar(20), @b_bankdpid Varchar(16), @b_dp_acc_code Varchar(16))
As
Declare @@cur  Cursor,
@@gentcode Cursor,
@@getdptype Cursor,
@@gentrans_code Cursor,
@@party_code Varchar(15),
@@tcode Int,
@@trans_code Int,
@@effdate Varchar(11),
@@scrip_cd Varchar(12),
@@series Varchar(3),
@@isin Varchar(20),
@@c_bankcode Varchar(16),
@@c_cltaccno Varchar(16),
@@qty Int,
@@remarks Varchar(100),
@@c_dp_type Varchar(4),
@@b_dp_type Varchar(4)

Set @@getdptype = Cursor For
	Select Dptype From Msajag.dbo.deliverydp Where Dpid = @b_bankdpid
	Open @@getdptype 
	Fetch Next From @@getdptype Into @@b_dp_type
Close @@getdptype 
Deallocate @@getdptype 


Set @@cur = Cursor For
	Select Party_code, Scrip_cd, Series, Isin, Qty, Bankcode, Cltaccno, Rec_dt, Remarks  
	From Msajag.dbo.securities
	Where Exch_indicator = @exchange And Seg_indicator Like @segment + '%'
Open @@cur
Fetch Next From @@cur Into @@party_code, @@scrip_cd, @@series, @@isin, @@qty, @@c_bankcode, @@c_cltaccno, @@effdate, @@remarks

While @@fetch_status = 0
Begin
	Set @@gentrans_code = Cursor For
	Select Maxtrans_code = Isnull(max(trans_code),0)+1 From Msajag.dbo.c_securitiesmst	
	Open @@gentrans_code
	Fetch Next From @@gentrans_code Into @@trans_code	
	Close @@gentrans_code
	Deallocate @@gentrans_code		

	Set @@getdptype = Cursor For
	Select Banktype From Msajag.dbo.bank Where Bankid = @@c_bankcode
	Open @@getdptype 
	Fetch Next From @@getdptype Into @@c_dp_type
	Close @@getdptype 
	Deallocate @@getdptype 

		
	Set @@gentcode = Cursor For
	Select Maxtcode = Isnull(max(tcode),0)+1 From Msajag.dbo.c_securitiesmst Where Trans_code = @@trans_code
	Open @@gentcode
	Fetch Next From @@gentcode Into @@tcode
	Close @@gentcode
	Deallocate @@gentcode			

	/*fldauto  Exchange Segment Company Party_code Bankdpid Dp_acc_code Dp_type Inst_type Isin  Scrip_cd Series Qty Drcr 
	Trans_code Effdate B_bankdpid  B_dp_acc_code  B_dp_type Trtype End_date Tcode Remarks Active Status Loginname Logintime
	Transtoexch Filler11   Filler12   Filler13   Filler14   Filler15   */
	If @@qty >= 0
	Begin
		Insert Into Msajag.dbo.c_securitiesmst Values( @exchange, @segment, '',@@party_code, @@c_bankcode, @@c_cltaccno, @@c_dp_type, 'sec', @@isin, @@scrip_cd, @@series, 
		@@qty,'c' , @@trans_code, @@effdate, @b_bankdpid, @b_dp_acc_code, @@b_dp_type, '', @@effdate, @@tcode, @@remarks,  1, '', '', @@effdate, 'n', 'party', '', '', '', '')

		Insert Into Msajag.dbo.c_securitiesmst Values( @exchange, @segment, '','broker', @b_bankdpid, @b_dp_acc_code, @@c_dp_type, 'sec', @@isin, @@scrip_cd, @@series, 
		@@qty,'d' , @@trans_code, @@effdate, @b_bankdpid, @b_dp_acc_code, @@b_dp_type, '', @@effdate, @@tcode+1, @@remarks,  1, '', '', @@effdate, 'n', 'broker', '', '', '', '')		
	End
	Else
	Begin
		Insert Into Msajag.dbo.c_securitiesmst Values( @exchange, @segment, '',@@party_code, @@c_bankcode, @@c_cltaccno, @@c_dp_type, 'sec', @@isin, @@scrip_cd, @@series, 
		Abs(@@qty),'d' , @@trans_code, @@effdate, @b_bankdpid, @b_dp_acc_code, @@b_dp_type, '', @@effdate, @@tcode, @@remarks,  1, '', '', @@effdate, 'n', 'party', '', '', '', '')

		Insert Into Msajag.dbo.c_securitiesmst Values( @exchange, @segment, '','broker', @b_bankdpid, @b_dp_acc_code, @@c_dp_type, 'sec', @@isin, @@scrip_cd, @@series, 
		Abs(@@qty),'c' , @@trans_code, @@effdate, @b_bankdpid, @b_dp_acc_code, @@b_dp_type, '', @@effdate, @@tcode+1, @@remarks,  1, '', '', @@effdate, 'n', 'broker', '', '', '', '')		

	End
	
Fetch Next From @@cur Into @@party_code, @@scrip_cd, @@series, @@isin, @@qty, @@c_bankcode, @@c_cltaccno, @@effdate, @@remarks
End
Close @@cur
Deallocate @@cur

GO
