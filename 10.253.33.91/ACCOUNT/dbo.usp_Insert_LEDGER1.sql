-- Object: PROCEDURE dbo.usp_Insert_LEDGER1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create procedure dbo.usp_Insert_LEDGER1 
	@bnkname [varchar](100), @brnname [varchar](100), @dd [char](1), @ddno [varchar](30), @dddt [datetime], @reldt [datetime], @relamt [money], @refno [char](12), @receiptno [int], @vtyp [smallint], @vno [varchar](12), @lno [int], @drcr [char](1), @BookType [char](2), @MicrNo [int], @SlipNo [int], @slipdate [datetime], @ChequeInName [varchar](100), @Chqprinted [tinyint], @clear_mode [char](1)
as
begin
	INSERT INTO LEDGER1 ( bnkname, brnname, dd, ddno, dddt, reldt, relamt, refno, receiptno, vtyp, vno, lno, drcr, BookType, MicrNo, SlipNo, slipdate, ChequeInName, Chqprinted, clear_mode ) 
	VALUES (@bnkname, @brnname, @dd, @ddno, @dddt, @reldt, @relamt, @refno, @receiptno, @vtyp, @vno, @lno, @drcr, @BookType, @MicrNo, @SlipNo, @slipdate, @ChequeInName, @Chqprinted, @clear_mode);
end

GO
