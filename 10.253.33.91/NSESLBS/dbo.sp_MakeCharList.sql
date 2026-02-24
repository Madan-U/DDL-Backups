-- Object: PROCEDURE dbo.sp_MakeCharList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure sp_MakeCharList( @codelistselect varchar(1000), @delimitedlist varchar(8000) output, @IsChar bit = 0)
AS
begin
  set nocount on
  set rowcount 0

  declare @vcCurrentCol varchar(255)
  declare @vcCurrentList varchar(8000)
  declare @RC int

  create table #temptable (code varchar(255))
  insert into #temptable (code)
    exec(@codelistselect)

  set @RC = @@RowCount

  if @RC = 0
  begin
    set @DelimitedList = null
    return 0
  end

  declare SysCols insensitive scroll cursor
  for select code from #temptable 
  for read only

  open SysCols

  fetch next from SysCols into @vcCurrentCol

  select @vcCurrentList = '' 
  while @@Fetch_Status = 0
  begin
    if @IsChar = 1
      select @vcCurrentList = @vcCurrentList + quotename(@vcCurrentCol, '''') + ', '
    else
      select @vcCurrentList = @vcCurrentList + @vcCurrentCol + ', '

    fetch next from SysCols into @vcCurrentCol
  end

  close SysCols
  deallocate SysCols

  if @vcCurrentList = ''
    select @DelimitedList = null
  else
    --Remove the last ', '
    select @delimitedList = Substring(@vcCurrentList, 1, datalength(@vcCurrentList) - 2)

end

GO
