-- Object: PROCEDURE dbo.V2_BulkPayoutPosting
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------






CREATE Procedure V2_BulkPayoutPosting 
(
      @SessionId varchar(50), 
      @Uname varchar(50), 
      @S_SessionId varchar(50), 
      @Sett_No varchar(50), 
      @Sett_Type varchar(50), 
      @GenFlag varchar(1) 
)

As

-- Exec V2_BulkPayoutPosting '1971159042202006', 'boxm', '1971159042', '2006012', 'N', 'S' 

            Set NoCount On

            Declare 
            @@NEWVNO As Varchar(12), 
            @@MAXCOUNT As Int, 
            @@VDT As Varchar(11), 
            @@BANKBRANCH As Varchar(10), 
            @@BANKCOST As Numeric, 
            @@LNOCUR As Cursor, 
            @@LNOVNO As Varchar(12), 
            @@ERROR_COUNT Int 
            
            DECLARE 
            @@STD_DATE VARCHAR(11), 
            @@LST_DATE VARCHAR(11), 
            @@VNOMETHOD INT, 
            @@ACNAME CHAR(100), 
            @@BOOKTYPE CHAR(2), 
            @@MICRNO VARCHAR(10), 
            @@DRCR VARCHAR(1), 
            @@VTYP SMALLINT 

            -------------------------- UPDATE BANK CODE DETAILS ------------------------
            UPDATE 
                p 
                SET bnkname = a.acname, 
                branchcode = a.branchcode, 
                micrno = a.micrno, 
                BookType = a.BookType, 
                accdtls = a.accdtls, 
                updflag = 'Y' 
            FROM V2_payout_temp p, 
                Acmast a 
            WHERE p.bnkcode = a.Cltcode 
                AND Accat = 2 
                AND SessionId = @SessionId 
      
            UPDATE 
                P 
                SET COSTCODE = C.COSTCODE 
            FROM ACMAST a, 
                COSTMAST C, 
                V2_payout_temp P 
            WHERE a.cltcode = Accode 
                AND ACCAT in ('4') 
                AND A.BRANCHCODE = C.COSTNAME 
      
      
            UPDATE 
                P 
                SET COSTCODE = C.COSTCODE 
            FROM ACMAST a, 
                COSTMAST C, 
                V2_payout_temp P
            WHERE a.cltcode = bnkcode 
                AND ACCAT in ('2') 
                AND A.BRANCHCODE = C.COSTNAME 
            
            
           UPDATE 
                V2_payout_temp 
                SET bankcost = costcode 
            WHERE bankcost = '' 
      
	
	SELECT  top 1
		@@ACNAME = bnkname,  
		@@BOOKTYPE = booktype,  
		@@MICRNO = MicrNo,  
		@@VTYP = vtyp 
	FROM V2_payout_temp  Where SessionId = @SessionId 
	
	-------------------------- VALIDATION BASED ON UPDFLAG ------------------------
	Select @@ERROR_COUNT = COUNT(1) From 
		( 
		Select Distinct acCode 
	            From V2_payout_temp 
	            Where updflag = 'N' And SessionId = @SessionId 
	      ) A 
      
	If @@ERROR_COUNT > 0 
	Begin 
		Select 'FOLLOWING CLIENTS DO NOT EXIST' 
		Union All 
		Select Distinct acCode 
			From V2_payout_temp 
			Where updflag = 'N' And SessionId = @SessionId 
			RETURN 
	END 	

	--------------------------AUTO GENERATION OF VNO ------------------------
	Select 
		@@STD_DATE = LEFT(SDTCUR, 11), 
		@@LST_DATE = LEFT(LDTCUR, 11), 
		@@VNOMETHOD = VNOFLAG 
		From Parameter 
		Where Curyear = 1 

	Select @@MAXCOUNT = Count(Distinct Srno) From V2_payout_temp Where SessionId = @SessionId 
	Select Top 1 @@VDT = vdt From V2_payout_temp Where SessionId = @SessionId 
	Select Lastvno Into #VNO From Lastvno Where 1 = 2 

	Insert Into #VNO 
		EXEC Acc_GenVno_New 
			@@VDT, 
			@@VTYP, 
			@@BOOKTYPE, 
			@@STD_DATE, 
			@@LST_DATE 
      
	SELECT @@NEWVNO = Lastvno From #VNO 

	Update 
		V2_payout_temp 
			SET VNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC,@@NEWVNO) + (Srno - 1)) Where SessionId = @SessionId 

	UPDATE 
		V2_LASTVNO 
			SET LASTVNO = 
				( 
					SELECT 
						MAX(VNO) 
							FROM V2_payout_temp 
							WHERE VTYP = @@VTYP 
							AND BOOKTYPE = @@BOOKTYPE And SessionId = @SessionId 
				) 
			WHERE VTYP = @@VTYP AND BOOKTYPE = @@BOOKTYPE 
			AND VDT BETWEEN @@STD_DATE AND @@LST_DATE + ' 23:59:59' 
	DROP TABLE #VNO 
	
	--------------------------AUTO GENERATION OF LNO ------------------------
	Update 
		V2_payout_temp 
			Set lno = 2 
		Where vno in 
		( 
			Select 
				vno 
			From V2_payout_temp WITH(NOLOCK) 
			Where SessionId = @SessionId 
			Group By vno 
			Having count(*) = 1 
		) 

	Set @@LNOCUR = CURSOR For 
		Select 
			vno 
		From V2_payout_temp With(NOLOCK) Where SessionId = @SessionId 
		Group BY vno 
		Having count(*) > 1 
		OPEN @@LNOCUR 
		FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO 
		WHILE @@FETCH_STATUS = 0 
		BEGIN 
	
			Create Table [#lnogen] ( 
				VNO varchar(12), 
				SNO INT, 
				LNO INT IDENTITY(1,1)) 

			Insert Into #lnogen 
				Select 
					vno, 
					sno 
				From V2_payout_temp WITH(NoLock) 
				Where vno = @@LNOVNO And SessionId = @SessionId 
				Order BY sno 
            
			Update 
				V2_payout_temp 
				Set lno = l.lno + 1 
			From #lnogen l 
			Where V2_payout_temp.vno = l.vno 
			And V2_payout_temp.sno = l.sno 
			And V2_payout_temp.lno = 0 And SessionId = @SessionId 
            
			Drop Table #lnogen 
			FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO 
		END 
		CLOSE @@LNOCUR 
		DEALLOCATE @@LNOCUR 


	--------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------
	Insert 
		Into ledger1 
		Select 
			bnkname = MAX(bnkname), 
			brnname = MAX(brcode), 
			dd = LEFT(MAX(Paymode), 1), 
			ddno = MAX(ddno), 
			dddt = MAX(vdt), 
			reldt = '', 
			relamt = SUM(amt), 
			refno = 0, 
			receiptno = 0, 
			vtyp, 
			vno, 
			lno = 2, 
			drcr, 
			BookType = @@BOOKTYPE, 
			MicrNo = @@MICRNO, 
			SlipNo = 0, 
			slipdate = '', 
			ChequeInName = MAX(ISNULL(Acname,'')), 
			Chqprinted = 0, 
			clear_mode = '' 
		From 
			V2_payout_temp Where SessionId = @SessionId 
		Group By VTYP, VNO, DRCR 
		 
	/*============================== 
	      CLIENT SIDE RECORD 
	==============================*/ 
	Insert 
		Into ledger 
		Select 
			vtyp, 
			vno, 
			edt, 
			lno, 
			acname, 
			drcr, 
			vamt = amt, 
			vdt, 
			vno1 = VNO, 
			refno = 0, 
			balamt = amt, 
			NoDays = 0, 
			cdt = GETDATE(), 
			cltcode = acCode, 
			BookType = @@BOOKTYPE, 
			EnteredBy = @Uname, 
			pdt = GETDATE(), 
			CheckedBy = @Uname, 
			actnodays = 0, 
			narration 
		From 
			V2_payout_temp Where SessionId = @SessionId 
    
	/*============================== 
	      BANK SIDE RECORD 
	==============================*/ 
	Insert 
		Into ledger 
		Select 
			vtyp, 
			vno, 
			edt, 
			lno = 1, 
			@@acname, 
			drcr = (Case When DrCr = 'D' Then 'C' Else 'D' End), 
			vamt = Sum(amt), 
			vdt, 
			vno1 = VNO, 
			refno = 0, 
			balamt = Sum(amt), 
			NoDays = 0, 
			cdt = GETDATE(), 
			cltcode = bnkcode, 
			BookType = @@BOOKTYPE, 
			EnteredBy = @Uname, 
			pdt = GETDATE(), 
			CheckedBy = @Uname, 
			actnodays = 0, 
			narration = MAX(narration) 
		From 
			V2_payout_temp Where SessionId = @SessionId 
		Group By VTYP, VNO, EDT, DRCR, VDT, bnkcode 
		
	/*============================== 
	      BANK SIDE RECORD 
	==============================*/ 
	Insert 
		Into ledger3 
		Select 
			naratno = 1, 
			narration = MAX(narration), 
			refno = 0, 
			vtyp, 
			vno, 
			@@BookType 
		From 
			V2_payout_temp Where SessionId = @SessionId 
		Group By VTYP, VNO 

	/*============================== 
	      CLIENT SIDE RECORD 
	==============================*/ 
	Insert 
		Into ledger3 
		Select 
			naratno = LNO, 
			narr = NARRATION, 
			refno = 0, 
			vtyp, 
			vno, 
			@@BookType 
		From 
			V2_payout_temp Where SessionId = @SessionId 
	
	DECLARE @@L2CUR AS CURSOR, 
		@@L2VNO AS VARCHAR(12) 
		SET @@L2CUR = CURSOR FOR 
			SELECT DISTINCT VNO FROM V2_payout_temp Where SessionId = @SessionId ORDER BY VNO 
		OPEN @@L2CUR 
		FETCH NEXT FROM @@L2CUR INTO @@L2VNO 
		WHILE @@FETCH_STATUS = 0 
			BEGIN 
				Delete From Templedger2 
					Where Sessionid =  @S_SessionId

	/*============================== 
	      CLIENT SIDE RECORD 
	==============================*/ 
	
				Insert Into Templedger2 
				Select 
					'BRANCH', 
					C.COSTNAME, 
					amt, 
					VTYP, 
					VNO, 
					LNO, 
					DRCR, 
					'0', 
					@@BOOKTYPE, 
					@S_SessionId , 
					acCode, 
					'A', 
					'0' 
				From 
					V2_payout_temp RP, 
					COSTMAST C 
				Where 
					RP.COSTCODE = C.COSTCODE 
					And VNO = @@L2VNO And SessionId = @SessionId 
	/*============================== 
	      BANK SIDE RECORD 
	==============================*/ 
	
				Insert Into Templedger2 
				Select 
					'BRANCH', 
					branchcode, 
					SUM(amt), 
					VTYP, 
					VNO, 
					LNO = 1, 
					DRCR = (CASE WHEN DRCR = 'D' THEN 'C' ELSE 'D' END), 
					'0', 
					@@BOOKTYPE, 
					@S_SessionId, 
					bnkcode, 
					'A', 
					'0' 
				From 
					V2_payout_temp 
				Where 
					VNO = @@L2VNO And SessionId = @SessionId 
				Group By branchcode, VTYP, VNO, (CASE WHEN DRCR = 'D' THEN 'C' ELSE 'D' END), bnkcode 


				EXEC InsertToLedger2 @S_SessionId, @@L2VNO, '1', '1', '1', 'BROKER', 'BROKER' 

				FETCH NEXT FROM @@L2CUR INTO @@L2VNO 
			END 
				Delete From Templedger2 
					Where Sessionid =  @S_SessionId   
	
	Update S 
		Set status = 'A', 
		ApprovedDt = getDate(), 
		HOPaymode = P.Paymode, 
		bankcode = P.bnkcode, 
		Vno = P.Vno, 
		vdt = P.vdt, 
		edt = P.edt, 
		Amounttobepaid = P.amt 
	From 
		SettPayout S, 
		V2_payout_temp P 
	Where 
		CltCode = acCode 
		And S.branchcode = brcode 
		And isnull(settno,'') = isnull(@Sett_No,'') 
		And isnull(setttype,'') = isnull(@Sett_Type,'')
                  And GenFlag = @GenFlag 
		And Status = 'P' 
                  And P.SessionId = @SessionId 
			
	Delete From 
		V2_LedgerBalance 
	Where 
		PartyCode In (Select acCode From V2_payout_temp Where updflag = 'Y' And SessionId = @SessionId) 


	Select 'Voucher Numbers Generated : <BR>' 
         Union All 
	Select VNO + ' : ' + acCode + Space(10 - len(acCode)) + ' : ' + Convert(Varchar, amt) + '~' As Result 
	From V2_payout_temp Where SessionId = @SessionId  

	Delete From V2_payout_temp Where SessionId = @SessionId

GO
