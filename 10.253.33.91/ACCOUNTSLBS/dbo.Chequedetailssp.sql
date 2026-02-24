-- Object: PROCEDURE dbo.Chequedetailssp
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



Create Proc Chequedetailssp  
@Cltcode Varchar(10),   
@Option Varchar(2),   
@Vdt Varchar(11),   
@Statusname Varchar(25)  
As  
 /*  
 Select Acname , Bnkname, Brnname, Vamt, Ddno, L.Vtyp, L.Vno, L.Lno, L.Drcr, L.Vdt , L.Booktype  
 From Ledger L, Ledger1 L1   
 Where  L1.Vtyp = L.Vtyp And L1.Vno = L.Vno And L.Lno = L1.Lno  
 And L.Vtyp In (Select Vtyp From Ledger Where L.Vtyp = Vtyp And L.Vno = Vno And L.Booktype = Booktype And Vtyp In (2, 19) And Cltcode = @Cltcode)   
 And L.Vno In (Select Vno From Ledger Where L.Vtyp = Vtyp And L.Vno = Vno And L.Booktype = Booktype And Vtyp In (2, 19)  And Cltcode = @Cltcode)   
 And Ddno Like @Option And L.Cltcode <> @Cltcode And L.Vdt Like @Vdt + '%'  
 */  
   
 Select Distinct Acname , Cltcode, Bnkname, Brnname, Vamt, Ddno, L.Vtyp, L.Vno, L.Lno, L.Drcr, L.Vdt , L.Booktype, City = ''  
 From Ledger L, Ledger1 L1 /*, Msajag.Dbo.Client4 C4, Msajag.Dbo.Pobank P*/, Msajag.Dbo.Tblpradnyausers U, Msajag.Dbo.Tbladmin A  
 Where  L1.Vtyp = L.Vtyp And L1.Vno = L.Vno And L.Lno = L1.Lno  
 And L.Vtyp In (Select Vtyp From Ledger Where L.Vtyp = Vtyp And L.Vno = Vno And L.Booktype = Booktype And Vtyp In (2, 19) And Cltcode = @Cltcode)   
 And L.Vno In (Select Vno From Ledger Where L.Vtyp = Vtyp And L.Vno = Vno And L.Booktype = Booktype And Vtyp In (2, 19)  And Cltcode = @Cltcode)   
 And Clear_mode = @Option And L.Cltcode <> @Cltcode And L.Vdt Like @Vdt + '%'  
        /*and C4.Party_code = L.Cltcode And Depository Not In ('Cdsl', 'Nsdl') And C4.Bankid = P.Bankid*/  
 And Enteredby = Fldusername And A.Fldstname = U.Fldstname And Fldadminauto = Fldauto_admin  
 And U.Fldstname = @Statusname

GO
